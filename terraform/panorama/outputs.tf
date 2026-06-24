output "panorama_private_ip" {
  description = "Panorama private mgmt IP. Firewalls bootstrap to this over the TGW peering (default path)."
  value       = module.panorama.mgmt_ip_private_address
}

output "panorama_public_ip" {
  description = "Panorama EIP. Used for panorama-init/admin/API access, and as the FW bootstrap fallback (panorama-server)."
  value       = module.panorama.mgmt_ip_public_address
}

output "panorama_vpc_id" {
  value = aws_vpc.panorama.id
}

output "panorama_vpc_cidr" {
  value = aws_vpc.panorama.cidr_block
}

output "region" {
  value = var.region
}

output "panorama_version" {
  description = "Panorama PAN-OS version (consumed by the security-stack FW<=Panorama compat check)."
  value       = var.panorama_version
}

output "tgw_id" {
  description = "Panorama-region TGW id (peering target for the security-stack root)."
  value       = module.tgw.transit_gateway.id
}

output "tgw_from_panorama_rt_id" {
  description = "Route table associated to the Panorama VPC attachment. Security-stack adds the FW return route here."
  value       = module.tgw.route_tables["from_panorama"].id
}

output "tgw_from_peer_rt_id" {
  description = "Dedicated route table for the cross-region peering attachment (remote side)."
  value       = module.tgw.route_tables["from_peer"].id
}

output "panorama_vpc_attachment_id" {
  description = "Panorama VPC TGW attachment id (next hop for FW->Panorama traffic arriving via peering)."
  value       = module.panorama_tgw_attach.attachment.id
}

output "ssh_key_name" {
  value = aws_key_pair.panorama.key_name
}

output "ssh_private_key_path" {
  description = "Local path to the generated Panorama SSH private key (panorama-init --ssh-key). Gitignored."
  value       = local_file.panorama_private_key.filename
}
