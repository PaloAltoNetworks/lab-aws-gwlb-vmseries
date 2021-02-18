output "firewalls" {
  value = {
    for k, f in aws_instance.pa-vm-series :
    k => f
  }
}


output vmseries_eips {
  value = {
    for k, eip in aws_eip.this :
    k => eip.public_ip
  }
}