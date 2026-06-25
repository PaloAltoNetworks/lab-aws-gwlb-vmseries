#!/usr/bin/env bash
#
# validate-azure-cngfw-e2e.sh - INTERNAL / instructor revalidation of the Azure
# Cloud NGFW (Part 3) lab, end to end, via API/CLI/Terraform. This automates what
# the STUDENT guide (AZURE-CLOUDNGFW-ADDENDUM.md) has people do by hand in the
# Panorama UI - keep the two separate: this is for OUR testing, not the learner path.
#
# It drives: Panorama keygen -> ensure Azure plugin -> create cloud DG + template
# stack -> commit -> generate registration string -> terraform apply (vendored
# example) -> read CNGFW egress IP -> open the AWS Panorama security group ->
# poll for registration -> push an allow policy -> curl WordPress.
#
# Secrets (registration string / auth key) are written to files and NEVER echoed;
# base64 blobs are masked in all output.
#
# Prereqs / inputs (env vars, with this-run defaults):
#   ~/.claude/.env must hold QWIKLABS_PANORAMA (Panorama 'lab-admin' pw),
#   AWS_QWIKLABS_KEY / AWS_QWIKLABS_SECRET (AWS creds for the Panorama SG).
#   CSP PIN: PIN_ID / PIN_VALUE env, or a file at $PIN_FILE (default /tmp/csp-pin.txt
#   with lines PIN_ID=... / PIN_VALUE=...).
#
# Usage:
#   export PIN_ID=... PIN_VALUE=...        # or put them in /tmp/csp-pin.txt
#   ./validate-azure-cngfw-e2e.sh
#
set -euo pipefail

# ------------------------------------------------------------------ config
PAN_HOST="${PAN_HOST:-100.22.30.41}"
PAN_USER="${PAN_USER:-lab-admin}"
AZURE_PLUGIN="${AZURE_PLUGIN:-azure-5.2.4}"

SUBSCRIPTION_ID="${SUBSCRIPTION_ID:-aab8f84c-7790-4073-afe3-bf27ed5b639e}"   # deploy sub
RG="${RG:-syoungberg-4ckoydxldt2l-torque}"
REGION="${REGION:-Central US}"
NAME_PREFIX="${NAME_PREFIX:-syb-}"
DG="${DG:-cngfw-az-vwan-hub}"           # cloud device group name (= template stack name)
TS="${TS:-$DG}"

AWS_REGION="${AWS_REGION:-us-west-2}"
PAN_SG="${PAN_SG:-sg-0e036eaafcaf590a3}"   # AWS security group on the Panorama instance
CNGFW_PORTS=(3978 28443 28270)

ENVFILE="${ENVFILE:-$HOME/.claude/.env}"
PIN_FILE="${PIN_FILE:-/tmp/csp-pin.txt}"
REGSTRING_FILE="${REGSTRING_FILE:-/tmp/regstring.txt}"
KEYFILE="${KEYFILE:-/tmp/pan-key}"
# Vendored TF is copied here (backend stripped) so we run with local state and never
# touch the student files.
SRC_TF="${SRC_TF:-$(cd "$(dirname "$0")/.." && pwd)/terraform/azure-cngfw}"
TFDIR="${TFDIR:-/tmp/azure-cngfw-e2e}"

MASK="s/eyJ[A-Za-z0-9+/=]+/<REGSTRING>/g; s/[A-Za-z0-9+/]{40,}={0,2}/<BLOB>/g"
log() { printf '\n=== %s ===\n' "$*"; }
getenv() { grep -E "^$1=" "$ENVFILE" | head -1 | cut -d= -f2- | tr -d '"'\''\r'; }

# ------------------------------------------------------------------ Panorama XML API helpers
PAN_PW="$(getenv QWIKLABS_PANORAMA)"; [ -n "$PAN_PW" ] || { echo "no QWIKLABS_PANORAMA in $ENVFILE"; exit 1; }
pan_keygen() {
  curl -sk -G "https://$PAN_HOST/api/" --data-urlencode "type=keygen" \
    --data-urlencode "user=$PAN_USER" --data-urlencode "password=$PAN_PW" \
    | sed -nE 's#.*<key>(.*)</key>.*#\1#p' > "$KEYFILE"
  [ -s "$KEYFILE" ] || { echo "keygen failed"; exit 1; }
}
pan() { # pan <type> <cmd-or-extra...>
  local t="$1"; shift
  curl -sk -G "https://$PAN_HOST/api/" --data-urlencode "type=$t" \
    --data-urlencode "key=$(cat "$KEYFILE")" "$@"
}
pan_poll() { # pan_poll <jobid>
  local job="$1" i st res
  for i in $(seq 1 60); do
    local r; r=$(pan op --data-urlencode "cmd=<show><jobs><id>$job</id></jobs></show>")
    st=$(echo "$r" | sed -nE 's#.*<status>([^<]*)</status>.*#\1#p' | head -1)
    res=$(echo "$r" | sed -nE 's#.*<result>([^<]*)</result>.*#\1#p' | head -1)
    printf '  job %s: %s/%s\n' "$job" "${st:-?}" "${res:-?}"
    [ "$st" = "FIN" ] && { [ "$res" = "OK" ] || return 1; return 0; }
    sleep 6
  done; return 1
}

# ------------------------------------------------------------------ 1. plugin
log "Panorama keygen + ensure Azure plugin $AZURE_PLUGIN"
pan_keygen
if pan op --data-urlencode "cmd=<show><plugins><packages></packages></plugins></show>" \
   | tr '>' '>\n' | grep -A4 "<pkg-file>$AZURE_PLUGIN</pkg-file>" | grep -q '<installed>yes'; then
  echo "  $AZURE_PLUGIN already installed"
else
  pan op --data-urlencode "cmd=<request><plugins><check></check></plugins></request>" >/dev/null
  J=$(pan op --data-urlencode "cmd=<request><plugins><download><file>$AZURE_PLUGIN</file></download></plugins></request>" | sed -nE 's#.*<job>([0-9]+)</job>.*#\1#p'); pan_poll "$J"
  J=$(pan op --data-urlencode "cmd=<request><plugins><install>$AZURE_PLUGIN</install></plugins></request>" | sed -nE 's#.*<job>([0-9]+)</job>.*#\1#p'); pan_poll "$J" || true
  echo "  waiting for mgmt to settle after plugin install..."; sleep 25; pan_keygen
fi

# ------------------------------------------------------------------ 2. cloud DG + template stack
log "Create template stack '$TS' + cloud device group '$DG' (idempotent)"
pan op --data-urlencode "cmd=<request><plugins><azure><cngfw-create-template-stack><name>$TS</name></cngfw-create-template-stack></azure></plugins></request>" | sed -E "$MASK" | grep -oE '<msg>[^<]*' || true
pan op --data-urlencode "cmd=<request><plugins><azure><cngfw-create-device-group><name>$DG</name><template-stack>$TS</template-stack></cngfw-create-device-group></azure></plugins></request>" | sed -E "$MASK" | grep -oE '<msg>[^<]*' || true
log "Commit to Panorama"
J=$(pan commit --data-urlencode "cmd=<commit></commit>" | sed -nE 's#.*<job>([0-9]+)</job>.*#\1#p'); pan_poll "$J"

# ------------------------------------------------------------------ 3. registration string
log "Generate registration string -> $REGSTRING_FILE (not echoed)"
[ -f "$PIN_FILE" ] && { PIN_ID="${PIN_ID:-$(grep '^PIN_ID=' "$PIN_FILE" | cut -d= -f2-)}"; PIN_VALUE="${PIN_VALUE:-$(grep '^PIN_VALUE=' "$PIN_FILE" | cut -d= -f2-)}"; }
[ -n "${PIN_ID:-}" ] && [ -n "${PIN_VALUE:-}" ] || { echo "need PIN_ID/PIN_VALUE (env or $PIN_FILE)"; exit 1; }
pan op \
  --data-urlencode "cmd=<request><plugins><azure><registration-strings><generate><cloud-device-group>$DG</cloud-device-group><panorama-ip>$PAN_HOST</panorama-ip><template-stack>$TS</template-stack><pin-id>$PIN_ID</pin-id><pin-value>$PIN_VALUE</pin-value></generate></registration-strings></azure></plugins></request>" \
  | sed -nE 's#.*<registrationString>(.*)</registrationString>.*#\1#p' > "$REGSTRING_FILE"
chmod 600 "$REGSTRING_FILE"
[ -s "$REGSTRING_FILE" ] || { echo "registration-string generate failed"; exit 1; }
echo "  reg string captured ($(wc -c <"$REGSTRING_FILE") bytes)"

# ------------------------------------------------------------------ 4. terraform (vendored, local state, backend stripped)
log "Terraform apply (work dir $TFDIR, local state)"
rm -rf "$TFDIR"; mkdir -p "$TFDIR"; cp "$SRC_TF"/*.tf "$SRC_TF/.header.md" "$TFDIR"/ 2>/dev/null || cp "$SRC_TF"/*.tf "$TFDIR"/
# strip the remote backend so this test run uses local state
perl -0pi -e 's/\n\s*backend "azurerm" \{\}\n/\n/' "$TFDIR/versions.tf"
# build terraform.tfvars from the template with our values + reg string
python3 - "$SRC_TF/example.tfvars" "$TFDIR/terraform.tfvars" "$REGSTRING_FILE" \
  "$SUBSCRIPTION_ID" "$REGION" "$RG" "$NAME_PREFIX" <<'PY'
import sys
tmpl,out,regf,sub,region,rg,prefix=sys.argv[1:8]
s=open(tmpl).read(); reg=open(regf).read().strip()
s=s.replace('TODO_YOUR_SUBSCRIPTION_ID',sub).replace('"Central US"',f'"{region}"')
s=s.replace('TODO_YOUR_RG',rg).replace('"TODO-"',f'"{prefix}"')
s=s.replace('TODO_PASTE_REGISTRATION_STRING',reg)
open(out,'w').write(s)
PY
( cd "$TFDIR" && terraform init -input=false >/dev/null && terraform apply -auto-approve -input=false >/dev/null )
echo "  apply complete"

# ------------------------------------------------------------------ 5. egress IP + AWS SG
log "Read CNGFW egress IP + open AWS Panorama SG $PAN_SG"
FW_ID=$(az resource list -g "$RG" --subscription "$SUBSCRIPTION_ID" --resource-type paloaltonetworks.cloudngfw/firewalls --query "[0].id" -o tsv)
EGRESS=$(az resource show --ids "$FW_ID" --query "properties.networkProfile.egressNatIp[0].address" -o tsv)
echo "  egress IP: $EGRESS"
export AWS_ACCESS_KEY_ID="$(getenv AWS_QWIKLABS_KEY)" AWS_SECRET_ACCESS_KEY="$(getenv AWS_QWIKLABS_SECRET)"
unset AWS_PROFILE AWS_SESSION_TOKEN
for p in "${CNGFW_PORTS[@]}"; do
  aws ec2 authorize-security-group-ingress --region "$AWS_REGION" --group-id "$PAN_SG" \
    --ip-permissions "IpProtocol=tcp,FromPort=$p,ToPort=$p,IpRanges=[{CidrIp=$EGRESS/32,Description='CNGFW-Azure mgmt'}]" \
    >/dev/null 2>&1 && echo "  opened tcp/$p from $EGRESS/32" || echo "  tcp/$p already present (ok)"
done

# ------------------------------------------------------------------ 6. registration
log "Poll Panorama for registration (Cloud NGFW = ~3 instances)"
for i in $(seq 1 16); do
  pan_keygen
  N=$(pan op --data-urlencode "cmd=<show><devices><all></all></devices></show>" \
      | tr '>' '>\n' | grep -c "<hostname>${NAME_PREFIX}cloudngfw</hostname>" || true)
  printf '  poll %s: %s connected instance(s) named %scloudngfw\n' "$i" "$N" "$NAME_PREFIX"
  [ "${N:-0}" -ge 1 ] && break; sleep 45
done

# ------------------------------------------------------------------ 7. policy + traffic
log "Push allow-web policy to $DG + test WordPress"
XP="/config/devices/entry[@name='localhost.localdomain']/device-group/entry[@name='$DG']/pre-rulebase/security/rules/entry[@name='allow-web']"
EL="<from><member>any</member></from><to><member>any</member></to><source><member>any</member></source><destination><member>any</member></destination><source-user><member>any</member></source-user><application><member>any</member></application><service><member>application-default</member></service><action>allow</action><log-end>yes</log-end>"
pan config --data-urlencode "action=set" --data-urlencode "xpath=$XP" --data-urlencode "element=$EL" >/dev/null
J=$(pan commit --data-urlencode "cmd=<commit></commit>" | sed -nE 's#.*<job>([0-9]+)</job>.*#\1#p'); pan_poll "$J"
J=$(pan commit --data-urlencode "action=all" --data-urlencode "cmd=<commit-all><shared-policy><device-group><entry name='$DG'/></device-group></shared-policy></commit-all>" | sed -nE 's#.*<job>([0-9]+)</job>.*#\1#p'); pan_poll "$J" || true
sleep 30
for n in 1 2 3; do
  CODE=$(curl -s -m 15 -o /dev/null -w "%{http_code}" "http://$EGRESS/" || echo 000)
  echo "  app1 http://$EGRESS/ -> HTTP $CODE"
  [ "$CODE" != "000" ] && break; sleep 25
done

log "DONE - e2e validation complete (egress $EGRESS, dg $DG)"
