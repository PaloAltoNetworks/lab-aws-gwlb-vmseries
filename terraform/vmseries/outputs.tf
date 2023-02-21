output vmseries_eips {
  value = module.vmseries.vmseries_eips
}

output endpoint_ids {
    value = merge(module.gwlb.endpoint_ids, module.spoke1_gwlb.endpoint_ids, module.spoke2_gwlb.endpoint_ids)
}

output app_nlbs_dns {
  value = {
    spoke1_nlb = module.spoke1_nlb.lb_dns_name
    spoke2_nlb = module.spoke2_nlb.lb_dns_name
  }
}