terraform {
  required_version = ">= 1.3.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"
    }
  }
}

provider "aws" {
  region = var.region

  # In QwikLabs Cloud Shell the ambient role is used, so leave aws_profile empty.
  # Set it only when running locally against a named profile.
  profile = var.aws_profile != "" ? var.aws_profile : null

  default_tags {
    tags = var.global_tags
  }
}
