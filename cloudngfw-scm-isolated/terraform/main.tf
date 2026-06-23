data "aws_caller_identity" "current" {}

data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  # az1, az2, ... keyed maps derived from the AZ name list.
  az_map         = { for idx, az in var.azs : "az${idx + 1}" => az }
  app_subnets    = { for idx, az in var.azs : "az${idx + 1}" => cidrsubnet(var.vpc_cidr, 8, idx + 1) }
  gwlbe_subnets  = { for idx, az in var.azs : "az${idx + 1}" => cidrsubnet(var.vpc_cidr, 8, idx + 11) }
  public_subnets = { for idx, az in var.azs : "az${idx + 1}" => cidrsubnet(var.vpc_cidr, 8, idx + 21) }
}

# ---------------- VPC + IGW ----------------

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.name_prefix}vpc" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name_prefix}igw" }
}

# ---------------- Subnets (per AZ: app / gwlbe / public) ----------------

resource "aws_subnet" "app" {
  for_each          = local.az_map
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value
  cidr_block        = local.app_subnets[each.key]
  tags              = { Name = "${var.name_prefix}app-${each.key}" }
}

resource "aws_subnet" "gwlbe" {
  for_each          = local.az_map
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value
  cidr_block        = local.gwlbe_subnets[each.key]
  tags              = { Name = "${var.name_prefix}gwlbe-${each.key}" }
}

resource "aws_subnet" "public" {
  for_each                = local.az_map
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value
  cidr_block              = local.public_subnets[each.key]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name_prefix}public-${each.key}" }
}

# ---------------- NAT (one per AZ) ----------------

resource "aws_eip" "nat" {
  for_each = local.az_map
  domain   = "vpc"
  tags     = { Name = "${var.name_prefix}nat-${each.key}" }
}

resource "aws_nat_gateway" "this" {
  for_each      = local.az_map
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = { Name = "${var.name_prefix}nat-${each.key}" }
  depends_on    = [aws_internet_gateway.this]
}

# ---------------- Cloud NGFW GWLB endpoint (phase 2 only) ----------------
# Customer-managed endpoint pointing at the SCM-managed Cloud NGFW's GWLB
# endpoint service. Created only when insert_cngfw = true.

resource "aws_vpc_endpoint" "gwlbe" {
  for_each          = var.insert_cngfw ? local.az_map : {}
  vpc_id            = aws_vpc.this.id
  service_name      = var.cngfw_gwlb_service_name
  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = [aws_subnet.gwlbe[each.key].id]
  tags              = { Name = "${var.name_prefix}gwlbe-${each.key}" }

  lifecycle {
    # Avoids "Endpoint must be removed from route table before deletion".
    create_before_destroy = true
  }
}

# ---------------- Route tables ----------------
# Public (NAT) RT - per AZ so return traffic can be steered back through the
# firewall (GWLB requires flow symmetry; forward-proxy decryption breaks without it).

resource "aws_route_table" "public" {
  for_each = local.az_map
  vpc_id   = aws_vpc.this.id
  tags     = { Name = "${var.name_prefix}public-${each.key}" }
}

resource "aws_route" "public_default" {
  for_each               = local.az_map
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Return-path symmetry (phase 2): app-bound replies leaving the NAT go back
# through the firewall endpoint instead of straight to the instance.
resource "aws_route" "public_return_to_fw" {
  for_each               = var.insert_cngfw ? local.az_map : {}
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = local.app_subnets[each.key]
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[each.key].id
}

resource "aws_route_table_association" "public" {
  for_each       = local.az_map
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

# GWLBE RT - inspected egress continues to the NAT.
resource "aws_route_table" "gwlbe" {
  for_each = local.az_map
  vpc_id   = aws_vpc.this.id
  tags     = { Name = "${var.name_prefix}gwlbe-${each.key}" }
}

resource "aws_route" "gwlbe_default" {
  for_each               = local.az_map
  route_table_id         = aws_route_table.gwlbe[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "gwlbe" {
  for_each       = local.az_map
  subnet_id      = aws_subnet.gwlbe[each.key].id
  route_table_id = aws_route_table.gwlbe[each.key].id
}

# App RT - phase 1: straight to NAT; phase 2: redirected through the firewall.
resource "aws_route_table" "app" {
  for_each = local.az_map
  vpc_id   = aws_vpc.this.id
  tags     = { Name = "${var.name_prefix}app-${each.key}" }
}

resource "aws_route" "app_default_nat" {
  for_each               = var.insert_cngfw ? {} : local.az_map
  route_table_id         = aws_route_table.app[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key].id
}

resource "aws_route" "app_default_fw" {
  for_each               = var.insert_cngfw ? local.az_map : {}
  route_table_id         = aws_route_table.app[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[each.key].id
}

resource "aws_route_table_association" "app" {
  for_each       = local.az_map
  subnet_id      = aws_subnet.app[each.key].id
  route_table_id = aws_route_table.app[each.key].id
}

# ---------------- Security group ----------------

resource "aws_security_group" "web" {
  name        = "${var.name_prefix}web"
  description = "Lab web servers"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP from anywhere (lab)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere (lab; used by inbound phase 2)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from within the VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name_prefix}web" }
}

# ---------------- IAM for app instances (SSM + read the CA secret) ----------------

resource "aws_iam_role" "web" {
  name = "${var.name_prefix}web-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "web_ssm" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "web_secrets" {
  name = "read-cngfw-ca"
  role = aws_iam_role.web.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["secretsmanager:GetSecretValue"]
      Resource = "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.ca_secret_name}*"
    }]
  })
}

resource "aws_iam_instance_profile" "web" {
  name = "${var.name_prefix}web"
  role = aws_iam_role.web.name
}

# ---------------- App web servers ----------------

locals {
  web_user_data = <<-EOT
    #!/bin/bash
    sleep 60
    until sudo yum update -y; do echo retry; sleep 5; done
    until sudo yum install -y httpd php; do echo retry; sleep 5; done
    sudo rm -f /var/www/html/index.html
    until sudo wget -O /var/www/html/index.php https://raw.githubusercontent.com/wwce/terraform/master/gcp/adv_peering_2fw_2spoke_common/scripts/showheaders.php; do echo retry; sleep 5; done
    sudo systemctl enable --now httpd
  EOT
}

resource "aws_instance" "web" {
  for_each               = local.az_map
  ami                    = data.aws_ami.amzn2.id
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.app[each.key].id
  vpc_security_group_ids = [aws_security_group.web.id]
  iam_instance_profile   = aws_iam_instance_profile.web.name
  user_data              = local.web_user_data

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${var.name_prefix}web-${each.key}" }
}
