variable "region" {
  description = "Region for Panorama. MUST differ from the security/FW region (cross-region split). Avoid regions already running other stacks."
  type        = string
  default     = "ca-central-1"
}

variable "name_prefix" {
  description = "Prefix for all resource names in this root."
  type        = string
  default     = "pan-gwlb-lab-"
}

variable "global_tags" {
  description = "Tags applied to every resource (via provider default_tags)."
  type        = map(string)
  default = {
    ManagedBy   = "terraform"
    Application = "Palo Alto Networks VM-Series GWLB lab"
    Component   = "panorama"
  }
}

variable "module_version" {
  description = "Pinned PaloAltoNetworks/swfw-modules/aws version."
  type        = string
  default     = "2.2.7"
}

### Network ###
variable "vpc_cidr" {
  description = "Panorama management VPC CIDR. Must not overlap the FW-region supernet (var.fw_supernet)."
  type        = string
  default     = "192.168.10.0/24"
}

variable "mgmt_subnet_cidr" {
  description = "Subnet for the Panorama management interface."
  type        = string
  default     = "192.168.10.0/25"
}

variable "tgw_subnet_cidr" {
  description = "Small subnet to host the Transit Gateway attachment ENI."
  type        = string
  default     = "192.168.10.128/25"
}

variable "panorama_private_ip" {
  description = "Fixed private IP for Panorama. Firewalls bootstrap to this address over the TGW peering (default reachability path)."
  type        = string
  default     = "192.168.10.10"
}

variable "mgmt_allowed_cidrs" {
  description = "CIDRs allowed to reach Panorama mgmt (SSH 22 + HTTPS 443) for panorama-init and admin/API access. Set to your runner/admin IP. Empty = no inbound admin access (locked down)."
  type        = list(string)
  default     = []
}

variable "fw_supernet" {
  description = "Supernet covering the FW-region VPCs (security + spokes). Used for SG ingress (3978/443/ICMP from firewalls) and the TGW return route."
  type        = string
  default     = "10.0.0.0/8"
}

variable "tgw_asn" {
  description = "BGP ASN for the Panorama-region TGW. Must differ from the FW-region TGW ASN for peering."
  type        = number
  default     = 64513
}

### Panorama instance ###
variable "panorama_version" {
  description = "Panorama PAN-OS version. MUST be >= the managed FW version. 12.x requires >=16 vCPU / 32 GB."
  type        = string
  default     = "12.1.7"
}

variable "panorama_instance_type" {
  description = "Panorama instance type. 12.x needs >=16 vCPU / 32 GB; m5.4xlarge = 16 vCPU / 64 GB."
  type        = string
  default     = "m5.4xlarge"
}

variable "panorama_product_code" {
  description = "Marketplace product code (BYOL). Default matches the public Panorama BYOL image used with sw_fw_license."
  type        = string
  default     = "eclz7j04vu9lf8ont8ta3n17o"
}

variable "panorama_ami_id" {
  description = "Explicit Panorama AMI ID. If null, resolved from panorama_version + product_code (newest match)."
  type        = string
  default     = null
}

variable "panorama_log_disk_gib" {
  description = "Size of the gp3 logging disk attached to Panorama (panorama-mode). PAN-OS Panorama on AWS requires 2 TB (2000 GiB) units; an undersized disk fails to initialize and the mgmt plane hangs at boot. Matches the official module default."
  type        = number
  default     = 2000
  validation {
    condition     = var.panorama_log_disk_gib >= 2000 && var.panorama_log_disk_gib % 2000 == 0
    error_message = "Panorama logging disk must be a multiple of 2000 GiB (2 TB units); PAN-OS rejects other sizes and hangs at boot."
  }
}
