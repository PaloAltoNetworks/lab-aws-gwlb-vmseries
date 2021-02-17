### Global
variable "region" {}
variable "prefix_name_tag" {}
variable "global_tags" {}
variable "fw_instance_type" {}
variable "fw_license_type" {}
variable "fw_version" {}
variable "ssh_key_name" {}
variable "public_key_path" {}

### VPC
variable "security_vpc" {}
variable "security_vpc_route_tables" {}
variable "security_vpc_subnets" {}
variable "security_vpc_security_groups" {}
variable "security_nat_gateways" {}
variable "security_vpc_endpoints" {}

# VMSERIES
variable "interfaces" {}
variable "firewalls" {}
# variable "addtional_interfaces" {}

# VPC_ROUTES
variable "vpc_routes" {}

# GWLB
variable "gateway_load_balancers" {}
variable "gateway_load_balancer_endpoints" {}
variable "gateway_load_balancer_subnets" {}

variable transit_gateways {
  default = {}
}

variable transit_gateway_vpc_attachments {
  default = {}
}

variable transit_gateway_peerings {
  default = {}
}