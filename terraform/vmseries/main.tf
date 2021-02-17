module "security_vpc" {
  source           = "../modules/vpc"
  global_tags      = var.global_tags
  prefix_name_tag  = var.prefix_name_tag
  vpc              = var.security_vpc
  vpc_route_tables = var.security_vpc_route_tables
  subnets          = var.security_vpc_subnets
  nat_gateways     = var.security_nat_gateways
  vpc_endpoints    = var.security_vpc_endpoints
  security_groups  = var.security_vpc_security_groups
}

resource "aws_key_pair" "lab" {
  key_name   = var.ssh_key_name
  public_key = var.public_key_path
}

module "vmseries" {
  source              = "../modules/vmseries"
  region              = var.region
  prefix_name_tag     = var.prefix_name_tag
  ssh_key_name        = aws_key_pair.lab.key_name
  fw_license_type     = var.fw_license_type
  fw_version          = var.fw_version
  fw_instance_type    = var.fw_instance_type
  tags                = var.global_tags
  firewalls           = var.firewalls
  interfaces          = var.interfaces
  subnets_map         = module.security_vpc.subnet_ids
  security_groups_map = module.security_vpc.security_group_ids
  # addtional_interfaces = var.addtional_interfaces
}

module "vpc_routes" {
  source            = "../modules/vpc_routes"
  region            = var.region
  global_tags       = var.global_tags
  prefix_name_tag   = var.prefix_name_tag
  vpc_routes        = var.vpc_routes
  vpc_route_tables  = module.security_vpc.route_table_ids
  internet_gateways = module.security_vpc.internet_gateway_id
  nat_gateways      = module.security_vpc.nat_gateway_ids
  vpc_endpoints     = module.gwlb.endpoint_ids
  transit_gateways  = module.transit_gateways.transit_gateway_ids
}

# We need to generate a list of subnet IDs
locals {
  trusted_subnet_ids = [
    for s in var.gateway_load_balancer_subnets :
    module.security_vpc.subnet_ids[s]
  ]
}

module "gwlb" {
  source                          = "../modules/gwlb"
  region                          = var.region
  global_tags                     = var.global_tags
  prefix_name_tag                 = var.prefix_name_tag
  vpc_id                          = module.security_vpc.vpc_id.vpc_id
  gateway_load_balancers          = var.gateway_load_balancers
  gateway_load_balancer_endpoints = var.gateway_load_balancer_endpoints
  name                            = "zzz"
  firewalls                       = module.vmseries.firewalls
  subnet_ids                      = local.trusted_subnet_ids
  subnets_map                     = module.security_vpc.subnet_ids
}

module "transit_gateways" {
  source                          = "../modules/transit_gateway"
  global_tags                     = var.global_tags
  prefix_name_tag                 = var.prefix_name_tag
  subnets                         = module.security_vpc.subnet_ids
  vpcs                            = module.security_vpc.vpc_id
  transit_gateways                = var.transit_gateways
  transit_gateway_vpc_attachments = var.transit_gateway_vpc_attachments
  transit_gateway_peerings        = var.transit_gateway_peerings
}