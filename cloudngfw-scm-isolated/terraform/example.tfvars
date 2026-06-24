# Copy to terraform.tfvars and edit.

# Your short unique prefix (initials, under 8 chars). Keeps names from
# colliding if you share a tenant with other participants.
name_prefix = "ab-"

region = "us-east-1"
azs    = ["us-east-1a", "us-east-1b"]

vpc_cidr = "10.104.0.0/16"

# ---- Phase 1 ----
# Deploy the VPC, NAT, and app web servers with egress straight to the NAT.
# Confirm the apps come up and can reach the internet, then move to Phase 2.
insert_cngfw            = false
cngfw_gwlb_service_name = ""

# ---- Phase 2 ----
# After you create the Cloud NGFW in SCM and copy its GWLB endpoint service
# name from the Cloud NGFW console, set:
#   insert_cngfw            = true
#   cngfw_gwlb_service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0123456789abcdef0"
# then re-apply. App egress is now inspected by Cloud NGFW.
