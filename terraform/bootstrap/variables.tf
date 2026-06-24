variable "region" {
  description = "Region to host the Terraform state bucket + lock table. Any region works; pick one you keep (state survives even if a lab region is torn down). Defaults to the FW/security region."
  type        = string
  default     = "us-west-1"
}

variable "name_prefix" {
  description = "Prefix for the backend resource names. Keep short; the account id is appended for global uniqueness."
  type        = string
  default     = "pan-gwlb-lab"
}

variable "global_tags" {
  description = "Tags applied to the backend resources."
  type        = map(string)
  default = {
    ManagedBy   = "terraform"
    Application = "Palo Alto Networks VM-Series GWLB lab"
    Component   = "tf-backend"
  }
}
