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

resource "aws_launch_configuration" "this" {
  name_prefix   = var.prefix_name_tag
  ebs_optimized = true
  image_id      = data.aws_ami.pa-vm.id
  instance_type = var.fw_instance_type
  key_name      = var.ssh_key_name
  security_groups = var.asg_interface["security_groups"]
  #iam_instance_profile = var.iam_instance_profile

  user_data = base64encode(join(",", compact(concat(
    [for k, v in var.bootstrap_options : "${k}=${v}"],
  ))))

  lifecycle {
    create_before_destroy = true
  }
}


locals {
  asg_tags = [
    for k, v in var.global_tags : {
      key                 = k
      value               = v
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.prefix_name_tag}asg1"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  vpc_zone_identifier = var.asg_interface["subnets"]

  launch_configuration = aws_launch_configuration.this.name

  initial_lifecycle_hook {
    name                   = "${var.prefix_name_tag}launch"
    default_result       = "CONTINUE"
    heartbeat_timeout      = var.lifecycle_hook_timeout
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    notification_metadata = <<EOF
${var.lifecycle_hook_metadata}
EOF
  }

  tags                = concat(local.asg_tags, [{ key = "Name", value = var.autoscaling_name_tag, propagate_at_launch = true}])

  lifecycle { // https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-3-upgrade#resource-aws_autoscaling_group
    create_before_destroy = true
    ignore_changes = [ load_balancers, target_group_arns ]
  }

}

# Add lifecycle hook to autoscaling group
resource "aws_autoscaling_lifecycle_hook" "this" {
  name                   = "${var.prefix_name_tag}hook1"
  autoscaling_group_name = aws_autoscaling_group.this.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = var.lifecycle_hook_timeout
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = <<EOF
${var.lifecycle_hook_metadata}
EOF
}

# IAM role that will be used for Lambda function
resource "aws_iam_role" "this" {
  name               = "${var.prefix_name_tag}lambda_iam_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach IAM Policy to IAM role for Lambda
resource "aws_iam_role_policy" "this" {
  name   = "${var.prefix_name_tag}lambda_iam_policy"
  role   = aws_iam_role.this.id
  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DetachNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:ModifyNetworkInterfaceAttribute",
                "ec2:DescribeSubnets",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeInstances",
                "autoscaling:CompleteLifecycleAction",
                "autoscaling:DescribeAutoScalingGroups"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_lambda_function" "this" {
  filename         = "${path.module}/lambda_payload.zip"
  function_name    = "${var.prefix_name_tag}add_nics"
  role             = aws_iam_role.this.arn
  handler          = "lambda.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/lambda_payload.zip")
  runtime          = "python3.8"
  tags             = var.global_tags
  timeout          = var.lambda_timeout
}

resource "aws_lambda_permission" "this" {
  action              = "lambda:InvokeFunction"
  function_name       = aws_lambda_function.this.function_name
  principal           = "events.amazonaws.com"
  statement_id_prefix = var.prefix_name_tag
  # source_arn    = "arn:aws:events:eu-west-1:111122223333:rule/RunDaily"
}

resource "aws_cloudwatch_event_rule" "this" {
  name          = "${var.prefix_name_tag}add_nics"
  tags          = var.global_tags
  event_pattern = <<EOF
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance-launch Lifecycle Action"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${aws_autoscaling_group.this.name}"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "${var.prefix_name_tag}add_nics"
  arn       = aws_lambda_function.this.arn
}
