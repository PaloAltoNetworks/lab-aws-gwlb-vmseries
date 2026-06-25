output "test_vms_usernames" {
  description = "Initial administrative username to use for test VMs."
  value = length(var.test_infrastructure) > 0 ? {
    for k, v in local.test_vm_authentication : k => v.username
  } : null
}

output "test_vms_passwords" {
  description = "Initial administrative password to use for test VMs."
  value = length(var.test_infrastructure) > 0 ? {
    for k, v in local.test_vm_authentication : k => v.password
  } : null
  sensitive = true
}

output "test_vms_ips" {
  description = "IP Addresses of the test VMs."
  value       = length(var.test_infrastructure) > 0 ? { for k, v in module.test_infrastructure : k => v.vm_private_ips } : null
}

output "test_lb_frontend_ips" {
  description = "IP Addresses of the test load balancers."
  value = length({ for k, v in var.test_infrastructure : k => v if v.load_balancers != null }) > 0 ? {
    for k, v in module.test_infrastructure : k => v.frontend_ip_configs
  } : null
}
