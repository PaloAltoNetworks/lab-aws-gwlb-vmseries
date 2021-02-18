### Module calls for Security VPC and base infrastructure

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
  public_key = file(var.public_key_path)
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


### Module calls for App1 VPC



module "app1_vpc" {
  source           = "../modules/vpc"
  global_tags      = var.global_tags
  prefix_name_tag  = var.prefix_name_tag
  vpc              = var.app1_vpc
  vpc_route_tables = var.app1_vpc_route_tables
  subnets          = var.app1_vpc_subnets
  vpc_endpoints    = var.app1_vpc_endpoints
  security_groups  = var.app1_vpc_security_groups
}


module "app1_vpc_routes" {
  source            = "../modules/vpc_routes"
  region            = var.region
  global_tags       = var.global_tags
  prefix_name_tag   = var.prefix_name_tag
  vpc_routes        = var.app1_vpc_routes
  vpc_route_tables  = module.app1_vpc.route_table_ids
  internet_gateways = module.app1_vpc.internet_gateway_id
  nat_gateways      = module.app1_vpc.nat_gateway_ids
  vpc_endpoints     = module.app1_gwlb.endpoint_ids
  transit_gateways  = module.app1_transit_gateways.transit_gateway_ids
}

module "app1_transit_gateways" {
  source                          = "../modules/transit_gateway"
  global_tags                     = var.global_tags
  prefix_name_tag                 = var.prefix_name_tag
  subnets                         = module.app1_vpc.subnet_ids
  vpcs                            = module.app1_vpc.vpc_id
  transit_gateways                = var.app1_transit_gateways
  transit_gateway_vpc_attachments = var.app1_transit_gateway_vpc_attachments
  depends_on = [module.gwlb] // Depends on GWLB being created in security VPC
}

module "app1_gwlb" {
  source                          = "../modules/gwlb"
  region                          = var.region
  global_tags                     = var.global_tags
  prefix_name_tag                 = var.prefix_name_tag
  vpc_id                          = module.app1_vpc.vpc_id.vpc_id
  gateway_load_balancers          = var.app1_gateway_load_balancers
  gateway_load_balancer_endpoints = var.app1_gateway_load_balancer_endpoints
  subnets_map                     = module.app1_vpc.subnet_ids
  depends_on = [module.transit_gateways] // Depends on GWLB being created in security VPC
}

# output "testing" {
#   value = module.gwlb.endpoints
# }


module "app1_ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "app1-cluster"
  instance_count         = 2
  associate_public_ip_address = false

  ami                    = "ami-0e999cbd62129e3b1" //TODO lookup ami per region
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.lab.key_name
  monitoring             = true
  vpc_security_group_ids = [module.app1_vpc.security_group_ids["web-server-sg"]]
  subnet_id              = module.app1_vpc.subnet_ids["web1"]

  tags = var.global_tags
}


### Module calls for app2 VPC



module "app2_vpc" {
  source           = "../modules/vpc"
  global_tags      = var.global_tags
  prefix_name_tag  = var.prefix_name_tag
  vpc              = var.app2_vpc
  vpc_route_tables = var.app2_vpc_route_tables
  subnets          = var.app2_vpc_subnets
  vpc_endpoints    = var.app2_vpc_endpoints
  security_groups  = var.app2_vpc_security_groups
}


module "app2_vpc_routes" {
  source            = "../modules/vpc_routes"
  region            = var.region
  global_tags       = var.global_tags
  prefix_name_tag   = var.prefix_name_tag
  vpc_routes        = var.app2_vpc_routes
  vpc_route_tables  = module.app2_vpc.route_table_ids
  internet_gateways = module.app2_vpc.internet_gateway_id
  nat_gateways      = module.app2_vpc.nat_gateway_ids
  vpc_endpoints     = module.app2_gwlb.endpoint_ids
  transit_gateways  = module.app2_transit_gateways.transit_gateway_ids
}

module "app2_transit_gateways" {
  source                          = "../modules/transit_gateway"
  global_tags                     = var.global_tags
  prefix_name_tag                 = var.prefix_name_tag
  subnets                         = module.app2_vpc.subnet_ids
  vpcs                            = module.app2_vpc.vpc_id
  transit_gateways                = var.app2_transit_gateways
  transit_gateway_vpc_attachments = var.app2_transit_gateway_vpc_attachments
  depends_on = [module.gwlb] // Depends on GWLB being created in security VPC
}

module "app2_gwlb" {
  source                          = "../modules/gwlb"
  region                          = var.region
  global_tags                     = var.global_tags
  prefix_name_tag                 = var.prefix_name_tag
  vpc_id                          = module.app2_vpc.vpc_id.vpc_id
  gateway_load_balancers          = var.app2_gateway_load_balancers
  gateway_load_balancer_endpoints = var.app2_gateway_load_balancer_endpoints
  subnets_map                     = module.app2_vpc.subnet_ids
  depends_on = [module.transit_gateways] // Depends on GWLB being created in security VPC
}

# output "testing" {
#   value = module.gwlb.endpoints
# }


module "app2_ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "app2-cluster"
  instance_count         = 2
  associate_public_ip_address = false

  ami                    = "ami-0e999cbd62129e3b1" //TODO lookup ami per region
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.lab.key_name
  monitoring             = true
  vpc_security_group_ids = [module.app2_vpc.security_group_ids["web-server-sg"]]
  subnet_id              = module.app2_vpc.subnet_ids["web1"]

  tags = var.global_tags
}
