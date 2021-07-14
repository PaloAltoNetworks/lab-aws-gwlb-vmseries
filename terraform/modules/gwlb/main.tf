data "aws_caller_identity" "current" {}

//TODO: Add support for brownfield GWLB service to create new endpoints in spoke VPCs


################
# Locals to combine data source and resource references for optional browfield support
################

####  Gateway Load Balancer Endpoint Service #### 

locals {
  existing_gwlbe_services = {
    for k, gwlbe in data.aws_vpc_endpoint_service.this :
    k => gwlbe
  }

  new_gwlbe_services = {
    for k, gwlbe in aws_vpc_endpoint_service.this :
    k => gwlbe
  }

  combined_gwlbe_services = merge(local.existing_gwlbe_services, local.new_gwlbe_services)
}

data "aws_vpc_endpoint_service" "this" {
  for_each = {
    for k, gwlb in var.gateway_load_balancers : k => gwlb
    if lookup(gwlb, "existing", null) == true ? true : false
  }
  tags = {
    Name = each.value.name
  }
}



resource "aws_lb_target_group" "this" {
  #for_each    = var.gateway_load_balancers
  for_each = {
    for k, gwlb in var.gateway_load_balancers : k => gwlb
    if lookup(gwlb, "existing", null) != true ? true : false
  }
  protocol    = "GENEVE"
  vpc_id      = var.vpc_id
  target_type = "instance"
  port        = "6081"
  name        = "${var.prefix_name_tag}${each.value.name}"
  health_check {
    port     = "80"
    protocol = "TCP"
  }
}

locals {
  fw-to-gwlb = flatten([
    for k, v in var.gateway_load_balancers : [
      for fw in v.firewall_names : {
        firewall_id = var.firewalls[fw].id
        gwlb        = k
      }
    ]
    if lookup(v, "existing", null) != true ? true : false
  ])
}

resource "aws_lb_target_group_attachment" "this" {
  for_each         = { for k, v in local.fw-to-gwlb : k => v }
  target_group_arn = aws_lb_target_group.this[each.value.gwlb].arn
  target_id        = each.value.firewall_id
}

resource "aws_lb" "this" {
  #for_each           = var.gateway_load_balancers
  for_each = {
    for k, gwlb in var.gateway_load_balancers : k => gwlb
    if lookup(gwlb, "existing", null) != true ? true : false
  }
  name               = "${var.prefix_name_tag}${each.value.name}"
  load_balancer_type = "gateway"
  subnets = [
    for subnet in each.value.subnet_names :
    var.subnets_map[subnet]
  ]
  enable_cross_zone_load_balancing = true
  lifecycle {
    create_before_destroy = true
  }
  tags = merge({ Name = "${var.prefix_name_tag}${each.value.name}" }, var.global_tags, lookup(each.value, "local_tags", {}))
}

resource "aws_lb_listener" "this" {
  #for_each          = var.gateway_load_balancers
  for_each = {
    for k, gwlb in var.gateway_load_balancers : k => gwlb
    if lookup(gwlb, "existing", null) != true ? true : false
  }
  load_balancer_arn = aws_lb.this[each.key].arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.key].arn
  }
}

resource "aws_vpc_endpoint_service" "this" {
  #for_each            = var.gateway_load_balancers
  for_each = {
    for k, gwlb in var.gateway_load_balancers : k => gwlb
    if lookup(gwlb, "existing", null) != true ? true : false
  }
  acceptance_required = false
  allowed_principals         = lookup(each.value, "allowed_principals", null) #["arn:aws:iam::632512868473:root"]
  gateway_load_balancer_arns = [aws_lb.this[each.key].arn]
  tags                       = merge({ Name = "${var.prefix_name_tag}${each.value.name}" }, var.global_tags, lookup(each.value, "local_tags", {}))
}

resource "aws_vpc_endpoint" "this" {
  for_each          = var.gateway_load_balancer_endpoints
  service_name      = local.combined_gwlbe_services[each.value.gateway_load_balancer].service_name
  vpc_endpoint_type = local.combined_gwlbe_services[each.value.gateway_load_balancer].service_type
  vpc_id            = var.vpc_id
  subnet_ids = [
    for subnet in each.value.subnet_names :
    var.subnets_map[subnet]
  ]
  tags = merge({ Name = "${var.prefix_name_tag}${each.value.name}" }, var.global_tags, lookup(each.value, "local_tags", {}))
}