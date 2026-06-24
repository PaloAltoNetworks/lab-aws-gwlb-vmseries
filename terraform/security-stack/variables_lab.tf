# ── Lab/refactor-specific variables (additions beyond the upstream combined_design surface) ──

variable "az_count" {
  description = "Number of AZs to spread the topology across. AZ names are derived from the region (data.aws_availability_zones), never hardcoded. 2 = active/active GWLB."
  type        = number
  default     = 2
}

variable "module_version" {
  description = "Pinned PaloAltoNetworks/swfw-modules/aws version (documentation; module blocks hardcode the literal)."
  type        = string
  default     = "2.2.7"
}

### Cross-region Panorama wiring ###
variable "panorama_region" {
  description = "Region where the Panorama root is deployed (the aws.panorama provider alias + cross-region TGW peering target)."
  type        = string
  default     = "ca-central-1"
}

variable "panorama_state_bucket" {
  description = "S3 bucket holding the panorama root's remote state (from the bootstrap root)."
  type        = string
}

variable "panorama_state_key" {
  description = "Key of the panorama root's state object."
  type        = string
  default     = "panorama/terraform.tfstate"
}

variable "panorama_state_region" {
  description = "Region of the state bucket (the backend region, not the Panorama region)."
  type        = string
  default     = "us-west-1"
}

variable "fw_bootstrap_to_panorama_eip" {
  description = "false (default) = FW bootstraps to Panorama PRIVATE IP over the TGW peering. true = one-line fallback to the Panorama public EIP (no peering dependency)."
  type        = bool
  default     = false
}

variable "fw_supernet" {
  description = "Supernet covering all FW-region VPCs (security + spokes). Used for the cross-region TGW return routes to Panorama."
  type        = string
  default     = "10.0.0.0/8"
}

### Licensing (the gate) ###
variable "lm_authkey" {
  description = <<-EOF
  The sw_fw_license License-Manager bootstrap auth-key (the `_AQ__...` key) injected into FW
  bootstrap as `auth-key=`. Sourced from SSM by the orchestrator AFTER the License Manager is
  committed + verified. Empty until then (the FW apply is gated on a non-empty value).
  EOF
  type        = string
  default     = ""
  sensitive   = true
}

### Instructor vs student ###
variable "deploy_exercise_routes" {
  description = "false (default, student) = the guide's inspection-path routes are intentionally omitted for the routing exercises. true (instructor / e2e) = deploy them for a fully-working environment."
  type        = bool
  default     = false
}
