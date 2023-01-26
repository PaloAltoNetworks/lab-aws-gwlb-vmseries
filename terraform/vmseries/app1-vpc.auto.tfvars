### VPC ###
app1_vpc = {
  app1_vpc = {
    name                 = "app1-spoke-vpc"
    cidr_block           = "10.200.0.0/23"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    internet_gateway     = true
  }
}

app1_vpc_route_tables = {
  igw-edge = { name = "app1-igw-edge", igw_association = "app1_vpc" }
  alb1      = { name = "app1-alb1" }
  alb2      = { name = "app1-alb2" }
  gwlbe1    = { name = "app1-gwlbe1" }
  gwlbe2    = { name = "app1-gwlbe2" }
  web1      = { name = "app1-web1" }
  web2      = { name = "app1-web2" }
}

app1_vpc_subnets = {
  alb1      = { name = "app1-alb1", cidr = "10.200.0.16/28", az = "a", rt = "alb1" }
  alb2      = { name = "app1-alb2", cidr = "10.200.1.16/28", az = "c", rt = "alb2" }
  gwlbe1    = { name = "app1-gwlbe1", cidr = "10.200.0.32/28", az = "a", rt = "gwlbe1" }
  gwlbe2    = { name = "app1-gwlbe2", cidr = "10.200.1.32/28", az = "c", rt = "gwlbe2" }
  web1      = { name = "app1-web1", cidr = "10.200.0.48/28", az = "a", rt = "web1" }
  web2      = { name = "app1-web2", cidr = "10.200.1.48/28", az = "c", rt = "web2" }
}

app1_vpc_endpoints = {
}

app1_vpc_security_groups = {
  web-server-sg = {
    name = "app1-web-server-sg"
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

app1_gateway_load_balancers = { // Pull back info from existing GWLB endpoint service in security VPC
  security-gwlb = {
    name           = "ps-lab-security-gwlb"
    existing = true
  }
}

app1_gateway_load_balancer_endpoints = {
  app1-inbound1 = {
    name                  = "app1-inbound-gwlb-endpoint1"
    gateway_load_balancer = "security-gwlb"
    subnet_names          = ["gwlbe1"]
  }
  app1-inbound2 = {
    name                  = "app1-inbound-gwlb-endpoint2"
    gateway_load_balancer = "security-gwlb"
    subnet_names          = ["gwlbe2"]
  }
}


app1_transit_gateways = {
  gwlb = {
    name     = "management-lab-tgw"
    existing = true
    route_tables = {
      security-in = { name = "ps-lab-from-security-vpc", existing = true }
      spoke-in = { name = "ps-lab-from-spoke-vpcs", existing = true }
    }
  }
}

app1_transit_gateway_vpc_attachments = {
  prod = {
    name = "ps-lab-app1-vpc"
    vpc  = "vpc_id"
    #appliance_mode_support                  = "enable"
    subnets                                  = ["web1", "web2"]
    transit_gateway                          = "gwlb"
    transit_gateway_route_table_association  = "spoke-in"
    transit_gateway_route_table_propagations = "security-in"
  }
}


### VPC_ROUTES
# app1_vpc_routes = {
#   igw-edge-alb1-to-endpoint1 = {
#     route_table   = "igw-edge"
#     prefix        = "10.200.0.16/28"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "app1-inbound1"
#   }
#   igw-edge-alb2-to-endpoint2 = {
#     route_table   = "igw-edge"
#     prefix        = "10.200.1.16/28"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "app1-inbound2"
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
#     next_hop_name = "app1_vpc"
#   }
#   gwlbe2-default-to-igw = {
#     route_table   = "gwlbe2"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "internet_gateway"
#     next_hop_name = "app1_vpc"
#   }
#   alb1-to-endpoint1 = {
#     route_table   = "alb1"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "app1-inbound1"
#   }
#   alb2-to-endpoint2 = {
#     route_table   = "alb2"
#     prefix        = "0.0.0.0/0"
#     next_hop_type = "vpc_endpoint"
#     next_hop_name = "app1-inbound2"
#   }
# }