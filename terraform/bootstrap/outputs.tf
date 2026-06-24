output "state_bucket" {
  description = "S3 bucket holding remote state for the panorama + security-stack roots."
  value       = aws_s3_bucket.tfstate.id
}

output "lock_table" {
  description = "DynamoDB table used for state locking."
  value       = aws_dynamodb_table.tflock.name
}

output "backend_region" {
  description = "Region the backend bucket + lock table live in."
  value       = var.region
}
