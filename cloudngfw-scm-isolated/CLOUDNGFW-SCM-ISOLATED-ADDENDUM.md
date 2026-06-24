# Cloud NGFW for AWS + Strata Cloud Manager - Isolated Outbound Lab (Part 2)

> &#8505; This is Part 2, a self-contained lab. You deploy a new VPC and run its own Terraform independently of Part 1. Part 1 is needed for one thing only: its deployment profile, which you use to turn on Strata Cloud Manager Pro.

```
Manual Last Updated: 2026-06-24
```

## Lab Guide Syntax conventions

- Items with a bullet indicate actions to take to complete the lab.
- Code blocks follow an action for copy / paste or reference.

> &#8505; Items with the info icon are additional context or details around the actions.

> &#10067; Items with the question mark icon are good check-your-understanding questions.

## 1. Overview

In Part 1 you ran one firewall engine: VM-Series behind a Gateway Load Balancer, managed by Panorama. In this part you introduce a second engine, Palo Alto Cloud NGFW for AWS (a Palo Alto-operated managed firewall service), and you manage it from Strata Cloud Manager (SCM).

This lab uses the **isolated model**: the Cloud NGFW inspection endpoint lives in the same VPC as the application, and that VPC sends its outbound traffic through Cloud NGFW for inspection. No Transit Gateway, no separate security VPC. You will:

- Turn on Strata Cloud Manager Pro using your Part 1 deployment profile.
- Deploy a self-contained application VPC with Terraform.
- Create an SCM-managed Cloud NGFW and insert it into the VPC's outbound path.
- Author policy in SCM-native security rules and watch traffic get inspected.

| Choice | Part 1 (VM-Series) | This lab (Cloud NGFW) |
| --- | --- | --- |
| Firewall resource | VM-Series you run (EC2 + GWLB) | Cloud NGFW, a managed service |
| Endpoint placement | Centralized security VPC | Distributed: endpoint in the app VPC (isolated) |
| Management plane | Panorama | Strata Cloud Manager (SCM) |

> &#8505; The isolated model does not inspect east/west traffic between VPCs. That is expected; this lab is about getting one application VPC's outbound traffic inspected by a SaaS firewall you manage from SCM.

> &#8505; A later part of this lab (Part B) adds account onboarding, TLS decryption, and CloudWatch logging. The core lab here works **without** onboarding your account with cross-account IAM roles, which is a useful way to see what those roles do (and do not) gate.

## 2. Architecture

Outbound, before Cloud NGFW is inserted (Phase 1):

```
app server -> NAT gateway -> IGW -> internet
```

Outbound, after Cloud NGFW is inserted (Phase 2):

```
app server -> Cloud NGFW endpoint -> [inspect] -> NAT gateway -> IGW -> internet
return:      internet -> NAT -> Cloud NGFW endpoint -> app server
```

> &#8505; The return path is steered back through the Cloud NGFW endpoint on purpose. Gateway Load Balancer requires the firewall to see both directions of a flow. Cloud NGFW does not source-NAT (egress NAT is not supported on SCM-managed firewalls), so the AWS NAT gateway does the NAT and the Terraform sets up the symmetric routing for you.

## 3. Prerequisites

- Your own QwikLabs AWS account. This lab is built for `us-east-1`.
- Your Part 1 deployment profile (it carries a Strata Cloud Manager Pro entitlement).
- SCM access: your instructor's workshop parent tenant, where you activate your own child tenant.

## 4. Step 1 - Activate Strata Cloud Manager Pro from your deployment profile

You do not need the 30-day eval. Your Part 1 deployment profile already includes a Strata Cloud Manager Pro entitlement; you activate it onto your tenant.

- In the Customer Support Portal / hub, open your deployment profile and choose `Finish Setup`.
- On `Activate Subscriptions based on Deployment Profile(s)`, select your Customer Support Account.
- Under `Specify the Recipient`, select your tenant (your `*-swfw-lab` tenant under the workshop parent).
- Select your Region, then under `Select Deployment Profile(s)` choose your `*-swfw-workshop` profile (Strata Cloud Manager Pro).
- Review, agree to the Terms and Conditions, and choose `Activate`.
- Strata Cloud Manager begins provisioning on your tenant (`Initializing`, ~20 minutes). Continue to the next step while it finishes.

<!-- screenshots (clean versions to add): Finish Setup; recipient tenant; deployment-profile select; review+Activate; tenant SCM Initializing -->

> &#8505; The first Cloud NGFW resource you create later also upgrades the tenant with SCM Pro features for Cloud NGFW (~45-50 minutes), which runs in the background. You do not need to wait for it.

## 5. Step 2 - Deploy the lab infrastructure (Terraform, Phase 1)

Run Terraform from the QwikLabs Cloud Shell, the same way as Part 1.

- Open Cloud Shell in `us-east-1`.
- Clone the repo and change into the Cloud NGFW Terraform directory.

```
git clone https://github.com/PaloAltoNetworks/lab-aws-gwlb-vmseries.git
cd lab-aws-gwlb-vmseries/cloudngfw-scm-isolated/terraform
cp example.tfvars terraform.tfvars
```

- Edit `terraform.tfvars`: set `name_prefix` to a short unique value (your initials). Leave `insert_cngfw = false` for now.
- Deploy.

```
terraform init
terraform apply
```

- Note the outputs. You will need `gwlbe_subnet_az_ids` in the next step.

```
terraform output gwlbe_subnet_az_ids
```

- Confirm an app server reaches the internet: connect with Session Manager (EC2 -> Instances -> select an app server -> Connect -> Session Manager) and run `curl -s https://ifconfig.me`. You should get a NAT public IP back (`terraform output nat_public_ips`).

> &#8505; In Phase 1 the app servers egress straight through the NAT. This proves the application works before you insert the firewall, so when traffic changes later you know the firewall is the cause.

> &#9888; This QwikLabs account does not have the `AWS-RunShellCommand` SSM document, so use **Session Manager** (an interactive shell) for any on-box step in this lab, not SSM Run Command.

## 6. Step 3 - Create the Cloud NGFW resource in SCM

- In SCM: Configurations -> Cloud NGFWs -> Create Cloud NGFW.
- Select Cloud Provider: `Amazon Web Services`. The first time you will see `The environment setup has completed successfully`.
- General Info:
  - `Firewall Name`: a name with your prefix.
  - `Region`: `us-east-1`.
  - `Availability Zone IDs`: enter the IDs from `terraform output gwlbe_subnet_az_ids`. They must match the AZs your `gwlbe` subnets are in.
- Endpoint Management -> `Allowlisted AWS Accounts`: enter your AWS Account ID.
- Create and Deploy. The firewall shows `CREATING` for up to 10 minutes, then registers as a device in SCM.

<!-- screenshots (clean versions to add): Create Cloud NGFW wizard General Info; Creating Firewall notification -->

> &#8505; Allowlisting your account is all the core lab needs - it lets you create the Cloud NGFW endpoint in your VPC. Full account onboarding (the CloudFormation template that creates cross-account IAM roles) is a separate step covered in Part B; it is what enables decryption and CloudWatch logging, not basic inspection.

> &#8505; AZ names are per-account aliases; Cloud NGFW places its endpoints by physical AZ ID. The `gwlbe_subnet_az_ids` output gives you the exact IDs to paste, so you do not have to look them up by hand.

> &#10067; Why does Cloud NGFW ask for Availability Zone IDs instead of names?

## 7. Step 4 - Insert Cloud NGFW into the egress path (Terraform, Phase 2)

- In the Cloud NGFW console, open your firewall and copy its GWLB endpoint **service name** (looks like `com.amazonaws.vpce.us-east-1.vpce-svc-...`).
- Edit `terraform.tfvars`:

```
insert_cngfw            = true
cngfw_gwlb_service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0123456789abcdef0"
```

- Re-apply.

```
terraform apply
```

This creates the Cloud NGFW endpoint in each `gwlbe` subnet and redirects the app subnets' egress (and the return path) through it.

> &#8505; The apply pauses for about 2.5 minutes after creating the endpoint. A GWLB endpoint returns from creation in a `pending` state, and AWS rejects a route to it until it is `available`. The Terraform waits this out for you (`gwlbe_route_delay`).

> &#9888; Cloud NGFW denies by default. The moment you insert it, the app servers lose internet (including Session Manager) until you add an allow policy in the next step. That is expected.

> &#10067; At this exact moment (routes flipped, no policy yet), where would you see an app server's outbound request being dropped?

## 8. Step 5 - Author SCM policy and test

Policy for an SCM-managed Cloud NGFW lives in SCM-native security rules in a folder, not in Cloud NGFW rulestacks.

- Create a folder: SCM -> Workflows -> NGFW Setup -> Folder Management -> Add Folder (e.g. `aws-cloudngfw`), in `All Firewalls`.
- Move your firewall into the folder: Folder Management -> your firewall -> Actions -> Move.
- Author an outbound allow rule: Manage -> Configuration -> NGFW and Prisma Access -> Configuration Scope = your folder -> Security Services -> Security Policy -> Add Rule:
  - `Source Zone`: `any` (required)
  - `Source Address`: your app subnets (or `any`)
  - `Destination Zone`: `any` (required)
  - `Application`: `web-browsing`, `ssl`, `dns` (and whatever your apps need outbound)
  - `Action`: `Allow`, log at session end
- Push the configuration.

<!-- screenshots (clean versions to add): Add Folder; Folder Management move firewall; Add Rule; Push -->

> &#9888; SCM-managed Cloud NGFW rules must use `any` for source and destination zone. A real zone value silently drops traffic.

Test:

- From an app server (Session Manager), `curl -s https://ifconfig.me` and browse a few sites. Traffic now flows again, inspected by Cloud NGFW.
- View logs: SCM -> Configurations -> Cloud NGFWs -> your firewall -> View Logs. You should see the allowed sessions.

> &#10067; Compare these session logs with the VM-Series traffic logs in Panorama from Part 1. What is the same, and what differs in how each engine is managed and logged?

## 9. What you built

You now have an application VPC whose outbound traffic is inspected by an SCM-managed Cloud NGFW, inserted as a Gateway Load Balancer endpoint in the isolated model, with policy authored in SCM-native security rules. You did all of this with only your account **allowlisted** - no cross-account IAM roles.

## 10. Coming next (Part B): onboarding, decryption, and logging

The next part adds the cross-account IAM roles (via a CloudFormation template) and uses them to:

- **Decrypt** outbound TLS with a forward-proxy certificate (an SCM Cloud Certificate bound to an AWS Secrets Manager secret), so Cloud NGFW can inspect the payload, not just the handshake.
- **Forward logs** to CloudWatch (log groups `PaloAltoCloudNGFW` and `PaloAltoCloudNGFWAuditLog`) and publish metrics.

> &#8505; This is the natural place to see what the onboarding roles actually unlock: the core inspection above worked without them; decryption and CloudWatch logging do not.

## 11. Cleanup

- `terraform destroy` the lab VPC.
- In SCM, delete the Cloud NGFW endpoints and the firewall resource.
- Your QwikLabs account is recycled at the end of the workshop.

## References

- *Cloud NGFW for AWS - Getting Started* (SCM onboarding, tenant V2, deployment-profile activation)
- *Cloud NGFW for AWS - Administration* (SCM policy management, certificates, decryption, logging)
- *Cloud NGFW for AWS - Deployment* (distributed / isolated architecture)
