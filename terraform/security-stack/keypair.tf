# Break-glass SSH keypair for the firewalls (PAN-OS mgmt). Spoke app hosts are managed
# via SSM (no SSH needed) but receive the same key. If var.ssh_key_name is set, that
# existing key is used instead and nothing is generated.
resource "tls_private_key" "fw" {
  count     = var.ssh_key_name == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "fw" {
  count      = var.ssh_key_name == "" ? 1 : 0
  key_name   = "${var.name_prefix}fw-key"
  public_key = tls_private_key.fw[0].public_key_openssh
  tags       = var.global_tags
}

resource "local_file" "fw_private_key" {
  count           = var.ssh_key_name == "" ? 1 : 0
  filename        = "${path.module}/fw-ssh-key.pem"
  content         = tls_private_key.fw[0].private_key_pem
  file_permission = "0600"
}

locals {
  ssh_key_name = var.ssh_key_name != "" ? var.ssh_key_name : aws_key_pair.fw[0].key_name
}
