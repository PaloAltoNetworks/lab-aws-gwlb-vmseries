data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.available.names
}

############################################
# Fail-fast AMI resolution (clear message) #
############################################
# Mirror the panorama module's lookup so we can assert it resolves and emit a
# readable error instead of an opaque "your query returned no results".
data "aws_ami" "panorama_check" {
  count       = var.panorama_ami_id == null ? 1 : 0
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["Panorama-AWS-${var.panorama_version}*"]
  }
  filter {
    name   = "product-code"
    values = [var.panorama_product_code]
  }
}

check "panorama_ami_resolves" {
  assert {
    condition     = var.panorama_ami_id != null || length(data.aws_ami.panorama_check) > 0
    error_message = "No Panorama AMI found for version '${var.panorama_version}' (product code '${var.panorama_product_code}') in region '${var.region}'. List options: aws ec2 describe-images --region ${var.region} --owners aws-marketplace --filters 'Name=name,Values=Panorama-AWS-*' --query 'Images[].Name'"
  }
}

############################################
# VPC + networking                          #
############################################
resource "aws_vpc" "panorama" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${var.name_prefix}panorama-vpc" }
}

resource "aws_internet_gateway" "panorama" {
  vpc_id = aws_vpc.panorama.id
  tags   = { Name = "${var.name_prefix}panorama-igw" }
}

resource "aws_subnet" "mgmt" {
  vpc_id            = aws_vpc.panorama.id
  cidr_block        = var.mgmt_subnet_cidr
  availability_zone = local.azs[0]
  tags              = { Name = "${var.name_prefix}panorama-mgmt" }
}

resource "aws_subnet" "tgw" {
  vpc_id            = aws_vpc.panorama.id
  cidr_block        = var.tgw_subnet_cidr
  availability_zone = local.azs[0]
  tags              = { Name = "${var.name_prefix}panorama-tgw-attach" }
}

resource "aws_route_table" "mgmt" {
  vpc_id = aws_vpc.panorama.id
  tags   = { Name = "${var.name_prefix}panorama-mgmt-rt" }
}

resource "aws_route" "mgmt_default" {
  route_table_id         = aws_route_table.mgmt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.panorama.id
}

# Return path: Panorama -> firewalls (replies to FW-initiated device comms) via the TGW.
resource "aws_route" "mgmt_to_fw" {
  route_table_id         = aws_route_table.mgmt.id
  destination_cidr_block = var.fw_supernet
  transit_gateway_id     = module.tgw.transit_gateway.id
  depends_on             = [module.panorama_tgw_attach]
}

resource "aws_route_table_association" "mgmt" {
  subnet_id      = aws_subnet.mgmt.id
  route_table_id = aws_route_table.mgmt.id
}

resource "aws_route_table" "tgw" {
  vpc_id = aws_vpc.panorama.id
  tags   = { Name = "${var.name_prefix}panorama-tgw-rt" }
}

resource "aws_route_table_association" "tgw" {
  subnet_id      = aws_subnet.tgw.id
  route_table_id = aws_route_table.tgw.id
}

############################################
# Security group                            #
############################################
resource "aws_security_group" "panorama" {
  name        = "${var.name_prefix}panorama-sg"
  description = "Panorama management access"
  vpc_id      = aws_vpc.panorama.id
  tags        = { Name = "${var.name_prefix}panorama-sg" }
}

# Admin/runner access (panorama-init SSH + XML API + UI). Only created if CIDRs provided.
resource "aws_security_group_rule" "admin_ssh" {
  count             = length(var.mgmt_allowed_cidrs) > 0 ? 1 : 0
  security_group_id = aws_security_group.panorama.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = var.mgmt_allowed_cidrs
  description       = "SSH (panorama-init) from admin/runner"
}

resource "aws_security_group_rule" "admin_https" {
  count             = length(var.mgmt_allowed_cidrs) > 0 ? 1 : 0
  security_group_id = aws_security_group.panorama.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = var.mgmt_allowed_cidrs
  description       = "HTTPS XML API + UI from admin/runner"
}

# Firewall device communications (FWs initiate to Panorama).
resource "aws_security_group_rule" "fw_mgmt_3978" {
  security_group_id = aws_security_group.panorama.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3978
  to_port           = 3978
  cidr_blocks       = [var.fw_supernet]
  description       = "Panorama and FW device management (3978) from firewalls"
}

resource "aws_security_group_rule" "fw_https" {
  security_group_id = aws_security_group.panorama.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [var.fw_supernet]
  description       = "HTTPS from firewalls"
}

resource "aws_security_group_rule" "fw_icmp" {
  security_group_id = aws_security_group.panorama.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  cidr_blocks       = [var.fw_supernet]
  description       = "ICMP (reachability tests) from firewalls"
}

resource "aws_security_group_rule" "egress_all" {
  security_group_id = aws_security_group.panorama.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All outbound (licensing, updates, device comms)"
}

############################################
# SSH keypair (panorama-init requires SSH)  #
############################################
resource "tls_private_key" "panorama" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "panorama" {
  key_name   = "${var.name_prefix}panorama-key"
  public_key = tls_private_key.panorama.public_key_openssh
  tags       = { Name = "${var.name_prefix}panorama-key" }
}

# Private key written locally for panorama-init --ssh-key. Gitignored (*.pem).
resource "local_file" "panorama_private_key" {
  filename        = "${path.module}/panorama-ssh-key.pem"
  content         = tls_private_key.panorama.private_key_pem
  file_permission = "0600"
}

############################################
# IAM (Panorama instance profile)           #
############################################
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_iam_role" "panorama" {
  name               = "${var.name_prefix}panorama"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": { "Service": "ec2.amazonaws.com" }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "panorama" {
  role   = aws_iam_role.panorama.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances", "ec2:DescribeInstanceStatus"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["cloudwatch:ListMetrics", "cloudwatch:GetMetricStatistics", "cloudwatch:DescribeAlarmsForMetric", "cloudwatch:DescribeAlarms"],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "panorama" {
  name = "${var.name_prefix}panorama-instance-profile"
  role = aws_iam_role.panorama.name
}

############################################
# Panorama instance (official module)       #
############################################
module "panorama" {
  source  = "PaloAltoNetworks/swfw-modules/aws//modules/panorama"
  version = "2.2.7" # keep in sync with var.module_version

  name              = "${var.name_prefix}panorama"
  availability_zone = local.azs[0]
  create_public_ip  = true

  panorama_version       = var.panorama_version
  product_code           = var.panorama_product_code
  panorama_ami_id        = var.panorama_ami_id
  include_deprecated_ami = false
  instance_type          = var.panorama_instance_type
  private_ip_address     = var.panorama_private_ip

  ebs_encrypted     = true
  ebs_volume_type   = "gp3"
  ebs_kms_key_alias = "alias/aws/ebs"
  # NOTE: the official module attaches log disks via a post-launch aws_volume_attachment,
  # which hangs PAN-OS 12.1.7 first boot (mgmt plane never starts; confirmed by deploy
  # without a disk reaching login in ~3 min vs hanging forever with one). Default to NO
  # dedicated log disk (Panorama logs to /opt/panlogs on the 224 GB root, like the canonical
  # 11.2 lab). A dedicated disk needs the inline ebs_block_device approach (follow-up).
  ebs_volumes = var.panorama_log_disk_gib > 0 ? [
    {
      name            = "${var.name_prefix}panorama-logs"
      ebs_device_name = "/dev/sdb"
      ebs_size        = tostring(var.panorama_log_disk_gib)
    }
  ] : []

  ssh_key_name           = aws_key_pair.panorama.key_name
  subnet_id              = aws_subnet.mgmt.id
  vpc_security_group_ids = [aws_security_group.panorama.id]
  panorama_iam_role      = aws_iam_instance_profile.panorama.name

  global_tags = var.global_tags
}

############################################
# Transit Gateway (Panorama region)         #
############################################
module "tgw" {
  source  = "PaloAltoNetworks/swfw-modules/aws//modules/transit_gateway"
  version = "2.2.7" # keep in sync with var.module_version

  name = "${var.name_prefix}panorama-tgw"
  asn  = var.tgw_asn
  route_tables = {
    # Association for the Panorama VPC attachment.
    from_panorama = {
      create = true
      name   = "${var.name_prefix}from-panorama"
    }
    # Dedicated table for the cross-region peering attachment (the security-stack
    # root associates the peering here and adds the FW<->Panorama routes).
    from_peer = {
      create = true
      name   = "${var.name_prefix}from-peer"
    }
  }
  tags = var.global_tags
}

module "panorama_tgw_attach" {
  source  = "PaloAltoNetworks/swfw-modules/aws//modules/transit_gateway_attachment"
  version = "2.2.7" # keep in sync with var.module_version

  name                        = "${var.name_prefix}panorama-vpc"
  vpc_id                      = aws_vpc.panorama.id
  subnets                     = { (local.azs[0]) = { id = aws_subnet.tgw.id } }
  transit_gateway_route_table = module.tgw.route_tables["from_panorama"]
  propagate_routes_to         = {}
  appliance_mode_support      = "disable"
  dns_support                 = "enable"
  tags                        = var.global_tags
}
