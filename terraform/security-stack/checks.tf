# ── Fail-fast + compatibility guards (root glue only, no module edits) ──

# Soft AMI resolution probe (aws_ami_ids returns an empty list rather than erroring),
# so we can surface a clear, actionable message naming the offending FW group + region.
data "aws_ami_ids" "fw" {
  for_each = var.vmseries
  owners   = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["${each.value.airs_deployment ? "PA-AI-Runtime-Security-AWS-" : (each.value.arm_deployment ? "PA-VMARM-AWS-" : "PA-VM-AWS-")}${each.value.panos_version}*"]
  }
}

check "fw_ami_resolves" {
  assert {
    condition = alltrue([for k, d in data.aws_ami_ids.fw : length(d.ids) > 0])
    error_message = format(
      "No VM-Series/AIRS AMI resolved in region %s for FW group(s): %s. Verify panos_version + airs_deployment and AMI availability:\n  aws ec2 describe-images --region %s --owners aws-marketplace --filters 'Name=name,Values=PA-*' --query 'Images[].Name'",
      var.region,
      join(", ", [for k, d in data.aws_ami_ids.fw : k if length(d.ids) == 0]),
      var.region
    )
  }
}

locals {
  _pan_ver = data.terraform_remote_state.panorama.outputs.panorama_version
  _pan_mm  = tonumber(split(".", local._pan_ver)[0]) * 1000 + tonumber(split(".", local._pan_ver)[1])
}

# Panorama must be at or above every managed firewall's PAN-OS version.
check "fw_not_newer_than_panorama" {
  assert {
    condition = alltrue([
      for k, v in var.vmseries :
      (tonumber(split(".", v.panos_version)[0]) * 1000 + tonumber(split(".", v.panos_version)[1])) <= local._pan_mm
    ])
    error_message = "Each FW PAN-OS major.minor must be <= Panorama (${local._pan_ver}). Panorama must be at or above the managed firewall version."
  }
}

# AIRS images exist only for PAN-OS >= 11.2.4-h1 (coarse major.minor guard).
check "airs_min_version" {
  assert {
    condition = alltrue([
      for k, v in var.vmseries :
      !v.airs_deployment || (tonumber(split(".", v.panos_version)[0]) * 1000 + tonumber(split(".", v.panos_version)[1])) >= 11002
    ])
    error_message = "AIRS images exist only for PAN-OS >= 11.2.4-h1. Set airs_deployment=false or use panos_version >= 11.2.4-h1."
  }
}
