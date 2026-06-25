# ===========================================================================
# Azure Cloud NGFW lab (Part 3) — centralized single Virtual WAN, Panorama-managed.
# Copy this file to terraform.tfvars and fill in the values marked TODO.
# See AZURE-CLOUDNGFW-ADDENDUM.md (Part 3 guide) for the full walkthrough.
#
# You deploy these resources into YOUR Azure resource group. Cloud Shell storage
# and Terraform remote state live in the shared subscription (see the guide).
# ===========================================================================

# GENERAL

subscription_id = "TODO_YOUR_SUBSCRIPTION_ID" # Azure subscription you deploy into (Torque or shared)

region                = "Central US"   # TODO: your resource group's region
resource_group_name   = "TODO_YOUR_RG" # TODO: your pre-created/lab resource group
create_resource_group = false          # false = reuse an existing RG (Torque RG-scoped Contributor).
#                                                Set true ONLY if you have rights to create a new RG.
name_prefix = "TODO-" # TODO: short unique prefix (e.g. your initials, "jdoe-")

tags = {
  "createdBy"     = "Palo Alto Networks"
  "createdWith"   = "Terraform"
  "xdr-exclusion" = "yes"
  "lab"           = "azure-cloud-ngfw"
}

# NETWORK

vnets = {}

virtual_wans = {
  "virtual_wan" = {
    name = "virtual_wan"
    virtual_hubs = {
      "virtual_hub" = {
        name           = "virtual_hub"
        address_prefix = "10.0.0.0/24"
        connections = {
          "app1-to-hub" = {
            name                       = "app1-to-hub"
            connection_type            = "Vnet"
            remote_virtual_network_key = "app1"
          }
          "app2-to-hub" = {
            name                       = "app2-to-hub"
            connection_type            = "Vnet"
            remote_virtual_network_key = "app2"
          }
        }
        # Routing intent steers ALL spoke Internet + private traffic through the Cloud NGFW.
        routing_intent = {
          routing_intent_name = "routing_intent"
          routing_policy = [
            {
              routing_policy_name = "PrivateTraffic"
              destinations        = ["PrivateTraffic"]
              next_hop_key        = "cloudngfw"
            },
            {
              routing_policy_name = "Internet"
              destinations        = ["Internet"]
              next_hop_key        = "cloudngfw"
            }
          ]
        }
      }
    }
  }
}

# CLOUDNGFW

cloudngfws = {
  "cloudngfw" = {
    name            = "cloudngfw"
    attachment_type = "vwan"
    virtual_hub_key = "virtual_hub"
    virtual_wan_key = "virtual_wan"
    management_mode = "panorama"
    cloudngfw_config = {
      # TODO: paste the registration string you generated in Panorama (Step 4.5).
      # It is a single base64 line; it embeds your device-group/template-stack,
      # Panorama IP, serial, and an auth key — keep it secret, do not commit it.
      panorama_base64_config = "TODO_PASTE_REGISTRATION_STRING"
      # Inbound DNAT: the firewall's public IP -> the WordPress test VMs.
      destination_nats = {
        "app1-tcp80-dnat" = {
          destination_nat_name     = "app1-tcp80-dnat"
          destination_nat_protocol = "TCP"
          frontend_port            = 80
          backend_port             = 80
          backend_ip_address       = "10.100.0.4"
        }
        "app2-tcp443-dnat" = {
          destination_nat_name     = "app2-tcp443-dnat"
          destination_nat_protocol = "TCP"
          frontend_port            = 443
          backend_port             = 443
          backend_ip_address       = "10.100.1.4"
        }
      }
    }
  }
}

# TEST INFRASTRUCTURE
# Two spoke VNets, each with a WordPress VM + an Azure Bastion. Both reuse YOUR
# resource group (create_resource_group = false) to fit RG-scoped Contributor.

test_infrastructure = {
  "app1_testenv" = {
    create_resource_group = false
    resource_group_name   = "TODO_YOUR_RG" # TODO: same RG as above
    vnets = {
      "app1" = {
        name          = "app1-vnet"
        address_space = ["10.100.0.0/25"]
        network_security_groups = {
          "app1" = {
            name = "app1-nsg"
            rules = {
              from_bastion = {
                name                       = "app1-mgmt-allow-bastion"
                priority                   = 100
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_address_prefix      = "10.100.0.64/26"
                source_port_range          = "*"
                destination_address_prefix = "*"
                destination_port_range     = "*"
              }
              web_inbound = {
                name                       = "app1-web-allow-inbound"
                priority                   = 110
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_address_prefixes    = ["0.0.0.0/0"] # TODO: scope to student/source IPs for the workshop
                source_port_range          = "*"
                destination_address_prefix = "10.100.0.0/25"
                destination_port_ranges    = ["80", "443"]
              }
            }
          }
        }
        subnets = {
          "vms" = {
            name                       = "vms"
            address_prefixes           = ["10.100.0.0/26"]
            network_security_group_key = "app1"
          }
          "bastion" = {
            name             = "AzureBastionSubnet"
            address_prefixes = ["10.100.0.64/26"]
          }
        }
      }
    }
    spoke_vms = {
      "app1_vm" = {
        name       = "app1-vm"
        vnet_key   = "app1"
        subnet_key = "vms"
      }
    }
    bastions = {
      "app1_bastion" = {
        name       = "app1-bastion"
        vnet_key   = "app1"
        subnet_key = "bastion"
      }
    }
  }
  "app2_testenv" = {
    create_resource_group = false
    resource_group_name   = "TODO_YOUR_RG" # TODO: same RG as above
    vnets = {
      "app2" = {
        name          = "app2-vnet"
        address_space = ["10.100.1.0/25"]
        network_security_groups = {
          "app2" = {
            name = "app2-nsg"
            rules = {
              from_bastion = {
                name                       = "app2-mgmt-allow-bastion"
                priority                   = 100
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_address_prefix      = "10.100.1.64/26"
                source_port_range          = "*"
                destination_address_prefix = "*"
                destination_port_range     = "*"
              }
              web_inbound = {
                name                       = "app2-web-allow-inbound"
                priority                   = 110
                direction                  = "Inbound"
                access                     = "Allow"
                protocol                   = "Tcp"
                source_address_prefixes    = ["0.0.0.0/0"] # TODO: scope to student/source IPs for the workshop
                source_port_range          = "*"
                destination_address_prefix = "10.100.1.0/25"
                destination_port_ranges    = ["80", "443"]
              }
            }
          }
        }
        subnets = {
          "vms" = {
            name                       = "vms"
            address_prefixes           = ["10.100.1.0/26"]
            network_security_group_key = "app2"
          }
          "bastion" = {
            name             = "AzureBastionSubnet"
            address_prefixes = ["10.100.1.64/26"]
          }
        }
      }
    }
    spoke_vms = {
      "app2_vm" = {
        name       = "app2-vm"
        vnet_key   = "app2"
        subnet_key = "vms"
      }
    }
    bastions = {
      "app2_bastion" = {
        name       = "app2-bastion"
        vnet_key   = "app2"
        subnet_key = "bastion"
      }
    }
  }
}
