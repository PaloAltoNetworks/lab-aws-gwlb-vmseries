### Panorama root — copy to terraform.tfvars and edit. terraform.tfvars is gitignored.

region      = "ca-central-1" # MUST differ from the security/FW region
name_prefix = "pan-gwlb-lab-"

### Panorama instance (latest+greatest: 12.1.7, m5.4xlarge = 16 vCPU / 64 GB)
panorama_version       = "12.1.7"
panorama_instance_type = "m5.4xlarge"
# 0 = no dedicated log disk (logs to /opt/panlogs on the root). A dedicated disk via the
# module's volume-attachment hangs PAN-OS 12.1.7 first boot; see docs/GUIDE-CHANGES.md.
panorama_log_disk_gib  = 0

### Networking
vpc_cidr            = "192.168.10.0/24"
panorama_private_ip = "192.168.10.10"
fw_supernet         = "10.0.0.0/8" # supernet covering the FW-region VPCs

### Admin/runner access for panorama-init (SSH 22 + HTTPS 443).
### Set to your public IP. Find it: curl -s https://checkip.amazonaws.com
mgmt_allowed_cidrs = ["203.0.113.10/32"] # TODO: replace with your IP/32
