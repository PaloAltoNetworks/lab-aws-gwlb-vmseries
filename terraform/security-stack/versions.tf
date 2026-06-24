terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.17, < 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
  backend "s3" {}
}

# Firewall/security region.
provider "aws" {
  region = var.region
}

# Panorama region — used for the remote (accepter) side of the cross-region TGW peering.
provider "aws" {
  alias  = "panorama"
  region = var.panorama_region
}
