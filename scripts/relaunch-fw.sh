#!/usr/bin/env bash
#
# relaunch-fw.sh (v2) - recreate lab VM-Series "exactly the same" after a failed
# licensing bootstrap, with NO terraform state. Robust to instances already being
# terminated: it copies the common launch config + user-data from any SURVIVING
# lab FW, and reuses each FW's existing ENIs (and mgmt EIP), found by tag.
#
# PREREQUISITE - do this FIRST: fix the bad authcode in the Panorama License
# Manager bootstrap definition and COMMIT it. A failed-licensing FW will not retry,
# so the fix is: correct Panorama, THEN relaunch (this) so the fresh boot licenses
# cleanly and sets the admin creds.
#
# Run from CloudShell PERSISTENT home (~/), not /tmp.
#   chmod +x relaunch-fw.sh
#   ./relaunch-fw.sh                 # vmseries01 + vmseries02
#   ./relaunch-fw.sh vmseries01      # just one
# Shared account: export PREFIX="your-" first (instance tags are prefixed; ENI tags are not).
#
set -euo pipefail
REGION="${REGION:-us-east-1}"
PREFIX="${PREFIX:-}"
if [ "$#" -gt 0 ]; then FWS=("$@"); else FWS=("vmseries01" "vmseries02"); fi

di() { aws ec2 describe-instances --region "$REGION" "$@"; }

# 1) Copy the common launch config + a user-data template from any SURVIVING lab FW
#    (terminated instances are excluded by the state filter).
REF=$(di --filters "Name=tag:Name,Values=${PREFIX}vmseries*" \
                   "Name=instance-state-name,Values=pending,running,stopping,stopped" \
        --query 'Reservations[].Instances[].InstanceId' --output text | tr '\t' '\n' | head -n1)
if [ -z "$REF" ] || [ "$REF" = "None" ]; then
  echo "ERROR: no surviving lab FW to copy config from. Both gone -> needs a from-scratch rebuild (contact your instructor)."; exit 1
fi
AMI=$(di --instance-ids "$REF" --query 'Reservations[0].Instances[0].ImageId' --output text)
TYPE=$(di --instance-ids "$REF" --query 'Reservations[0].Instances[0].InstanceType' --output text)
KEY=$(di --instance-ids "$REF" --query 'Reservations[0].Instances[0].KeyName' --output text)
IAM=$(di --instance-ids "$REF" --query 'Reservations[0].Instances[0].IamInstanceProfile.Arn' --output text)
ROOTDEV=$(aws ec2 describe-images --region "$REGION" --image-ids "$AMI" --query 'Images[0].RootDeviceName' --output text)
aws ec2 describe-instance-attribute --region "$REGION" --instance-id "$REF" --attribute userData \
  --query 'UserData.Value' --output text | base64 --decode > "${HOME}/ud-template.txt"
echo "reference FW ${REF}: AMI=${AMI} type=${TYPE} key=${KEY} root=${ROOTDEV}"

for BASENAME in "${FWS[@]}"; do
  NAME="${PREFIX}${BASENAME}"
  echo "================ ${NAME} ================"

  # 2) If a live instance still exists for this FW, capture its OWN user-data, then terminate it.
  CUR=$(di --filters "Name=tag:Name,Values=${NAME}" \
                     "Name=instance-state-name,Values=pending,running,stopping,stopped" \
          --query 'Reservations[].Instances[].InstanceId' --output text | tr '\t' '\n' | head -n1)
  if [ -n "$CUR" ] && [ "$CUR" != "None" ]; then
    echo "  live instance ${CUR} present"
    aws ec2 describe-instance-attribute --region "$REGION" --instance-id "$CUR" --attribute userData \
      --query 'UserData.Value' --output text | base64 --decode > "${HOME}/ud-${NAME}.txt"
    # keep its ENIs (and the mgmt EIP) when it dies
    di --instance-ids "$CUR" \
       --query 'Reservations[0].Instances[0].NetworkInterfaces[].[Attachment.AttachmentId,NetworkInterfaceId]' --output text \
      | while read -r AID ENI; do
          aws ec2 modify-network-interface-attribute --region "$REGION" \
            --network-interface-id "$ENI" --attachment "AttachmentId=${AID},DeleteOnTermination=false"
        done
    read -r -p "  terminate ${CUR} and relaunch ${NAME}? [y/N] " ok; [ "$ok" = "y" ] || { echo "  skipped"; continue; }
    aws ec2 terminate-instances --region "$REGION" --instance-ids "$CUR" >/dev/null
    aws ec2 wait instance-terminated --region "$REGION" --instance-ids "$CUR"
  else
    echo "  no live instance (already terminated); deriving user-data from the reference FW"
    sed "s/hostname=[^;]*/hostname=${BASENAME}/" "${HOME}/ud-template.txt" > "${HOME}/ud-${NAME}.txt"
  fi

  # 3) Find this FW's ENIs by tag. The module tags ENIs WITHOUT the prefix: <name>-data / <name>-mgmt.
  DATA_ENI=$(aws ec2 describe-network-interfaces --region "$REGION" \
    --filters "Name=tag:Name,Values=${BASENAME}-data" --query 'NetworkInterfaces[0].NetworkInterfaceId' --output text)
  MGMT_ENI=$(aws ec2 describe-network-interfaces --region "$REGION" \
    --filters "Name=tag:Name,Values=${BASENAME}-mgmt" --query 'NetworkInterfaces[0].NetworkInterfaceId' --output text)
  if [ -z "$DATA_ENI" ] || [ "$DATA_ENI" = "None" ] || [ -z "$MGMT_ENI" ] || [ "$MGMT_ENI" = "None" ]; then
    echo "  ERROR: both ENIs for ${BASENAME} not found (data=${DATA_ENI} mgmt=${MGMT_ENI})."
    echo "         They were likely deleted on termination. Skipping ${NAME}; contact your instructor for the fresh-ENI rebuild."
    continue
  fi
  echo "  reusing ENIs: data=${DATA_ENI} (idx0)  mgmt=${MGMT_ENI} (idx1)"

  for ENI in "$DATA_ENI" "$MGMT_ENI"; do
    until [ "$(aws ec2 describe-network-interfaces --region "$REGION" --network-interface-ids "$ENI" \
                --query 'NetworkInterfaces[0].Status' --output text)" = "available" ]; do
      echo "  waiting for ${ENI} to free ..."; sleep 5
    done
  done

  NEW=$(aws ec2 run-instances --region "$REGION" \
    --image-id "$AMI" --instance-type "$TYPE" --key-name "$KEY" \
    --iam-instance-profile "Arn=${IAM}" \
    --user-data "fileb://${HOME}/ud-${NAME}.txt" \
    --network-interfaces "NetworkInterfaceId=${DATA_ENI},DeviceIndex=0" "NetworkInterfaceId=${MGMT_ENI},DeviceIndex=1" \
    --block-device-mappings "[{\"DeviceName\":\"${ROOTDEV}\",\"Ebs\":{\"VolumeType\":\"gp3\",\"DeleteOnTermination\":true}}]" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${NAME}}]" \
    --query 'Instances[0].InstanceId' --output text)
  echo "  launched ${NAME} as ${NEW}"

  EIP=$(aws ec2 describe-network-interfaces --region "$REGION" --network-interface-ids "$MGMT_ENI" \
    --query 'NetworkInterfaces[0].Association.PublicIp' --output text 2>/dev/null || true)
  [ -n "$EIP" ] && [ "$EIP" != "None" ] && echo "  ${NAME} mgmt EIP: ${EIP}"

  TG=$(aws elbv2 describe-target-groups --region "$REGION" --names "${PREFIX}security-gwlb" \
    --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || true)
  if [ -n "$TG" ] && [ "$TG" != "None" ]; then
    aws elbv2 register-targets --region "$REGION" --target-group-arn "$TG" --targets "Id=${NEW}"
    echo "  registered ${NEW} to ${PREFIX}security-gwlb"
  else
    echo "  WARN: ${PREFIX}security-gwlb not found; register ${NEW} to the GWLB target group manually"
  fi
done
echo; echo "Done. ~10-15 min to bootstrap + license. Verify: SSH to the mgmt EIP, 'request license info' and 'show system info'."
