### VPC ###
spoke1_vpc = {
  spoke1_vpc = {
    name                 = "spoke1-app-vpc"
    cidr_block           = "10.200.0.0/23"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    internet_gateway     = true
  }
}

spoke1_vpc_route_tables = {
  igw-edge = { name = "spoke1-vpc-igw-edge", igw_association = "spoke1_vpc" }
  alb1      = { name = "spoke1-vpc-alb1" }
  alb2      = { name = "spoke1-vpc-alb2" }
  gwlbe1    = { name = "spoke1-vpc-gwlbe1" }
  gwlbe2    = { name = "spoke1-vpc-gwlbe2" }
  web1      = { name = "spoke1-vpc-web1" }
  web2      = { name = "spoke1-vpc-web2" }
}

spoke1_vpc_subnets = {
  alb1      = { name = "spoke1-vpc-alb1", cidr = "10.200.0.16/28", az = "a", rt = "alb1" }
  alb2      = { name = "spoke1-vpc-alb2", cidr = "10.200.1.16/28", az = "c", rt = "alb2" }
  gwlbe1    = { name = "spoke1-vpc-gwlbe1", cidr = "10.200.0.32/28", az = "a", rt = "gwlbe1" }
  gwlbe2    = { name = "spoke1-vpc-gwlbe2", cidr = "10.200.1.32/28", az = "c", rt = "gwlbe2" }
  web1      = { name = "spoke1-vpc-web1", cidr = "10.200.0.48/28", az = "a", rt = "web1" }
  web2      = { name = "spoke1-vpc-web2", cidr = "10.200.1.48/28", az = "c", rt = "web2" }
}

spoke1_vpc_endpoints = {
}

spoke1_vpc_security_groups = {
  web-server-sg = {
    name = "spoke1-vpc-web-server-sg"
    rules = {
      all-outbound = {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
      permit-internal = {
        description = "Permit All Internal traffic"
        type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["10.0.0.0/8"]
      }
      permit-sy-https = {
        description = "Permit Port 80 Public"
        type        = "ingress", from_port = "80", to_port = "80", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      permit-sy-ssh = {
        description = "Permit Port 22 Public"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }

}


### GWLB ###

spoke1_gateway_load_balancers = { // Pull back info from existing GWLB endpoint service in security VPC
  security-gwlb = {
    name           = "security-gwlb"
    existing = true
  }
}

spoke1_gateway_load_balancer_endpoints = {
  spoke1-inbound1 = {
    name                  = "spoke1-vpc-inbound-gwlb-endpoint1"
    gateway_load_balancer = "security-gwlb"
    subnet_names          = ["gwlbe1"]
  }
  spoke1-inbound2 = {
    name                  = "spoke1-vpc-inbound-gwlb-endpoint2"
    gateway_load_balancer = "security-gwlb"
    subnet_names          = ["gwlbe2"]
  }
}


spoke1_transit_gateways = {
  gwlb = {
    name     = "tgw-us-east1"
    existing = true
    route_tables = {
      security-in = { name = "from-security-vpc", existing = true }
      spoke-in = { name = "from-spoke-vpcs", existing = true }
    }
  }
}

spoke1_transit_gateway_vpc_attachments = {
  prod = {
    name = "spoke1-vpc-vpc"
    vpc  = "vpc_id"
    #appliance_mode_support                  = "enable"
    subnets                                  = ["web1", "web2"]
    transit_gateway                          = "gwlb"
    transit_gateway_route_table_association  = "spoke-in"
    #transit_gateway_route_table_propagations = ""
  }
}


### VPC_ROUTES
# spoke1_vpc_routes = {
#   igw-edge-alb1-to-endpoint1 = {
#     route_table   = "igw-edge"
#     prefix        = "10.200.0.16/28"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "spoke1-inbound1"
#   }
#   igw-edge-alb2-to-endpoint2 = {
#     route_table   = "igw-edge"
#     prefix        = "10.200.1.16/28"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "spoke1-inbound2"
#   }
#   web1-default-to-tgw = {
#     route_table   = "web1"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "transit_gateway"
#     next_hop_name = "gwlb"
#   }
#   web2-default-to-tgw = {
#     route_table   = "web2"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "transit_gateway"
#     next_hop_name = "gwlb"
#   }
#   gwlbe1-default-to-igw = {
#     route_table   = "gwlbe1"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "internet_gateway"
#     next_hop_name = "spoke1_vpc"
#   }
#   gwlbe2-default-to-igw = {
#     route_table   = "gwlbe2"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "internet_gateway"
#     next_hop_name = "spoke1_vpc"
#   }
#   alb1-to-endpoint1 = {
#     route_table   = "alb1"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "spoke1-inbound1"
#   }
#   alb2-to-endpoint2 = {
#     route_table   = "alb2"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "spoke1-inbound2"
#   }
# }