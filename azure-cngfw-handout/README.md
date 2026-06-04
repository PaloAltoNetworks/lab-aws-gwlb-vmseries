# Cloud NGFW for Azure, managed by your AWS Panorama — Lab Addendum (Part 3)

> &#8505; This is an addendum to the VM-Series on AWS Gateway Load Balancer lab ([Part 1 lab README](../README.md)). Complete **Part 1** first — you need the **Panorama** you deployed there (in `us-west-2`, with a public IP) up and reachable. This part is **independent of Part 2** (the SCM addendum); it uses Panorama, not SCM, as the management plane.

```
Manual Last Updated: 2026-06-04
```

## Lab Guide Syntax conventions

- Items with a bullet indicate actions to take to complete the lab.
- Code blocks follow an action for copy / paste or reference.

> &#8505;  Items with the info icon are additional context or details around the actions.

> &#10067; Items with the question mark icon are good check-your-understanding questions.

## 1. Overview

In Part 1 you ran one firewall engine (VM-Series) in **AWS**, managed by **Panorama**. In this part you extend that same Panorama **across clouds**: you deploy **Cloud NGFW for Azure** — a Palo Alto-operated, Azure-native managed firewall — with Terraform, and you point it back at your existing AWS Panorama for policy. One management plane, two clouds, two firewall form factors.

> &#8505; Why this matters. Cloud NGFW is a SaaS firewall: there are no VMs to patch or scale — Azure and Palo Alto operate the dataplane. You declare it in Terraform, attach it to an Azure Virtual WAN hub, and (in this lab) manage its policy from Panorama exactly like any other managed device. The interesting outcome is operational: your `us-west-2` Panorama ends up managing both VM-Series in AWS *and* Cloud NGFW in Azure.

Three independent choices, as in Part 2 — made differently here:

| Choice | Part 1 (AWS) | This addendum (Azure) |
| --- | --- | --- |
| 1. Firewall resource | VM-Series on GWLB (software you run) | Cloud NGFW for Azure (managed SaaS) |
| 2. Insertion / topology | GWLB endpoints, hub-and-spoke via TGW | Centralized **Virtual WAN** hub with routing intent |
| 3. Management plane | Panorama | **The same Panorama** (cross-cloud) |

## 2. Architecture — centralized Virtual WAN

You deploy the upstream Palo Alto reference example `cloudngfw_centralized_single_vwan`: a Virtual WAN with a single Virtual Hub that hosts the Cloud NGFW, two spoke VNets (WordPress test VMs + Azure Bastion), and **routing intent** that steers all Internet + private traffic through the firewall.

```
                         ┌──────────────────── Azure Virtual WAN ────────────────────┐
 Internet ◀────────────▶ │  Virtual Hub  ──  Cloud NGFW (managed)  ── public IP(s)    │
                         │       ▲  routing intent: Internet + PrivateTraffic → CNGFW │
                         │       │                                                    │
                         │   ┌───┴────┐        ┌────────┐                             │
                         │   │ app1   │        │ app2   │  spoke VNets (WordPress VM  │
                         │   │ VNet   │        │ VNet   │  + Azure Bastion)           │
                         └───┴────────┴────────┴────────┴─────────────────────────────┘
                                     │ Cloud NGFW calls home over the internet
                                     ▼
                       AWS Panorama (us-west-2, public IP)  ◀── you from Part 1
```

> &#8505; The Cloud NGFW dataplane lives entirely inside Azure. Only the **management channel** crosses clouds: the firewall registers to, and pulls policy from, your AWS Panorama over the public internet. That is why a chunk of this lab is about preparing Panorama and opening the right inbound access to it.

## 3. Provisioning & management model used here

- **Provisioning:** Terraform (IaC), using the official `PaloAltoNetworks/terraform-azurerm-swfw-modules` repo and its `cloudngfw_centralized_single_vwan` example.
- **Management:** **Panorama mode** (`management_mode = "panorama"`). The example ships in this mode already; you supply a Panorama *connection string* and the firewall registers itself. (The module also supports `rulestack` and `scm` modes — out of scope here.)
- **Licensing/billing:** Azure Marketplace PAYG for the `panw-cngfw-payg` plan. In the workshop the marketplace agreement and the `PaloAltoNetworks.Cloudngfw` resource provider are **already accepted/registered** in your vended subscription — you do not (and cannot) do this yourself (see §4).

## 4. Prerequisites

- **Completed Part 1**, with your Panorama reachable on a public IP.
- **An Azure lab environment vended via Torque.** You get:
  - A pre-created **resource group** (e.g. `syoungberg-uthze56h2vpb-torque`) in a region (e.g. `East US 2`).
  - **Contributor scoped to that resource group only** — *not* subscription Owner. This shapes several edits below.
  - Subscription-level prerequisites **already done for you**: the `PaloAltoNetworks.Cloudngfw` provider is registered and the Cloud NGFW marketplace plan is accepted.
- **Local tooling:** [`az` CLI](https://learn.microsoft.com/cli/azure/install-azure-cli), [`terraform`](https://developer.hashicorp.com/terraform/downloads) (>= 1.5, < 2.0), [`git`](https://git-scm.com/), and **VS Code**.

> &#8505; **Why "RG-scoped Contributor" matters.** You can create everything *inside* your resource group, but you **cannot** create a new resource group, register resource providers, or accept marketplace terms (those are subscription-scoped). The default example tries to create extra resource groups — you will turn that off in §7. If a `terraform apply` ever fails with `AuthorizationFailed` on a *resource group* or *marketplace* action, this is why.

> &#10067; Your firewall in Azure must reach a Panorama running in AWS. Which side initiates the connection, and therefore whose firewall rules (Azure NSG vs. AWS security group) must allow it?

---

## 5. Step 1 — Prepare your AWS Panorama

Your Part 1 Panorama needs a supported PAN-OS, the **Azure plugin**, CSP registration, and **inbound network access** from the Cloud NGFW. The techdocs are the source of truth — links at the end; the checklist below is what to verify.

- **PAN-OS / plugin versions** (from the integration prerequisites):
  - **Panorama 11.2 or above** is required for new deployments (effective Jan 2026). **11.2.7+** is recommended (fixes Cloud NGFW devices being counted against Panorama licenses). **Panorama 12.0 / 12.1 are NOT supported.**
  - **Azure plugin for Cloud NGFW 5.2.3 or above.** Install from **Panorama → Plugins → Check Now → Azure → Download / Install**.

- **CSP / licensing prerequisites:**
  - Panorama must be **registered, licensed, and have its device certificate installed** so it can authenticate to the Palo Alto Customer Support Portal (CSP).
  - The Cloud NGFW and the Panorama must live under the **same CSP account, and you must use the same email** — a mismatch breaks the integration.
  - You need a **Panorama Administrator** role.

- **Allow inbound to Panorama from the Cloud NGFW.** Because your Panorama is in AWS (no VNet peering / VPN / vWAN to Azure), this is the *"Panorama Public IP access via the internet"* connectivity scenario: the Cloud NGFW connects **outbound to your Panorama's public IP**, so you open **inbound** on the Panorama side. Add rules to the **AWS security group on your Part 1 Panorama instance (`us-west-2`)**:
  - **TCP `3978`, `28443`, `28270`** (the ports Cloud NGFW uses to reach Panorama). *(Not 443.)*
  - Source: the Cloud NGFW egress public IP (known after the Azure deploy — `terraform output` / Portal) — or a scoped range for the lab, tightened afterward.

> &#9888; **Do not** set **Panorama → Setup → Management → Permitted IP Addresses** to lock down Panorama — that feature is **not supported** with Cloud NGFW for Azure and will block the firewall from connecting.

## 6. Step 2 — Create the Cloud Device Group and generate the registration string

Panorama **generates** the connection string for you (the value that becomes `panorama_base64_config`). You do **not** hand-build it. In the Panorama console:

- **Create the Cloud Device Group:** **Panorama → (Azure plugin) → Cloud NGFW → Add**, then set:
  - a **Name** (this is your `dgname`, e.g. `azure-cngfw-dg`) and Description.
  - **Parent Device Group** (default `shared`).
  - **Template Stack** — select one or click **Add** to create it (e.g. `azure-cngfw-ts`). *You cannot change the template stack name after deploying the Cloud NGFW.*
  - **Panorama IP** — choose **public** (your AWS Panorama is reached over the internet).
  - **PIN ID / PIN Value** — generate these in the **CSP → Assets → Device Certificates → Generate Registration PIN**, then paste them in (registers the Cloud NGFW serial under the same CSP account as Panorama).
  - Click **OK**, then **Commit** to Panorama.

- **Generate the registration string:** locate your Cloud Device Group → in the **Registration String** field click **Generate** → **Copy Registration String**.

> &#8505; That copied string **is** your `panorama_base64_config` — paste it directly into `terraform.tfvars` in §7 (it's already the base64 blob; no encoding step needed). It internally carries the device-group / template-stack names, the Panorama IP and serial, versions, and an embedded auth key — which is why there is no separate "VM auth key" step.

> &#8505; The device-group and template-stack names are **baked into the string** — they are not separate Terraform variables. Whatever you named them in this step is what the firewall will join in Panorama, and (per above) the **template-stack name cannot be changed after deploy**. The `dgname`/`tplname` you see on the firewall later (Portal or `az resource show`, §10) should exactly match what you created here.

> &#8505; If you later change the Panorama IP, log collector, or SLS settings, you must **generate a new registration string** and update the firewall (in this lab: update `panorama_base64_config` in tfvars and `terraform apply` — it's an in-place update).

> &#9888; **Trap — re-applying a changed registration string may silently do nothing.** The `azurerm` provider treats `panorama_base64_config` as effectively **write-only**: it never reads the value back from Azure, so Terraform **cannot detect that the string drifted** and will report **`No changes`** even when the firewall is still on the old/placeholder config. (It only re-pushes the string when *some other* attribute in the firewall resource also changes, forcing a full update call.) If you fixed your reg string and a plain `terraform apply` says `No changes` — or the device still won't register after a re-apply — force a clean re-push with a recreate:
> ```bash
> terraform apply -replace='module.cloudngfw["cloudngfw"].azurerm_palo_alto_next_generation_firewall_virtual_hub_panorama.this[0]'
> ```
> Note this **destroys and recreates** the Cloud NGFW — budget another **~40 min**. Getting §5–§6 right *before* the first apply avoids this entirely.

## 7. Step 3 — Clone the Terraform repo, open in VS Code, make the lab edits

- Clone the official module repo and open the example folder in VS Code:

```bash
git clone https://github.com/PaloAltoNetworks/terraform-azurerm-swfw-modules.git
code terraform-azurerm-swfw-modules
```

- In a terminal, move into the example and create your tfvars from the template:

```bash
cd terraform-azurerm-swfw-modules/examples/cloudngfw_centralized_single_vwan
cp example.tfvars terraform.tfvars
```

### 7a. Required code fix — let test workloads reuse your vended RG

The example's `test_infrastructure` accepts a `create_resource_group` flag but **`main.tf` never forwards it**, so it always tries to create new `*-testenv` resource groups. With RG-scoped Contributor that **fails**. Edit `main.tf`, find the `module "test_infrastructure"` block, and replace its `resource_group_name = try(...)` line with the version that forwards the flag:

```hcl
  # BEFORE
  resource_group_name = try(
    "${var.name_prefix}${each.value.resource_group_name}", "${local.resource_group.name}-testenv"
  )

  # AFTER
  create_resource_group = each.value.create_resource_group
  resource_group_name = each.value.create_resource_group ? try(
    "${var.name_prefix}${each.value.resource_group_name}", "${local.resource_group.name}-testenv"
  ) : coalesce(each.value.resource_group_name, local.resource_group.name)
```

### 7b. Edit `terraform.tfvars`

Work through the `# TODO` markers, and set these lab-specific values (use **your** Torque RG name, region, and subscription):

```hcl
# GENERAL
subscription_id       = "<YOUR_TORQUE_SUBSCRIPTION_ID>"
region                = "East US 2"                       # your Torque RG's region
resource_group_name   = "<YOUR_TORQUE_RG>"               # e.g. syoungberg-uthze56h2vpb-torque
create_resource_group = false                            # RG-scoped Contributor: reuse the vended RG
name_prefix           = "syb-"                           # short, unique to you
```

- In the `cloudngfws` map, leave `management_mode = "panorama"` and paste your one-line string from §6:

```hcl
    cloudngfw_config = {
      panorama_base64_config = "<YOUR_BASE64_STRING_FROM_STEP_6>"
      # ...keep the destination_nats block as-is...
    }
```

- In **each** `test_infrastructure` entry (`app1_testenv` and `app2_testenv`), add these two lines at the top of the entry so the workloads land in your vended RG instead of a new one:

```hcl
  "app1_testenv" = {
    create_resource_group = false
    resource_group_name   = "<YOUR_TORQUE_RG>"
    vnets = { ... }
  }
```

> &#8505; You can find your subscription ID and RG name after you log in (next step) with `az group show -n <YOUR_TORQUE_RG> --query "{rg:name, region:location, sub:id}"`.

## 8. Step 4 — Authenticate to your Azure (Torque) environment

- Log in to the tenant that holds your Torque environment, then select the right subscription:

```bash
az login --tenant <YOUR_TORQUE_TENANT>     # e.g. TSOperations.onmicrosoft.com
az account set --subscription "<YOUR_TORQUE_SUBSCRIPTION_ID>"
az account show -o table
```

> &#8505; Terraform authenticates through this `az` CLI session (the example's provider reads `subscription_id` from your tfvars). If `az account show` lists the wrong subscription, fix it before applying.

## 9. Step 5 — Init, plan, apply

```bash
terraform init
terraform plan      # sanity check: expect resources only in YOUR rg, 0 resource groups created
terraform apply     # type yes
```

> &#8505; **Expect ~45 minutes, and plan your session around it.** The Cloud NGFW resource itself takes **~40+ minutes** to provision (measured: 43m39s in a lab run) — it is by far the long pole, well after the Virtual WAN hub (~12 min) and Bastions finish. **Start this apply early** (e.g. before a break or a lecture segment) and continue with other material while it runs; do not sit and watch it. Emptying `test_infrastructure` saves a few minutes on VMs/Bastions but does **not** shorten the ~40-min firewall provision.

> &#8505; **The apply will succeed even if your Panorama connection string is wrong.** The Azure firewall resource does **not** validate Panorama reachability at create time (a placeholder pointing at `1.1.1.1` provisions fine). A bad `dgname`/`vm-auth-key`/IP surfaces *later* as the device simply never appearing in Panorama (§10) — not as a Terraform error. Get §5–§6 right before you apply, because **fixing the string afterward is not a simple re-apply** (Terraform can't see the change — see the write-only trap in §6) and a forced recreate means another ~40-min cycle.

> &#8505; **Sanity check the plan.** Every `resource_group_name` should be **your** RG, and the summary should say it will create **0** `azurerm_resource_group` resources. If you see a `*-testenv` resource group being *created*, re-check the §7a fix and the per-testenv lines in §7b.

## 10. Step 6 — Verify

- **Azure side:** in the Portal, open your resource group and confirm the **Cloud NGFW** resource, the **Virtual WAN / hub**, the routing intent, and the two spoke VMs/Bastions. Terraform outputs print the test VM usernames/passwords/IPs.
- **Confirm the firewall is actually pointed at *your* Panorama** (do this *before* blaming the AWS side). This reads back the live config the firewall is using:

```bash
FW_ID=$(az resource list -g <YOUR_TORQUE_RG> \
  --resource-type paloaltonetworks.cloudngfw/firewalls --query "[0].id" -o tsv)
az resource show --ids "$FW_ID" \
  --query "{state:properties.provisioningState, panorama:properties.panoramaConfig.panoramaServer, dg:properties.panoramaConfig.dgName, tpl:properties.panoramaConfig.tplName}" -o json
```

> &#8505; Expect `state: "Succeeded"` and `panorama` / `dg` / `tpl` matching your AWS Panorama IP and the names from §6. If `panorama` shows `1.1.1.1` or the placeholder `dg`/`tpl`, your registration string never took effect — fix it via the **write-only trap** escape hatch in §6 (a plain re-apply won't help).
- **Panorama side:** in your AWS Panorama, go to **Panorama → Managed Devices → Summary**. Within a few minutes the Cloud NGFW should appear and connect into your `azure-cngfw-dg` / `azure-cngfw-ts`.

> &#8505; If the device never shows up: it's almost always (a) the Panorama inbound rules from §5 (TCP `3978`/`28443`/`28270` not open to the firewall's egress IP), (b) Panorama → Setup → Management **Permitted IP Addresses** is set (unsupported — clear it), or (c) a CSP account/email or PIN ID/Value mismatch when the Cloud Device Group was created.

> &#10067; The firewall in Azure connected outbound to Panorama in AWS, but you only opened *inbound* rules on Panorama. Why didn't you need to open inbound rules on the Azure side for the management channel?

## 11. Step 7 — Push policy & test (optional, instructor-led)

- In Panorama, author security policy in the `azure-cngfw-dg` Device Group, **Commit to Panorama**, then **Push to Devices**.
- Hit the WordPress test VMs via the Cloud NGFW public IP / DNAT rules and confirm traffic is inspected (check **Monitor → Traffic** logs forwarded to Panorama).

## 12. Cleanup

```bash
terraform destroy   # type yes
```

> &#8505; Torque will also reclaim the environment on schedule, but run `destroy` when you finish to free the Cloud NGFW (billed per hour while running) and remove the device from Panorama. Optionally delete the managed device entry in Panorama afterward.

## References

- Terraform example (follow its README too): <https://github.com/PaloAltoNetworks/terraform-azurerm-swfw-modules/tree/main/examples/cloudngfw_centralized_single_vwan>
- Cloud NGFW for Azure — Panorama integration overview: <https://docs.paloaltonetworks.com/cloud-ngfw/azure/cloud-ngfw-for-azure/panorama-policy-management/panorama-integration-overview>
- Cloud NGFW for Azure — techdocs home: <https://docs.paloaltonetworks.com/cloud-ngfw/azure>
- Securing Apps with Cloud NGFW for Azure — design guide: <https://www.paloaltonetworks.com/resources/reference-architectures>
- azurerm resource ref: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/palo_alto_next_generation_firewall_virtual_hub_panorama>
