region           = "xxx"
ssh_key_name     = "xxx"
panorama_host    = "xxx"
panorama_username = "xxx"
panorama_password = "xxx"

firewalls = [
  {
    name    = "vmseries01"
    fw_tags = {}
    bootstrap_options = {
      mgmt-interface-swap = "enable"
      plugin-op-commands  = "aws-gwlb-inspect:enable"
      type                = "dhcp-client"
      hostname            = "labxxx_vmseries01"
      tplname             = "TPL-STUDENT-STACK-xxx"
      dgname              = "DG-STUDENT-xxx"
      panorama-server     = "xxx"
      panorama-server-2   = "xxx"
      vm-auth-key         = "xxx"
      authcodes           = "xxx"
    }
    interfaces = [
      { name = "vmseries01-data", index = "0" },
      { name = "vmseries01-mgmt", index = "1" },
    ]
  },
  {
    name    = "vmseries02"
    fw_tags = {}
    bootstrap_options = {
      mgmt-interface-swap = "enable"
      plugin-op-commands  = "aws-gwlb-inspect:enable"
      type                = "dhcp-client"
      hostname            = "labxxx_vmseries02"
      tplname             = "TPL-STUDENT-STACK-xxx"
      dgname              = "DG-STUDENT-xxx"
      panorama-server     = "xxx"
      panorama-server-2   = "xxx"
      vm-auth-key         = "xxx"
      authcodes           = "xxx"
    }
    interfaces = [
      { name = "vmseries02-data", index = "0" },
      { name = "vmseries02-mgmt", index = "1" },
    ]
  }
]


#authcodes=xxxxxx
#mgmt-interface-swap=enable
#plugin-op-commands=aws-gwlb-inspect:enable
