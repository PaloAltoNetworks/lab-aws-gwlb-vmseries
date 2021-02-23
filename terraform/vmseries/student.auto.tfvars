ssh_key_name     = "qwikLABS-L17939-10286"

### VMSERIES ###
firewalls = [
  {
    name    = "vmseries01"
    fw_tags = {}
    bootstrap_options = {
      mgmt-interface-swap = "enable"
      plugin-op-commands  = "aws-gwlb-inspect:enable"
      type                = "dhcp-client"
      hostname            = "lab###_vmseries01"
      panorama-server     = "###"
      panorama-server-2   = "###"
      tplname             = "TPL-STUDENT-STACK-###"
      dgname              = "DG-STUDENT-###"
      vm-auth-key         = "###"
      authcodes           = "###"
      #op-command-modes    = ""
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
      hostname            = "lab#EE_vmseries02"
      panorama-server     = "###"
      panorama-server-2   = "###"
      tplname             = "TPL-STUDENT-STACK-###"
      dgname              = "DG-STUDENT-###"
      vm-auth-key         = "###"
      authcodes           = "###"
      #op-command-modes    = ""
    }
    interfaces = [
      { name = "vmseries02-data", index = "0" },
      { name = "vmseries02-mgmt", index = "1" },
    ]
  }
]