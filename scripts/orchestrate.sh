#!/usr/bin/env bash
# orchestrate.sh — the deterministic spine for the GWLB VM-Series lab.
#
#   P0 bootstrap (S3+DynamoDB)  ->  P1 Panorama infra  ->  [P2 Panorama init + License
#   Manager gate]  ->  P3 security-stack (FWs + spokes)  ->  P4 e2e verify
#
# P2 needs two CSP-sourced inputs that cannot be self-served:
#   CSP_API_KEY    : Customer Support Portal API key (sw_fw_license licensing proxy)
#   PANORAMA_OTP   : device-certificate OTP generated in CSP for the Panorama serial
# Export them before running, or the script stops at the gate with instructions.
#
# Usage: source your AWS creds, then:  bash scripts/orchestrate.sh [phase]
#   phase = all (default) | bootstrap | panorama | init | license | security | verify
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF="${ROOT}/terraform"
SCRIPTS="${ROOT}/scripts"
PHASE="${1:-all}"

: "${PANORAMA_SERIAL:=${QWIKLABS_REFACTOR_PANORAMA_SN:-}}"
: "${VM_AUTHCODE:=${QWIKLABS_REFACTOR_VM_AUTHCODE:-}}"
: "${SSM_PARAM:=/pan-gwlb-lab/lm-authkey}"
: "${BACKEND_REGION:=us-west-1}"
: "${DEPLOY_EXERCISE_ROUTES:=true}"   # instructor/e2e default; students set false

tf() { terraform -chdir="$1" "${@:2}"; }
say() { printf '\n\033[1;36m== %s ==\033[0m\n' "$*"; }

run_bootstrap() {
  say "P0 bootstrap (S3 + DynamoDB backend)"
  tf "${TF}/bootstrap" init -input=false
  tf "${TF}/bootstrap" apply -auto-approve -input=false
}

run_panorama() {
  say "P1 Panorama infra (separate region)"
  tf "${TF}/panorama" init -input=false -backend-config=backend.hcl
  tf "${TF}/panorama" apply -auto-approve -input=false
  PAN_EIP="$(tf "${TF}/panorama" output -raw panorama_public_ip)"
  PAN_KEY="$(tf "${TF}/panorama" output -raw ssh_private_key_path)"
  echo "Panorama EIP: ${PAN_EIP}"
}

run_init() {
  say "P2a panorama-init (Panorama readiness) — CSP GATE"
  PAN_EIP="$(tf "${TF}/panorama" output -raw panorama_public_ip)"
  PAN_KEY="${TF}/panorama/$(tf "${TF}/panorama" output -raw ssh_private_key_path)"
  if [[ -z "${CSP_API_KEY:-}" || -z "${PANORAMA_OTP:-}" ]]; then
    cat >&2 <<EOF

  ┌─ CSP GATE ─────────────────────────────────────────────────────────────┐
  │ panorama-init needs two CSP-sourced inputs (Berg-provided, not faked):   │
  │   export CSP_API_KEY=...      # CSP API key for sw_fw_license proxy      │
  │   export PANORAMA_OTP=...     # device-cert OTP for serial ${PANORAMA_SERIAL:-<serial>}  │
  │ Generate the OTP in CSP for the Panorama serial, then re-run:            │
  │   bash scripts/orchestrate.sh init                                       │
  └─────────────────────────────────────────────────────────────────────────┘
EOF
    exit 2
  fi
  python3 -m pip install -q -r "${SCRIPTS}/panorama-init/requirements.txt" 2>/dev/null || true
  python3 "${SCRIPTS}/panorama-init/panorama_init.py" "${PAN_EIP}" \
    --ssh-key "${PAN_KEY}" \
    --serial-number "${PANORAMA_SERIAL}" \
    --otp "${PANORAMA_OTP}" \
    --csp-api-key "${CSP_API_KEY}" \
    --upgrade-content --upgrade-av \
    --plugins sw_fw_license-1.2.3 \
    --public-ip "${PAN_EIP}"
}

run_license() {
  say "P2b License Manager gate (create + commit + verify + key -> SSM)"
  PAN_EIP="$(tf "${TF}/panorama" output -raw panorama_public_ip)"
  python3 "${SCRIPTS}/panorama-license-manager.py" "${PAN_EIP}" \
    --state-file "panorama-${PAN_EIP}-state.json" \
    --authcode "${VM_AUTHCODE}" \
    --ssm-param "${SSM_PARAM}" --ssm-region "${BACKEND_REGION}"
}

run_security() {
  say "P3 security-stack (FWs + GWLB + spokes) — gated on the LM key in SSM"
  LM_AUTHKEY="$(aws ssm get-parameter --name "${SSM_PARAM}" --with-decryption --region "${BACKEND_REGION}" --query Parameter.Value --output text 2>/dev/null || true)"
  if [[ -z "${LM_AUTHKEY}" || "${LM_AUTHKEY}" == "None" ]]; then
    echo "GATE: LM auth-key not in SSM (${SSM_PARAM}). Run the 'license' phase first." >&2
    exit 2
  fi
  tf "${TF}/security-stack" init -input=false -backend-config=backend.hcl
  TF_VAR_lm_authkey="${LM_AUTHKEY}" tf "${TF}/security-stack" apply -auto-approve -input=false \
    -var "deploy_exercise_routes=${DEPLOY_EXERCISE_ROUTES}"
}

run_verify() {
  say "P4 e2e verification"
  PAN_EIP="$(tf "${TF}/panorama" output -raw panorama_public_ip)"
  python3 "${SCRIPTS}/verify-e2e.py" \
    --panorama-ip "${PAN_EIP}" \
    --panorama-state-file "panorama-${PAN_EIP}-state.json" \
    --security-tf-dir "${TF}/security-stack" \
    --fw-region "${BACKEND_REGION}"
}

case "${PHASE}" in
  bootstrap) run_bootstrap ;;
  panorama)  run_panorama ;;
  init)      run_init ;;
  license)   run_license ;;
  security)  run_security ;;
  verify)    run_verify ;;
  all)       run_bootstrap; run_panorama; run_init; run_license; run_security; run_verify ;;
  *) echo "unknown phase: ${PHASE}" >&2; exit 1 ;;
esac
