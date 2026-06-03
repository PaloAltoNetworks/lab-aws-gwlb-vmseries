# Cloud NGFW for AWS + Strata Cloud Manager — Lab Addendum (Part 2)

> &#8505; This is an addendum to the VM-Series on AWS Gateway Load Balancer lab ([README.md](README.md)). Complete that lab first. You need its deployed Security VPC, Transit Gateway, and the two App Spoke VPCs (`spoke1-app-vpc`, `spoke2-app-vpc`), with inbound traffic working through the VM-Series, before you start here.

```
Manual Last Updated: 2026-06-03
```

## Lab Guide Syntax conventions

- Items with a bullet indicate actions to take to complete the lab.
- Code blocks follow an action for copy / paste or reference.

> &#8505;  Items with the info icon are additional context or details around the actions.

> &#10067; Items with the question mark icon are good check-your-understanding questions.

## 1. Overview

In Part 1 you deployed one firewall engine, VM-Series behind a Gateway Load Balancer (GWLB), and used it for every traffic flow. In this part you introduce a second engine: Palo Alto Cloud NGFW for AWS, a Palo Alto-operated managed firewall service. You will use it to inspect inbound traffic to your application spokes, manage its policy from Strata Cloud Manager (SCM), and migrate the inbound inspection path off the VM-Series and onto Cloud NGFW. Outbound and east/west traffic keep flowing through the VM-Series.

> &#8505; Why two engines? VM-Series is software you run and patch: EC2 instances, GWLB, capacity planning. Cloud NGFW is a SaaS firewall with no instances to manage. You consume it as a set of Gateway Load Balancer endpoints and pay per usage. Real environments often mix them: VM-Series where you need full PAN-OS feature depth and control, Cloud NGFW where you want an elastic inspection point close to a workload. This lab lets you operate both in the same topology.

It helps to think about firewall insertion as three independent choices, which you can make differently for each traffic flow:

| Choice | Part 1 (VM-Series) | This addendum (Cloud NGFW) |
| --- | --- | --- |
| 1. Firewall resource | A single VM-Series (GWLB) handling all flows | A separate engine, Cloud NGFW, handling inbound |
| 2. Endpoint placement | Centralized (Security VPC) for OB/EW; distributed for inbound | Distributed: an endpoint in each app spoke VPC |
| 3. Management plane | Panorama | Strata Cloud Manager (SCM) |

> &#8505; After this lab, your environment uses distributed Cloud NGFW endpoints for inbound and the existing centralized VM-Series for outbound/east-west: a hybrid design.

> &#10067; For a given application, what are the trade-offs of inspecting *inbound* traffic with a firewall in the app's own VPC (distributed) versus hair-pinning it to a central security VPC (centralized)?

## 2. Architecture — before & after

Before (end of Part 1), inbound through VM-Series:

```
Internet ─▶ Spoke IGW ─▶ [igw-edge route] ─▶ VM-Series inbound GWLB endpoint ─▶ VM-Series (Security VPC) ─▶ App ALB/NLB ─▶ web instances
```

After (this addendum), inbound through Cloud NGFW:

```
Internet ─▶ Spoke IGW ─▶ [igw-edge route] ─▶ Cloud NGFW endpoint (in spoke) ─▶ Cloud NGFW (managed service) ─▶ App ALB/NLB ─▶ web instances

Outbound + East/West: UNCHANGED ── spoke web subnets ─▶ TGW ─▶ VM-Series (Security VPC)
```

> &#8505; This is the Distributed Inbound model from the *Cloud NGFW for AWS Deployment Guide*: `Internet → IGW → NGFW endpoint → NGFW → ALB → app`. Both VM-Series GWLB and Cloud NGFW use the same underlying AWS primitive, a Gateway Load Balancer endpoint, so the migration is mostly a matter of pointing the spoke ingress routes at a different endpoint. The Cloud NGFW endpoints live in the same spoke `gwlbe` subnets you already created (which already route to the IGW), so no new subnets are needed.

## 3. Provisioning & management model used here

There are several ways to provision and manage Cloud NGFW for AWS. This lab uses the newest, simplest combination:

- Provisioning: SCM-initiated. You create the firewall from inside the SCM console. SCM automatically creates and hides the underlying Cloud NGFW tenant, links it to SCM, and starts a 30-day free trial. No AWS Marketplace subscription and no cross-account IAM onboarding are required to start.
- Management: SCM-native policy. You author security rules in SCM (folders + security rules), not in Cloud NGFW "rulestacks."

> &#8505; The other provisioning paths (AWS-Marketplace-initiated, AWS Firewall Manager) and the billing models (free trial, Marketplace PAYG, Cloud NGFW credits) are covered in the companion deck *"Cloud NGFW for AWS — Provisioning & Billing."* Ask your instructor for it.

## 4. Prerequisites

- Completed Part 1, with inbound traffic to the spokes working through the VM-Series.
- AWS access to the same account and region as Part 1. Your App Spokes are in `us-east-1`. Use the same SSO/CLI profile you used in Part 1.
- Strata Cloud Manager access, one of:
  - Workshop: your instructor provides a CSP account and an SCM tenant (TSG) to use. Skip the BYO activation.
  - Bring-your-own: provision a new SCM tenant (TSG) under your CSP and activate Strata Cloud Manager Essentials. There is an activation link in the *Cloud NGFW for AWS — Getting Started* guide; it is not automatic. Use the same CSP for SCM and for the Cloud NGFW you create.
  - An SCM role with write access: Superuser or Network Administrator.

> &#8505; Tenant version matters. Any SCM/Cloud NGFW tenant created after ~July 2025 is a "V2" tenant and supports the SCM-initiated flow used here (a brand-new TSG is V2). On V2 you allowlist AWS accounts for endpoints rather than fully onboarding them up front.

> &#8505; Free-trial sizing: the Cloud NGFW free trial covers up to 2 firewalls / 100 GB / 30 days, per tenant. Because each participant uses their own TSG, one Cloud NGFW per person fits comfortably. No Marketplace subscription or credits are needed for the core lab.

## 5. Step 1 — Access SCM

- Log in to Strata Cloud Manager for your assigned (or newly created) tenant.
- (BYO only) If this is a fresh tenant, activate SCM Essentials using the link in the Getting Started guide.

> &#8505; The first Cloud NGFW resource you create automatically upgrades the tenant to SCM Pro features for Cloud NGFW. This can take ~45–50 minutes the first time. It runs in the background, so start the next step and continue; you do not need to wait for it.

## 6. Step 2 — Deploy a Cloud NGFW resource from SCM

> &#8505; In the SCM-initiated model you never open a separate Cloud NGFW console and never create a Cloud NGFW "tenant" by hand. SCM provisions and manages it for you. An SCM-managed firewall cannot be administered from the standalone Cloud NGFW console.

- In SCM, go to Configurations -> Cloud NGFWs -> Get Started -> Create Cloud NGFW.
- Step 1 of the wizard, Select Cloud Provider: choose `Amazon Web Services`, then Next.

> &#8505; The first time, you will see a green banner: *"The environment setup has completed successfully."* That one-time step initializes the AWS environment for your tenant.

- Step 2 of the wizard, Create & Deploy Firewall. Fill in General Info:
  - `Firewall Name`: use a name with your prefix (e.g. `ad-cloudngfw-lab`) so it doesn't collide with other participants if you share a tenant.
  - `Region`: `us-east-1`. This must be the region where your Part 1 compute lives (the App Spoke VPCs and their workloads).
  - `Availability Zone IDs`: select the AZ IDs that correspond to the AZs your spoke subnets are in. For the Part 1 build that is `us-east-1a` and `us-east-1c`, but you must select them by AZ ID, which you have to look up (see the box below). In this lab account those IDs are `use1-az6` (us-east-1a) and `use1-az2` (us-east-1c).
- Under Endpoint Management -> `Allowlisted AWS Accounts`, enter your AWS Account ID (the account where the spokes live). This allowlists the account so you can create Cloud NGFW endpoints in it in Step 4.
- Click Create and Deploy. The firewall shows `CREATING` for several minutes, then registers automatically as a device in SCM. On the first firewall, SCM also creates the hidden Cloud NGFW tenant and starts your 30-day trial.

---

> &#8505; Availability Zone IDs vs Availability Zone names, and why GWLB cares.
>
> An AZ name like `us-east-1a` is not a fixed physical location. It is a per-account alias. AWS randomly maps each account's AZ names to the underlying physical datacenters to spread load. So `us-east-1a` in your account may be a different physical AZ than `us-east-1a` in someone else's account.
>
> An AZ ID like `use1-az2` is the stable, physical identifier. `use1-az2` is the same datacenter for every AWS account. Services that span accounts use AZ IDs to talk about the same physical AZ unambiguously.
>
> Cloud NGFW is a managed service running in Palo Alto's own AWS account. For it to place its firewall and Gateway Load Balancer endpoints in the same physical AZ as your workloads, it asks you for AZ IDs, not names. Your account's private name aliases would be meaningless to it.
>
> This matters for any GWLB-based design (VM-Series GWLB and Cloud NGFW). A Gateway Load Balancer endpoint is AZ-bound, and traffic should be inspected by an endpoint in the same AZ as the source/destination subnet. Mismatched AZs mean cross-AZ hairpinning, which adds latency and inter-AZ data-transfer charges; if the AZ has no endpoint, traffic black-holes. So you must deploy Cloud NGFW into the same physical AZs (by ID) as the spoke subnets that will hold its endpoints.
>
> Find your AZ IDs. The name-to-ID mapping is specific to your account, so look it up. Never assume `us-east-1a == use1-az1`:
> ```
> aws ec2 describe-availability-zones --region us-east-1 \
>   --query 'AvailabilityZones[].{Name:ZoneName,Id:ZoneId}' --output table
> ```
> To see exactly which AZ ID each of your spoke endpoint subnets lives in:
> ```
> aws ec2 describe-subnets --region us-east-1 \
>   --filters "Name=tag:Name,Values=*spoke*-vpc-gwlbe*" \
>   --query 'Subnets[].{Name:Tags[?Key==`Name`]|[0].Value,AZ:AvailabilityZone,AZ_ID:AvailabilityZoneId}' --output table
> ```
> (In the AWS console, the VPC -> Subnets list also shows an "Availability Zone ID" column.)

> &#10067; In this lab account, `us-east-1a` maps to `use1-az6` and `us-east-1c` maps to `use1-az2`, not `use1-az1`/`use1-az3`. Why would picking AZ IDs by guessing the "a/b/c -> az1/az2/az3" order break your endpoints?

> &#10067; What happens to inbound traffic for a spoke subnet in an AZ where you did not create a Cloud NGFW endpoint?

## 7. Step 3 — Onboard the AWS account for logging & decryption

Allowlisting (Step 2) is enough to create endpoints. To let Cloud NGFW write logs and later decrypt, the account also needs a set of cross-account IAM roles.

- In SCM: Cloud NGFW -> Onboard AWS Account -> enter your AWS Account ID -> Download/Launch the CloudFormation template -> deploy it. The stack creates four cross-account roles (Logging, Endpoint, Network Monitoring, Decryption). Then copy the four Role ARNs back into SCM -> Onboard.

> &#9888; Workshop / shared-account note. These onboarding roles are account-global IAM roles. On a shared AWS account they are normally pre-provisioned once by the instructor so everyone reuses them. Do not run the onboarding CFT yourself unless told to. You can collide with the existing `cloudngfw-cross-account-roles-*` roles. The allowlisting in Step 2 is per-firewall and is still yours to do. Confirm with your instructor whether account onboarding is already complete.

> &#8505; The billing account (what pays: Marketplace subscription or credits, not needed during the trial) is a separate concept from the onboarded/allowlisted accounts (the workload accounts the firewall is allowed to operate in). One billing account can cover many onboarded accounts.

## 8. Step 4 — Create Cloud NGFW endpoints in your App Spoke VPCs

Now place the actual Gateway Load Balancer endpoints, one per AZ in each spoke, in the existing `gwlbe` subnets (which already route to the IGW).

- Open your firewall in SCM -> Endpoint Management.
- Create service-managed endpoints. This is recommended, since Cloud NGFW creates and owns the VPC endpoint for you. For each, select:
  - VPC: `spoke1-app-vpc`, then repeat for `spoke2-app-vpc`
  - Subnet: `spoke1-vpc-gwlbe1` (AZ `us-east-1a` / `use1-az6`), then `spoke1-vpc-gwlbe2` (AZ `us-east-1c` / `use1-az2`)
  - (Names carry your Part 1 `prefix_name_tag`, e.g. `ad-spoke1-vpc-gwlbe1`.)
- Record the resulting endpoint (`vpce-…`) IDs for each spoke and AZ. You need them to fix routing in Step 5.

> &#8505; One endpoint per subnet: you cannot put two Cloud NGFW endpoints in the same subnet. You have one `gwlbe` subnet per AZ per spoke, which is what you want: one endpoint per AZ. The AZ IDs you chose in Step 2 must include the AZ IDs of these subnets, or the endpoint cannot be created there.

> &#9888; Service-managed vs customer-managed: customer-managed endpoints (ones you create yourself in the AWS VPC console) cannot be deleted afterward. Prefer service-managed for the lab so cleanup is simple.

## 9. Step 5 — Migrate inbound traffic to Cloud NGFW

Re-point the spoke inbound routes from the VM-Series GWLB endpoints (Part 1) to the new Cloud NGFW endpoints. You'll do it in the AWS console, the same way you built the inbound routing in Part 1 §4.16. This keeps your Part 1 Terraform state undisturbed and lets you watch the inspection path move from one engine to the other.

> &#8505; Filter the VPC Dashboard by your spoke VPC. All route-table names carry your `prefix_name_tag`. You are only changing targets on existing routes, swapping the VM-Series endpoint for the matching Cloud NGFW endpoint in the same AZ.

Spoke1 (`spoke1-app-vpc`, 10.200.0.0/23):

- Route table `spoke1-vpc-igw-edge`:
  - `10.200.0.16/28` -> Cloud NGFW endpoint in AZ `us-east-1a` (`use1-az6`) (was the VM-Series `spoke1-inbound1` endpoint)
  - `10.200.1.16/28` -> Cloud NGFW endpoint in AZ `us-east-1c` (`use1-az2`)
- Route table `spoke1-vpc-alb1`: `0.0.0.0/0` -> Cloud NGFW endpoint AZ `us-east-1a`
- Route table `spoke1-vpc-alb2`: `0.0.0.0/0` -> Cloud NGFW endpoint AZ `us-east-1c`
- Route tables `spoke1-vpc-gwlbe1/2`: leave unchanged (`0.0.0.0/0` -> IGW, since the Cloud NGFW endpoint lives here and needs the IGW path).

Spoke2 (`spoke2-app-vpc`, 10.250.0.0/23): repeat with `10.250.0.16/28` / `10.250.1.16/28` and the spoke2 Cloud NGFW endpoints (matched by AZ).

Do not touch the `web1`/`web2` route tables or any Security-VPC / Transit Gateway routing. Outbound and east/west stay on the VM-Series.

> &#9888; Match endpoints to AZs carefully. The AZ-1 route must point at the AZ-1 (`use1-az6`) endpoint and the AZ-2 route at the AZ-2 (`use1-az2`) endpoint. Crossing them sends traffic across AZs and can break the return path.

> &#9888; After re-pointing, inbound is now sent to Cloud NGFW, which denies by default. Your apps will be unreachable until you add an allow rule in Step 6. That is expected.

> &#10067; At this exact moment (routes flipped, no policy yet), which traffic is still being inspected by VM-Series, and which by Cloud NGFW?

## 10. Step 6 — Author SCM policy & test inbound

Cloud NGFW policy in the SCM-managed model lives in SCM-native security rules, organized in a folder, not in Cloud NGFW rulestacks.

- Create a folder: SCM -> Workflows -> NGFW Setup -> Folder Management -> Add Folder (e.g. `ad-cloudngfw-lab`).
- Place your firewall in the folder: Workflows -> NGFW Setup -> Device Management -> Cloud NGFWs, and move your firewall into the folder.
- Author the rule: Manage -> Configuration -> NGFW and Prisma Access -> Configuration Scope = your folder -> Security Services -> Security Policy -> Add Rule:
  - `Source Zone`: `any` (required, see warning)
  - `Source Address`: `any` (or your client's public IP)
  - `Destination Zone`: `any` (required)
  - `Destination Address`: your app subnets (`10.200.0.16/28`, `10.200.1.16/28`, `10.250.0.16/28`, `10.250.1.16/28`)
  - `Application`: `web-browsing`, `ssl`
  - `Action`: `Allow`, Log at session end
- Push the configuration.

> &#9888; Zone gotcha: SCM-managed Cloud NGFW rules must use `any` for source and destination zone. If you set a real zone, traffic is silently dropped with no obvious error.

Test:

- From your browser, hit the spoke application load-balancer FQDNs (the `app_nlbs_dns` outputs from Part 1).
- You should get a response, now inspected by Cloud NGFW instead of the VM-Series.
- View logs: SCM -> Configurations -> Cloud NGFWs -> your firewall -> View Logs (opens the Log Viewer, filtered to your firewall).

> &#10067; Compare the inbound session logs here with the VM-Series traffic logs in Panorama from Part 1. What is the same, and what is different about how each engine is managed and logged?

## 11. Step 7 — Decryption & advanced features (later)

Once the basic inbound flow works, layer on advanced controls in SCM: threat prevention / URL filtering / WildFire profiles attached to your rule, and decryption policy + profile.

> &#9888; Under SCM-managed Cloud NGFW, some capabilities differ from native rulestacks at the time of writing. For example, Cloud certificate, DLP, and tag-based (DAG) policy are not supported via SCM management. Verify current support in the *Cloud NGFW for AWS — Administration* guide before building the decryption exercise; certificate handling for decryption may require the native/rulestack path.

*(Detailed decryption steps will be added once the basic-flow lab is validated end-to-end.)*

## 12. Cleanup

- Re-point the spoke inbound routes back to the VM-Series endpoints (reverse of Step 5), or plan to `terraform destroy` the Part 1 stack afterward.
- In SCM, delete the Cloud NGFW endpoints (disassociate the subnets) and the firewall resource. (Service-managed endpoints can be removed this way; customer-managed endpoints cannot be deleted.)

> &#9888; If you ever associate Marketplace PAYG billing and then unsubscribe with no credits, the platform deletes your Cloud NGFW resources. During the free trial this is not a concern.

## References

- *Cloud NGFW for AWS — Getting Started* (SCM-initiated onboarding, tenant V2, free trial, AZ IDs)
- *Cloud NGFW for AWS — Administration* (SCM policy management, account onboarding, endpoints, logging)
- *Cloud NGFW for AWS — Deployment* (Distributed Inbound architecture)
- AWS — *Availability Zone IDs for your resources* (AZ name vs AZ ID)

> &#8505; SCM console navigation evolves. If a menu path differs from what you see, consult the current *Administration* guide. This addendum was written and screenshot-verified against the console as of the date above.
