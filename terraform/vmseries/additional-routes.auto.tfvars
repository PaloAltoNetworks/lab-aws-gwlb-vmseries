spoke1_vpc_routes_additional = {
  igw-edge-alb1-to-endpoint1 = {
    route_table   = "igw-edge"
    prefix        = "10.200.0.16/28"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "spoke1-inbound1"
  }
  igw-edge-alb2-to-endpoint2 = {
    route_table   = "igw-edge"
    prefix        = "10.200.1.16/28"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "spoke1-inbound2"
  }
  web1-default-to-tgw = {
    route_table   = "web1"
    prefix        = "0.0.0.0/0"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  web2-default-to-tgw = {
    route_table   = "web2"
    prefix        = "0.0.0.0/0"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe1-default-to-igw = {
    route_table   = "gwlbe1"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "spoke1_vpc"
  }
  gwlbe2-default-to-igw = {
    route_table   = "gwlbe2"
    prefix        = "0.0.0.0/0"
    next_hop_type = "internet_gateway"
    next_hop_name = "spoke1_vpc"
  }
  alb1-to-endpoint1 = {
    route_table   = "alb1"
    prefix        = "0.0.0.0/0"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "spoke1-inbound1"
  }
  alb2-to-endpoint2 = {
    route_table   = "alb2"
    prefix        = "0.0.0.0/0"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "spoke1-inbound2"
  }
}

spoke2_vpc_routes_additional = {
 igw-edge-alb1-to-endpoint1 = {
   route_table   = "igw-edge"
   prefix        = "10.250.0.16/28"
   next_hop_type = "vpc_endpoint"
   next_hop_name = "spoke2-inbound1"
 }
 igw-edge-alb2-to-endpoint2 = {
   route_table   = "igw-edge"
   prefix        = "10.250.1.16/28"
   next_hop_type = "vpc_endpoint"
   next_hop_name = "spoke2-inbound2"
 }
}


vpc_routes_additional = {
 natgw1-to-gwlbe-outbound1 = {
    route_table   = "natgw1"
    prefix        = "10.0.0.0/8"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "outbound1"
  }
  natgw2-to-gwlbe-outbound2 = {
    route_table   = "natgw2"
    prefix        = "10.0.0.0/8"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "outbound2"
  }
  gwlbe-outbound1-to-natgw1 = {
    route_table   = "gwlbe-outbound-1"
    prefix        = "0.0.0.0/0"
    next_hop_type = "nat_gateway"
    next_hop_name = "natgw1"
  }
  gwlbe-outbound2-to-natgw2 = {
    route_table   = "gwlbe-outbound-2"
    prefix        = "0.0.0.0/0"
    next_hop_type = "nat_gateway"
    next_hop_name = "natgw2"
  }
  gwlbe-outbound1-to-tgw = {
    route_table   = "gwlbe-outbound-1"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe-outbound2-to-tgw = {
    route_table   = "gwlbe-outbound-2"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe-east-west-1-to-tgw = {
    route_table   = "gwlbe-eastwest-1"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe-east-west-2-to-tgw = {
    route_table   = "gwlbe-eastwest-2"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe-outbound1-to-tgw-test-spoke = {
    route_table   = "gwlbe-outbound-1"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe-outbound2-to-tgw-test-spoke = {
    route_table   = "gwlbe-outbound-2"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe-east-west-1-to-tgw-test-spoke = {
    route_table   = "gwlbe-eastwest-1"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  gwlbe-east-west-2-to-tgw-test-spoke = {
    route_table   = "gwlbe-eastwest-2"
    prefix        = "10.0.0.0/8"
    next_hop_type = "transit_gateway"
    next_hop_name = "gwlb"
  }
  tgw-attach-1-to-outbound-gwlbe-1 = {
    route_table   = "tgw-attach1"
    prefix        = "0.0.0.0/0"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "outbound1"
  }
  tgw-attach-2-to-outbound-gwlbe-2 = {
    route_table   = "tgw-attach2"
    prefix        = "0.0.0.0/0"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "outbound2"
  }
  tgw-attach-1-to-eastwest-gwlbe-1 = {
    route_table   = "tgw-attach1"
    prefix        = "10.0.0.0/8"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "east-west1"
  }
  tgw-attach-2-to-eastwest-gwlbe-2 = {
    route_table   = "tgw-attach2"
    prefix        = "10.0.0.0/8"
    next_hop_type = "vpc_endpoint"
    next_hop_name = "east-west2"
  }
}