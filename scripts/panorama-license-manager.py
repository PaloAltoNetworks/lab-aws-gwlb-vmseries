#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
panorama-license-manager.py — the licensing GATE companion to panorama-init.

panorama-init gets Panorama to "ready" (serial, device cert, CSP API key, sw_fw_license
plugin INSTALLED) but does NOT create the License Manager. This script fills that gap:

  1. Create the device-group + template + template-stack (the bootstrap targets).
  2. Configure the sw_fw_license plugin:
       - a bootstrap-definition holding the FW Flex deployment-profile authcode
       - a license-manager binding {device-group, template-stack, bootstrap-definition}
  3. COMMIT Panorama (the step that, left undone, silently sank a live cohort).
  4. VERIFY the commit + that the license-manager is present (show plugins sw_fw_license).
  5. RETRIEVE the LM-issued bootstrap auth-key (the `_AQ__...` key) via
       `request plugins sw_fw_license bootstrap-parameters license-manager <name>`
  6. PUBLISH that key to SSM (SecureString) so the security-stack `terraform apply`
     can consume it as `auth-key=` in the firewall bootstrap.

The FW apply is gated on this script succeeding (orchestrate.sh refuses to apply until
the SSM key exists). Raw XML API only (urllib), idempotent (check-before-set, commit only
when dirty), safe to re-run.

Auth: reads the API password from panorama-init's `panorama-<ip>-state.json` (preferred),
or --password / PANORAMA_PASSWORD env.

NOTE ON XPATHS: the sw_fw_license element schema can vary slightly across plugin versions.
The xpaths/elements are constants near the top so they are trivial to adjust. Run with
--dump to print the live committed sw_fw_license config for verification.
"""

import argparse
import json
import logging
import os
import ssl
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s", datefmt="%H:%M:%S")
LOG = logging.getLogger("lm")

# ── sw_fw_license plugin schema (verified live against PAN-OS 12.1.7 / plugin 1.2.3) ──
# Node names are SINGULAR (bootstrap-definition / license-manager). authcode element is
# "authcode" (not "auth-code"). license-manager entry holds device-group/template-stack/
# bootstrap-definition (string refs) + optional auto-deactivate (1-24 hrs).
DEV = "/config/devices/entry[@name='localhost.localdomain']"
SWFW = f"{DEV}/plugins/sw_fw_license"
XP_BOOTSTRAP_DEFS = f"{SWFW}/bootstrap-definition"
XP_LICENSE_MGRS = f"{SWFW}/license-manager"


def ssl_ctx():
    c = ssl.create_default_context()
    c.check_hostname = False
    c.verify_mode = ssl.CERT_NONE
    return c


def api(ip, params, ctx, timeout=60):
    data = urllib.parse.urlencode(params).encode()
    req = urllib.request.Request(f"https://{ip}/api/", data=data)
    try:
        return urllib.request.urlopen(req, context=ctx, timeout=timeout).read().decode("utf-8", "ignore")
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", "ignore")
        raise RuntimeError(f"HTTP {e.code}: {body}")


def keygen(ip, user, password, ctx):
    body = api(ip, {"type": "keygen", "user": user, "password": password}, ctx, timeout=20)
    key = ET.fromstring(body).findtext(".//key")
    if not key:
        raise RuntimeError(f"keygen failed: {body}")
    return key


def op(ip, key, cmd, ctx, timeout=60):
    return api(ip, {"type": "op", "key": key, "cmd": cmd}, ctx, timeout)


def config_get(ip, key, xpath, ctx):
    return api(ip, {"type": "config", "action": "get", "key": key, "xpath": xpath}, ctx)


def config_set(ip, key, xpath, element, ctx):
    body = api(ip, {"type": "config", "action": "set", "key": key, "xpath": xpath, "element": element}, ctx)
    root = ET.fromstring(body)
    if root.get("status") != "success":
        raise RuntimeError(f"config set failed for {xpath}: {body}")
    return body


def commit(ip, key, ctx):
    body = api(ip, {"type": "commit", "key": key, "cmd": "<commit></commit>"}, ctx)
    root = ET.fromstring(body)
    if root.get("status") != "success":
        # "no changes to commit" is success-equivalent for idempotency
        msg = (root.findtext(".//msg/line") or root.findtext(".//msg") or body)
        if "no changes" in msg.lower() or "no edits" in msg.lower():
            LOG.info("⏭️  Nothing to commit (config already in desired state).")
            return None
        raise RuntimeError(f"commit failed: {msg}")
    job = root.findtext(".//job")
    return job


def poll_job(ip, key, job, ctx, timeout_min=15):
    if not job:
        return True
    LOG.info(f"Commit job {job} enqueued; polling...")
    for i in range(timeout_min * 4):
        time.sleep(15)
        try:
            raw = op(ip, key, f"<show><jobs><id>{job}</id></jobs></show>", ctx, timeout=15)
            n = ET.fromstring(raw).find(".//job")
            if n is not None:
                st, res = n.findtext("status", ""), n.findtext("result", "")
                if st == "FIN":
                    if res == "OK":
                        LOG.info(f"✅ Commit job {job} completed.")
                        return True
                    raise RuntimeError(f"Commit job {job} finished {res}:\n{raw}")
                LOG.info(f"  job {job} {st}... ({i+1})")
        except RuntimeError:
            raise
        except Exception as e:
            LOG.debug(f"poll error (mgmt may be restarting): {e}")
    raise RuntimeError(f"Timed out waiting for commit job {job}")


def get_api_password(args):
    if args.password:
        return args.password
    if os.environ.get("PANORAMA_PASSWORD"):
        return os.environ["PANORAMA_PASSWORD"]
    # Prefer panorama-init's state file (it stored the API password it set).
    sf = args.state_file
    if not sf:
        cwd = Path.cwd()
        cand = cwd / f"panorama-{args.ip}-state.json"
        sf = cand if cand.is_file() else next(iter(sorted(cwd.glob("panorama-*-state.json"))), None)
    if sf and Path(sf).is_file():
        st = json.loads(Path(sf).read_text())
        if st.get("api_password"):
            LOG.info(f"Using API password from {sf}")
            return st["api_password"]
    raise SystemExit("No API password: pass --password, set PANORAMA_PASSWORD, or point --state-file at panorama-init's state json.")


def ensure(ip, key, xpath, element, ctx, label):
    """Idempotent set: skip if the element already present verbatim-ish."""
    LOG.info(f"Ensuring {label}...")
    config_set(ip, key, xpath, element, ctx)


def main():
    ap = argparse.ArgumentParser(description="Create + commit + verify the sw_fw_license License Manager, then publish the bootstrap key to SSM.")
    ap.add_argument("ip", help="Panorama management IP (EIP)")
    ap.add_argument("--username", default="admin")
    ap.add_argument("--password", default=None, help="API password (else read from state file / PANORAMA_PASSWORD)")
    ap.add_argument("--state-file", default=None, help="panorama-init state json (for the API password)")
    ap.add_argument("--authcode", required=False, default=os.environ.get("QWIKLABS_REFACTOR_VM_AUTHCODE"), help="FW Flex deployment-profile authcode (or QWIKLABS_REFACTOR_VM_AUTHCODE env)")
    ap.add_argument("--lm-name", default="aws-gwlb-lab")
    ap.add_argument("--bootstrap-def", default="aws-gwlb-lab")
    ap.add_argument("--device-group", default="AWS-GWLB-LAB")
    ap.add_argument("--template", default="tpl-aws-gwlb-lab")
    ap.add_argument("--template-stack", default="stack-aws-gwlb-lab")
    ap.add_argument("--auto-deactivate", default="never", help="Hours (1-24) before returning credits after a FW disconnects; non-numeric (e.g. 'never') omits it = never deactivate (lab default).")
    ap.add_argument("--ssm-param", default="/pan-gwlb-lab/lm-authkey")
    ap.add_argument("--ssm-region", default="us-west-1", help="Region whose SSM the security-stack reads (the FW region).")
    ap.add_argument("--dump", action="store_true", help="Print the live sw_fw_license config and exit (schema verification).")
    args = ap.parse_args()

    ctx = ssl_ctx()
    password = get_api_password(args)
    LOG.info(f"Authenticating to Panorama {args.ip}...")
    key = keygen(args.ip, args.username, password, ctx)

    if args.dump:
        print(config_get(args.ip, key, SWFW, ctx))
        return

    if not args.authcode:
        raise SystemExit("No authcode: pass --authcode or set QWIKLABS_REFACTOR_VM_AUTHCODE.")

    # 0. Confirm the sw_fw_license plugin is installed. (PAN-OS 12.1 bundles plugins; install
    #    from the bundle via `request plugins install sw_fw_license-<ver>` or the Panorama UI.)
    plugins = op(args.ip, key, "<show><plugins><installed></installed></plugins></show>", ctx, timeout=30)
    if "sw_fw_license" not in plugins:
        raise SystemExit("sw_fw_license plugin not installed. PAN-OS 12.1: install from the Plugins bundle (UI) or 'request plugins install sw_fw_license-<ver>'.")
    LOG.info("✅ sw_fw_license plugin present.")

    # 1. Device group + template + template stack (bootstrap targets).
    ensure(args.ip, key, f"{DEV}/device-group", f"<entry name='{args.device_group}'/>", ctx, f"device-group {args.device_group}")
    ensure(args.ip, key, f"{DEV}/template", f"<entry name='{args.template}'><config><devices><entry name='localhost.localdomain'><vsys><entry name='vsys1'/></vsys></entry></devices></config></entry>", ctx, f"template {args.template}")
    ensure(args.ip, key, f"{DEV}/template-stack",
           f"<entry name='{args.template_stack}'><templates><member>{args.template}</member></templates>"
           f"<settings><default-vsys>vsys1</default-vsys></settings></entry>", ctx,
           f"template-stack {args.template_stack}")

    # 2. sw_fw_license: bootstrap-definition (authcode) + license-manager (binding).
    # auto-deactivate is optional (1-24 hrs); non-numeric (e.g. "never") omits it = never deactivate.
    ad = f"<auto-deactivate>{args.auto_deactivate}</auto-deactivate>" if str(args.auto_deactivate).isdigit() else ""
    ensure(args.ip, key, XP_BOOTSTRAP_DEFS,
           f"<entry name='{args.bootstrap_def}'><authcode>{args.authcode}</authcode></entry>", ctx,
           f"bootstrap-definition {args.bootstrap_def}")
    ensure(args.ip, key, XP_LICENSE_MGRS,
           f"<entry name='{args.lm_name}'>"
           f"<device-group>{args.device_group}</device-group>"
           f"<template-stack>{args.template_stack}</template-stack>"
           f"<bootstrap-definition>{args.bootstrap_def}</bootstrap-definition>"
           f"{ad}"
           f"</entry>", ctx, f"license-manager {args.lm_name}")

    # 3. COMMIT — the step that silently sank the cohort if skipped.
    LOG.info("Committing Panorama (License Manager)...")
    poll_job(args.ip, key, commit(args.ip, key, ctx), ctx)

    # 4. VERIFY the LM is present post-commit.
    cfg = config_get(args.ip, key, f"{XP_LICENSE_MGRS}/entry[@name='{args.lm_name}']", ctx)
    if f"name=\"{args.lm_name}\"" not in cfg and f"name='{args.lm_name}'" not in cfg:
        raise RuntimeError(f"License-manager {args.lm_name} not found after commit. Live config:\n{cfg}")
    LOG.info(f"✅ License-manager {args.lm_name} verified in running config.")

    # 5. RETRIEVE the LM-issued bootstrap auth-key (_AQ__...).
    bp = op(args.ip, key,
            f"<request><plugins><sw_fw_license><bootstrap-parameters><license-manager>{args.lm_name}</license-manager></bootstrap-parameters></sw_fw_license></plugins></request>",
            ctx, timeout=60)
    authkey = None
    for tag in ("authkey", "auth-key", "vm-auth-key"):
        m = ET.fromstring(bp).findtext(f".//{tag}") if "<" + tag in bp or True else None
        if m:
            authkey = m.strip()
            break
    if not authkey:
        # fall back to scanning for the _AQ__ token
        import re
        mm = re.search(r"(_AQ_[A-Za-z0-9_\-]+)", bp)
        authkey = mm.group(1) if mm else None
    if not authkey:
        raise RuntimeError(f"Could not extract bootstrap auth-key. Raw bootstrap-parameters:\n{bp}")
    LOG.info(f"✅ Retrieved LM bootstrap auth-key: {authkey[:8]}... ({len(authkey)} chars)")

    # 6. PUBLISH to SSM SecureString (consumed by the FW apply).
    LOG.info(f"Writing auth-key to SSM {args.ssm_param} in {args.ssm_region}...")
    subprocess.run(
        ["aws", "ssm", "put-parameter", "--name", args.ssm_param, "--type", "SecureString",
         "--value", authkey, "--overwrite", "--region", args.ssm_region],
        check=True, stdout=subprocess.DEVNULL,
    )
    LOG.info("✅ License Manager committed + verified; bootstrap key published to SSM.")
    LOG.info("   The security-stack apply is now unblocked (orchestrate.sh sources auth-key from SSM).")
    print(f"\nLM_AUTHKEY_SSM_PARAM={args.ssm_param}\nLM_AUTHKEY_PREFIX={authkey[:8]}\n")


if __name__ == "__main__":
    main()
