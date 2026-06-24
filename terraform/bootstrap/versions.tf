terraform {
  required_version = ">= 1.4.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.17, < 6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

# Bootstrap keeps LOCAL state by design: it creates the S3 bucket + DynamoDB
# table that every other root uses as its remote backend (chicken-and-egg).
# Its own state is small and reproducible; it is gitignored.
provider "aws" {
  region = var.region
}
