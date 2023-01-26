### General

variable "region" {
  description = "AWS Region."
  default     = "us-west-2"
  type        = string
}

variable "prefix_name_tag" {
  description = "Prefix use for creating unique names."
  default     = ""
  type        = string
}

variable "global_tags" {
  description = <<-EOF
  A map of tags to assign to the resources.
  If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  EOF
  default     = {}
  type        = map(any)
}

### Network

variable management_vpc { default = {} }
variable management_vpc_route_tables { default = {} }
variable management_vpc_subnets { default = {} }
variable management_vpc_security_groups { default = {} }
variable management_nat_gateways { default = {} }
variable management_vpc_endpoints { default = {} }
variable management_vpc_routes { default = {} }
variable management_vpc_routes_additional { default = {} }
variable management_gateway_load_balancers { default = {} }
variable management_gateway_load_balancer_endpoints { default = {} }
variable management_transit_gateways { default = {} }
variable management_transit_gateway_vpc_attachments { default = {} }
variable management_transit_gateway_peerings { default = {} }


### Panorama

variable "panorama_ami_id" {
  description = "AMI ID if using a custom image. Leave null to detect from marketplace"
  type        = string
  default     = null
}

variable "panorama_az" {
  description = "Availability zone where Panorama was be deployed."
  type        = string
}

variable "panorama_ssh_key_name" {
  description = "SSH key used to login into Panorama EC2 server."
  type        = string
}

variable "panorama_create_public_ip" {
  description = "Public access to Panorama."
  default     = false
  type        = bool
}

variable "panorama_version" {
  description = "Panorama OS Version."
  default     = "10.2.0"
  type        = string
}

variable "panorama_deployment_name" {
  description = "Name of Panorama deployment, further use for tagging and name of Panorama instance."
  default     = "panorama"
  type        = string
}

variable "panorama_ebs_volumes" {
  description = "List of Panorama volumes"
  default     = []
  type        = list(any)
}

variable "panorama_ebs_encrypted" {
  description = "Whether to enable EBS encryption on volumes.."
  default     = true
  type        = bool
}

variable "panorama_ebs_kms_key_alias" {
  description = "KMS key alias used for encrypting Panorama EBS."
  default     = ""
  type        = string
}

### IAM Instance Role

variable "panorama_create_iam_instance_profile" {
  description = "Enable creation of IAM Instance Profile and attach it to Panorama."
  default     = false
  type        = bool
}

variable "panorama_create_iam_role" {
  description = "Enable creation of IAM Role for IAM Instance Profile."
  default     = false
  type        = bool
}

variable "panorama_iam_policy_name" {
  description = <<-EOF
If you want to use existing IAM Policy in Terraform created IAM Role, provide IAM Role name with this variable."
EOF
  default     = ""
  type        = string
}

variable "panorama_existing_iam_role_name" {
  description = <<-EOF
If you want to use existing IAM Role as IAM Instance Profile use this variable to provide IAM Role name."
EOF
  default     = ""
  type        = string
}

variable "private_ip_address" {
  description = "If provided, associates a private IP address to the Panorama instance."
  type        = string
  default     = null
}