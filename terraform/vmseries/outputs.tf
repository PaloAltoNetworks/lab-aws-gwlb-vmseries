output vmseries_eips {
  value = module.vmseries.vmseries_eips
}

output endpoint_ids {
    value = merge(module.gwlb.endpoint_ids, module.app1_gwlb.endpoint_ids, module.app2_gwlb.endpoint_ids)
}