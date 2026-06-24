##### Firewalls #####
output "vmseries_public_ips" {
  description = "Per-instance map of public IPs (mgmt + public interface EIPs)."
  value       = { for k, v in module.vmseries : k => v.public_ips }
}

output "security_gwlb_target_group_arns" {
  description = "GWLB target group ARNs (for health checks in the e2e harness)."
  value       = { for k, v in module.gwlb : k => v.target_group.arn }
}

##### Spokes #####
output "application_load_balancers" {
  description = "FQDNs of spoke Application Load Balancers."
  value       = { for k, v in module.app_alb : k => v.lb_fqdn }
}

output "network_load_balancers" {
  description = "FQDNs of spoke Network Load Balancers (inbound showheaders test target)."
  value       = { for k, v in module.app_nlb : k => v.lb_fqdn }
}

output "spoke_vm_instance_ids" {
  description = "Spoke app host instance ids (SSM send-command targets for the traffic tests)."
  value       = { for k, v in aws_instance.spoke_vms : k => v.id }
}

##### Panorama (passthrough from remote state, for convenience) #####
output "panorama_private_ip" {
  value = data.terraform_remote_state.panorama.outputs.panorama_private_ip
}

output "panorama_public_ip" {
  value = data.terraform_remote_state.panorama.outputs.panorama_public_ip
}

output "fw_bootstrap_panorama_server" {
  description = "The address the firewalls were told to bootstrap to (private via peering, or EIP fallback)."
  value       = local.panorama_server
}

##### Cross-region peering #####
output "tgw_peering_attachment_id" {
  value = module.tgw_peering.peering_attachment.id
}

##### Break-glass SSH #####
output "fw_ssh_key_name" {
  value = local.ssh_key_name
}
