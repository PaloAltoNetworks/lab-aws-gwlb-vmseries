region           = "xxx"

ssh_key_name     = "qwikLABS-xxx"

firewalls = [
  {
    name    = "vmseries01"
    fw_tags = {}
    bootstrap_options = {
      mgmt-interface-swap = "enable"
      plugin-op-commands  = "aws-gwlb-inspect:enable"
      type                = "dhcp-client"
      hostname            = "lab##_vmseries01"
      tplname             = "TPL-STUDENT-STACK-##"
      dgname              = "DG-STUDENT-##"
      panorama-server     = "xxx"
      panorama-server-2   = "xxx"
      vm-auth-key         = "xxx"
      authcodes           = "xxx"
      op-command-modes    = ""
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
      hostname            = "lab##_vmseries02"
      tplname             = "TPL-STUDENT-STACK-##"
      dgname              = "DG-STUDENT-##"
      panorama-server     = "xxx"
      panorama-server-2   = "xxx"
      vm-auth-key         = "xxx"
      authcodes           = "xxx"
      op-command-modes    = ""
    }
    interfaces = [
      { name = "vmseries02-data", index = "0" },
      { name = "vmseries02-mgmt", index = "1" },
    ]
  }
]