resource "random_id" "student" {
  byte_length = 4
}

output "test" {
  value = null_resource.panorama-python
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
    "Notes" = "Login using these blah blah"
  }
}