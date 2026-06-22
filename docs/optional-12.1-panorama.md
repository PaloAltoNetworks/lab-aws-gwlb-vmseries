# Optional: Standalone 12.1.x Panorama (advanced path)

> **Status: STUB** - to be fleshed out and tested. The primary lab keeps Panorama and the firewalls on **11.2.x** (see README §4.8). This optional path stands up a separate, current Panorama on **12.1.x** for those who want to stay on the latest train.

## Why this exists

The pre-baked lab Panorama image is `11.1.2-h3`, and its `/opt/panrepo` partition is too small to ingest the 12.1 base image: once the running 11.2 image and its base are on disk (neither can be purged while running), post-processing of the 12.1 base fails for lack of space. Rather than fight that on the pre-baked image, deploy a fresh Panorama from the **public Marketplace image**, sized correctly, and put it on 12.1.x.

## Approach

- **Its own Terraform state, in a different AWS region** from the lab. QwikLabs vCPU/EIP quota will not allow a second Panorama beside the lab in `us-west-2`, so place this one in another region and **peer its Transit Gateway to the lab's TGW** so the managed firewalls can reach it over the overlay.
- Deploy the **public Marketplace Panorama image** (NOT the pre-baked lab image) - e.g. `Panorama-AWS-12.1.x` - on an instance with adequate vCPU/RAM and a **dedicated log/system disk sized for 12.1**, so future software upgrades have room (the whole point).
- **Mint a unique Panorama serial from the same deployment profile** (CSP > Software NGFW Credits > your profile > **Provision Panorama** > Provision New) so it does not collide with the lab Panorama's serial.
- **SSH in with your key pair** for initial setup (set serial, `request license fetch`, fetch the device-certificate via OTP), then configure the log collector + template/device-group as in README §4.8.2.

## TODO (flesh out + test)

- [ ] Terraform: a separate dir/module with its own state - VPC + public subnet + EIP, Panorama instance (proper instance type + a correctly sized EBS log disk), TGW + **peering to the lab TGW**, and routes to reach the lab spokes.
- [ ] Recommend instance type + disk sizing (enough `panrepo` headroom that 12.1 base + target both ingest).
- [ ] Region choice + exact TGW peering / route-table config from the lab side.
- [ ] Steps: set serial, license fetch, device-cert OTP, collector group `default`, `sw_fw_license` bootstrap definition + license manager, show bootstrap parameters.
- [ ] Validate end-to-end with a VM-Series firewall pointed at this Panorama (`panorama_host` / bootstrap `auth-key`).

## Notes

- Firewalls managed by this Panorama can run up to its version (12.1.x), so you may use the latest AI Runtime Security / VM-Series 12.1 image for the data plane on this path (`fw_version` up to the Panorama version - see README §4.5).
- Keep this entirely optional and separate; the primary lab path does not depend on it.
