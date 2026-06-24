# Panorama Initial Provisioning CLI

> **This script does not deploy Panorama.** It assumes Panorama is already running and reachable at the IP address you provide — fresh from factory defaults, with the admin account accessible via SSH. To deploy Panorama infrastructure first, see [panorama-create](https://github.com/thresh97/panorama-create).

A Python CLI tool for idempotently bootstrapping and provisioning a freshly deployed, factory-default Palo Alto Networks Panorama instance. It works with any supported Panorama form factor: hardware appliances, software VMs on public cloud (Azure, AWS, GCP), and software VMs on private cloud or on-premises hypervisors.

Due to the nature of Panorama deployments (long boot times, multiple management server restarts when applying licenses/certificates), traditional automation tools can sometimes struggle or falsely report failures. This script tracks its progress locally in a JSON state file. If a network timeout occurs or the Panorama web server restarts mid-flight, you can safely re-run the exact same command, and the script will pick up exactly where it left off.

## Why This Was Built (The Bootstrapping Dilemma)

When deploying Palo Alto Networks software firewalls (VM-Series and Cloud NGFW) at scale, it's common practice to bootstrap them directly to a Panorama management server. However, this creates a strict dependency: Panorama *must* exist and be fully operational *prior* to the firewalls being provisioned.

Attempting to deploy the Panorama VM and the software firewalls simultaneously in a single Infrastructure-as-Code (IaC) pipeline (like Terraform or CloudFormation) creates race conditions that are nearly impossible to resolve natively. The firewalls will boot up, attempt to connect to Panorama, and fail because Panorama is still initializing, rebooting to apply its license, or missing necessary routing/cloud plugins.

This script does the heavy lifting required to solve this problem, enabling a robust, serialized deployment strategy:

1. **Deploy Panorama VM:** Spin up the base Panorama virtual appliance via your IaC tool of choice.
2. **Provision Panorama (This Script):** Run this tool to handle the messy, reboot-heavy phases — applying licenses, fetching device certificates, generating VM auth keys, and installing required plugins (like SD-WAN or Cloud Services).
3. **Configure Panorama Base Policy:** Push the foundational Device Groups (DG) and Template Stacks to the now-ready Panorama (via Terraform, Ansible, or PAN-OS Python).
4. **Deploy Software Firewalls:** Finally, deploy the VM-Series or Cloud NGFW instances. They will successfully bootstrap, connect to Panorama, and pull down their assigned configurations without issue.

### Why Python and not Ansible?
While it would probably be best to handle this multi-step, stateful process natively within Ansible, this script was built as a "quick and dirty" alternative. It serves as a lightweight, stand-alone tool that is arguably much easier to read, run, and debug in isolation than a more complex and fully integrated Ansible playbook configuration.

### Why raw XML API instead of `pan-os-python`?
Similarly, utilizing the official `pan-os-python` SDK would normally be the most appropriate and robust way to interact with PAN-OS programmatically. However, this script relies strictly on raw Python `urllib` XML API calls. This was a deliberate design choice: `pan-os-python` occasionally auto-wraps XML payloads in ways that PAN-OS rejects for very specific, low-level operational commands (like setting a serial number or downloading specific plugin versions). Using raw XML gives us the explicit, character-for-character control required for these early bootstrapping tasks without requiring external dependencies.

---

## Features

- **SSH Bootstrapping:** Connects via SSH (key-based or password fallback via ENV) to disable CLI pagination, verify system readiness, set an initial API password, and perform the initial config commit.
- **Idempotent State Tracking:** Generates a `panorama-<ip>-state.json` file to track the success of every step. Automatically discovers existing state files in the current directory on re-runs.
- **Licensing & Certificates:** Sets the Panorama serial number, configures the CSP API Key, and fetches a Device Certificate via OTP using the XML API.
- **Dynamic Updates:** Downloads and installs the latest Content and Anti-Virus definitions. Skips download if already at latest version.
- **Plugin Management:** Checks existing installed plugins and sequentially downloads and installs a comma-separated list of required Panorama plugins. Skips plugins already present.
- **VM Auth Key Generation:** Generates a VM Auth Key with a configurable lifetime (default 1 year) for bootstrapping managed firewalls.
- **PAN-OS Upgrade:** Downloads, installs, and waits through reboots to upgrade Panorama to a specified version or the latest in the current major.minor family.
- **Live Idempotency Checks:** Before sending any potentially disruptive command (serial number set, commit, content/AV download), the script first queries the device's live state and skips the step if it is already complete — even without a state file.

---

## Firewall Licensing: Two Approaches

This is the most important architectural decision before running this script. The two approaches use **different bootstrap keys** and are mutually exclusive **per firewall** — a single Panorama can support both simultaneously, but each VM-Series firewall can only be licensed via one method in its bootstrap.

### Approach A: Software Firewall Licensing via Panorama (Flex)

The `sw_fw_license` plugin extends Panorama with a license manager. FW Flex credit pool deployment profile authcodes are configured in Panorama and bound to specific Device Groups — when a firewall connects and is assigned to a Device Group, Panorama licenses it using the authcodes associated with that group.

Licensing transactions are **proxied through Panorama** to the PAN licensing cloud. The firewall's management interface does not need direct outbound internet access to the PAN licensing cloud.

Firewalls bootstrapped under this model use `authkey=` in their bootstrap configuration. This Panorama auth key is generated through the `sw_fw_license` plugin (via Panorama UI or API) — it is **not** the VM Auth Key produced by `--vm-auth-key`, and `--vm-auth-key` is not used in this approach.

**Operational considerations:**
- **License deactivation**: The sw_fw_license plugin can be configured to automatically return credits to the pool after a firewall has been disconnected for 2–24 hours — well suited for autoscaling and ephemeral deployments.
- **Pool exhaustion**: If the credit pool is depleted at licensing time, the firewall will retry through Panorama — no manual intervention or redeployment required.

**What you need on Panorama:**
- The `sw_fw_license` plugin installed (via `--plugins`)
- The CSP API Key configured (via `--csp-api-key`) so Panorama can communicate with the PAN licensing cloud
- FW Flex deployment profile authcodes configured in Panorama and bound to Device Groups (done in Panorama after this script completes)

**What the firewall bootstrap needs:**
- `panorama-server=` Panorama IP
- `panorama-server-2=` secondary Panorama IP (optional)
- `tplname=` Panorama template stack name
- `dgname=` Panorama device group name
- `authkey=` generated via the sw_fw_license plugin
- `plugin-op-commands=panorama-licensing-mode-on`

See [Panorama-Based Software Firewall License Management](https://docs.paloaltonetworks.com/vm-series/11-1/vm-series-deployment/license-the-vm-series-firewall/use-panorama-based-software-firewall-license-management) for full plugin configuration details.

> **Note:** The `sw_fw_license` plugin (PAN-182488) does not support dedicated Log Collector groups (`cgname=` in bootstrap). It only works when Panorama is in `panorama` mode (combined management + logging). If your deployment uses separate Log Collectors, use Approach B instead.

```bash
python3 panorama_init.py \
  --serial-number 000000000000 \
  --otp abcdef123456 \
  --csp-api-key 0123456789abcdef... \
  --plugins sw_fw_license-1.2.0,sd_wan-3.3.3-h2,ztp-3.0.1 \
  192.168.1.100
```

### Approach B: Direct Bootstrap Licensing (FW Flex)

The authcode from a FW Flex credit pool deployment profile is placed directly in the firewall's bootstrap configuration. The firewall presents it to the PAN licensing cloud on first boot without Panorama's involvement in the licensing transaction.

**The firewall's management interface requires direct outbound internet access to the PAN licensing cloud.** If your management network does not permit this, use Approach A.

Firewalls bootstrapped under this model use `vm-auth-key=` in their bootstrap configuration. This is what `--vm-auth-key` generates on Panorama.

Authcodes can be delivered to the firewall in two ways:

- **Basic bootstrapping (userdata/instance metadata):** Pass `authcodes=XXXXXXXX` in the VM's user data at launch time. Works well in most cloud deployments and is often simpler to manage than the sw_fw_license plugin.
- **Complete bootstrapping (cloud storage / USB):** Include a `/licenses/authcodes` file in the bootstrap package stored in an S3 bucket, Azure blob, GCS bucket, or USB drive.

**What you need on Panorama:**
- VM Auth Key generated (via `--vm-auth-key`)
- The `sw_fw_license` plugin is **not** used

**What the firewall bootstrap needs:**
- `panorama-server=` Panorama IP
- `panorama-server-2=` secondary Panorama IP (optional)
- `tplname=` Panorama template stack name
- `dgname=` Panorama device group name
- `vm-auth-key=` for Panorama registration
- `authcodes=` (FW Flex deployment profile authcode) delivered via userdata or bootstrap package

**Operational considerations:**
- **Licensing is one-shot**: The authcode is consumed on first successful contact with the PAN licensing cloud. If licensing fails for any reason, there is no automatic retry — manual intervention or redeployment is required.
- **License deactivation**: Returning credits to the pool requires direct interaction with the [PANW Software NGFW Licensing API](https://docs.paloaltonetworks.com/vm-series/11-1/vm-series-deployment/license-the-vm-series-firewall/software-ngfw/software-ngfw-licensing-api). This is not handled by this script and requires custom orchestration. For autoscaling deployments this complexity should be weighed carefully against Approach A.


```bash
python3 panorama_init.py \
  --serial-number 000000000000 \
  --otp abcdef123456 \
  --vm-auth-key \
  192.168.1.100
```

### Summary

| | Approach A (sw_fw_license / Flex) | Approach B (Direct Bootstrap) |
|---|---|---|
| Firewall bootstrap key | `authkey=` (from sw_fw_license plugin) | `vm-auth-key=` (from `--vm-auth-key`) |
| `--vm-auth-key` on this script | **Not used** | Required |
| `--csp-api-key` | Required (license pool auth) | Optional |
| `sw_fw_license` plugin | Required | Not used |
| Authcode source | FW Flex deployment profile, configured in Panorama per Device Group | FW Flex deployment profile authcode, delivered in firewall bootstrap |
| Licensing transaction | Proxied through Panorama — no direct internet required from firewall mgmt | Firewall mgmt interface contacts PAN licensing cloud directly |
| License deactivation | Configurable: automatic after 2–24 hours disconnection | Requires custom orchestration via PANW Software NGFW Licensing API |
| Bootstrap failure recovery | Retries if pool depleted; Panorama manages retry | One-shot: failure requires manual intervention or redeployment |
| Log Collector groups | Not supported (PAN-182488); requires panorama-mode panorama | Works well |

---

## Prerequisites & Setup

- **Panorama Version:** Initially built and tested with Panorama 11.2.8.
- **Python Environment:** Python 3.7+ and `paramiko`.

It is recommended to run this within a Python Virtual Environment.

```bash
python3 -m venv venv
source venv/bin/activate
pip install paramiko
```

---

## Usage

### Authentication

The script uses SSH for initial configuration (setting hostname, API password, and performing the first commit), then switches to the XML API for all subsequent steps. What you need depends on how your Panorama was deployed:

**Public cloud (Azure, AWS, GCP):** Cloud marketplace images typically deploy with SSH key-based authentication and no local password set on the admin account. Use `--ssh-key` to point to your private key. No password is needed.

```bash
python3 panorama_init.py --ssh-key ~/.ssh/my-cloud-key.pem 192.168.1.100
```

**Private cloud / on-premises / hardware:** If Panorama already has a password configured on the admin account, provide it via environment variable:

```bash
export PANORAMA_PASSWORD='YourSecretPassword123!'
```

> **Known limitation — `admin/admin` default with forced password change:** Some deployments (hardware appliances and certain VM images) ship with a default `admin/admin` credential and require a password change on the very first interactive login before allowing any further access. This script does not currently handle that forced-change flow. If your Panorama requires this, you must complete the initial password change manually (via console or direct SSH) before running this script. See [Planned / Future Functionality](#planned--future-functionality).

### Command Line Arguments

| Argument | Default | Description |
|---|---|---|
| `ip` | *(required)* | IP address of the Panorama VM. Optional if `--state-file` is provided (IP is read from state). |
| `--hostname` | `Panorama-Management` | Hostname to configure on the Panorama VM. |
| `--username` | *(from state, or `admin`)* | SSH/API username. Stored in state on first run; inferred automatically on re-runs. |
| `--ssh-key` | `~/.ssh/id_rsa` | Path to SSH private key file. |
| `--state-file` | `./panorama-<ip>-state.json` | Path to state tracking JSON file. If omitted, the current directory is scanned for an existing matching state file. |
| `--serial-number` | — | Serial number to apply to Panorama via XML API. |
| `--otp` | — | One-Time Password for fetching the device certificate. Skipped automatically if certificate is already valid. |
| `--csp-api-key` | — | Customer Support Portal API Key. Required for Software Firewall Licensing (Approach A). |
| `--upgrade-content` | `false` | Check, download, and install the latest Content (App-ID) update. Skips if already at latest. |
| `--upgrade-av` | `false` | Check, download, and install the latest Anti-Virus update. Skips if already at latest. |
| `--upgrade-panos` | — | Upgrade PAN-OS to a specific version (e.g. `11.2.8`) or `latest` for the newest in the current major.minor family. Triggers a full reboot. |
| `--plugins` | — | Comma-separated list of plugins to install (e.g. `sw_fw_license-1.2.0,sd_wan-3.3.3-h2`). Skips any already installed. |
| `--vm-auth-key` | — | Generate a VM Auth Key for firewall bootstrapping. Optionally accepts a lifetime in hours (default: `8760` = 1 year). Omitting the flag skips key generation entirely. |
| `--configure-ha` | — | Configure Active/Passive HA with the given peer Panorama IP. Both nodes must be provisioned first. The current node becomes the primary (active); the peer becomes secondary (passive). Uses XML API only — no SSH required. |
| `--connectivity` | `private` | HA peer connectivity: `private` reads each node's private management IP from `show system info` and uses that as the HA peer address (intra-VPC/VNet). `public` uses the passed management IPs directly. |
| `--ha-peer-state-file` | *(auto-discovered)* | Explicit state file for the HA peer node. Auto-discovered by peer IP if omitted. |
| `--configure-local-lc` | — | Configure the local log collector on a Panorama instance in panorama-mode. Requires: license applied, panorama-mode, at least one attached log disk. Can be combined with provisioning args in one invocation — provisioning runs first, then LC setup. |
| `--collector-group-name` | `default` | Collector group name for `--configure-local-lc`. |
| `--debug` | `false` | Enable verbose logging, including full XML requests and responses. |

### Example Invocations

**Full provisioning — Software Firewall Licensing / Flex (Approach A):**
```bash
python3 panorama_init.py \
  --debug \
  --username panadmin \
  --hostname My-Panorama \
  --serial-number 000000000000 \
  --otp abcdef123456 \
  --csp-api-key 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef \
  --upgrade-content \
  --upgrade-av \
  --plugins sw_fw_license-1.2.0,sd_wan-3.3.3-h2,ztp-3.0.1,azure-5.2.3,aws-5.4.3 \
  192.168.1.100
```

**Full provisioning — Traditional authcodes (Approach B):**
```bash
python3 panorama_init.py \
  --username panadmin \
  --serial-number 000000000000 \
  --otp abcdef123456 \
  --upgrade-content \
  --upgrade-av \
  --plugins sd_wan-3.3.3-h2,ztp-3.0.1 \
  --vm-auth-key \
  192.168.1.100
```

**Resume from an explicit state file (IP inferred from state):**
```bash
python3 panorama_init.py --state-file panorama-192.168.1.100-state.json
```

**PAN-OS upgrade only:**
```bash
python3 panorama_init.py --state-file panorama-192.168.1.100-state.json --upgrade-panos 11.2.8
```

**Add plugins to an already-provisioned Panorama:**
```bash
python3 panorama_init.py \
  --state-file panorama-192.168.1.100-state.json \
  --plugins sw_fw_license-1.2.0
```

**Generate a new VM Auth Key with a custom lifetime:**
```bash
python3 panorama_init.py \
  --state-file panorama-192.168.1.100-state.json \
  --vm-auth-key 4380
```

**Configure Active/Passive HA (intra-VPC/VNet — private connectivity):**
```bash
# Both nodes must be provisioned first. State files are auto-discovered by IP.
python3 panorama_init.py 20.119.51.64 --configure-ha 20.119.51.65 --username panadmin
```

**Configure Active/Passive HA (public IP connectivity):**
```bash
python3 panorama_init.py 20.119.51.64 --configure-ha 20.119.51.65 \
  --username panadmin \
  --connectivity public
```

Validated: **Azure Panorama 11.2.8**.

**Configure local log collector (panorama-mode, disk attached):**
```bash
python3 panorama_init.py 10.0.0.1 --configure-local-lc --collector-group-name LCG_default
```

**Full provisioning + PAN-OS upgrade + plugin + local LC in one invocation:**
```bash
python3 panorama_init.py 10.0.0.1 \
  --serial-number 000000000000 \
  --upgrade-panos latest \
  --plugins sd_wan-3.3.3-h2 \
  --configure-local-lc \
  --collector-group-name LCG_default
```

Sequence: set serial → fetch license → upgrade PAN-OS to latest in current family → configure local LC and collector group → poll until In Sync. All steps are idempotent — safe to re-run if interrupted at any point.

---

## State File & Idempotency

Every completed step is recorded in a local JSON state file (`panorama-<ip>-state.json` by default). This means:

- **Safe to re-run:** If the script is interrupted at any point, re-running the same command resumes exactly where it left off.
- **State file discovery:** If `--state-file` is not specified and the default file doesn't exist, the script scans the current directory for any `panorama-*-state.json` files. If exactly one is found with a matching IP, it is used automatically (with a warning). If multiple are found, you are prompted to choose one or start fresh.
- **IP recovery:** The IP address is stored in the state file on the first run. When using `--state-file` without an explicit IP argument, the IP is read from state.

The state file records: IP address, hostname, API password, serial number, content version, AV version, plugin list, VM Auth Key, and the completion status of each provisioning step.

---

## Planned / Future Functionality

- **Default credential / forced password change handling:** Automatically detect and handle the `admin/admin` default credential with forced password change on first login, common on hardware appliances and some VM images. This would allow the script to run fully unattended against a fresh out-of-box device with no prior manual steps.
- **Deployment Mode Configuration:** Ability to dynamically set or toggle the Panorama deployment mode between `panorama` mode (management + logging), `management-only` mode, and `log-collector` mode.
- **Log Collector Setup:** ✅ Implemented via `--configure-local-lc`. Validated on GCP Panorama 11.2.6. Adds available disks, creates the log-collector config entry and disk-pair assignments, creates a Collector Group, commits, and polls until the LC reports Connected / In Sync. Compound with provisioning args supported in one invocation.
- **X.Y version targeting for `--upgrade-panos`:** Currently supports exact versions (`11.2.8`) and `latest` (newest patch within the currently-running major.minor). Adding `X.Y` shorthand (e.g. `11.2` → latest 11.2.x) would be useful but gets complicated when Panorama is on a different major.minor family and a stepping upgrade is required.

---

## Disclaimer

**Lab & Demo Use Only:** This script is provided as-is for educational, lab, and demonstration purposes. It is not officially supported by Palo Alto Networks. Please review the code and test thoroughly in a non-production environment before utilizing it in any production capacity. The authors assume no responsibility for any misconfigurations or disruptions caused by the use of this tool.

---

## License (MIT)

MIT License — Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
