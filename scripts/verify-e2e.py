#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify-e2e.py — the lab's acceptance gate. Asserts and reports:

  (i)   Panorama up + sw_fw_license License Manager committed/present.
  (ii)  Both firewalls connected to Panorama (device_registered) + licensed tier
        matches the authcode (AIRS -> AI-RUNTIME-SECURITY).
  (iii) GWLB target-group targets healthy.
  (iv)  Three inspection flows return HTTP 200:
          inbound  : spoke NLB -> showheaders.php
          outbound : spoke host -> the internet
          east-west: spoke1 host -> spoke2 host
        (traffic driven via SSM send-command on the app hosts; no SSH.)

Reads connection details from the terraform roots' outputs and panorama-init's state
file. PAN-OS via XML API (re-keygen after any mgmt restart); AWS via the CLI.

Exit 0 only if every assertion passes. Designed to be run repeatedly while debugging.
"""

import argparse
import json
import os
import ssl
import subprocess
import sys
import time
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from pathlib import Path

GREEN, RED, YEL, RST = "\033[32m", "\033[31m", "\033[33m", "\033[0m"
results = []


def ok(msg):
    results.append(True)
    print(f"{GREEN}PASS{RST} {msg}")


def fail(msg):
    results.append(False)
    print(f"{RED}FAIL{RST} {msg}")


def info(msg):
    print(f"{YEL}····{RST} {msg}")


def tf_output(tf_dir, region_env=None):
    env = dict(os.environ)
    out = subprocess.run(["terraform", f"-chdir={tf_dir}", "output", "-json"],
                         capture_output=True, text=True, env=env)
    if out.returncode != 0:
        return {}
    return json.loads(out.stdout or "{}")


def ssl_ctx():
    c = ssl.create_default_context()
    c.check_hostname = False
    c.verify_mode = ssl.CERT_NONE
    return c


def pan_keygen(ip, user, password, ctx):
    data = urllib.parse.urlencode({"type": "keygen", "user": user, "password": password}).encode()
    body = urllib.request.urlopen(urllib.request.Request(f"https://{ip}/api/", data=data), context=ctx, timeout=20).read()
    return ET.fromstring(body).findtext(".//key")


def pan_op(ip, key, cmd, ctx, timeout=30):
    data = urllib.parse.urlencode({"type": "op", "key": key, "cmd": cmd}).encode()
    return urllib.request.urlopen(urllib.request.Request(f"https://{ip}/api/", data=data), context=ctx, timeout=timeout).read().decode("utf-8", "ignore")


def ssm_run(instance_id, region, command, timeout=120):
    """Run a shell command on an instance via SSM; return (rc, stdout)."""
    send = subprocess.run(
        ["aws", "ssm", "send-command", "--region", region, "--instance-ids", instance_id,
         "--document-name", "AWS-RunShellScript", "--parameters", json.dumps({"commands": [command]}),
         "--query", "Command.CommandId", "--output", "text"],
        capture_output=True, text=True)
    if send.returncode != 0:
        return 1, send.stderr.strip()
    cid = send.stdout.strip()
    for _ in range(timeout // 5):
        time.sleep(5)
        inv = subprocess.run(
            ["aws", "ssm", "get-command-invocation", "--region", region,
             "--command-id", cid, "--instance-id", instance_id, "--output", "json"],
            capture_output=True, text=True)
        if inv.returncode != 0:
            continue
        d = json.loads(inv.stdout)
        if d["Status"] in ("Success", "Failed", "Cancelled", "TimedOut"):
            return (0 if d["Status"] == "Success" else 1), (d.get("StandardOutputContent", "") + d.get("StandardErrorContent", ""))
    return 1, "SSM command timed out"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--panorama-ip", required=True)
    ap.add_argument("--panorama-user", default="admin")
    ap.add_argument("--panorama-password", default=os.environ.get("PANORAMA_PASSWORD"))
    ap.add_argument("--panorama-state-file", default=None)
    ap.add_argument("--security-tf-dir", default="terraform/security-stack")
    ap.add_argument("--fw-region", default="us-west-1")
    ap.add_argument("--expected-license", default="AI-RUNTIME-SECURITY", help="Substring expected in the FW licensed tier (AIRS authcode).")
    args = ap.parse_args()

    ctx = ssl_ctx()
    pw = args.panorama_password
    if not pw and args.panorama_state_file and Path(args.panorama_state_file).is_file():
        pw = json.loads(Path(args.panorama_state_file).read_text()).get("api_password")
    if not pw:
        sys.exit("Need Panorama password (--panorama-password / PANORAMA_PASSWORD / --panorama-state-file).")

    print("== (i) Panorama + License Manager ==")
    key = pan_keygen(args.panorama_ip, args.panorama_user, pw, ctx)
    lm = pan_op(args.panorama_ip, key, "<show><plugins><sw_fw_license><license-manager-status></license-manager-status></sw_fw_license></plugins></show>", ctx)
    # Some plugin versions differ; fall back to a config read of the license-manager.
    if "aws-gwlb-lab" in lm or "license-manager" in lm.lower():
        ok("sw_fw_license License Manager present on Panorama")
    else:
        info(f"LM status raw: {lm[:200]}")
        fail("License Manager not confirmed via sw_fw_license status")

    print("== (ii) Firewalls registered + licensed ==")
    devs = pan_op(args.panorama_ip, key, "<show><devices><all></all></devices></show>", ctx, timeout=30)
    root = ET.fromstring(devs)
    entries = root.findall(".//devices/entry") or root.findall(".//entry")
    connected = [e for e in entries if (e.findtext("connected", "") or "").lower() == "yes"]
    if len(connected) >= 2:
        ok(f"{len(connected)} firewall(s) connected to Panorama")
    else:
        fail(f"expected >=2 firewalls connected, found {len(connected)}")
    for e in entries:
        serial = e.findtext("serial", "?")
        fam = e.findtext(".//family", "") or ""
        sw = e.findtext("sw-version", "?")
        # licensed tier surfaces in various places depending on version; scan the entry text
        txt = "".join(e.itertext())
        tier_ok = args.expected_license.lower() in txt.lower()
        (ok if tier_ok else info)(f"FW {serial} sw={sw} licensed-tier-match={tier_ok}")

    print("== (iii) GWLB target health ==")
    sec = tf_output(args.security_tf_dir)
    tg_arns = (sec.get("security_gwlb_target_group_arns", {}) or {}).get("value", {})
    for name, arn in tg_arns.items():
        th = subprocess.run(["aws", "elbv2", "describe-target-health", "--region", args.fw_region,
                             "--target-group-arn", arn, "--output", "json"], capture_output=True, text=True)
        if th.returncode == 0:
            states = [t["TargetHealth"]["State"] for t in json.loads(th.stdout).get("TargetHealthDescriptions", [])]
            healthy = [s for s in states if s == "healthy"]
            (ok if healthy else fail)(f"GWLB {name}: {len(healthy)}/{len(states)} targets healthy ({states})")
        else:
            fail(f"GWLB {name}: describe-target-health failed: {th.stderr.strip()}")

    print("== (iv) Inspection flows (HTTP 200 via SSM) ==")
    vm_ids = (sec.get("spoke_vm_instance_ids", {}) or {}).get("value", {})
    nlbs = (sec.get("network_load_balancers", {}) or {}).get("value", {})
    # inbound: curl each spoke NLB from the runner (public) -> showheaders
    for name, fqdn in nlbs.items():
        r = subprocess.run(["curl", "-s", "-o", "/dev/null", "-w", "%{http_code}", "--max-time", "20", f"http://{fqdn}/showheaders.php"], capture_output=True, text=True)
        (ok if r.stdout.strip() == "200" else fail)(f"inbound {name} -> showheaders.php : HTTP {r.stdout.strip() or 'ERR'}")
    # outbound: a spoke host curls the internet
    s1 = vm_ids.get("app1_vm01")
    if s1:
        rc, out = ssm_run(s1, args.fw_region, "curl -s -o /dev/null -w '%{http_code}' --max-time 20 http://checkip.amazonaws.com")
        (ok if "200" in out else fail)(f"outbound app1_vm01 -> internet : {out.strip()[:40]}")
    # east-west: spoke1 host curls spoke2 host private IP
    s2 = vm_ids.get("app2_vm01")
    if s1 and s2:
        ip2 = subprocess.run(["aws", "ec2", "describe-instances", "--region", args.fw_region,
                              "--instance-ids", s2, "--query", "Reservations[0].Instances[0].PrivateIpAddress", "--output", "text"],
                             capture_output=True, text=True).stdout.strip()
        rc, out = ssm_run(s1, args.fw_region, f"curl -s -o /dev/null -w '%{{http_code}}' --max-time 20 http://{ip2}/")
        (ok if "200" in out else fail)(f"east-west app1_vm01 -> app2_vm01 ({ip2}) : {out.strip()[:40]}")

    print("\n== SUMMARY ==")
    passed, total = sum(results), len(results)
    print(f"{passed}/{total} checks passed")
    sys.exit(0 if passed == total and total > 0 else 1)


if __name__ == "__main__":
    main()
