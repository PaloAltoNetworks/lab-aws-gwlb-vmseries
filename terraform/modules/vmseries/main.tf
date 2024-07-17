locals {
  firewalls = {
    for firewall in var.firewalls :
    firewall.name => firewall
  }

  interfaces = {
    for interface in var.interfaces :
    interface.name => interface
  }

  eips = {
    for interface in var.interfaces :
    interface.name => interface
    if lookup(interface, "eip", null) != null ? true : false
  }

}

#************************************************************************************
# CREATE & ASSIGN IAM ROLE, POLICY, & INSTANCE PROFILE
#************************************************************************************
resource "aws_iam_role" "vmseries" {
  name = "${var.prefix_name_tag}vmseries-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bootstrap_policy" {
  for_each = var.buckets_map
  name     = "${var.prefix_name_tag}${each.key}-pan-bootstrap"
  role     = aws_iam_role.vmseries.id

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${each.value.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bootstrap_policy_objects" {
  for_each = var.buckets_map
  name     = "pan_bootstrap_s3_object-${each.key}"
  role     = aws_iam_role.vmseries.id

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "${each.value.arn}/*"
    }
  ]
}
EOF
}

# Get info from environment to construct ARNs for IAM policies

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "${var.prefix_name_tag}vmseries-cloudwatch"
  role   = aws_iam_role.vmseries.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudwatch:PutMetricData",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:PaloAltoNetworksFirewalls:log-stream:*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "vmseries" {
  name = "${var.prefix_name_tag}vmseries"
  role = aws_iam_role.vmseries.id
  path = "/"
}


#### PA VM AMI ID Lookup based on license type, region, version ####

data "aws_ami" "pa-vm" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "product-code"
    values = [var.fw_license_type_map[var.fw_license_type]]
  }

  filter {
    name   = "name"
    values = ["PA-VM-AWS-${var.fw_version}*"]
  }
}

################
# VPC Routes to FW ENI
################

# Create Default route to FW ENI

resource "aws_route" "to_eni" {
  for_each               = var.rts_to_fw_eni
  route_table_id         = var.route_tables_map[each.value.route_table]
  destination_cidr_block = each.value.destination_cidr
  network_interface_id   = aws_network_interface.this[each.value.eni].id
}


###################
# Network Interfaces
###################
resource "aws_network_interface" "this" {
  for_each          = local.interfaces
  subnet_id         = var.subnets_map[each.value.subnet_name]
  source_dest_check = lookup(each.value, "source_dest_check", null) != null ? each.value.source_dest_check : null
  security_groups   = [var.security_groups_map[each.value.security_group]]
  description       = each.value.name
  tags = merge(
    {
      "Name" = format("%s", each.value.name)
    },
    var.tags
  )
}

###################
# Create and Associate EIPs
###################

resource "aws_eip" "this" {
  for_each = local.eips
  tags = merge(
    {
      "Name" = format("%s", each.value.eip)
    },
    var.tags,
  )

  depends_on = [aws_instance.pa-vm-series]
}

resource "aws_eip_association" "this" {
  for_each             = local.eips
  network_interface_id = aws_network_interface.this[each.key].id
  allocation_id        = aws_eip.this[each.key].id
}


################
# Create PA VM-series instances
################

resource "aws_instance" "pa-vm-series" {
  for_each                             = local.firewalls
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  ebs_optimized                        = true
  ami                                  = data.aws_ami.pa-vm.id
  instance_type                        = var.fw_instance_type
  tags = merge(
    {
      "Name" = format("%s", each.value.name_tag)
    },
    var.tags, each.value.fw_tags
  )

  iam_instance_profile = lookup(each.value, "iam_instance_profile", null) != null ? each.value.iam_instance_profile : aws_iam_instance_profile.vmseries.id
  user_data = base64encode(join(";", compact(concat(
    [for k, v in each.value.bootstrap_options : "${k}=${v}"],
    [lookup(each.value, "bootstrap_bucket", null) != null ? "vmseries-bootstrap-aws-s3bucket=${var.buckets_map[each.value.bootstrap_bucket].name}" : null],
  ))))

  root_block_device {
    delete_on_termination = true
  }

  key_name   = var.ssh_key_name
  monitoring = false
  dynamic "network_interface" {
    for_each = each.value.interfaces
    content {
      device_index         = network_interface.value.index
      network_interface_id = aws_network_interface.this[network_interface.value.name].id
    }
  }
}

resource "aws_network_interface_attachment" "this" {
  for_each             = var.addtional_interfaces
  instance_id          = aws_instance.pa-vm-series[each.value.ec2_instance].id
  network_interface_id = aws_network_interface.this[each.key].id
  device_index         = each.value.index

  depends_on        = [aws_eip_association.this]
}
