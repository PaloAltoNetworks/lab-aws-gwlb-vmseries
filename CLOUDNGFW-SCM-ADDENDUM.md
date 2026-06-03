# Cloud NGFW for AWS + Strata Cloud Manager — Lab Addendum (Part 2)

> &#8505; This is an **addendum** to the VM-Series on AWS Gateway Load Balancer lab ([README.md](README.md)). Complete that lab first — you need its deployed Security VPC, Transit Gateway, and the two App Spoke VPCs (`spoke1-app-vpc`, `spoke2-app-vpc`) with working **inbound** traffic through the VM-Series before starting here.

```
Manual Last Updated: 2026-06-03
```

## 1. Overview

In Part 1 you deployed **one** firewall engine — VM-Series behind a Gateway Load Balancer — and used it for **all** traffic flows. Inbound to the app spokes used **distributed** GWLB endpoints (one in each spoke VPC); outbound and east/west used **centralized** GWLB endpoints in the Security VPC, reached over the Transit Gateway.

In this part you add a **second, different firewall engine — Palo Alto Cloud NGFW for AWS** — and use it to inspect **inbound** traffic to the app spokes, managed by **Strata Cloud Manager (SCM)**. Outbound and east/west stay on the VM-Series. You will **migrate** the inbound inspection path from the VM-Series endpoints to new Cloud NGFW endpoints.

This teaches two independent design axes you can mix **per traffic flow**:

| Axis | Part 1 (VM-Series) | This addendum |
| --- | --- | --- |
| **Firewall resource** | Single VM-Series (GWLB) | A *second* engine: Cloud NGFW (AWS-native managed) |
| **Endpoint placement** | Centralized (OB/EW) + distributed inbound | Distributed inbound, in the spoke VPCs |
| **Management plane** | Panorama | **Strata Cloud Manager (SCM)** |
| **Provisioning** | Terraform | **SCM-initiated** (deploy from the SCM console) |

> &#10067; Why might you run two different firewall engines in the same environment, split by traffic direction?

## 2. Architecture — before & after

**Before (end of Part 1) — inbound through VM-Series:**

```
Internet ─▶ Spoke IGW ─▶ [igw-edge route] ─▶ VM-Series inbound GWLB endpoint ─▶ VM-Series (Security VPC) ─▶ App ALB/NLB ─▶ web instances
```

**After (this addendum) — inbound through Cloud NGFW:**

```
Internet ─▶ Spoke IGW ─▶ [igw-edge route] ─▶ Cloud NGFW endpoint (in spoke) ─▶ Cloud NGFW (managed) ─▶ App ALB/NLB ─▶ web instances

Outbound + East/West: UNCHANGED  ── spoke web subnets ─▶ TGW ─▶ VM-Series (Security VPC)
```

You are re-pointing only the **inbound** path. The Cloud NGFW endpoints live in the same spoke `gwlbe` subnets (which already route to the IGW), so the migration is a small set of route-table edits.

> &#8505; This is the **Distributed Inbound** model from the Cloud NGFW for AWS *Deployment Guide*: `Internet → IGW → NGFW endpoint → NGFW → ALB → app`.

## 3. Prerequisites

- **Completed Part 1**, with inbound traffic to the spokes working through the VM-Series.
- **AWS access** to the same account/region as Part 1 (App Spokes are in **us-east-1**). Your SSO/CLI profile from Part 1.
- **Strata Cloud Manager access** — one of:
  - **Workshop:** your instructor provides a **CSP account and SCM tenant (TSG)** to use. *(Skip the BYO activation below.)*
  - **Bring-your-own:** provision a **new SCM tenant (TSG)** under your CSP and **activate Strata Cloud Manager Essentials** (there is an activation link in the *Cloud NGFW for AWS — Getting Started* guide; it is **not** automatic). Use the **same CSP** for SCM and for the Cloud NGFW you will create.
  - SCM role with write access: **Superuser** or **Network Administrator**.

> &#8505; **Tenant version:** any SCM/Cloud NGFW tenant created after ~July 2025 is a **"V2"** tenant and supports the simplified, SCM-initiated flow used here. A brand-new TSG is V2.

> &#8505; **Free trial sizing:** the Cloud NGFW free trial covers **up to 2 firewalls / 100 GB / 30 days** *per tenant*. Because each participant uses their own TSG, one Cloud NGFW per person fits comfortably. No Marketplace subscription or credits are required to complete the core flows.

## 4. Step 1 — Access SCM & enable the environment

- Log in to **Strata Cloud Manager** for your assigned/created tenant.
- (BYO only) If this is a fresh tenant, **activate SCM Essentials** per the Getting Started guide link.

> &#8505; The **first** Cloud NGFW resource you create automatically enables **SCM Pro features** for Cloud NGFW (this can take ~45–50 minutes the first time). You can continue with the next steps while it finishes.

## 5. Step 2 — Deploy a Cloud NGFW resource from SCM (SCM-initiated)

> &#8505; In the **SCM-initiated** model you never touch the Cloud NGFW console or create a Cloud NGFW "tenant" yourself — SCM **auto-creates and manages** it and starts your free trial on first deploy.

- In SCM: **Configurations → Cloud NGFWs → Get Started → Create Cloud NGFW**.
- Select **Amazon Web Services**.
- Enter:
  - **Name:** a unique name with **your prefix** (e.g. `ad-cngfw-inbound`) so it doesn't collide with other participants in a shared tenant.
  - **Region:** **us-east-1** (must match your App Spoke VPCs from Part 1).
  - **Availability Zones:** the AZs your spokes use (Part 1 uses AZ **a** and **c** → `use1-az*` IDs).
- **Create and Deploy.**

> &#8505; On the first firewall, the platform creates a hidden Cloud NGFW tenant, links it to SCM, and starts the **30-day free trial**. The resource will show **CREATING** for several minutes, then register automatically as a device in SCM.

> &#10067; Where did the Cloud NGFW "tenant" come from, and why don't you log into a separate Cloud NGFW console in this model?

## 6. Step 3 — Onboard the AWS account & permissions (endpoints, logging, decryption)

Cloud NGFW needs permission in your AWS account to create endpoints, write logs, and (later) decrypt.

- **Allowlist your AWS account for endpoints:** in the firewall's **Endpoint Management** page → **Manage Allowlist AWS Accounts** → add your AWS account ID. *(On V2 tenants, allowlisting — not full onboarding — is enough to create endpoints.)*
- **Onboard the account for logging/decryption (cross-account roles):** SCM → **Cloud NGFW → Onboard AWS Account** → enter your **AWS Account ID** → **Download/Launch the CloudFormation template** → deploy it. The stack creates four cross-account roles (**Logging**, **Endpoint**, **Network Monitoring**, **Decryption**). Copy the four **Role ARNs** back into SCM → **Onboard**.

> &#9888; **Workshop / shared-account note:** the cross-account onboarding roles are **account-global IAM roles**. On a shared AWS account they are typically **pre-provisioned once by the instructor** (so everyone reuses them) — **do not** run the onboarding CFT yourself unless told to, or you may collide with existing `cloudngfw-cross-account-roles-*` roles. Confirm with your instructor whether onboarding is already done. (Allowlisting for endpoints in Step 6 is per-firewall and is still yours to do.)

## 7. Step 4 — Create Cloud NGFW endpoints in your App Spoke VPCs

Create one Cloud NGFW endpoint per AZ in each spoke, in the existing `gwlbe` subnets (they already route to the IGW).

- In the firewall's **Endpoint Management**, use **service-managed** endpoints (recommended): set service-managed = **Yes**, then for each endpoint select:
  - **VPC:** `spoke1-app-vpc` (then repeat for `spoke2-app-vpc`)
  - **Subnet:** `spoke1-vpc-gwlbe1` (AZ a), then `spoke1-vpc-gwlbe2` (AZ c)
  - *(Names carry your Part 1 `prefix_name_tag`, e.g. `ad-spoke1-vpc-gwlbe1`.)*
- *(Alternative — customer-managed: AWS **VPC → Endpoints → Create endpoint → Find service by name** using the Cloud NGFW endpoint service name, select the spoke VPC + `gwlbe` subnet, Create.)*

> &#8505; One endpoint per subnet — you need a separate subnet per endpoint. You have `gwlbe1`/`gwlbe2` per spoke (one per AZ), so you get one Cloud NGFW endpoint per AZ.

- **Record the new endpoint (`vpce-…`) IDs** for each spoke/AZ — you need them in the next step.

> &#9888; Customer-managed endpoints **cannot be deleted** once created — prefer service-managed for the lab.

## 8. Step 5 — Migrate inbound traffic to Cloud NGFW (console)

You will re-point the spoke **inbound** routes from the VM-Series GWLB endpoints (Part 1) to the new Cloud NGFW endpoints. We do this **in the console** (as in Part 1 §4.16) so it doesn't disturb your Part 1 Terraform state — and so you can *see* the inspection path move from one engine to the other.

> &#8505; Filter the VPC Dashboard by your spoke VPC. All route-table names below carry your `prefix_name_tag`.

**Spoke1 (`spoke1-app-vpc`, 10.200.0.0/23):**

- Route table `spoke1-vpc-igw-edge`:
  - `10.200.0.16/28` → **change target** to the Cloud NGFW endpoint in **AZ a** (was the VM-Series `spoke1-inbound1` GWLBE)
  - `10.200.1.16/28` → Cloud NGFW endpoint in **AZ c**
- Route table `spoke1-vpc-alb1`: `0.0.0.0/0` → Cloud NGFW endpoint **AZ a**
- Route table `spoke1-vpc-alb2`: `0.0.0.0/0` → Cloud NGFW endpoint **AZ c**
- Route tables `spoke1-vpc-gwlbe1/2`: **leave as-is** (`0.0.0.0/0` → IGW).

**Spoke2 (`spoke2-app-vpc`, 10.250.0.0/23):** repeat with `10.250.0.16/28` / `10.250.1.16/28` and the spoke2 Cloud NGFW endpoints.

**Do not touch** the `web1`/`web2` route tables or the Security/TGW routing — outbound and east/west stay on the VM-Series.

> &#9888; After re-pointing, inbound traffic is now sent to Cloud NGFW, which **denies by default** — your apps will be unreachable until you add an allow policy in the next step. That's expected.

> &#10067; What is still being inspected by VM-Series at this point, and what moved to Cloud NGFW?

## 9. Step 6 — Author SCM policy & test inbound

Cloud NGFW policy in the SCM-managed model is authored in **SCM-native** security rules (in a **folder**), not rulestacks.

- **Create a folder:** SCM → **Workflows → NGFW Setup → Folder Management → Add Folder** (e.g. `ad-cngfw-lab`).
- **Place your firewall in the folder:** **Workflows → NGFW Setup → Device Management → Cloud NGFWs**, move your firewall into the folder.
- **Author the rule:** **Manage → Configuration → NGFW and Prisma Access → Configuration Scope =** your folder → **Security Services → Security Policy → Add Rule**:
  - **Source Zone:** `any` &nbsp; **(required)**
  - **Source Address:** `any` (or your client public IP)
  - **Destination Zone:** `any` &nbsp; **(required)**
  - **Destination Address:** your app subnets (`10.200.0.16/28`, `10.200.1.16/28`, `10.250.0.16/28`, `10.250.1.16/28`)
  - **Application:** `web-browsing`, `ssl`
  - **Action:** `Allow`, **Log** at session end
- **Push** the configuration.

> &#9888; **Zone gotcha:** SCM-managed Cloud NGFW rules **must use `any` for source/destination zone**. If you set a real zone, traffic is **silently dropped**.

**Test:**
- From your browser, hit the spoke app load-balancer FQDNs (the `app_nlbs_dns` outputs from Part 1).
- You should get a response — now inspected by **Cloud NGFW**.
- **View logs:** SCM → **Configurations → Cloud NGFWs →** your firewall → **View Logs** (opens the **Log Viewer**, filtered to your firewall).

> &#10067; Compare the inbound logs here to the VM-Series traffic logs in Panorama from Part 1. What's the same, what's different?

## 10. Step 7 — Decryption & advanced features (later)

Once basic inbound flows work, layer on advanced controls in SCM:

- **Threat prevention / URL filtering / WildFire** profiles attached to your security rule.
- **Decryption** policy + profile for inbound/forward-proxy inspection.

> &#9888; Under SCM-managed Cloud NGFW, some features differ from native rulestacks at time of writing — e.g. **Cloud certificate, DLP, and tag-based (DAG) policy are not supported** via SCM management. Verify current support in the *Cloud NGFW for AWS — Administration* guide before building the decryption exercise; certificate handling for decryption may require the native/rulestack path.

*(Detailed decryption steps to be added once the basic-flow lab is validated.)*

## 11. Cleanup

- Re-point the spoke inbound routes back to the VM-Series endpoints (reverse of Step 5) **or** plan to `terraform destroy` Part 1 afterward.
- Delete the Cloud NGFW **endpoints** and **resource** in SCM. *(Service-managed endpoints can be removed by disassociating the subnet; customer-managed endpoints cannot be deleted.)*

> &#9888; If you ever associate Marketplace PAYG billing and then **unsubscribe with no credits**, the platform **deletes your Cloud NGFW resources**. During the free trial this isn't a concern.

## Appendix — provisioning, integration & billing models

There are several ways to provision and manage Cloud NGFW for AWS (SCM-initiated, AWS-Marketplace-initiated, AWS Firewall Manager) and several billing models (free trial, Marketplace PAYG, credits). See the companion slide deck **“Cloud NGFW for AWS — Provisioning & Billing”** for the full picture. This lab uses **SCM-initiated provisioning + free-trial billing + SCM-native policy**.

## References

- *Cloud NGFW for AWS — Getting Started* (SCM-initiated onboarding, tenant V2, free trial)
- *Cloud NGFW for AWS — Administration* (SCM policy management, account onboarding, endpoints, logging)
- *Cloud NGFW for AWS — Deployment* (Distributed Inbound architecture)

> &#8505; SCM console navigation evolves — if a menu path differs, consult the current *Administration* guide. This addendum was written against the docs current as of the date above.
