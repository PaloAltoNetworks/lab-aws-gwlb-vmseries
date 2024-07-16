terraform {
  required_version = ">=0.12.29, <2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}


provider "aws" {
  region  = var.region
}

provider "aws" {
  region  = var.peer_region
  alias   = "peer"
}