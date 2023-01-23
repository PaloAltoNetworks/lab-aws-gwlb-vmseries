terraform {
  required_version = ">=0.12.29, <2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.5"
    }
    panos = {
      source = "PaloAltoNetworks/panos"
    }
  }
}


provider "aws" {
  region  = var.region
}

provider "panos" {
  hostname           = var.panorama_host
  verify_certificate = false
  username           = var.panorama_username
  password           = var.panorama_password
  #username = data.aws_ssm_parameter.user.value  ## Update to parameter store
  #password = data.aws_ssm_parameter.pass.value ## Update to parameter store
}

# data "aws_ssm_parameter" "user" {
#   provider = aws.east
#   name = var.panorama_ssm_path_user
# }

# data "aws_ssm_parameter" "pass" {
#   provider = aws.east
#   name = var.panorama_ssm_path_pass
# }