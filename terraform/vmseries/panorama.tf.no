resource "random_id" "student" {
  byte_length = 4
}

resource "panos_panorama_template" "this" {
  name = "TPL-STUDENT-BASE-${random_id.student.id}"
}

resource "panos_panorama_template_stack" "this" {
  name        = "TPL-STUDENT-STACK-${random_id.student.id}"
  description = "Student Template Stack ${random_id.student.id}"
  templates   = [panos_panorama_template.this.name, "TPL-COMMON"]
}

resource "panos_panorama_device_group" "this" {
  name        = "DG-STUDENT-${random_id.student.id}"
  description = "Student Device Group ${random_id.student.id}"
}

resource "panos_panorama_ethernet_interface" "eth1" {
    name = "ethernet1/1"
    template = panos_panorama_template.this.name
    mode = "layer3"
    enable_dhcp = true
    create_dhcp_default_route = true
    dhcp_default_route_metric = 10
}

resource "panos_panorama_zone" "gwlb" {
    name = "gwlb"
    template = panos_panorama_template.this.name
    mode = "layer3"
    interfaces = [
        panos_panorama_ethernet_interface.eth1.name
    ]
}

resource "panos_panorama_virtual_router" "example" {
    template = panos_panorama_template.this.name
    name = "vr-default"
    interfaces = [
        panos_panorama_ethernet_interface.eth1.name
        ]
}


# resource "panos_panorama_security_rule_group" "this" {
#     position_keyword = "bottom"
#     device_group = panos_panorama_device_group.this.name
#     rule {
#         name = "student-gwlb-any"
#         description = "Temporary Permit Any on GWLB main interface"
#         source_zones = [panos_panorama_zone.gwlb.name]
#         source_addresses = ["any"]
#         source_users = ["any"]
#         #hip_profiles = ["any"]
#         destination_zones = [panos_panorama_zone.gwlb.name]
#         destination_addresses = ["any"]
#         applications = ["any"]
#         services = ["any"]
#         categories = ["any"]
#         action = "allow"
#         log_setting = "default"
#     }
# }

resource "panos_security_rule_group" "this" {
    position_keyword = "bottom"
    device_group = panos_panorama_device_group.this.name
    rulebase = "pre-rulebase"
    rule {
        name = "student-gwlb-any"
        description = "Temporary Permit Any on GWLB main interface"
        source_zones = [panos_panorama_zone.gwlb.name]
        source_addresses = ["any"]
        source_users = ["any"]
        #hip_profiles = ["any"]
        destination_zones = [panos_panorama_zone.gwlb.name]
        destination_addresses = ["any"]
        applications = ["any"]
        services = ["any"]
        categories = ["any"]
        action = "allow"
        log_setting = "default"
    }
}




resource "null_resource" "panorama-python" {
  depends_on = [panos_panorama_template_stack.this, panos_panorama_device_group.this]

  provisioner "local-exec" {
    when        = create
    command     = "panorama.py"
    interpreter = ["python3"]
    environment = {
      panorama_host       = var.panorama_host
      panorama_username       = var.panorama_username
      panorama_password   = var.panorama_password
      panorama_student_id = random_id.student.id
      panorama_destroy    = "False"
    }
  }
}

output "lab_info" {
  value = {
    "Panorama URL" = "https://${var.panorama_host}"
    "Student User" = "student-${random_id.student.id}"
    "Student Password"  = "student-${random_id.student.id}"
    "Notes" = "Login to the shared Panorama with these credentials that are specific to your deployment"
  }
}