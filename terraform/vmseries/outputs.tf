output vmseries_eips {
  value = module.vmseries.vmseries_eips
}

output endpoint_ids {
    value = merge(module.gwlb.endpoint_ids, module.app1_gwlb.endpoint_ids, module.app2_gwlb.endpoint_ids)
}

output app_nlbs_dns {
  value = {
    app1_nlb = module.app1_nlb.lb_dns_name
    app2_nlb = module.app2_nlb.lb_dns_name
  }
}