output transit_gateway_ids {
  description = "TGW Name -> ID Map (New AND Existing)"
  value       = local.combined_transit_gateways
}

output "transit_gateway_route_table_ids" {
  description = "TGW Route Table Name -> ID Map (New AND Existing)"
  value       = local.combined_transit_gateway_route_tables
}

output "transit_gateway_vpc_attachment_ids" {
  value =  {
    for k, vpc in aws_ec2_transit_gateway_vpc_attachment.this :
    k => vpc.id
  }
}
