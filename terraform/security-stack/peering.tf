# ── Cross-region TGW peering: FW region <-> Panorama region ──
#
# The peering module creates the peering attachment + accepter + route-table associations
# (it does NOT create CIDR routes). We add the four directional routes explicitly so the
# FW->Panorama bootstrap path (and the Panorama->FW reply path) work end to end.
#
# Path (FW -> Panorama):
#   FW mgmt -> security VPC attach -> [us from_security_vpc: Panorama CIDR -> peering] -> peering
#   -> [ca from_peer: Panorama CIDR -> Panorama VPC attach] -> Panorama
# Reply (Panorama -> FW):
#   Panorama -> Panorama VPC attach -> [ca from_panorama: fw_supernet -> peering] -> peering
#   -> [us from_peer: fw_supernet -> security VPC attach] -> FW

module "tgw_peering" {
  source  = "PaloAltoNetworks/swfw-modules/aws//modules/transit_gateway_peering"
  version = "2.2.7"

  providers = {
    aws        = aws
    aws.remote = aws.panorama
  }

  local_tgw_route_table = {
    id                 = module.transit_gateway["tgw"].route_tables["from_peer"].id
    transit_gateway_id = module.transit_gateway["tgw"].transit_gateway.id
  }
  remote_tgw_route_table = {
    id                 = data.terraform_remote_state.panorama.outputs.tgw_from_peer_rt_id
    transit_gateway_id = data.terraform_remote_state.panorama.outputs.tgw_id
  }
  local_attachment_tags = { Name = "${var.name_prefix}to-panorama" }
  tags                  = var.global_tags
}

# FW side: from_security_vpc -> Panorama CIDR via the peering attachment.
resource "aws_ec2_transit_gateway_route" "to_panorama" {
  transit_gateway_route_table_id = module.transit_gateway["tgw"].route_tables["from_security_vpc"].id
  destination_cidr_block         = data.terraform_remote_state.panorama.outputs.panorama_vpc_cidr
  transit_gateway_attachment_id  = module.tgw_peering.peering_attachment.id
  depends_on                     = [module.tgw_peering]
}

# FW side: from_peer (peering-associated) -> fw_supernet via the security VPC attachment (return path).
resource "aws_ec2_transit_gateway_route" "peer_to_security" {
  transit_gateway_route_table_id = module.transit_gateway["tgw"].route_tables["from_peer"].id
  destination_cidr_block         = var.fw_supernet
  transit_gateway_attachment_id  = module.transit_gateway_attachment["security"].attachment.id
  depends_on                     = [module.tgw_peering]
}

# Panorama side: from_panorama -> fw_supernet via the peering attachment.
resource "aws_ec2_transit_gateway_route" "panorama_to_fw" {
  provider                       = aws.panorama
  transit_gateway_route_table_id = data.terraform_remote_state.panorama.outputs.tgw_from_panorama_rt_id
  destination_cidr_block         = var.fw_supernet
  transit_gateway_attachment_id  = module.tgw_peering.peering_attachment_accepter.transit_gateway_attachment_id
  depends_on                     = [module.tgw_peering]
}

# Panorama side: from_peer (peering-associated) -> Panorama CIDR via the Panorama VPC attachment.
resource "aws_ec2_transit_gateway_route" "peer_to_panorama" {
  provider                       = aws.panorama
  transit_gateway_route_table_id = data.terraform_remote_state.panorama.outputs.tgw_from_peer_rt_id
  destination_cidr_block         = data.terraform_remote_state.panorama.outputs.panorama_vpc_cidr
  transit_gateway_attachment_id  = data.terraform_remote_state.panorama.outputs.panorama_vpc_attachment_id
  depends_on                     = [module.tgw_peering]
}
