# Guide changes forced by the official-modules refactor

> **CORRECTION (2026-06-26):** items 9, 16, 17 below were written mid-debug and wrongly blamed the
> Panorama logging disk for the boot "hang." The real cause was a single-`/32` security group vs the
> runner's rotating corp egress IP (see item 17) — **the disk attachment via the official module's
> `ebs_volumes` works fine**, and `panorama_log_disk_gib = 2000` is the correct value (panorama-mode
> needs the logging disk). The fresh 12.1 image boots `management-only`; attach the disk + **reboot**
> and it auto-switches to `panorama` mode. The `variables.tf` default (0) and the "no dedicated disk"
> framing should be reverted to 2000 during the P5 cleanup. See HANDOVER-gwlb-refactor-2026-06-26.

Running list for Berg's review (decision #4). Every change the refactor forces in the lab guide
(`README.md`) versus the old build. The guide is the crown jewel, so each item notes what changes
and why. Structural items are settled; the P4 e2e pass may append more. Nothing here is applied to
`README.md` yet (that is P5).

## Settled (structural)

1. **GWLB inspection model -> subinterfaces + overlay routing.** The official `combined_design`
   model uses a single dataplane interface (`ethernet1/1`) with per-flow subinterfaces
   (`.11`/`.12` inbound, `.20` outbound, `.30` east-west) and `aws-gwlb-overlay-routing` +
   `advance-routing`, with the VPCE-to-subinterface mapping injected at bootstrap
   (`aws-gwlb-associate-vpce:<id>@<subif>`). The old base lab taught a single-zone model and left
   subinterfaces/overlay to advanced sections (4.19/4.20). The AWS-side routing exercises are
   preserved; the firewall-side config the guide walks changes. Affects roughly 4.8-4.20.

2. **Outbound egress via the firewall public interface, not a NAT gateway.** `combined_design`
   routes inspected outbound traffic out the firewall public interface to the IGW (the firewall
   does the egress); there is no NAT gateway. The old lab used NAT gateways in the security VPC.
   Removes the NAT-gateway setup + its routes from the guide.

3. **AZ-ID prose map removed.** The old guide hardcoded an AZ-name-to-AZ-ID mapping in prose (and
   baked the wrong answer into a check-your-understanding box). The refactor derives AZs from
   `data.aws_availability_zones` and uses `az_index` in tfvars. The guide must drop the AZ-ID map
   and the box, and explain az_index instead.

4. **Any-region generalization.** No hardcoded `us-east-1`/`us-west-2`. `region` (FW) +
   `panorama_region` are variables; the cross-region split is var-driven. The guide stops naming
   specific regions except as examples.

5. **Licensing is scripted, not click-through.** The old 4.7/4.8 manual Panorama UI steps (install
   plugin, create License Manager + bootstrap-definition, commit) become: run `panorama-init`
   (readiness, serial, optional cert, CSP key, plugin install) then `panorama-license-manager.py`
   (create DG + template-stack + LM + bootstrap-definition, COMMIT, verify, retrieve the `_AQ__`
   key, publish to SSM). The manual path can remain as an appendix for teaching.

6. **`sw_fw_license` plugin version.** Old guide said `1.1.2`; the working version is `1.2.3`
   (the deployed version is resolved against the running Panorama in P2).

7. **Remote state backend.** Students use an S3 + DynamoDB backend (a one-time `bootstrap` root),
   not local CloudShell state. This is the single biggest reliability fix (state survives
   CloudShell resets/timeouts). The guide adds the bootstrap step and `init -backend-config`.

8. **Execution environment.** Primary recommended path is a small runner EC2 (instance profile =
   the deploy role) + the S3 backend; CloudShell + the S3 backend is the documented constrained
   fallback. The old guide was CloudShell-only.

9. **Fresh public Marketplace Panorama image (no prepped golden AMI).** Eliminates the prepped-image
   failure class (panrepo too small, KMS-CMK cross-org sharing, version pinned below the FW). Costs
   it adds, now documented: ~15-20 min first boot, Marketplace subscription acceptance, and sizing
   (12.x Panorama = `m5.4xlarge`, 224 GB gp3 root from the AMI default).

   **Logging-disk gotcha (load-bearing).** A dedicated Panorama logging disk attached via the
   official module's `ebs_volumes` (a post-launch `aws_volume_attachment`) HANGS PAN-OS 12.1.7
   first boot: the mgmt plane never starts (CPU idle, console frozen at `eth0 link ready`, no SSH).
   Confirmed by isolation: with no disk the same image reaches the login prompt in ~3 min. The
   working hand-built 12.1.7 reference instead used an INLINE `ebs_block_device` (present in the
   launch block-device mapping, 1024 GiB, unencrypted) and booted fine. The canonical 11.2 lab uses
   NO dedicated disk and logs to `/opt/panlogs` on the root. So: default to **no dedicated log
   disk** (logs to the root partition); a dedicated disk is a tracked follow-up that must use the
   inline `ebs_block_device` method, which the official module does not expose (needs a module
   wrapper or a raw instance for Panorama).

10. **tfvars shape.** `az_index` (0/1) replaces `az` strings; `deploy_exercise_routes` gates the
    inspection-path routes (false = the student exercise; true = a fully-wired instructor/e2e env).
    The intentionally-omitted routes are now a single explicit switch instead of scattered
    commented blocks.

11. **Official Registry modules, pinned.** `PaloAltoNetworks/swfw-modules/aws` `2.2.7` via the
    Registry; the vendored `terraform/modules/` forks are retired. The guide stops referencing
    local module paths.

12. **Repo structure.** Three roots (`terraform/bootstrap`, `terraform/panorama`,
    `terraform/security-stack`) replace the old two-root `vmseries` + `panorama` split. Apply order
    is bootstrap -> panorama -> (Panorama init + license) -> security-stack.

13. **App hosts via SSM, no SSH key required.** Spoke app hosts use SSM Session Manager (the
    `showheaders.php` traffic tests run via `ssm send-command`). A break-glass firewall SSH key is
    generated by Terraform; Panorama keeps an SSH key because `panorama-init` requires SSH.

14. **First build = AIRS 12.1.6 firewalls / Panorama 12.1.7** (latest+greatest), versus the old
    11.2.x. 11.2.10-h6 / 11.2.12 remains the documented fallback pair.

## PAN-OS 12.1 Panorama provisioning (operational learnings from the live build)

Provisioning a fresh 12.1.7 Panorama differs from the prepped-image 11.2 lab in load-bearing ways:

15. **Bundled plugins (12.1).** Plugins ship bundled in the image; you install from the bundle
    (Panorama UI "Bundled Plugins", or `request plugins install <name>`). The old
    `request plugins download file <name>` path is **server-refused** with
    `Only Cloud Services plugin is allowed for download` on 12.1. panorama-init's plugin step
    (download-then-install) therefore fails on 12.1 and needs an install-from-bundle path
    (tracked: patch the vendored panorama-init or wrap it). The companion + guide assume the
    plugin is installed from the bundle.

16. **Panorama-mode needs a logging disk + a reboot.** A fresh 12.1 image boots
    `system-mode: management-only`. Attaching a logging disk (any supported size; the module's
    post-launch volume-attachment is fine) and **rebooting** makes PAN-OS auto-switch to
    `panorama` mode (the disk goes Present->Available, then panorama-mode on reboot).
    `request system system-mode panorama` fails while the disk is still being integrated; the
    reboot is the reliable trigger. (The earlier "disk hangs the boot" was a misdiagnosis — see
    item 17.)

17. **Connectivity, not Panorama, was the multi-day red herring.** The "boot hang / mgmt plane
    dead" symptoms were a **single-`/32` security group vs a rotating runner egress IP**: the
    runner's corp IP rotated out of the SG mid-session, so SSH/443 "timed out" (dropped, not
    refused) while Panorama was healthy. `get-console-output` is stale (caps ~283s; use
    `get-console-screenshot`), and a healthy idle Panorama sits at ~1% CPU (idle != stuck).
    Fix: allow the runner's stable range (or use the runner-EC2 with a fixed IP).

18. **Licensing sequence (12.1, no prepped image):** device cert via OTP
    (`request certificate fetch otp <otp>`, single-use/short-lived) -> `request license fetch`
    (pulls the Device-Management license if the serial is provisioned in CSP) -> install
    `sw_fw_license` from the bundle -> the License-Manager companion (DG + template-stack +
    bootstrap-definition + license-manager, commit, retrieve `_AQ__` key). The `sw_fw_license`
    config schema (verified): singular `bootstrap-definition`/`license-manager` nodes, `authcode`
    element, template-stack requires a `<settings>` element.

## Still to confirm during P4 e2e
- FW-side template/policy config for the three flows (zones, security policy, GWLB
  health-probe interface-mgmt-profile) — how much is bootstrap-driven vs needs Panorama push.
