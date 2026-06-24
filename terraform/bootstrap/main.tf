data "aws_caller_identity" "current" {}

locals {
  # Globally-unique, deterministic bucket name (account id guarantees uniqueness).
  bucket_name = "${var.name_prefix}-tfstate-${data.aws_caller_identity.current.account_id}-${var.region}"
  table_name  = "${var.name_prefix}-tflock"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = local.bucket_name
  # Lab convenience: allow teardown of the backend bucket. Remove for production.
  force_destroy = true
  tags          = var.global_tags
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tflock" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.global_tags
}

# Emit ready-to-use partial-backend config files for the other roots.
# These are gitignored (account-specific) and consumed via `terraform init -backend-config=backend.hcl`.
resource "local_file" "backend_panorama" {
  filename = "${path.module}/../panorama/backend.hcl"
  content  = <<-EOT
    bucket         = "${aws_s3_bucket.tfstate.id}"
    key            = "panorama/terraform.tfstate"
    region         = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.tflock.name}"
    encrypt        = true
  EOT
}

resource "local_file" "backend_security" {
  filename = "${path.module}/../security-stack/backend.hcl"
  content  = <<-EOT
    bucket         = "${aws_s3_bucket.tfstate.id}"
    key            = "security-stack/terraform.tfstate"
    region         = "${var.region}"
    dynamodb_table = "${aws_dynamodb_table.tflock.name}"
    encrypt        = true
  EOT
}
