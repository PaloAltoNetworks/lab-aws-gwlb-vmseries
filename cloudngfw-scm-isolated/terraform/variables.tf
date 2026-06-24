variable "region" {
  description = "AWS region for the lab. Must match the region where you create the Cloud NGFW resource in SCM. Defaults to us-east-1 to match the QwikLabs account used in Part 1."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Named AWS CLI profile to use. Leave empty in QwikLabs Cloud Shell (uses the ambient role)."
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Short unique prefix for every resource name (use your initials, under 8 chars). Keeps resources from colliding if a tenant is shared."
  type        = string
  default     = "cngfw-"
}

variable "global_tags" {
  description = "Tags applied to every resource via provider default_tags."
  type        = map(string)
  default = {
    lab = "cloudngfw-scm-isolated"
  }
}

variable "vpc_cidr" {
  description = "CIDR for the single lab VPC. /16 gives clean /24 subnets."
  type        = string
  default     = "10.104.0.0/16"
}

variable "azs" {
  description = "Availability Zone NAMES to spread the lab across (your own account, so names are fine here). The Cloud NGFW resource in SCM is placed by AZ ID separately; use the gwlbe_subnet_az_ids output to get the matching IDs."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "insert_cngfw" {
  description = "Phase toggle. false = app egress goes straight to NAT (deploy infra + apps first, prove they work). true = app egress is redirected through the Cloud NGFW GWLB endpoint for inspection. Requires cngfw_gwlb_service_name."
  type        = bool
  default     = false
}

variable "cngfw_gwlb_service_name" {
  description = "The Gateway Load Balancer endpoint service name of your SCM-managed Cloud NGFW (e.g. com.amazonaws.vpce.us-west-2.vpce-svc-0123456789abcdef0). Found in the Cloud NGFW console after the firewall is created. Required when insert_cngfw = true."
  type        = string
  default     = ""

  validation {
    condition     = var.cngfw_gwlb_service_name == "" || can(regex("^com\\.amazonaws\\.vpce\\.", var.cngfw_gwlb_service_name))
    error_message = "cngfw_gwlb_service_name must be a GWLB endpoint service name beginning with com.amazonaws.vpce.<region>.vpce-svc-..."
  }
}

variable "web_instance_type" {
  description = "Instance type for the app web servers."
  type        = string
  default     = "t3.micro"
}

variable "gwlbe_route_delay" {
  description = "Seconds to wait after the Cloud NGFW GWLB endpoint is created before adding routes to it. AWS rejects routes to a GWLB endpoint still in 'pending' state (RouteNotSupported), so the endpoint must reach 'available' first."
  type        = string
  default     = "150s"
}

variable "ca_secret_name" {
  description = "Name of the AWS Secrets Manager secret holding the Cloud NGFW forward-proxy CA (key + cert). The SCM Cloud Certificate references this as its Cloud Secret Name. The app instance role is granted read access to secrets matching this prefix for the decryption exercise."
  type        = string
  default     = "aws-outbound-trust"
}
