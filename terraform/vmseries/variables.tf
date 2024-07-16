### Global
variable region {}
variable peer_region {}
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

# authcodes and vm_auth_key if bootstrapping without Panorama Licensing Plugin
variable authcodes { default = "" }
variable vm_auth_key { default = "" }

# auth-key for boostrap with Panorama Licnesing Plugin
variable auth-key { default = "" }

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

### spoke1 Variables

variable spoke1_vpc { default = {} }
variable spoke1_vpc_route_tables { default = {} }
variable spoke1_vpc_subnets { default = {} }
variable spoke1_vpc_security_groups { default = {} }
variable spoke1_nat_gateways { default = {} }
variable spoke1_vpc_endpoints { default = {} }
variable spoke1_vpc_routes { default = {} }
variable spoke1_vpc_routes_additional { default = {} }
variable spoke1_gateway_load_balancers { default = {} }
variable spoke1_gateway_load_balancer_endpoints { default = {} }
variable spoke1_transit_gateways { default = {} }
variable spoke1_transit_gateway_vpc_attachments { default = {} }
variable spoke1_transit_gateway_peerings { default = {} }

### spoke2 Variables

variable spoke2_vpc { default = {} }
variable spoke2_vpc_route_tables { default = {} }
variable spoke2_vpc_subnets { default = {} }
variable spoke2_vpc_security_groups { default = {} }
variable spoke2_nat_gateways { default = {} }
variable spoke2_vpc_endpoints { default = {} }
variable spoke2_vpc_routes { default = {} }
variable spoke2_vpc_routes_additional { default = {} }
variable spoke2_gateway_load_balancers { default = {} }
variable spoke2_gateway_load_balancer_endpoints { default = {} }
variable spoke2_transit_gateways { default = {} }
variable spoke2_transit_gateway_vpc_attachments { default = {} }
variable spoke2_transit_gateway_peerings { default = {} }


