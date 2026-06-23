output "vpc_id" {
  description = "Lab VPC id."
  value       = aws_vpc.this.id
}

output "app_subnet_ids" {
  description = "App subnet ids (where the web servers live), keyed by az1/az2."
  value       = { for k, s in aws_subnet.app : k => s.id }
}

output "gwlbe_subnet_ids" {
  description = "GWLBE subnet ids (where the Cloud NGFW endpoint is placed), keyed by az1/az2."
  value       = { for k, s in aws_subnet.gwlbe : k => s.id }
}

output "gwlbe_subnet_az_ids" {
  description = "AZ ID of each gwlbe subnet. Enter THESE values as the Availability Zone IDs when you create the Cloud NGFW in SCM, so its endpoints land in the same physical AZs as your subnets."
  value       = { for k, s in aws_subnet.gwlbe : k => s.availability_zone_id }
}

output "public_subnet_ids" {
  description = "Public (NAT) subnet ids, keyed by az1/az2."
  value       = { for k, s in aws_subnet.public : k => s.id }
}

output "web_instance_ids" {
  description = "App web server instance ids (connect via Session Manager)."
  value       = { for k, i in aws_instance.web : k => i.id }
}

output "web_private_ips" {
  description = "App web server private IPs."
  value       = { for k, i in aws_instance.web : k => i.private_ip }
}

output "nat_public_ips" {
  description = "Per-AZ NAT public IPs (the source IP your egress traffic shows on the internet)."
  value       = { for k, e in aws_eip.nat : k => e.public_ip }
}

output "gwlbe_endpoint_ids" {
  description = "Cloud NGFW GWLB endpoint ids (empty until insert_cngfw = true)."
  value       = { for k, e in aws_vpc_endpoint.gwlbe : k => e.id }
}

output "cngfw_inserted" {
  description = "Whether app egress is currently routed through the Cloud NGFW."
  value       = var.insert_cngfw
}

output "next_step" {
  description = "What to do next."
  value       = var.insert_cngfw ? "Cloud NGFW inserted: app egress is inspected. Add an SCM allow policy or apps lose internet (deny by default)." : "Phase 1 deployed: apps egress via NAT. Create the SCM Cloud NGFW, copy its GWLB endpoint service name, then set insert_cngfw=true + cngfw_gwlb_service_name and re-apply."
}
