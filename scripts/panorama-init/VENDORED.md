# Vendored: thresh97/panorama-init

Source: https://github.com/thresh97/panorama-init
Pinned commit: 8538db941a6aca51bccf7ce5cc155a9f5d6b2ec9
Vendored: 2026-06-24

Vendored (not a submodule) so students get an exact, self-contained pin with no `git submodule` step.
`panorama_init.py` is upstream-verbatim. See UPSTREAM-README.md for upstream docs.

## What it does (and does NOT do)
Gets a factory-default Panorama to "ready": SSH bootstrap (hostname, API password, initial commit),
set serial, fetch device cert via OTP, set CSP API key, content/AV updates, PAN-OS upgrade, INSTALL
plugins (incl. `sw_fw_license`), generate a generic VM auth key, HA, local log collector. Idempotent
via a `panorama-<ip>-state.json` file.

It does **NOT** create the License Manager / device-group / template-stack / bootstrap-definition,
commit them, or retrieve the LM `_AQ__` bootstrap key. That gap is filled by the companion
`../panorama-license-manager.py` (the licensing gate the FW apply depends on).
