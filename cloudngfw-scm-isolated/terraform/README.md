# Cloud NGFW + SCM isolated lab - Terraform

Standalone Terraform for the Cloud NGFW for AWS + Strata Cloud Manager lab. It is
self-contained: no dependency on the Part 1 GWLB/VM-Series modules. It builds one
VPC where application servers send outbound traffic through a Cloud NGFW for
inspection and decryption, using the isolated model (the Cloud NGFW GWLB endpoint
lives in the same VPC as the workload, no Transit Gateway required).

## What it builds

A single VPC across two AZs:

- `app` subnets - two Amazon Linux web servers (Session Manager access, no public IP).
- `gwlbe` subnets - hold the customer-managed Cloud NGFW GWLB endpoint (Phase 2).
- `public` subnets - a NAT gateway per AZ for internet egress.

Routing follows the GWLB egress pattern with return-path symmetry, which the
forward-proxy decryption depends on:

```
Phase 1 (insert_cngfw = false):
  app -> NAT -> IGW -> internet

Phase 2 (insert_cngfw = true):
  app -> Cloud NGFW endpoint -> (inspect/decrypt) -> NAT -> IGW -> internet
  return: internet -> NAT -> Cloud NGFW endpoint -> app   (symmetry)
```

## Two-phase flow

The lab inserts the firewall as a deliberate, observable step.

1. **Phase 1** - `insert_cngfw = false`. Deploy infra + apps; egress goes straight
   to the NAT. Confirm the apps install and can reach the internet.
2. **Create the Cloud NGFW in SCM** (console) and copy its GWLB endpoint service
   name from the Cloud NGFW console.
3. **Phase 2** - set `insert_cngfw = true` and `cngfw_gwlb_service_name`, re-apply.
   App egress is now redirected through Cloud NGFW. Cloud NGFW denies by default,
   so add an SCM allow policy or the apps lose internet (this is expected and is a
   teaching point).

## Usage

```
cp example.tfvars terraform.tfvars   # edit name_prefix
terraform init
terraform apply                      # Phase 1

# ...create the Cloud NGFW in SCM, copy its GWLB service name...
# edit terraform.tfvars: insert_cngfw = true, cngfw_gwlb_service_name = "com.amazonaws.vpce..."
terraform apply                      # Phase 2
```

In QwikLabs Cloud Shell leave `aws_profile` empty (the ambient role is used).

## Variables

| Variable | Default | Notes |
| --- | --- | --- |
| `region` | `us-west-2` | Must match the Cloud NGFW region in SCM. |
| `name_prefix` | `cngfw-` | Short unique prefix (your initials). |
| `azs` | two us-west-2 AZs | AZ names in your own account. |
| `vpc_cidr` | `10.104.0.0/16` | `/16` gives clean `/24` subnets. |
| `insert_cngfw` | `false` | Phase toggle. |
| `cngfw_gwlb_service_name` | `""` | The SCM Cloud NGFW's GWLB endpoint service name. Required for Phase 2. |
| `web_instance_type` | `t3.micro` | App server size. |
| `ca_secret_name` | `cloudngfwca-untrust` | Secrets Manager secret the app role may read (decryption exercise). |

## Notes

- Customer-managed endpoints cannot be deleted independently in AWS, but QwikLabs
  accounts are recycled, so this does not matter for the lab.
- After Phase 2, Session Manager to the app servers also rides the inspected path;
  add the SCM allow policy promptly so SSM keeps working.
