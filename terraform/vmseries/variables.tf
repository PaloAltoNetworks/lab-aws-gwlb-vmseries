### Global
variable region {}
variable prefix_name_tag {}
variable global_tags {}
variable fw_instance_type {}
variable fw_license_type {}
variable fw_version {}
variable "vmseries_ssh_key_name" {
  description = "SSH key used to login into VM-Series EC2 server."
  type        = string
}

### Panorama API Connection

variable "panorama_host" {
  default = ""
}

variable "panorama_username" {
  description = "Username for terraform and python to authenticate to Panorama API"
  default =  ""
}

variable "panorama_password" {
  description = "Username for terraform and python to authenticate to Panorama API"
  default = ""
}

variable authcodes { default = "" }
variable vm_auth_key { default = "" }

#variable public_key_path {}

### VPC
variable security_vpc {}
variable security_vpc_route_tables {}
variable security_vpc_subnets {}
variable security_vpc_security_groups {}
variable security_nat_gateways {}
variable security_vpc_endpoints {}

# VMSERIES
variable interfaces { default = [] }
variable firewalls { default = [] }
# variable addtional_interfaces {}

# VPC_ROUTES
variable vpc_routes {}
variable vpc_routes_additional { default = {} }

# GWLB
variable gateway_load_balancers {}
variable gateway_load_balancer_endpoints {}
variable gateway_load_balancer_subnets {}
variable transit_gateways { default = {} }
variable transit_gateway_vpc_attachments { default = {} }
variable transit_gateway_peerings { default = {} }

### APP1 Variables

variable app1_vpc { default = {} }
variable app1_vpc_route_tables { default = {} }
variable app1_vpc_subnets { default = {} }
variable app1_vpc_security_groups { default = {} }
variable app1_nat_gateways { default = {} }
variable app1_vpc_endpoints { default = {} }
variable app1_vpc_routes { default = {} }
variable app1_vpc_routes_additional { default = {} }
variable app1_gateway_load_balancers { default = {} }
variable app1_gateway_load_balancer_endpoints { default = {} }
variable app1_transit_gateways { default = {} }
variable app1_transit_gateway_vpc_attachments { default = {} }
variable app1_transit_gateway_peerings { default = {} }

### APP2 Variables

variable app2_vpc { default = {} }
variable app2_vpc_route_tables { default = {} }
variable app2_vpc_subnets { default = {} }
variable app2_vpc_security_groups { default = {} }
variable app2_nat_gateways { default = {} }
variable app2_vpc_endpoints { default = {} }
variable app2_vpc_routes { default = {} }
variable app2_vpc_routes_additional { default = {} }
variable app2_gateway_load_balancers { default = {} }
variable app2_gateway_load_balancer_endpoints { default = {} }
variable app2_transit_gateways { default = {} }
variable app2_transit_gateway_vpc_attachments { default = {} }
variable app2_transit_gateway_peerings { default = {} }


