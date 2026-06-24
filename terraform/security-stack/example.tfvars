### Security-stack root — copy to terraform.tfvars and edit. terraform.tfvars is gitignored.
### Single root (combined_design model): security VPC + VM-Series + GWLB + 2 spokes + TGW.
### FW->Panorama is wired by remote-state output + the SSM-sourced LM auth-key (no tag rediscovery).

### GENERAL
region          = "us-west-1"   # FW/security region (separate from Panorama)
panorama_region = "ca-central-1" # must match the panorama root's region
name_prefix     = "pan-gwlb-lab-"
az_count        = 2

# Remote state of the panorama root (from the bootstrap output). TODO: set bucket to yours.
panorama_state_bucket = "pan-gwlb-lab-tfstate-493890030279-us-west-1"
panorama_state_key    = "panorama/terraform.tfstate"
panorama_state_region = "us-west-1"

fw_supernet = "10.0.0.0/8"

# Student default: inspection-path routes omitted for the guide's exercises.
# Instructor / e2e: set true (or `-var deploy_exercise_routes=true`) for a fully-wired env.
deploy_exercise_routes = false

# false = FW bootstraps to Panorama private IP via TGW peering (default). true = Panorama EIP fallback.
fw_bootstrap_to_panorama_eip = false

global_tags = {
  ManagedBy   = "terraform"
  Application = "Palo Alto Networks VM-Series GWLB lab"
  Component   = "security-stack"
}

### VPCS
vpcs = {
  security_vpc = {
    name = "security-vpc"
    cidr = "10.100.0.0/16"
    security_groups = {
      vmseries_private = {
        name = "vmseries-private"
        rules = {
          all_outbound = {
            description = "Permit all outbound"
            type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
          geneve = {
            description = "GENEVE from GWLB subnets"
            type        = "ingress", from_port = "6081", to_port = "6081", protocol = "udp"
            cidr_blocks = ["10.100.5.0/24", "10.100.69.0/24"]
          }
          health_probe = {
            description = "GWLB health probe (HTTP) from GWLB subnets"
            type        = "ingress", from_port = "80", to_port = "80", protocol = "tcp"
            cidr_blocks = ["10.100.5.0/24", "10.100.69.0/24"]
          }
        }
      }
      vmseries_mgmt = {
        name = "vmseries-mgmt"
        rules = {
          all_outbound = {
            description = "Permit all outbound"
            type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
          panorama_and_rfc1918 = {
            description = "Mgmt access from RFC1918 (Panorama, admin via peering)"
            type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
            cidr_blocks = ["10.0.0.0/8", "192.168.0.0/16"]
          }
        }
      }
      vmseries_public = {
        name = "vmseries-public"
        rules = {
          all_outbound = {
            description = "Permit all outbound"
            type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
          inbound_inspect = {
            description = "Inbound for inspection (from spokes + internet test source)"
            type        = "ingress", from_port = "0", to_port = "0", protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
        }
      }
    }
    subnets = {
      "10.100.0.0/24"  = { az_index = 0, subnet_group = "mgmt" }
      "10.100.64.0/24" = { az_index = 1, subnet_group = "mgmt" }
      "10.100.1.0/24"  = { az_index = 0, subnet_group = "private" }
      "10.100.65.0/24" = { az_index = 1, subnet_group = "private" }
      "10.100.2.0/24"  = { az_index = 0, subnet_group = "public" }
      "10.100.66.0/24" = { az_index = 1, subnet_group = "public" }
      "10.100.3.0/24"  = { az_index = 0, subnet_group = "tgw_attach" }
      "10.100.67.0/24" = { az_index = 1, subnet_group = "tgw_attach" }
      "10.100.4.0/24"  = { az_index = 0, subnet_group = "gwlbe_outbound" }
      "10.100.68.0/24" = { az_index = 1, subnet_group = "gwlbe_outbound" }
      "10.100.5.0/24"  = { az_index = 0, subnet_group = "gwlb" }
      "10.100.69.0/24" = { az_index = 1, subnet_group = "gwlb" }
      "10.100.10.0/24" = { az_index = 0, subnet_group = "gwlbe_eastwest" }
      "10.100.74.0/24" = { az_index = 1, subnet_group = "gwlbe_eastwest" }
    }
    routes = {
      # ── Base connectivity (always deployed) ──
      mgmt_default   = { vpc = "security_vpc", subnet_group = "mgmt", to_cidr = "0.0.0.0/0", next_hop_key = "security_vpc", next_hop_type = "internet_gateway" }
      mgmt_panorama  = { vpc = "security_vpc", subnet_group = "mgmt", to_cidr = "192.168.10.0/24", next_hop_key = "security", next_hop_type = "transit_gateway_attachment" }
      mgmt_rfc1918   = { vpc = "security_vpc", subnet_group = "mgmt", to_cidr = "10.0.0.0/8", next_hop_key = "security", next_hop_type = "transit_gateway_attachment" }
      public_default = { vpc = "security_vpc", subnet_group = "public", to_cidr = "0.0.0.0/0", next_hop_key = "security_vpc", next_hop_type = "internet_gateway" }

      # ── Inspection-path routes (guide exercise; gated by deploy_exercise_routes) ──
      tgw_default            = { vpc = "security_vpc", subnet_group = "tgw_attach", to_cidr = "0.0.0.0/0", next_hop_key = "security_gwlb_outbound", next_hop_type = "gwlbe_endpoint", exercise = true }
      tgw_rfc1918            = { vpc = "security_vpc", subnet_group = "tgw_attach", to_cidr = "10.0.0.0/8", next_hop_key = "security_gwlb_eastwest", next_hop_type = "gwlbe_endpoint", exercise = true }
      gwlbe_outbound_rfc1918 = { vpc = "security_vpc", subnet_group = "gwlbe_outbound", to_cidr = "10.0.0.0/8", next_hop_key = "security", next_hop_type = "transit_gateway_attachment", exercise = true }
      gwlbe_eastwest_rfc1918 = { vpc = "security_vpc", subnet_group = "gwlbe_eastwest", to_cidr = "10.0.0.0/8", next_hop_key = "security", next_hop_type = "transit_gateway_attachment", exercise = true }
    }
  }

  app1_vpc = {
    name = "spoke1-app-vpc"
    cidr = "10.104.0.0/16"
    security_groups = {
      app1_vm = {
        name = "app1-vm"
        rules = {
          all_outbound = { description = "outbound", type = "egress", from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
          web          = { description = "HTTP/SSH from RFC1918", type = "ingress", from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["10.0.0.0/8"] }
        }
      }
      app1_lb = {
        name = "app1-lb"
        rules = {
          all_outbound = { description = "outbound", type = "egress", from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
          http         = { description = "HTTP from anywhere (inbound test)", type = "ingress", from_port = "80", to_port = "80", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
        }
      }
    }
    subnets = {
      "10.104.0.0/24"   = { az_index = 0, subnet_group = "app1_vm" }
      "10.104.128.0/24" = { az_index = 1, subnet_group = "app1_vm" }
      "10.104.2.0/24"   = { az_index = 0, subnet_group = "app1_lb" }
      "10.104.130.0/24" = { az_index = 1, subnet_group = "app1_lb" }
      "10.104.3.0/24"   = { az_index = 0, subnet_group = "app1_gwlbe" }
      "10.104.131.0/24" = { az_index = 1, subnet_group = "app1_gwlbe" }
    }
    routes = {
      vm_default    = { vpc = "app1_vpc", subnet_group = "app1_vm", to_cidr = "0.0.0.0/0", next_hop_key = "app1", next_hop_type = "transit_gateway_attachment", exercise = true }
      gwlbe_default = { vpc = "app1_vpc", subnet_group = "app1_gwlbe", to_cidr = "0.0.0.0/0", next_hop_key = "app1_vpc", next_hop_type = "internet_gateway", exercise = true }
      lb_default    = { vpc = "app1_vpc", subnet_group = "app1_lb", to_cidr = "0.0.0.0/0", next_hop_key = "app1_inbound", next_hop_type = "gwlbe_endpoint", exercise = true }
    }
  }

  app2_vpc = {
    name = "spoke2-app-vpc"
    cidr = "10.105.0.0/16"
    security_groups = {
      app2_vm = {
        name = "app2-vm"
        rules = {
          all_outbound = { description = "outbound", type = "egress", from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
          web          = { description = "HTTP/SSH from RFC1918", type = "ingress", from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["10.0.0.0/8"] }
        }
      }
      app2_lb = {
        name = "app2-lb"
        rules = {
          all_outbound = { description = "outbound", type = "egress", from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
          http         = { description = "HTTP from anywhere (inbound test)", type = "ingress", from_port = "80", to_port = "80", protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
        }
      }
    }
    subnets = {
      "10.105.0.0/24"   = { az_index = 0, subnet_group = "app2_vm" }
      "10.105.128.0/24" = { az_index = 1, subnet_group = "app2_vm" }
      "10.105.2.0/24"   = { az_index = 0, subnet_group = "app2_lb" }
      "10.105.130.0/24" = { az_index = 1, subnet_group = "app2_lb" }
      "10.105.3.0/24"   = { az_index = 0, subnet_group = "app2_gwlbe" }
      "10.105.131.0/24" = { az_index = 1, subnet_group = "app2_gwlbe" }
    }
    routes = {
      vm_default    = { vpc = "app2_vpc", subnet_group = "app2_vm", to_cidr = "0.0.0.0/0", next_hop_key = "app2", next_hop_type = "transit_gateway_attachment", exercise = true }
      gwlbe_default = { vpc = "app2_vpc", subnet_group = "app2_gwlbe", to_cidr = "0.0.0.0/0", next_hop_key = "app2_vpc", next_hop_type = "internet_gateway", exercise = true }
      lb_default    = { vpc = "app2_vpc", subnet_group = "app2_lb", to_cidr = "0.0.0.0/0", next_hop_key = "app2_inbound", next_hop_type = "gwlbe_endpoint", exercise = true }
    }
  }
}

### TRANSIT GATEWAY (from_peer added for the cross-region peering attachment)
tgws = {
  tgw = {
    name = "tgw"
    asn  = "64512"
    route_tables = {
      from_security_vpc = { create = true, name = "from-security" }
      from_spoke_vpc    = { create = true, name = "from-spokes" }
      from_peer         = { create = true, name = "from-peer" }
    }
  }
}

tgw_attachments = {
  security = {
    tgw_key                 = "tgw"
    security_vpc_attachment = true
    name                    = "vmseries"
    vpc                     = "security_vpc"
    subnet_group            = "tgw_attach"
    route_table             = "from_security_vpc"
    propagate_routes_to     = ["from_spoke_vpc"]
  }
  app1 = {
    tgw_key             = "tgw"
    name                = "spoke1-app-vpc"
    vpc                 = "app1_vpc"
    subnet_group        = "app1_vm"
    route_table         = "from_spoke_vpc"
    propagate_routes_to = ["from_security_vpc"]
  }
  app2 = {
    tgw_key             = "tgw"
    name                = "spoke2-app-vpc"
    vpc                 = "app2_vpc"
    subnet_group        = "app2_vm"
    route_table         = "from_spoke_vpc"
    propagate_routes_to = ["from_security_vpc"]
  }
}

### GATEWAY LOAD BALANCER
gwlbs = {
  security_gwlb = {
    name         = "security-gwlb"
    vpc          = "security_vpc"
    subnet_group = "gwlb"
  }
}

gwlb_endpoints = {
  security_gwlb_eastwest = { name = "eastwest-gwlbe", gwlb = "security_gwlb", vpc = "security_vpc", subnet_group = "gwlbe_eastwest", act_as_next_hop = false }
  security_gwlb_outbound = { name = "outbound-gwlbe", gwlb = "security_gwlb", vpc = "security_vpc", subnet_group = "gwlbe_outbound", act_as_next_hop = false }
  app1_inbound           = { name = "spoke1-inbound-gwlbe", gwlb = "security_gwlb", vpc = "app1_vpc", subnet_group = "app1_gwlbe", act_as_next_hop = true, from_igw_to_vpc = "app1_vpc", from_igw_to_subnet_group = "app1_lb" }
  app2_inbound           = { name = "spoke2-inbound-gwlbe", gwlb = "security_gwlb", vpc = "app2_vpc", subnet_group = "app2_gwlbe", act_as_next_hop = true, from_igw_to_vpc = "app2_vpc", from_igw_to_subnet_group = "app2_lb" }
}

### VM-SERIES (AIRS 12.1.6, latest+greatest)
vmseries = {
  vmseries = {
    instances = {
      "01" = { az_index = 0 }
      "02" = { az_index = 1 }
    }

    # panorama-server + auth-key are injected at apply time (remote-state Panorama IP + SSM LM key).
    bootstrap_options = {
      mgmt-interface-swap         = "enable"
      plugin-op-commands          = "panorama-licensing-mode-on,aws-gwlb-inspect:enable,aws-gwlb-overlay-routing:enable,advance-routing:enable"
      panorama-server             = ""
      auth-key                    = ""
      dgname                      = "AWS-GWLB-LAB"
      tplname                     = "stack-aws-gwlb-lab"
      dhcp-send-hostname          = "yes"
      dhcp-send-client-id         = "yes"
      dhcp-accept-server-hostname = "yes"
      dhcp-accept-server-domain   = "yes"
    }

    airs_deployment = true        # AIRS unified image
    panos_version   = "12.1.6"    # AIRS uses airs_instance_type (c6in.xlarge) automatically
    ebs_kms_id      = "alias/aws/ebs"
    ebs_volume_type = "gp3"

    vpc  = "security_vpc"
    gwlb = "security_gwlb"

    interfaces = {
      # mgmt-interface-swap=enable => device_index 0 is DATAPLANE (the GWLB target), device_index 1 is mgmt.
      private = { device_index = 0, security_group = "vmseries_private", vpc = "security_vpc", subnet_group = "private", create_public_ip = false, source_dest_check = false }
      mgmt    = { device_index = 1, security_group = "vmseries_mgmt", vpc = "security_vpc", subnet_group = "mgmt", create_public_ip = true, source_dest_check = true }
      public  = { device_index = 2, security_group = "vmseries_public", vpc = "security_vpc", subnet_group = "public", create_public_ip = true, source_dest_check = false }
    }

    subinterfaces = {
      inbound = {
        app1 = { gwlb_endpoint = "app1_inbound", subinterface = "ethernet1/1.11" }
        app2 = { gwlb_endpoint = "app2_inbound", subinterface = "ethernet1/1.12" }
      }
      outbound = {
        only_1_outbound = { gwlb_endpoint = "security_gwlb_outbound", subinterface = "ethernet1/1.20" }
      }
      eastwest = {
        only_1_eastwest = { gwlb_endpoint = "security_gwlb_eastwest", subinterface = "ethernet1/1.30" }
      }
    }

    system_services = {
      dns_primary = "8.8.8.8"
      ntp_primary = "pool.ntp.org"
    }
  }
}

### SPOKE VMS (app hosts; managed via SSM, no SSH needed)
spoke_vms = {
  "app1_vm01" = { az_index = 0, vpc = "app1_vpc", subnet_group = "app1_vm", security_group = "app1_vm" }
  "app1_vm02" = { az_index = 1, vpc = "app1_vpc", subnet_group = "app1_vm", security_group = "app1_vm" }
  "app2_vm01" = { az_index = 0, vpc = "app2_vpc", subnet_group = "app2_vm", security_group = "app2_vm" }
  "app2_vm02" = { az_index = 1, vpc = "app2_vpc", subnet_group = "app2_vm", security_group = "app2_vm" }
}

### SPOKE NLBs (inbound showheaders test target, HTTP/80)
spoke_nlbs = {
  "spoke1-nlb" = {
    name          = "spoke1-nlb"
    vpc           = "app1_vpc"
    subnet_group  = "app1_lb"
    vms           = ["app1_vm01", "app1_vm02"]
    balance_rules = { "HTTP" = { port = "80", protocol = "TCP" } }
  }
  "spoke2-nlb" = {
    name          = "spoke2-nlb"
    vpc           = "app2_vpc"
    subnet_group  = "app2_lb"
    vms           = ["app2_vm01", "app2_vm02"]
    balance_rules = { "HTTP" = { port = "80", protocol = "TCP" } }
  }
}

spoke_albs = {}
