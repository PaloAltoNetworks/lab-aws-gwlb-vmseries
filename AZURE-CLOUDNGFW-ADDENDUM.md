# 1. Cloud NGFW for Azure — managed by your AWS Panorama (Part 3)

----------
This is an **addendum** to the [VM-Series on AWS Gateway Load Balancer lab](README.md). Complete **Part 1** first — you need the **Panorama** you built there, up and reachable on its public IP. This part is **independent of Part 2** (the SCM addendum): here Panorama is the management plane, not SCM.

***This lab guide is for a guided workshop / learning environment. Do not use it as-is for production.***

----------

```
Manual Last Updated: 2026-06-25
```

# 2. Overview

In Part 1 you ran one firewall engine — **VM-Series** in **AWS**, managed by **Panorama**. In this part you extend that *same* Panorama **across clouds**: you deploy **Cloud NGFW for Azure** (a Palo Alto-operated, Azure-native managed firewall) with Terraform, and point it back at your existing AWS Panorama for policy. One management plane, two clouds, two firewall form factors.

> &#8505; **Why this matters.** Cloud NGFW is a *SaaS* firewall: there are no VMs to patch or scale — Azure and Palo Alto operate the dataplane. You declare it in Terraform, attach it to an Azure **Virtual WAN** hub, and manage its policy from Panorama exactly like any other managed device. The interesting outcome is operational: your AWS Panorama ends up managing both **VM-Series in AWS** *and* **Cloud NGFW in Azure**.

Three independent choices, made differently than Part 1:

| Choice | Part 1 (AWS) | This addendum (Azure) |
| --- | --- | --- |
| 1. Firewall engine | VM-Series on GWLB (software you run) | Cloud NGFW for Azure (managed SaaS) |
| 2. Insertion / topology | GWLB endpoints, hub-and-spoke via TGW | Centralized **Virtual WAN** hub with routing intent |
| 3. Management plane | Panorama | **The same Panorama** (cross-cloud) |

## 2.1. Lab Guide Syntax conventions

- Items with a bullet indicate actions that need to be taken to complete the lab. They are sometimes followed by a code block for copy / paste or reference.

> &#8505; Items with the info icon are additional context or details around the actions performed in the lab.

> &#10067; Items with the question mark icon are questions to check your understanding — good ones to be able to answer by the end.

> &#9888; Items with the warning icon are gotchas that will cost you time if you miss them.

## 2.2. Table of Contents

- [1. Cloud NGFW for Azure — managed by your AWS Panorama (Part 3)](#1-cloud-ngfw-for-azure--managed-by-your-aws-panorama-part-3)
- [2. Overview](#2-overview)
  - [2.1. Lab Guide Syntax conventions](#21-lab-guide-syntax-conventions)
  - [2.2. Table of Contents](#22-table-of-contents)
- [3. Architecture](#3-architecture)
  - [3.1. The cross-cloud management channel](#31-the-cross-cloud-management-channel)
- [4. Lab Steps](#4-lab-steps)
  - [4.1. Prerequisites](#41-prerequisites)
  - [4.2. Launch Azure Cloud Shell](#42-launch-azure-cloud-shell)
  - [4.3. Install the Azure plugin on Panorama](#43-install-the-azure-plugin-on-panorama)
  - [4.4. Generate a CSP registration PIN](#44-generate-a-csp-registration-pin)
  - [4.5. Create the Cloud Device Group and registration string](#45-create-the-cloud-device-group-and-registration-string)
  - [4.6. Get the lab code and configure terraform.tfvars](#46-get-the-lab-code-and-configure-terraformtfvars)
  - [4.7. Initialize Terraform](#47-initialize-terraform)
  - [4.8. Plan and apply](#48-plan-and-apply)
  - [4.9. Open inbound access to Panorama (AWS security group)](#49-open-inbound-access-to-panorama-aws-security-group)
  - [4.10. Verify the firewall registered in Panorama](#410-verify-the-firewall-registered-in-panorama)
  - [4.11. Push a policy and test WordPress](#411-push-a-policy-and-test-wordpress)
  - [4.12. Review / check your understanding](#412-review--check-your-understanding)
- [5. References](#5-references)

# 3. Architecture

You deploy the centralized **Virtual WAN** design: a Virtual WAN with a single Virtual Hub that hosts the Cloud NGFW, two spoke VNets (each with a WordPress test VM + an Azure Bastion), and **routing intent** that steers all Internet and private traffic through the firewall.

```
                         ┌──────────────────── Azure Virtual WAN ────────────────────┐
 Internet ◀────────────▶ │  Virtual Hub  ──  Cloud NGFW (managed)  ── public IP        │
                         │       ▲  routing intent: Internet + PrivateTraffic → CNGFW │
                         │       │                                                    │
                         │   ┌───┴────┐        ┌────────┐                             │
                         │   │ app1   │        │ app2   │  spoke VNets (WordPress VM  │
                         │   │ VNet   │        │ VNet   │  + Azure Bastion)           │
                         └───┴────────┴────────┴────────┴─────────────────────────────┘
                                     │ Cloud NGFW calls home over the internet
                                     ▼
                       AWS Panorama (public IP)  ◀── the one you built in Part 1
```

## 3.1. The cross-cloud management channel

> &#8505; The Cloud NGFW **dataplane** lives entirely inside Azure. Only the **management channel** crosses clouds: the firewall *registers to*, and *pulls policy from*, your AWS Panorama over the public internet. Because your Panorama is in AWS (no VNet peering / VPN to Azure), the firewall connects **outbound to Panorama's public IP** on **TCP `3978`, `28443`, `28270`** (not 443). That is why a chunk of this lab is about preparing Panorama and opening the right **inbound** access *to it* (§4.9).

> &#10067; The firewall in Azure initiates the connection *outbound* to Panorama in AWS. Which side's firewall rules (the Azure NSG, or the AWS security group on Panorama) must you change to allow the management channel — and why only that side?

# 4. Lab Steps

## 4.1. Prerequisites

- **Completed Part 1**, with your **Panorama reachable on a public IP** and you able to log into it.
- **Panorama version**: **11.2** or above (11.2.7+ recommended). **12.0 / 12.1 are NOT supported** with Cloud NGFW for Azure.
- **Access to the shared lab Azure subscription** — your instructor will give you the **tenant** and **subscription** IDs directly. You have rights to create your own resources there.
- **Access to the Palo Alto Customer Support Portal (CSP)** for the same account your Panorama is registered under (for the registration PIN in §4.4).

> &#8505; **You do not need anything installed locally.** Everything runs in **Azure Cloud Shell** (next step), including the VS Code-style web editor for editing files. The previous cohort wrestled with local toolchains — we are skipping that.

> &#8505; **One resource group for everything.** You'll create a single resource group for your lab (§4.6) and deploy everything into it (`create_resource_group = false`, reusing it). Use a unique **`name_prefix`** (e.g. your initials) so your resources don't collide with other students sharing the subscription.

## 4.2. Launch Azure Cloud Shell

> &#8505; **Why Cloud Shell.** It gives you `az`, `terraform`, `git`, and a web **VS Code editor** with zero local setup, plus a **persistent home directory** — so your cloned repo and Terraform state survive across sessions.

- In the Azure Portal, click the **Cloud Shell** icon (`>_`) in the top bar, and choose **Bash**.
- If it's your first time, accept the prompt to create storage (Cloud Shell makes a small storage account for your home directory automatically — one-time, reused after).
- Point Cloud Shell at the shared lab subscription and confirm your tooling:

```
az account set --subscription "<SUBSCRIPTION_ID_FROM_INSTRUCTOR>"
az account show -o table
terraform version
```

## 4.3. Install the Azure plugin on Panorama

> &#8505; **Why.** Panorama manages Cloud NGFW through its **Azure plugin**. The plugin adds the *Cloud NGFW* configuration area (Cloud Device Groups, registration strings) you'll use in §4.5. You need **Azure plugin 5.2.3 or above**.

- Log into your Part 1 Panorama. Go to **Panorama → Plugins**.
- Click **Check Now**, find **azure**, and **Download** then **Install** a **5.2.3+** version (5.2.4 is known-good).

> &#8505; If your workshop uses a **shared** Panorama, the plugin may already be installed — check **Panorama → Plugins** for an installed `azure` 5.2.x before installing. Installing triggers a brief management-server restart.

## 4.4. Generate a CSP registration PIN

> &#8505; **Why.** The registration string you generate next ties the new firewall's identity to your **CSP account** using a **PIN ID / PIN Value**. This is how Cloud NGFW is licensed/registered under the same account as your Panorama.

- In the **Customer Support Portal**, go to **Assets → Device Certificates → Generate Registration PIN**.
- Record the **PIN ID** and **PIN Value** (you'll paste them in the next step).

> &#8505; Your instructor may provide a PIN ID/Value instead — if so, use theirs.

## 4.5. Create the Cloud Device Group and registration string

> &#8505; **Why this is the heart of the lab.** Panorama doesn't "find" the Cloud NGFW — the firewall **registers itself to Panorama** using a connection string that Panorama generates. That string encodes which **device group** and **template stack** the firewall joins, your Panorama's IP and serial, and an embedded auth key. You generate it here, then hand it to Terraform in §4.6.

- In Panorama, open the **Azure plugin → Cloud NGFW → Cloud Device Groups**, and **Add** one. Set:
  - **Name** — your cloud **device group**. Use something unique to you, e.g. `cngfw-<your-prefix>` (so you don't collide with others on a shared Panorama).
  - **Parent Device Group** — `shared` (or as your instructor directs).
  - **Template Stack** — **Add** one with a matching name, e.g. `cngfw-<your-prefix>`. &#9888; *The template-stack name cannot be changed after the firewall deploys — pick the final name now.*
  - **Panorama IP** — choose **Public** (your firewall reaches Panorama over the internet).
  - **PIN ID / PIN Value** — paste the values from §4.4.
- Click **OK**, then **Commit → Commit to Panorama**.
- Locate your Cloud Device Group, find the **Registration String** field, click **Generate**, then **Copy** the string.

> &#9888; The registration string is a base64 blob that contains an **auth key** — treat it like a password. Don't paste it into chat/tickets, and don't commit it to git.

## 4.6. Get the lab code and configure terraform.tfvars

> &#8505; **Why.** The Terraform here is the same repo you used for Part 1; the Azure lab lives under `terraform/azure-cngfw/`. You only edit a `terraform.tfvars` file — the module code (including a small fix that lets the test workloads reuse your resource group) is already in place.

- Create a resource group for your lab (skip if your instructor pre-made one for you). Use a unique name so you don't collide with other students:

```
az group create -n "<your-prefix>-cngfw-rg" -l "<REGION_FROM_INSTRUCTOR>"
```

- Clone the repo (skip if you already have it from Part 1) and move into the Azure lab:

```
cd ~ && git clone https://github.com/PaloAltoNetworks/lab-aws-gwlb-vmseries.git
cd ~/lab-aws-gwlb-vmseries/terraform/azure-cngfw
cp example.tfvars terraform.tfvars
```

- Open the editor and edit `terraform.tfvars`:

```
code terraform.tfvars
```

- Fill in the values marked `TODO`:
  - `subscription_id` — the shared lab subscription you deploy into.
  - `region` — your resource group's region.
  - `resource_group_name` — the resource group you just created (set it in **all** the `TODO_YOUR_RG` spots).
  - `create_resource_group` — leave **`false`** (you already created the RG above; everything reuses it).
  - `name_prefix` — a short unique prefix (e.g. your initials) — same one you used for the RG.
  - `panorama_base64_config` — paste the **registration string** from §4.5.

> &#8505; Notice the `routing_intent` block (all spoke traffic → the firewall), the `destination_nats` (the firewall's public IP → the WordPress VMs on :80 and :443), and the two `test_infrastructure` spokes. Skim them — this is the whole topology in ~150 lines of declarative config.

## 4.7. Initialize Terraform

> &#8505; **Why.** `terraform init` downloads the providers and the pinned firewall **modules** this lab uses (from the `terraform-azurerm-swfw-modules` repo at tag `v3.5.1`). Your Terraform **state** — the record of what you built — is kept locally in your persistent Cloud Shell home, which is fine because Cloud Shell persists across sessions.

- Initialize:

```
terraform init
```

## 4.8. Plan and apply

- Sanity-check the plan, then apply:

```
terraform plan
terraform apply    # type yes
```

> &#9888; **Expect ~40 minutes.** The Cloud NGFW resource itself takes ~40 min to provision — it is by far the long pole. **Start it now** and continue reading / do other material while it runs; don't sit and watch it.

> &#8505; **Keep the apply alive.** A Cloud Shell can idle-timeout during a long apply. Run it inside `tmux` (preinstalled) so it survives a disconnect:
> ```
> tmux new -s cngfw      # run terraform apply inside; reattach later with: tmux attach -t cngfw
> ```
> If your shell does drop, just reconnect, `cd` back, and `terraform apply` again — your state is in the persistent Cloud Shell home, so Terraform picks up where it left off.

> &#8505; **Sanity check the plan.** Every `resource_group_name` should be **your** RG, and the summary should create **0** `azurerm_resource_group` resources. If you see a `*-testenv` resource group being *created*, your `create_resource_group`/`resource_group_name` values aren't set in every spot (§4.6).

> &#9888; The apply **succeeds even if your registration string is wrong** — Azure does not validate Panorama reachability at create time. A bad string shows up *later* as the device simply never appearing in Panorama (§4.10), not as a Terraform error. That's why we got §4.3–§4.5 right first.

## 4.9. Open inbound access to Panorama (AWS security group)

> &#8505; **Why now (not earlier).** The firewall connects to Panorama **from its egress public IP**, which only exists once it's deployed. So we deploy first, read the IP, then allow it.

- Get your firewall's egress/public IP (from Terraform or `az`):

```
FW_ID=$(az resource list -g <YOUR_RG> --resource-type paloaltonetworks.cloudngfw/firewalls --query "[0].id" -o tsv)
az resource show --ids "$FW_ID" --query "properties.networkProfile.egressNatIp[].address" -o tsv
```

- On the **AWS security group** attached to your Part 1 Panorama (in AWS), add **inbound** rules allowing **TCP `3978`, `28443`, `28270`** from that **egress IP `/32`**.
- In Panorama, confirm **Setup → Management → Permitted IP Addresses is NOT set**.

> &#9888; **Permitted IP Addresses is unsupported with Cloud NGFW for Azure** — if it's set, it silently blocks the firewall from connecting. Leave it empty.

> &#8505; This is the cross-cloud "aha": the only thing crossing clouds is this management channel, and you secure it by allowing exactly one Azure IP inbound to one AWS host on three ports.

## 4.10. Verify the firewall registered in Panorama

- In Panorama, go to **Panorama → Managed Devices → Summary**. Within a few minutes of opening the security group, your firewall should appear and connect into your `cngfw-<your-prefix>` device group.

> &#8505; **You'll see ~3 devices, not one.** Cloud NGFW for Azure is a *scaled* service — it registers as several firewall instances that all share your firewall's name. That's normal; they're the dataplane instances behind the managed service.

- Optional ground-truth check from Cloud Shell that the firewall is pointed at *your* Panorama:

```
az resource show --ids "$FW_ID" \
  --query "{state:properties.provisioningState, panorama:properties.panoramaConfig.panoramaServer, dg:properties.panoramaConfig.dgName, tpl:properties.panoramaConfig.tplName}" -o json
```

> &#10067; If the device never shows up, it's almost always one of three things — what are they? (Hint: §4.9.) You should **not** need to redeploy the firewall; fix the cause and it retries on its own.

## 4.11. Push a policy and test WordPress

> &#8505; **Why nothing works yet.** Cloud NGFW **default-denies** until you push a security policy from Panorama. The inbound NAT (public IP → WordPress) is already built by Terraform — you just need to *allow* the traffic.

- In Panorama, select **Policies → Security**, choose your `cngfw-<your-prefix>` **Device Group**, and **Add** a rule:
  - Name `allow-web`; **Source Zone = Any**, **Destination Zone = Any** (Cloud NGFW only supports `Any` zones — that's expected); **Application = Any** (or `web-browsing` + `ssl`); **Service = application-default**; **Action = Allow**; enable **Log at Session End**.
- **Commit → Commit to Panorama**, then **Push to Devices** (Edit Selections → confirm your cloud device group) → **Push**.
- Browse to your firewall's public IP:
  - app1 → `http://<your-cngfw-public-ip>`
  - app2 → `https://<your-cngfw-public-ip>`

> &#8505; Give the push ~30 seconds. You can confirm the inspected traffic under **Panorama → Monitor → Traffic** (Cloud NGFW logs flow to Strata Logging Service).

> &#10067; You never created a NAT rule in Panorama, yet the public IP reaches a private WordPress VM. Where does the NAT actually live, and why isn't it in Panorama?

## 4.12. Review / check your understanding

- One Panorama, two clouds: it now manages your AWS VM-Series **and** your Azure Cloud NGFW. What's the same about managing them, and what's different?
- Why did the firewall register *outbound* to Panorama, and what would change if Panorama were in the same cloud/VNet?
- Why is `panorama_base64_config` worth getting right *before* the first apply? (Think about the ~40-minute create.)
- What does routing intent do in the Virtual WAN hub, and how is it different from the GWLB endpoints you used in Part 1?

# 5. References

- Lab Terraform: `terraform/azure-cngfw/` in this repo (pinned to the `PaloAltoNetworks/terraform-azurerm-swfw-modules` `v3.5.1` modules).
- Cloud NGFW for Azure — Panorama integration: <https://docs.paloaltonetworks.com/cloud-ngfw/azure/cloud-ngfw-for-azure/panorama-policy-management/panorama-integration-overview>
- Cloud NGFW for Azure — techdocs home: <https://docs.paloaltonetworks.com/cloud-ngfw/azure>
- azurerm resource reference: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/palo_alto_next_generation_firewall_virtual_hub_panorama>
