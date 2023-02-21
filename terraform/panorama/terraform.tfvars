## General
region                = "us-west-2"
prefix_name_tag       = ""

global_tags = {
  ManagedBy   = "terraform"
  Application = "Palo Alto Networks Panorama"
}

## Network
management_vpc = {
  management_vpc = {
    name                 = "panorama-vpc"
    cidr_block           = "192.168.10.0/24"
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    internet_gateway     = true
  }
}

management_vpc_route_tables = {
  management      = { name = "panorama-vpc-mgmt" }
}

management_vpc_subnets = {
  management1      = { name = "panorama-vpc-mgmt1", cidr = "192.168.10.0/25", az = "a", rt = "management" }
  management2      = { name = "panorama-vpc-mgmt2", cidr = "192.168.10.128/25", az = "c", rt = "management" }
}

management_vpc_endpoints = {
}

management_transit_gateways = {
  lab = {
    name     = "gwlb-lab-tgw"
    asn      = "65200"
    existing = false
    route_tables = {
      security-in = { name = "from-security-vpc", existing = false }
      spoke-in = { name = "from-spoke-vpcs", existing = false }
    }
  }
}

management_transit_gateway_vpc_attachments = {
  management = {
    name = "panorama-vpc"
    vpc  = "vpc_id"
    #appliance_mode_support                  = "enable"
    subnets                                  = ["management1", "management2"]
    transit_gateway                          = "lab"
    transit_gateway_route_table_association  = "spoke-in"
    transit_gateway_route_table_propagations = "security-in"
  }
}


management_vpc_security_groups = {
  panorama = {
    name = "panorama-sg"
    rules = {
      all-outbound = {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
      permit-vmseries-mgmt = {
        description = "Permit VM-Series Management"
        type        = "ingress", from_port = "3978", to_port = "3978", protocol = "tcp"
        cidr_blocks = ["10.100.0.0/23"]
      }
      permit-vmseries-logging = {
        description = "Permit VM-Series Logging"
        type        = "ingress", from_port = "28443", to_port = "28443", protocol = "tcp"
        cidr_blocks = ["10.100.0.0/23"]
      }
      permit-https-public = {
        description = "Permit Port 443 Public"
        type        = "ingress", from_port = "443", to_port = "443", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      permit-ssh-public = {
        description = "Permit Port 22 Public"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
      permit-icmp-public = {
        description = "Permit ICMP Public"
        type        = "ingress", from_port = "-1", to_port = "-1", protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
}

### VPC_ROUTES
management_vpc_routes = {
  management-default-to-igw = {
    route_table   = "management"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "management_vpc"
  }
  web2-default-to-tgw = {
    route_table   = "management"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "lab"
  }
}

### Panorama Vars ###

## IAM Instance Role
panorama_iam_policy_name             = "AmazonEC2ReadOnlyAccess"
panorama_create_iam_instance_profile = true
panorama_create_iam_role             = true
#panorama_existing_iam_role_name = "PanoramaROCuratedRole" <-- use this variable to attach existing IAM Role.

## Panorama
panorama_ssh_key_name     = "qwikLABS*"
panorama_ami_id           = "ami-0de23a5f895edf40a"
panorama_az               = "us-west-2a"
private_ip_address        = "192.168.10.10"
panorama_create_public_ip = true
panorama_ebs_encrypted    = false
#panorama_ebs_kms_key_alias = "panoramamainkms" <-- use this variable when you have own KMS key.

panorama_ebs_volumes = []


# panorama_ebs_volumes = [
#   {
#     name            = "ebs-1"
#     ebs_device_name = "/dev/sdb"
#     ebs_size        = "2000"
#     ebs_encrypted   = true
#   }
# ]
