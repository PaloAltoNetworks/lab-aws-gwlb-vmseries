## General
region                = "us-west-2"
name_prefix           = "panorama-"
panorama_ssh_key_name = "qwikLABS-xxxxx" // Find in AWS Console
global_tags = {
  ManagedBy   = "terraform"
  Application = "Palo Alto Networks Panorama"
}

## Network
vpc_name = "management-vpc"
vpc_cidr = "192.168.10.0/24"

vpc_subnets = {
  # Do not modify value of `set=`, it is an internal identifier referenced by main.tf.
  "192.168.10.0/24" = { az = "us-west-2a", set = "mgmt" }
}

vpc_security_groups = {
  panorama-mgmt = {
    name = "panorama-mgmt"
    rules = {
      all_outbound = {
        description = "Permit All traffic outbound"
        type        = "egress", from_port = "0", to_port = "0", protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
      https = {
        description = "Permit HTTPS"
        type        = "ingress", from_port = "443", to_port = "443", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
      ssh = {
        description = "Permit SSH"
        type        = "ingress", from_port = "22", to_port = "22", protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # TODO: update here
      }
    }
  }
}

vpc_routes_outbound_destin_cidrs = ["0.0.0.0/0"]

## IAM Instance Role
panorama_iam_policy_name             = "AmazonEC2ReadOnlyAccess"
panorama_create_iam_instance_profile = true
panorama_create_iam_role             = true
#panorama_existing_iam_role_name = "PanoramaROCuratedRole" <-- use this variable to attach existing IAM Role.

## Panorama
panorama_az               = "us-west-2a"
panorama_create_public_ip = true
panorama_ebs_encrypted    = false
#panorama_ebs_kms_key_alias = "panoramamainkms" <-- use this variable when you have own KMS key.

panorama_ebs_volumes = [
  {
    name            = "ebs-1"
    ebs_device_name = "/dev/sdb"
    ebs_size        = "2000"
    ebs_encrypted   = true
  }
]
