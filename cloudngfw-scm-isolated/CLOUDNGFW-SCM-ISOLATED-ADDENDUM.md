# Cloud NGFW for AWS + Strata Cloud Manager - Isolated Model Lab (Part 2)

> &#8505; DRAFT. This is the rebuilt Part 2. It is self-contained and does not depend on the Part 1 data plane: you deploy a new VPC and run all of its Terraform independently. Part 1 is the prerequisite for one thing only: your deployment profile, which you use to turn on Strata Cloud Manager Pro.

```
Manual Last Updated: 2026-06-23 (draft)
```

## Lab Guide Syntax conventions

- Items with a bullet indicate actions to take to complete the lab.
- Code blocks follow an action for copy / paste or reference.

> &#8505; Items with the info icon are additional context or details around the actions.

> &#10067; Items with the question mark icon are good check-your-understanding questions.

## 1. Overview

In Part 1 you ran one firewall engine, VM-Series behind a Gateway Load Balancer. In this part you introduce a second engine, Palo Alto Cloud NGFW for AWS, a Palo Alto-operated managed firewall service, and you manage it from Strata Cloud Manager (SCM).

This lab uses the **isolated model**: the Cloud NGFW inspection endpoint lives in the same VPC as the application, and that VPC sends its own outbound (and, later, inbound) traffic through Cloud NGFW. There is no Transit Gateway and no separate security VPC. You will:

- Turn on Strata Cloud Manager Pro using your Part 1 deployment profile.
- Onboard your AWS account to Cloud NGFW.
- Deploy a self-contained application VPC with Terraform.
- Create an SCM-managed Cloud NGFW and insert it into the VPC's outbound path.
- Author policy in SCM-native security rules.
- Decrypt outbound TLS with a forward-proxy certificate.

> &#8505; Why a new VPC instead of reusing the Part 1 spokes? Inserting a second firewall engine into the existing Part 1 topology mixes two inspection paths in one route table and gets confusing fast. A clean, isolated VPC keeps the Cloud NGFW story self-contained: one VPC, one engine, one set of routes you can read top to bottom.

| Choice | Part 1 (VM-Series) | This lab (Cloud NGFW) |
| --- | --- | --- |
| Firewall resource | VM-Series you run (EC2 + GWLB) | Cloud NGFW, a managed service |
| Endpoint placement | Centralized security VPC | Distributed: endpoint in the app VPC (isolated) |
| Management plane | Panorama | Strata Cloud Manager (SCM) |
| Inspection focus | All flows | Outbound + decryption (this lab) |

> &#8505; The isolated model does not inspect east/west between VPCs. That is expected; this lab is about getting a single application VPC's outbound traffic inspected and decrypted by a SaaS firewall you manage from SCM.

## 2. Architecture

Outbound, before Cloud NGFW is inserted (Phase 1):

```
app server ─▶ NAT gateway ─▶ IGW ─▶ internet
```

Outbound, after Cloud NGFW is inserted (Phase 2):

```
app server ─▶ Cloud NGFW endpoint ─▶ [inspect / decrypt] ─▶ NAT gateway ─▶ IGW ─▶ internet
return:      internet ─▶ NAT ─▶ Cloud NGFW endpoint ─▶ app server
```

> &#8505; The return path is deliberately steered back through the Cloud NGFW endpoint. Gateway Load Balancer requires the firewall to see both directions of a flow, and forward-proxy decryption cannot work if the reply bypasses the firewall. Cloud NGFW does not do source NAT (egress NAT is not supported on SCM-managed firewalls), so the AWS NAT gateway does the NAT and the Terraform sets up the symmetric routing for you.

## 3. Prerequisites

- Your own QwikLabs AWS account (each participant has one). This lab was built and tested in `us-east-1`.
- Your Part 1 deployment profile (it carries a Strata Cloud Manager Pro entitlement).
- SCM access: your instructor's workshop parent tenant, where you activate your own child tenant.

## 4. Step 1 - Activate Strata Cloud Manager Pro from your deployment profile

You do not need the 30-day eval. Your Part 1 deployment profile already includes a Strata Cloud Manager Pro entitlement; you activate it onto your tenant.

- In the Customer Support Portal / hub, open your deployment profile and choose `Finish Setup` (the profile shows a note that additional licenses need to be activated on a tenant).
- On `Activate Subscriptions based on Deployment Profile(s)`, select your Customer Support Account.
- Under `Specify the Recipient`, select your tenant (your `*-swfw-lab` tenant under the workshop parent).
- Select your Region.
- Under `Select Deployment Profile(s)`, choose your `*-swfw-workshop` profile (Strata Cloud Manager Pro).
- Review the summary, agree to the Terms and Conditions, and choose `Activate`.
- Strata Cloud Manager begins provisioning on your tenant. It shows `Initializing` and takes around 20 minutes. Continue to the next step while it finishes.

<!-- screenshots (clean versions to be added): deployment-profile Finish Setup; recipient tenant select; deployment-profile select; review + Activate; tenant Products showing SCM Initializing -->

> &#8505; The first Cloud NGFW resource you create later also upgrades the tenant with SCM Pro features for Cloud NGFW (around 45-50 minutes), which runs in the background. You do not need to wait for it.

## 5. Step 2 - Onboard your AWS account to Cloud NGFW

Creating endpoints needs your account allowlisted (you do that in Step 4). Logging and decryption also need a set of cross-account IAM roles, which is the account onboarding here.

- In SCM (or the Cloud NGFW console): Cloud NGFW -> Onboard AWS Account -> enter your AWS Account ID -> download/launch the CloudFormation template -> deploy it in your account.
- The stack creates four cross-account roles (Logging, Endpoint, Network Monitoring, Decryption). Copy the four Role ARNs back into the onboarding screen and confirm the account shows `Success`.

> &#9888; QwikLabs accounts are recycled and are sometimes left associated with a previous tenant. Onboard the account first; if you get an "already associated" error, restart the lab to get a fresh account. Do not skip this check.

> &#8505; You onboard your own account, so unlike a shared account there is nothing to collide with. The Decryption role is what later lets Cloud NGFW pull your forward-proxy certificate from Secrets Manager.

## 6. Step 3 - Deploy the lab infrastructure (Terraform, Phase 1)

You will run Terraform from the QwikLabs Cloud Shell, the same way as Part 1.

- Open Cloud Shell in your account's region (`us-east-1`).
- Clone the lab repo and change into the Cloud NGFW Terraform directory.

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

- When it finishes, note the outputs. You will need `gwlbe_subnet_az_ids` in the next step.

```
terraform output
```

- Confirm the app servers came up and reach the internet: connect to an app server with Session Manager and run `curl -s https://ifconfig.me`. You should get a NAT public IP back (`terraform output nat_public_ips`).

> &#8505; In Phase 1 the app servers egress straight through the NAT. This proves the application works before you insert the firewall, so when traffic later changes you know the firewall is the cause.

## 7. Step 4 - Create the Cloud NGFW resource in SCM

- In SCM: Configurations -> Cloud NGFWs -> Create Cloud NGFW.
- Select Cloud Provider: `Amazon Web Services`. The first time, you will see `The environment setup has completed successfully`.
- General Info:
  - `Firewall Name`: a name with your prefix.
  - `Region`: `us-east-1` (the region your Terraform deployed into).
  - `Availability Zone IDs`: enter the AZ IDs from `terraform output gwlbe_subnet_az_ids`. These must match the physical AZs your `gwlbe` subnets are in.
- Endpoint Management -> `Allowlisted AWS Accounts`: enter your AWS Account ID.
- Create and Deploy. The firewall shows `CREATING` for up to 10 minutes, then registers as a device in SCM.

<!-- screenshots (clean versions to be added): Create Cloud NGFW wizard General Info; Creating Firewall notification -->

> &#8505; AZ names are per-account aliases; Cloud NGFW places its endpoints by physical AZ ID. The `gwlbe_subnet_az_ids` Terraform output gives you the exact IDs to paste here, so you do not have to look them up by hand. If you prefer to verify in the console, the VPC -> Subnets list shows an "Availability Zone ID" column.

> &#10067; Why does Cloud NGFW ask for Availability Zone IDs instead of names?

## 8. Step 5 - Insert Cloud NGFW into the egress path (Terraform, Phase 2)

- In the Cloud NGFW console, open your firewall and copy its GWLB endpoint service name (looks like `com.amazonaws.vpce.us-east-1.vpce-svc-...`).
- Edit `terraform.tfvars`:

```
insert_cngfw            = true
cngfw_gwlb_service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0123456789abcdef0"
```

- Re-apply.

```
terraform apply
```

This creates the Cloud NGFW endpoint in each `gwlbe` subnet and redirects the app subnets' egress (and the matching return path) through it.

> &#9888; Cloud NGFW denies by default. The moment you insert it, the app servers lose internet (including Session Manager) until you add an allow policy in the next step. That is expected.

> &#10067; At this point, what path does an app server's outbound request take, and where would you see it denied?

## 9. Step 6 - Author SCM-native policy and test

Policy for an SCM-managed Cloud NGFW lives in SCM-native security rules in a folder, not in Cloud NGFW rulestacks.

- Create a folder: SCM -> Workflows -> NGFW Setup -> Folder Management -> Add Folder, e.g. `aws-cloudngfw`, in `All Firewalls`.
- Move your firewall into the folder: Folder Management -> your firewall -> Actions -> Move.
- Author an outbound allow rule: Manage -> Configuration -> NGFW and Prisma Access -> Configuration Scope = your folder -> Security Services -> Security Policy -> Add Rule:
  - `Source Zone`: `any` (required)
  - `Source Address`: your app subnets
  - `Destination Zone`: `any` (required)
  - `Application`: `web-browsing`, `ssl`, and the services your app servers need outbound (include what Session Manager uses so it keeps working)
  - `Action`: `Allow`, log at session end
- Push the configuration.

<!-- screenshots (clean versions to be added): Create Folder; Folder Management move firewall -->

> &#9888; SCM-managed Cloud NGFW rules must use `any` for source and destination zone. A real zone value silently drops traffic. (In the Strata Logging Service the from/to zone appears as the data zone.)

Test:

- From an app server (Session Manager), `curl -s https://ifconfig.me` and browse a few sites.
- View logs: SCM -> Configurations -> Cloud NGFWs -> your firewall -> View Logs. You should see the sessions, now inspected by Cloud NGFW.

## 10. Step 7 - Outbound decryption (forward proxy)

Decryption is where Cloud NGFW earns its keep: without it the firewall sees only the TLS handshake. Here you give Cloud NGFW a forward-proxy CA so it can decrypt outbound TLS from the app servers, inspect, and re-encrypt.

> &#8505; SCM-managed Cloud NGFW supports this. You store the CA in AWS Secrets Manager and reference it from SCM as a **Cloud Certificate** (`Cloud Platform = Amazon Web Services`, `Cloud Secret Name = <secret>`, `Algorithm = RSA`). A decryption rule of type SSL Forward Proxy then uses it. (An older note in the Administration guide says cloud certificates are not supported under SCM management; that note is out of date.)

### 10.1 Generate a CA and store it in Secrets Manager

- From Cloud Shell, generate a CA key and certificate. The CA basic-constraint must be true (a CA cert), which `-x509` with the default extensions provides.

```
openssl genrsa -out cngfwCA-key.pem 2048
openssl req -x509 -sha256 -new -nodes -key cngfwCA-key.pem -days 3650 -out cngfwCA-cert.pem -subj "/CN=cloudngfw-lab-ca"
```

- Store the key+cert in a secret named `aws-outbound-trust`, in the format Cloud NGFW expects (keys `private-key` and `public-key`), tagged so the Cloud NGFW Decryption role can read it. Also store the public cert in a second secret for the clients to trust.

```
aws secretsmanager create-secret --name aws-outbound-trust \
  --secret-string "{\"private-key\":\"$(awk 'BEGIN{ORS="\\n"}1' cngfwCA-key.pem)\",\"public-key\":\"$(awk 'BEGIN{ORS="\\n"}1' cngfwCA-cert.pem)\"}" \
  --tags Key=PaloAltoCloudNGFW,Value=true

aws secretsmanager create-secret --name cngfw-public-key \
  --secret-string file://cngfwCA-cert.pem
```

> &#8505; The secret name `aws-outbound-trust` matches the `ca_secret_name` the Terraform granted the app instance role permission to read, and the `Cloud Secret Name` you enter on the Cloud Certificate in the next step. The `PaloAltoCloudNGFW=true` tag is what lets the Cloud NGFW Decryption role retrieve it.

### 10.2 Create the Cloud Certificate and a decryption rule in SCM

- Create the Cloud Certificate: Manage -> Configuration -> NGFW and Prisma Access -> Configuration Scope = your folder -> Objects -> Certificate Management -> Cloud Certificates -> Add:
  - `Certificate Name`: e.g. `aws-cert`
  - `Cloud Platform`: `Amazon Web Services`
  - `Cloud Secret Name`: `aws-outbound-trust`
  - `Algorithm`: `RSA`
- Add a decryption rule: Security Services -> Decryption -> Add Rule, type **SSL Forward Proxy**, action Decrypt, scoped to your folder, using a decryption profile (the built-in `web-security-default` profile is a fine starting point) and your Cloud Certificate as the forward-trust certificate. Source = your app subnets, zones `any`.
- Push the configuration.

<!-- screenshots (clean versions to be added): Add New Cloud Certificate; Cloud Certificates list; decryption rule -->

### 10.3 Trust the CA on the app servers

The app servers are the TLS clients, so they must trust the forward-proxy CA.

- Connect to each app server with Session Manager and install the CA from Secrets Manager.

```
aws secretsmanager get-secret-value --secret-id cngfw-public-key --query SecretString --region us-east-1 --output text \
  | sudo tee /etc/pki/ca-trust/source/anchors/cloudngfw_ca.pem >/dev/null
sudo update-ca-trust
```

> &#8505; Challenge: use AWS Systems Manager Run Command to push the CA to both app servers at once instead of doing it one at a time.

### 10.4 Validate

- From an app server, `curl -v https://ifconfig.me`. In the certificate chain you should now see your `cloudngfw-lab-ca` issuer, which proves Cloud NGFW is decrypting and re-signing.
- In the Cloud NGFW logs (SCM Log Viewer), confirm you now see decrypted application and URL detail that was not visible before.

## 11. Step 8 - Inbound via ALB TLS termination (later)

> &#8505; PLANNED, to be built after the outbound flow is validated. The inbound scenario terminates TLS at an Application Load Balancer placed in front of the Cloud NGFW endpoint, so Cloud NGFW inspects the already-decrypted payload without doing decryption itself. This is a different teaching point from inbound SSL decryption and pairs with an `enable_inbound` Terraform toggle (to be added).

## 12. Cleanup

- `terraform destroy` the lab VPC.
- In SCM, delete the Cloud NGFW endpoints and the firewall resource.
- Delete the Secrets Manager secrets.
- Your QwikLabs account is recycled at the end, which also removes the onboarding roles.

## References

- *Cloud NGFW for AWS - Getting Started* (SCM onboarding, tenant V2, deployment profile activation)
- *Cloud NGFW for AWS - Administration* (SCM policy management, certificates, decryption, logging)
- *Cloud NGFW for AWS - Deployment* (distributed / isolated architecture)
