#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Panorama Virtual VM Initial Provisioning CLI 🚀

A Python CLI tool to idempotently bootstrap and provision a Palo Alto Networks
Panorama Virtual Machine.

Features:
  - Connects via SSH (Key-based by default, falls back to password from ENV).
  - Tracks progress in a JSON state file for idempotency.
  - Waits for system readiness (Panorama can take a while to boot).
  - Performs initial configuration (e.g., setting hostname, committing).
  - Configures an API password, applies a serial number, and fetches a device certificate via XML API.
  - Configures the CSP Licensing API key.
  - Upgrades Content and Anti-Virus definitions to the latest versions.
  - Upgrades PAN-OS to a specified target version with full reboot handling.
  - Downloads and installs specified Panorama plugins.
  - Generates and tracks a VM Auth Key for bootstrapping managed devices.

Prerequisites:
  - Python 3.7+
  - Required package: `paramiko`
    (install with: pip install paramiko)

Usage Examples:

# Basic usage (defaults to admin and ~/.ssh/id_rsa)
python panorama_provision.py 192.168.1.100

# Specify custom username, SSH key, serial number, and OTP
python panorama_provision.py 10.0.0.50 --username pantech --ssh-key ~/.ssh/custom_key --serial-number 000710008449 --otp 123456

# Set CSP API Key, upgrade content and AV after bootstrapping
python panorama_provision.py 10.0.0.50 --csp-api-key 043062840... --upgrade-content --upgrade-av

# Upgrade PAN-OS to a specific version
python panorama_provision.py 10.0.0.50 --upgrade-panos 11.2.8

# Upgrade PAN-OS to the latest in the current major.minor family
python panorama_provision.py 10.0.0.50 --upgrade-panos latest

# Generate a VM Auth Key with a custom lifetime (omitting --vm-auth-key skips key generation)
python panorama_provision.py 10.0.0.50 --vm-auth-key 4380

# Install specific plugins
python panorama_provision.py 10.0.0.50 --plugins vm_series-3.0.0,aws-5.4.3

# Enable verbose XML debugging
python panorama_provision.py 10.0.0.50 --upgrade-content --debug
"""

import argparse
import json
import logging
import os
import sys
import time
import secrets
import string
import ssl
import re
import urllib.request
import urllib.parse
import urllib.error
import xml.etree.ElementTree as ET
from pathlib import Path

import paramiko

# --- Configuration ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
LOGGER = logging.getLogger(__name__)

# Reduce paramiko logging noise
logging.getLogger("paramiko").setLevel(logging.WARNING)

# Canonical XML command for system info — used in multiple places.
# Fix #1: Use <system> not <s> throughout.
_CMD_SHOW_SYSTEM_INFO = "<show><system><info/></system></show>"

import ipaddress as _ipaddress

def _is_rfc1918(ip_str: str) -> bool:
    """Return True if ip_str is a private (RFC1918) address."""
    try:
        addr = _ipaddress.ip_address(ip_str)
        return any(addr in net for net in (
            _ipaddress.ip_network('10.0.0.0/8'),
            _ipaddress.ip_network('172.16.0.0/12'),
            _ipaddress.ip_network('192.168.0.0/16'),
        ))
    except ValueError:
        return False


# Connection drop signatures that indicate an intentional server restart,
# not a true failure. Defined once and reused across all retry loops.
# Fix #12: Centralise this constant instead of redefining it in each step.
_EXPECTED_DISCONNECT_ERRORS = [
    "connection reset",
    "remotedisconnected",
    "eof occurred",
    "timed out",
    "remote end closed connection",
    "connection refused",
    "network is down",   # errno 50 — Panorama drops connection immediately after serial set
    "errno 50",
]


def _is_expected_disconnect(exc: Exception) -> bool:
    """Returns True if the exception looks like an intentional server restart."""
    return any(msg in str(exc).lower() for msg in _EXPECTED_DISCONNECT_ERRORS)


def _make_ssl_ctx() -> ssl.SSLContext:
    """
    Creates and returns a permissive SSL context suitable for Panorama's
    self-signed management certificate.
    Fix #12: Extracted into a named helper so ctx creation is never inline-duplicated.
    """
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    return ctx


# --- State Management ---
def _discover_state_file(ip: str) -> Path:
    """
    Resolves the state file path when --state-file is not specified and the default
    panorama-<ip>-state.json does not exist in the current directory.

    - Zero candidates found  → return the default path (will start fresh).
    - Exactly one candidate whose IP matches  → warn and return it.
    - Exactly one candidate whose IP does NOT match  → return default (start fresh).
    - Multiple candidates  → prompt the user to pick one or start fresh.
    """
    cwd = Path.cwd()
    default = (cwd / f"panorama-{ip}-state.json").resolve()

    if default.is_file():
        return default

    candidates = sorted(cwd.glob("panorama-*-state.json"))

    if not candidates:
        return default

    def _extract_ip(p: Path) -> str:
        # filename: panorama-<ip>-state.json  →  stem: panorama-<ip>-state
        stem = p.stem  # e.g. "panorama-10.0.0.1-state"
        return stem[len("panorama-"):-len("-state")]

    if len(candidates) == 1:
        candidate = candidates[0]
        if _extract_ip(candidate) == ip:
            LOGGER.warning(
                f"No state file found for '{ip}', but '{candidate.name}' matches "
                f"the target IP. Using it to resume from a previous run."
            )
            return candidate.resolve()
        return default  # Single file, wrong IP — start fresh

    # Multiple candidates — prompt the user
    print(
        f"\nNo state file found for IP '{ip}', but {len(candidates)} state file(s) "
        f"exist in the current directory:"
    )
    for i, f in enumerate(candidates, 1):
        match_tag = "  ← IP matches!" if _extract_ip(f) == ip else ""
        print(f"  [{i}] {f.name}{match_tag}")
    print( "  [0] Start fresh (ignore all state files)")

    while True:
        try:
            raw = input(f"Select a state file to use [0-{len(candidates)}]: ").strip()
            choice = int(raw)
        except (ValueError, EOFError):
            print(f"  Please enter a number between 0 and {len(candidates)}.")
            continue
        if choice == 0:
            return default
        if 1 <= choice <= len(candidates):
            selected = candidates[choice - 1].resolve()
            LOGGER.warning(f"Using state file: {selected.name}")
            return selected
        print(f"  Please enter a number between 0 and {len(candidates)}.")


def load_state(state_file_path: Path) -> dict:
    """Loads the deployment state from a file."""
    if not state_file_path.is_file():
        LOGGER.info(f"State file {state_file_path} not found. Starting fresh.")
        return {}
    with state_file_path.open("r") as f:
        return json.load(f)


def save_state(state_file_path: Path, state: dict):
    """Saves the deployment state to a file."""
    with state_file_path.open("w") as f:
        json.dump(state, f, indent=2)
    LOGGER.debug(f"State saved to {state_file_path}")


# --- API Helpers ---
def _send_op_command(ip, api_key, ctx, cmd_xml, timeout=60):
    """Sends a synchronous OP command and returns the raw response body."""
    LOGGER.debug(f"XML Request: {cmd_xml}")
    op_data = urllib.parse.urlencode({'type': 'op', 'key': api_key, 'cmd': cmd_xml}).encode('utf-8')
    req = urllib.request.Request(f"https://{ip}/api/", data=op_data)
    try:
        res = urllib.request.urlopen(req, context=ctx, timeout=timeout)
        response_body = res.read().decode('utf-8', errors='ignore')
        LOGGER.debug(f"XML Response: {response_body}")
        return response_body
    except urllib.error.HTTPError as e:
        # Catch HTTP 400 Bad Request and print the raw XML error reason so it doesn't get swallowed
        error_body = e.read().decode('utf-8', errors='ignore')
        LOGGER.debug(f"HTTP Error {e.code} Response: {error_body}")
        raise RuntimeError(f"HTTP {e.code} {e.reason}: {error_body}")


def _send_op_job_command(ip, api_key, ctx, cmd_xml, timeout=30):
    """Sends an asynchronous OP command, extracts, and returns the Job ID."""
    raw_res = _send_op_command(ip, api_key, ctx, cmd_xml, timeout)
    try:
        response_xml = ET.fromstring(raw_res)

        # Check for error status
        if response_xml.get('status') == 'error':
            msg = response_xml.findtext(".//msg/line", default=raw_res)
            raise RuntimeError(f"API Error: {msg}")

        job_id_elem = response_xml.find(".//job")
        if job_id_elem is None or not job_id_elem.text:
            msg = response_xml.findtext(".//msg/line", default="")
            LOGGER.info(f"No job returned by system (might be already installed/up-to-date). Msg: {msg}")
            return None

        return job_id_elem.text
    except ET.ParseError:
        raise RuntimeError(f"Invalid XML response: {raw_res}")


def _is_already_latest(check_response: str, label: str):
    """
    Parses a content/AV upgrade check response.
    Returns (True, version_str) if the installed version is already the latest,
    or (False, "") if an update is available or the response could not be parsed.
    Looks for an entry where both <current>yes</current> and <latest>yes</latest>.
    """
    try:
        root = ET.fromstring(check_response)
        for entry in root.findall(".//entry"):
            current = entry.findtext("current", default="no").strip().lower()
            latest = entry.findtext("latest", default="no").strip().lower()
            if current == "yes" and latest == "yes":
                version = entry.findtext("version", default="unknown")
                LOGGER.info(f"✅ {label} is already at the latest version ({version}). Skipping download/install.")
                return True, version
    except ET.ParseError:
        LOGGER.debug(f"Could not parse {label} check response. Proceeding with update.")
    return False, ""


def poll_panorama_job(ip, api_key, ctx, job_id, job_name, timeout_mins=20):
    """Polls a Panorama Job ID until completion or failure."""
    if not job_id:
        LOGGER.info(f"✅ {job_name} skipped (likely already downloaded/installed).")
        return True

    LOGGER.info(f"Job {job_id} enqueued for {job_name}. Polling status...")
    max_attempts = timeout_mins * 4  # 15s intervals
    for attempt in range(max_attempts):
        time.sleep(15)
        try:
            job_cmd = f"<show><jobs><id>{job_id}</id></jobs></show>"
            job_raw = _send_op_command(ip, api_key, ctx, job_cmd, timeout=10)

            try:
                root = ET.fromstring(job_raw)

                # Check for structured XML first (Newer PAN-OS versions)
                job_node = root.find('.//job')
                if job_node is not None:
                    status = job_node.findtext('status', default='')
                    res_val = job_node.findtext('result', default='')
                    if status == 'FIN' and res_val == 'OK':
                        LOGGER.info(f"✅ Job {job_id} ({job_name}) completed successfully!")
                        return True
                    elif status == 'FIN' and res_val == 'FAIL':
                        # Check for benign failure: Already downloaded
                        if "Image exists already" in job_raw:
                            LOGGER.info(f"✅ Job {job_id} ({job_name}) skipped: Image exists already.")
                            return True
                        LOGGER.error(f"Job {job_id} ({job_name}) failed. Raw output:\n{job_raw}")
                        raise RuntimeError(f"Job {job_id} failed.")
                    else:
                        LOGGER.info(f"Job {job_id} ({job_name}) processing (status: {status})... (Attempt {attempt+1}/{max_attempts})")
                        continue

                # Fallback to plaintext table parsing (Older PAN-OS versions)
                result_text = root.findtext('.//result', default=job_raw)
            except ET.ParseError:
                result_text = job_raw

            # Replace non-breaking spaces with standard spaces
            if result_text:
                result_text = result_text.replace('\xa0', ' ')
            else:
                result_text = ""

            if re.search(r'FIN\s+OK', result_text):
                LOGGER.info(f"✅ Job {job_id} ({job_name}) completed successfully!")
                return True
            elif re.search(r'FIN\s+FAIL', result_text):
                # Check for benign failure: Already downloaded
                if "Image exists already" in job_raw:
                    LOGGER.info(f"✅ Job {job_id} ({job_name}) skipped: Image exists already.")
                    return True
                LOGGER.error(f"Job {job_id} ({job_name}) failed. Raw output:\n{result_text}")
                raise RuntimeError(f"Job {job_id} failed.")
            else:
                LOGGER.info(f"Job {job_id} ({job_name}) processing... (Attempt {attempt+1}/{max_attempts})")
        except RuntimeError:
            raise
        except Exception as e:
            LOGGER.debug(f"Connection error while polling (expected if mgmtsrvr restarting): {e}")

    raise RuntimeError(f"Timed out waiting for job {job_id} ({job_name}).")


# ---------------------------------------------------------------------------
# HA SETUP HELPERS
# ---------------------------------------------------------------------------

def _keygen(ip: str, username: str, password: str, ctx) -> str:
    """Fetch an XML API key via username/password credentials."""
    data = urllib.parse.urlencode({
        'type': 'keygen',
        'user': username,
        'password': password,
    }).encode('utf-8')
    LOGGER.debug(f"Keygen request for {username}@{ip}")
    req = urllib.request.Request(f"https://{ip}/api/", data=data)
    res = urllib.request.urlopen(req, context=ctx, timeout=15)
    body = res.read().decode('utf-8')
    LOGGER.debug(f"Keygen response: {body}")
    key = ET.fromstring(body).findtext('.//key')
    if not key:
        raise RuntimeError(f"Keygen failed for {ip}: {body}")
    return key


def _send_config_set(ip: str, api_key: str, ctx, xpath: str, element: str, timeout: int = 30) -> str:
    """Send a type=config&action=set command via the XML API. Returns raw XML response."""
    data = urllib.parse.urlencode({
        'type':    'config',
        'action':  'set',
        'key':     api_key,
        'xpath':   xpath,
        'element': element,
    }).encode('utf-8')
    LOGGER.debug(f"Config Set — xpath: {xpath}  element: {element}")
    req = urllib.request.Request(f"https://{ip}/api/", data=data)
    try:
        res = urllib.request.urlopen(req, context=ctx, timeout=timeout)
        body = res.read().decode('utf-8')
        LOGGER.debug(f"Config Set Response: {body}")
        root = ET.fromstring(body)
        if root.get('status') != 'success':
            raise RuntimeError(f"Config set failed: {body}")
        return body
    except urllib.error.HTTPError as e:
        err = e.read().decode('utf-8')
        LOGGER.debug(f"Config Set HTTP Error: {err}")
        raise RuntimeError(f"Config set HTTP {e.code}: {err}")


def _send_api_commit(ip: str, api_key: str, ctx, timeout: int = 30):
    """Send a type=commit command via the XML API. Returns job ID or None."""
    data = urllib.parse.urlencode({
        'type': 'commit',
        'key':  api_key,
        'cmd':  '<commit></commit>',
    }).encode('utf-8')
    LOGGER.debug(f"API commit request for {ip}")
    req = urllib.request.Request(f"https://{ip}/api/", data=data)
    try:
        res = urllib.request.urlopen(req, context=ctx, timeout=timeout)
        body = res.read().decode('utf-8')
        LOGGER.debug(f"Commit Response: {body}")
        root = ET.fromstring(body)
        if root.get('status') != 'success':
            raise RuntimeError(f"Commit failed: {root.findtext('.//msg') or body}")
        job_elem = root.find('.//job')
        return job_elem.text if job_elem is not None else None
    except urllib.error.HTTPError as e:
        err = e.read().decode('utf-8')
        LOGGER.debug(f"Commit HTTP Error: {err}")
        raise RuntimeError(f"Commit HTTP {e.code}: {err}")


def _get_private_ip(ip: str, api_key: str, ctx) -> str:
    """Return the private management IP of a Panorama node from show system info."""
    raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=15)
    private_ip = ET.fromstring(raw).findtext('.//ip-address')
    if not private_ip or private_ip.lower() == 'unknown':
        raise RuntimeError(f"Could not determine private management IP for {ip}")
    return private_ip


def _poll_ha_state(ip: str, api_key: str, ctx, expected_state: str, timeout_mins: int = 5):
    """Poll HA state until the node reports expected_state ('active' or 'passive')."""
    cmd = "<show><high-availability><state/></high-availability></show>"
    max_attempts = timeout_mins * 4  # 15s intervals
    LOGGER.info(f"Polling HA state on {ip} — expecting: {expected_state}")
    for attempt in range(max_attempts):
        time.sleep(15)
        try:
            raw = _send_op_command(ip, api_key, ctx, cmd, timeout=15)
            state = ET.fromstring(raw).findtext('.//local-info/state') or \
                    ET.fromstring(raw).findtext('.//state')
            LOGGER.info(f"  HA state: {state or 'unknown'} (attempt {attempt + 1}/{max_attempts})")
            if state and expected_state.lower() in state.lower():
                return
        except Exception as exc:
            LOGGER.debug(f"  HA state poll error: {exc}")
    raise RuntimeError(
        f"HA state on {ip} did not reach '{expected_state}' within {timeout_mins} minutes."
    )


def configure_panorama_ha(
    primary_ip: str,
    peer_ip: str,
    username: str,
    primary_state_file: Path,
    peer_state_file: Path,
    connectivity: str = 'private',
):
    """
    Configure Active/Passive HA between two Panorama nodes using the XML API only.

    primary_ip / peer_ip  — management IPs used for API access.
    connectivity          — 'private': each node peers to the other's private mgmt IP
                            (read from show system info — no VPN/encryption needed).
                            'public': uses the passed management IPs as peer-ip.
    """
    ctx = _make_ssl_ctx()

    # --- Credentials from state files ---
    primary_state = load_state(primary_state_file)
    peer_state    = load_state(peer_state_file)

    primary_password = primary_state.get('api_password')
    peer_password    = peer_state.get('api_password')

    if not primary_password:
        raise ValueError(
            f"No api_password in primary state file {primary_state_file}. "
            "Run panorama_init.py against the primary first."
        )
    if not peer_password:
        raise ValueError(
            f"No api_password in peer state file {peer_state_file}. "
            "Run panorama_init.py against the peer first."
        )

    # --- API keys ---
    LOGGER.info(f"Getting API key for primary ({primary_ip})...")
    primary_key = _keygen(primary_ip, username, primary_password, ctx)
    LOGGER.info(f"Getting API key for peer ({peer_ip})...")
    peer_key = _keygen(peer_ip, username, peer_password, ctx)

    # --- Determine peer IPs for HA config ---
    if connectivity == 'private':
        LOGGER.info("Reading private management IPs from each node...")
        primary_ha_ip = _get_private_ip(primary_ip, primary_key, ctx)
        peer_ha_ip    = _get_private_ip(peer_ip, peer_key, ctx)
        LOGGER.info(f"  Primary private IP: {primary_ha_ip}")
        LOGGER.info(f"  Peer private IP:    {peer_ha_ip}")
    else:
        primary_ha_ip = primary_ip
        peer_ha_ip    = peer_ip
        LOGGER.info(f"Using public IPs for HA peering: {primary_ha_ip} ↔ {peer_ha_ip}")

    # --- HA config xpaths (confirmed from debug cli output) ---
    BASE   = "/config/devices/entry[@name='localhost.localdomain']/deviceconfig/high-availability"
    ELECT  = BASE + "/election-option"
    TIMERS = ELECT + "/timers"
    PEER   = BASE + "/peer"

    def _peer_element(peer_addr: str) -> str:
        if connectivity == 'public':
            return (
                f"<ip-address>{peer_addr}</ip-address>"
                f"<encryption><enabled>yes</enabled></encryption>"
            )
        return f"<ip-address>{peer_addr}</ip-address>"

    def _configure_node(mgmt_ip: str, key: str, priority: str, peer_addr: str):
        LOGGER.info(f"Configuring HA on {mgmt_ip} — priority: {priority}, peer: {peer_addr}")
        _send_config_set(mgmt_ip, key, ctx, BASE,   "<enabled>yes</enabled>")
        _send_config_set(mgmt_ip, key, ctx, ELECT,  f"<priority>{priority}</priority>")
        _send_config_set(mgmt_ip, key, ctx, TIMERS, "<recommended/>")
        _send_config_set(mgmt_ip, key, ctx, PEER,   _peer_element(peer_addr))

    # --- Configure and commit primary ---
    _configure_node(primary_ip, primary_key, 'primary', peer_ha_ip)

    LOGGER.info(f"Committing primary ({primary_ip})...")
    job_id = _send_api_commit(primary_ip, primary_key, ctx)
    if job_id:
        poll_panorama_job(primary_ip, primary_key, ctx, job_id, "HA commit (primary)")
    LOGGER.info("✅ Primary committed.")

    # --- Configure and commit peer ---
    _configure_node(peer_ip, peer_key, 'secondary', primary_ha_ip)

    LOGGER.info(f"Committing peer ({peer_ip})...")
    job_id = _send_api_commit(peer_ip, peer_key, ctx)
    if job_id:
        poll_panorama_job(peer_ip, peer_key, ctx, job_id, "HA commit (peer)")
    LOGGER.info("✅ Peer committed.")

    # --- Verify HA state ---

    LOGGER.info("Verifying HA state convergence...")
    _poll_ha_state(primary_ip, primary_key, ctx, 'active')
    LOGGER.info(f"✅ Primary ({primary_ip}) is active.")
    _poll_ha_state(peer_ip, peer_key, ctx, 'passive')
    LOGGER.info(f"✅ Peer ({peer_ip}) is passive.")
    LOGGER.info("✅ HA pair healthy.")


def _poll_lc_sync(ip: str, api_key: str, ctx, serial: str,
                  group_name: str, timeout_mins: int = 5):
    """
    Poll until the log collector reports Connected=yes and Config Status=In Sync.
    Raises RuntimeError on timeout or if status is not reached.
    """
    cmd = f"<show><log-collector-group><name>{group_name}</name></log-collector-group></show>"
    max_attempts = timeout_mins * 4  # 15s intervals
    LOGGER.info(f"Polling LC sync status for {serial} in group '{group_name}'...")
    for attempt in range(max_attempts):
        time.sleep(15)
        try:
            raw = _send_op_command(ip, api_key, ctx, cmd, timeout=15)
            root = ET.fromstring(raw)
            # Response may be XML-structured or plain-text depending on version.
            # Try XML path first (11.2.x returns structured XML).
            lc_entry = root.find(f".//log-collector/entry[@name='{serial}']")
            if lc_entry is not None:
                connected   = lc_entry.findtext("connected", "").strip().lower() == "yes"
                config_stat = lc_entry.findtext("config-status", "").strip()
                in_sync     = config_stat.lower() == "in sync"
            else:
                # Fall back to plain-text line parsing
                text = "".join(root.itertext())
                connected = in_sync = False
                for line in text.splitlines():
                    if serial in line:
                        connected = "yes" in line.lower()
                        in_sync   = "in sync" in line.lower()
                        config_stat = "In Sync" if in_sync else "Out of Sync"
                        break

            LOGGER.info(
                f"  LC {serial}: connected={connected} "
                f"config_status={config_stat} "
                f"(attempt {attempt + 1}/{max_attempts})"
            )
            if connected and in_sync:
                return
        except Exception as exc:
            LOGGER.debug(f"  LC sync poll error: {exc}")
    raise RuntimeError(
        f"Log collector {serial} in group '{group_name}' did not reach "
        f"'Connected / In Sync' within {timeout_mins} minutes."
    )


def configure_local_log_collector(
    ip: str,
    username: str,
    state_file: Path,
    collector_group_name: str = "default",
    ssh_key_path: Path = None,
    public_ip: str = None,
):
    """
    Configure the local log collector on a Panorama instance running in
    panorama-mode (combined management + logging). Uses XML API only.

    Prerequisites verified before proceeding:
      - system-mode == 'panorama'
      - licensed-device-capacity > 0 (license applied)
      - at least one disk in Available state

    Steps:
      1. Add available disks to the system via op command.
      2. Create the log-collector config entry using Panorama's serial number.
      3. Create a collector group containing the local log collector.
      4. Commit.
      5. Push config to the log collector via commit-all log-collector-config.

    Note: After the commit, Panorama will warn "No disks enabled on log
    collector" in the commit output. The disk is added at the system level
    (step 1) but the config layer also requires disk assignment (a separate
    step requiring additional debug CLI output to confirm the xpath). The
    log collector will function, logging to the default panlogs partition
    until disk assignment is configured.
    """
    ctx = _make_ssl_ctx()

    state = load_state(state_file)
    api_password = state.get("api_password")
    if not api_password:
        raise ValueError(
            f"No api_password in state file {state_file}. Run panorama_init.py first."
        )

    LOGGER.info(f"Getting API key for {ip}...")
    api_key = _keygen(ip, username, api_password, ctx)

    # --- Verify prerequisites ---
    LOGGER.info("Verifying prerequisites (system-mode, license, disks)...")
    raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=15)
    root = ET.fromstring(raw)

    system_mode = root.findtext(".//system-mode") or ""
    if system_mode.lower() != "panorama":
        raise RuntimeError(
            f"Panorama is not in panorama-mode (system-mode={system_mode!r}). "
            "Local log collector configuration requires panorama-mode."
        )

    capacity = int(root.findtext(".//licensed-device-capacity") or "0")
    if capacity == 0:
        LOGGER.info("No license detected — fetching license from Palo Alto licensing server...")
        try:
            _send_op_command(ip, api_key, ctx,
                             "<request><license><fetch/></license></request>", timeout=60)
            LOGGER.info("License fetch complete. Re-checking capacity...")
            raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=15)
            root = ET.fromstring(raw)
            capacity = int(root.findtext(".//licensed-device-capacity") or "0")
        except Exception as exc:
            LOGGER.warning(f"License fetch failed: {exc}")

    if capacity == 0:
        raise RuntimeError(
            "Panorama is not licensed (licensed-device-capacity=0). "
            "Ensure the serial number is set and the instance has internet access to the licensing server."
        )

    serial = root.findtext(".//serial")
    if not serial or serial.strip().lower() == "unknown":
        raise RuntimeError("Panorama serial number is unknown. Apply serial before configuring log collector.")
    serial = serial.strip()
    LOGGER.info(f"  system-mode: panorama  serial: {serial}  capacity: {capacity}")

    # --- Discover and add disks ---
    disk_raw = _send_op_command(
        ip, api_key, ctx,
        "<show><system><disk><details/></disk></system></show>",
        timeout=15,
    )
    # Response is plain-text in either <result> CDATA or <result><member> depending on version.
    # Use itertext() to collect all text content regardless of nesting.
    disk_root = ET.fromstring(disk_raw)
    disk_text = "".join(disk_root.itertext())
    available_disks = []
    current = {}
    for line in disk_text.splitlines():
        line = line.strip()
        if line.startswith("Name"):
            current = {"name": line.split(":", 1)[-1].strip()}
        elif line.startswith("State") and current:
            current["state"] = line.split(":", 1)[-1].strip()
        elif line.startswith("Status") and current:
            current["status"] = line.split(":", 1)[-1].strip()
            if current.get("state") == "Present" and current.get("status") == "Available":
                available_disks.append(current["name"])
            current = {}

    if not available_disks:
        raise RuntimeError(
            "No disks in 'Present/Available' state found. Attach log disks before configuring the local log collector."
        )
    LOGGER.info(f"Available disks: {available_disks}")

    for disk in available_disks:
        LOGGER.info(f"Adding disk {disk} to system...")
        try:
            result = _send_op_command(
                ip, api_key, ctx,
                f"<request><system><disk><add>{disk}</add></disk></system></request>",
                timeout=60,
            )
            msg = ET.fromstring(result).findtext(".//result") or ""
            LOGGER.info(f"  {disk}: {msg.strip()}")
        except Exception as exc:
            LOGGER.warning(f"  {disk}: {exc} (continuing)")

    # --- Configure log-collector entry, disk pairs, and optional public IP ---
    BASE = "/config/devices/entry[@name='localhost.localdomain']"
    LOGGER.info(f"Creating log-collector entry for serial {serial}...")
    _send_config_set(
        ip, api_key, ctx,
        f"{BASE}/log-collector",
        f"<entry name='{serial}'/>",
    )

    # Assign each available disk as a disk-pair (A, B, C...).
    # Panorama auto-maps pair names to physical disks in order.
    for i, disk in enumerate(available_disks):
        pair_name = chr(ord('A') + i)
        LOGGER.info(f"Assigning disk {disk} as disk-pair {pair_name} on log collector...")
        _send_config_set(
            ip, api_key, ctx,
            f"{BASE}/log-collector/entry[@name='{serial}']/disk-settings/disk-pair",
            f"<entry name='{pair_name}'/>",
        )

    # Set public IP on the LC if provided — required for commit-all to reach
    # the LC when Panorama is behind NAT.
    if public_ip:
        LOGGER.info(f"Setting public-ip-address {public_ip} on log collector {serial}...")
        _send_config_set(
            ip, api_key, ctx,
            f"{BASE}/log-collector/entry[@name='{serial}']/deviceconfig/system",
            f"<public-ip-address>{public_ip}</public-ip-address>",
        )

    # --- Configure collector group ---
    LOGGER.info(f"Creating collector group '{collector_group_name}' with local log collector...")
    _send_config_set(
        ip, api_key, ctx,
        f"{BASE}/log-collector-group/entry[@name='{collector_group_name}']/logfwd-setting/collectors",
        f"<member>{serial}</member>",
    )

    # --- Commit ---
    LOGGER.info("Committing log collector configuration...")
    job_id = _send_api_commit(ip, api_key, ctx)
    if job_id:
        poll_panorama_job(ip, api_key, ctx, job_id, "local LC commit")
    LOGGER.info("✅ Committed.")

    # --- Push config to log collector (type=commit with commit-all cmd) ---
    # commit-all log-collector-config is blocked at the XML API layer (HTTP 400
    # for both type=op and type=commit). Use SSH/CLI — the same path the UI uses.
    # Try the provided SSH key first; fall back to api_password from state.
    LOGGER.info(f"Pushing config to log collector group '{collector_group_name}' via SSH...")
    try:
        ssh = PanoramaSSHClient(ip, username, ssh_key_path=ssh_key_path, password=api_password)
        ssh.connect(max_retries=5, delay=10)
        result = ssh.send_command(
            f"commit-all log-collector-config log-collector-group {collector_group_name}",
            timeout=120,
        )
        LOGGER.info(f"  {result.strip()}")
        ssh.close()
    except Exception as e:
        LOGGER.warning(f"commit-all via SSH failed: {e} — polling for self-sync")
    _poll_lc_sync(ip, api_key, ctx, serial, collector_group_name, timeout_mins=10)
    LOGGER.info("✅ Local log collector configured and In Sync.")


# --- SSH Interaction Class ---
class PanoramaSSHClient:
    """A wrapper for Paramiko to handle interactive shell sessions with Panorama."""

    def __init__(self, ip: str, username: str, ssh_key_path: Path, password: str = None):
        self.ip = ip
        self.username = username
        self.ssh_key_path = ssh_key_path
        self.password = password
        self.client = paramiko.SSHClient()
        self.client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        self.shell = None

    def connect(self, max_retries=15, delay=30):
        """Connects to Panorama, opens a shell, and disables the pager."""
        _pt = logging.getLogger("paramiko.transport")
        for attempt in range(max_retries):
            try:
                LOGGER.info(f"Attempting SSH connection to {self.ip} (Attempt {attempt + 1}/{max_retries})...")
                _pt.setLevel(logging.CRITICAL)  # suppress socket exception noise during connect

                # Attempt Key-based auth first if key file exists
                if self.ssh_key_path and self.ssh_key_path.is_file():
                    LOGGER.debug(f"Trying key-based auth using {self.ssh_key_path}")
                    try:
                        self.client.connect(
                            hostname=self.ip,
                            username=self.username,
                            key_filename=str(self.ssh_key_path),
                            timeout=15
                        )
                    except paramiko.ssh_exception.AuthenticationException:
                        if self.password:
                            LOGGER.debug("Key auth failed, falling back to password auth.")
                            self.client.connect(
                                hostname=self.ip,
                                username=self.username,
                                password=self.password,
                                timeout=15
                            )
                        else:
                            raise
                elif self.password:
                    LOGGER.debug("No SSH key found. Trying password auth from ENV.")
                    self.client.connect(
                        hostname=self.ip,
                        username=self.username,
                        password=self.password,
                        timeout=15
                    )
                else:
                    raise ValueError(f"No valid SSH key found at {self.ssh_key_path} and PANORAMA_PASSWORD env var is not set.")

                _pt.setLevel(logging.WARNING)  # restore after successful connect
                LOGGER.info("✅ SSH connection successful.")
                LOGGER.info("Opening interactive shell...")
                self.shell = self.client.invoke_shell()

                # Wait for standard prompt (handles both user and config mode prompts)
                self.wait_for_prompt(timeout=90)

                LOGGER.info("Disabling CLI pager for this session...")
                self.send_command("set cli pager off")

                LOGGER.info("✅ Interactive shell is ready.")
                return

            except Exception as e:
                LOGGER.warning(f"SSH connection failed: {e}")
                if attempt < max_retries - 1:
                    time.sleep(delay)
                else:
                    raise TimeoutError(f"Could not establish SSH connection to {self.ip} after {max_retries} attempts.")

    def close(self):
        """Closes the SSH connection."""
        if self.shell:
            self.shell.close()
        self.client.close()
        LOGGER.info("SSH client closed.")

    def wait_for_prompt(self, prompt_chars=['>', '#'], timeout=60):
        """Waits for one of the possible command prompts to appear."""
        output = ""
        start_time = time.time()
        self.shell.settimeout(timeout)

        while True:
            if time.time() - start_time > timeout:
                LOGGER.error(f"Timeout waiting for prompt. Received:\n{output}")
                raise TimeoutError("Timeout waiting for command prompt.")

            if self.shell.recv_ready():
                output += self.shell.recv(4096).decode('utf-8', errors='ignore')

            # Check if any of our expected prompt characters are in the tail of the output
            lines = output.split('\n')
            last_line = lines[-1] if lines else ""

            prompt_found = any(p in last_line for p in prompt_chars)

            if prompt_found:
                time.sleep(0.5)  # Wait slightly to ensure output flush
                if not self.shell.recv_ready():
                    return output

            time.sleep(0.2)

    def send_command(self, command, prompt_chars=['>', '#'], timeout=120):
        """Sends a command and returns the output once a prompt reappears."""
        self.shell.send(command + '\n')
        full_output = self.wait_for_prompt(prompt_chars, timeout)

        # Clean up output (remove the echoed command and the trailing prompt)
        lines = full_output.splitlines()
        if len(lines) > 1:
            return '\n'.join(lines[1:-1]).strip()
        return full_output.strip()


# --- PAN-OS Upgrade Helpers ---
def _get_current_panos_version(ip, api_key, ctx):
    """Queries the device and returns the currently running PAN-OS version string."""
    # Fix #1: Use correct <system> XML tag (not abbreviated <s>).
    sysinfo_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=15)
    match = re.search(r'(?:<sw-version>|sw-version:\s*)([^<\r\n]+)', sysinfo_raw)
    if not match:
        raise RuntimeError("Could not determine current PAN-OS version from system info.")
    return match.group(1).strip()


def _resolve_panos_target_version(ip, api_key, ctx, requested_version):
    """
    Resolves the requested version string to an exact installable version.

    - If requested_version is an exact version (e.g. '11.2.8'), it is returned as-is.
    - If requested_version is 'latest', queries available software images and returns
      the newest version within the same major.minor family as the currently running version.

    Returns:
        tuple: (target_version str, current_version str)
    """
    current_version = _get_current_panos_version(ip, api_key, ctx)
    LOGGER.info(f"Current PAN-OS version: {current_version}")

    # TODO: Add X.Y shorthand (e.g. '--upgrade-panos 11.2' → latest 11.2.x patch).
    # Complication: if Panorama is on 11.1.x and 11.2 is requested, a stepping upgrade
    # through an intermediate version may be required before reaching 11.2. For now,
    # exact version (11.2.8) and 'latest' (newest patch in current family) are supported.
    if requested_version.lower() != "latest":
        # Fix #7: Warn explicitly when the requested version is in a different major.minor
        # family, since PAN-OS requires stepping through intermediate versions for major jumps.
        current_major_minor = '.'.join(current_version.split('.')[:2])
        target_major_minor = '.'.join(requested_version.split('.')[:2])
        if current_major_minor != target_major_minor:
            LOGGER.warning(
                f"⚠️  Target version {requested_version} is in a different major.minor family "
                f"({target_major_minor}) than the currently running version ({current_version}, "
                f"family {current_major_minor}). PAN-OS requires upgrading through intermediate "
                f"versions for cross-family jumps. Verify this is a supported upgrade path before "
                f"proceeding. See: https://docs.paloaltonetworks.com/pan-os/upgrade-guide"
            )
        LOGGER.info(f"Target PAN-OS version (explicit): {requested_version}")
        return requested_version, current_version

    # Resolve 'latest' — first refresh the available image list from the update server.
    LOGGER.info("Checking for available PAN-OS software images to resolve 'latest'...")
    # Fix #3: Use correct <system> XML tag for software check command.
    check_raw = _send_op_command(
        ip, api_key, ctx,
        "<request><system><software><check/></software></system></request>",
        timeout=60
    )
    # Fix #6: Validate that the software check command actually succeeded before proceeding.
    # If the device has no update server route, the check returns an error status rather
    # than silently leaving the image list empty.
    try:
        check_root = ET.fromstring(check_raw)
        if check_root.get('status') == 'error':
            err_msg = check_root.findtext(".//msg", default=check_raw)
            raise RuntimeError(
                f"Software update check failed — the device may not have a route to the "
                f"Palo Alto Networks update server. API error: {err_msg}"
            )
    except ET.ParseError:
        pass  # Non-XML response is not necessarily an error; proceed and let version parse fail gracefully

    # Fix #4: Use correct <system> XML tag for software status command.
    images_raw = _send_op_command(
        ip, api_key, ctx,
        "<show><system><software><status/></software></system></show>",
        timeout=30
    )

    # Fix #9: Broaden the version regex to capture all hotfix suffix formats:
    # standard (-h1), cloud (-c1), expedited field release (-xfr1), and bare patches.
    # The original pattern only matched -hN suffixes and would miss other valid versions.
    versions_found = re.findall(
        r'(?:<entry name="|version:\s*)([0-9]+\.[0-9]+\.[0-9]+[^"<\s]*)',
        images_raw
    )

    if not versions_found:
        raise RuntimeError(
            "Could not parse any available PAN-OS versions from the software status output. "
            "Ensure the device has internet access to the Palo Alto Networks update server "
            f"and that the software check completed successfully. Raw output:\n{images_raw}"
        )

    # Restrict candidates to the same major.minor family as currently running
    current_major_minor = '.'.join(current_version.split('.')[:2])
    candidates = [v for v in versions_found if v.startswith(current_major_minor + '.')]

    if not candidates:
        raise RuntimeError(
            f"No available images found for the {current_major_minor}.x family. "
            f"All versions found: {versions_found}"
        )

    # Semantic sort: split on '.', '-', 'h', 'c', 'xfr' and compare integer segments
    def _version_sort_key(v):
        return [int(x) for x in re.split(r'[.\-a-zA-Z]', v) if x.isdigit()]

    target_version = sorted(candidates, key=_version_sort_key)[-1]
    LOGGER.info(
        f"Resolved 'latest' to version: {target_version} "
        f"(from {len(candidates)} candidates in the {current_major_minor}.x family)"
    )
    return target_version, current_version


# --- Provisioning Logic ---
def provision_panorama(ip: str, username: str, ssh_key: Path, password: str, state_file: Path,
                       serial_number: str = None, otp: str = None, csp_api_key: str = None,
                       upgrade_content: bool = False, upgrade_av: bool = False,
                       upgrade_panos: str = None, plugins: str = None,
                       vm_auth_key_hours: int = None, hostname: str = None,
                       public_ip: str = None):
    """Executes the idempotent provisioning sequence on Panorama."""
    state = load_state(state_file)
    _commit_just_ran = False  # local flag, never persisted to state file

    # Persist IP and username immediately so they can be recovered from the state file on re-runs.
    changed = False
    if "ip" not in state:
        state["ip"] = ip
        changed = True
    if "username" not in state:
        state["username"] = username
        changed = True
    if changed:
        save_state(state_file, state)

    # --- API Pre-check ---
    # If we already have a stored API password, attempt XML API authentication before
    # opening an SSH session. A successful API call confirms:
    #   1. The device is up and reachable
    #   2. The stored password is still valid (admin_password_set)
    # If the target hostname is also already set, the entire SSH phase can be skipped.
    # If the API call fails (e.g. fresh device, mgmtsrvr not yet up), fall through to SSH.
    api_key = None
    ctx = None

    if state.get("api_password") and not state.get("initial_commit_done"):
        LOGGER.info("API password found in state. Attempting API pre-check before SSH...")
        try:
            _ctx = _make_ssl_ctx()
            _keygen_data = urllib.parse.urlencode({
                'type': 'keygen',
                'user': username,
                'password': state["api_password"]
            }).encode('utf-8')
            _req = urllib.request.Request(f"https://{ip}/api/", data=_keygen_data)
            _res = urllib.request.urlopen(_req, context=_ctx, timeout=10)
            _root = ET.fromstring(_res.read())
            _key = _root.findtext(".//key")

            if _key:
                LOGGER.info("✅ API pre-check successful. Verifying device state...")
                api_key = _key
                ctx = _ctx
                state["admin_password_set"] = True
                state["system_ready"] = True

                # Check whether the target hostname is already configured.
                _sysinfo = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10)

                # Warn if connecting via a NAT/public IP but public-ip-address is not set.
                # NGFWs bootstrapping to Panorama via a public NAT address need Panorama to
                # advertise that address — set it with --public-ip <public-ip>.
                if not public_ip:
                    import xml.etree.ElementTree as _ET
                    _si = _ET.fromstring(_sysinfo)
                    _private_ip = (_si.findtext(".//ip-address") or "").strip()
                    _pub = (_si.findtext(".//public-ip-address") or "unknown").strip()
                    _via_nat = _private_ip and ip != _private_ip
                    if _via_nat and _pub.lower() in ("unknown", ""):
                        LOGGER.warning(
                            f"Connecting via {ip} but Panorama's private IP is {_private_ip} — "
                            "you appear to be going through NAT. "
                            "public-ip-address is not configured: managed firewalls will not be "
                            "able to bootstrap to Panorama via this public address. "
                            f"Pass --public-ip {ip} to configure it."
                        )

                _target_hostname = hostname or "Panorama-Management"
                if f"<hostname>{_target_hostname}</hostname>" in _sysinfo:
                    state["hostname_set"] = True
                    state["hostname"] = _target_hostname
                    LOGGER.info(f"✅ Hostname '{_target_hostname}' confirmed via API.")
                    LOGGER.info("⏭️  All SSH phase steps confirmed via API. Skipping SSH entirely.")
                    state["initial_commit_done"] = True
                    save_state(state_file, state)
                else:
                    # Hostname not yet set — SSH still needed, but password step can be skipped.
                    LOGGER.info("Hostname not yet configured. SSH required for config/commit.")
                    save_state(state_file, state)
        except Exception as _e:
            LOGGER.debug(f"API pre-check failed ({_e}). Proceeding with SSH.")
            api_key = None
            ctx = None

    ssh = PanoramaSSHClient(ip, username, ssh_key, password)

    try:
        # Only connect if the SSH phase is still needed.
        if not state.get("initial_commit_done"):
            ssh.connect()

        # Step 2: Check System Readiness
        # Panorama can take 15-20 minutes to fully initialize services on first boot.
        if not state.get("system_ready"):
            LOGGER.info("Checking if Panorama system is ready...")
            ready = False
            for attempt in range(60):  # Wait up to ~30 mins (60 * 30s)
                output = ssh.send_command("show system info")
                if "sw-version:" in output.lower() or "hostname:" in output.lower():
                    LOGGER.info("✅ Panorama system is fully ready!")
                    state["system_ready"] = True
                    save_state(state_file, state)
                    ready = True
                    break
                else:
                    LOGGER.info(f"System not ready yet. Retrying in 30 seconds... (Attempt {attempt+1}/60)")
                    time.sleep(30)

            if not ready:
                raise TimeoutError("Panorama system did not become ready in time.")
        else:
            LOGGER.info("⏭️  Skipping system readiness check (already complete).")

        # Step 3: Enter Configuration Mode
        if not state.get("initial_commit_done"):
            LOGGER.info("Entering configuration mode...")
            ssh.send_command("configure", prompt_chars=['#'])

            # Step 3.1: Set Admin Password for API Access
            if not state.get("admin_password_set"):
                LOGGER.info(f"Setting password for user '{username}' to enable XML API access...")

                # If no password was provided via ENV, generate a secure one
                api_password = password
                if not api_password:
                    alphabet = string.ascii_letters + string.digits
                    api_password = ''.join(secrets.choice(alphabet) for _ in range(16))
                    LOGGER.info(f"Generated new secure password for '{username}': {api_password}")

                # Send the password command
                ssh.shell.send(f"set mgt-config users {username} password\n")

                # Handle the interactive prompts
                ssh.wait_for_prompt(prompt_chars=['Enter password'])
                ssh.shell.send(api_password + '\n')

                ssh.wait_for_prompt(prompt_chars=['Confirm password'])
                ssh.shell.send(api_password + '\n')

                ssh.wait_for_prompt(prompt_chars=['#'])

                state["admin_password_set"] = True
                state["api_password"] = api_password  # Store the password in state for future API calls
                save_state(state_file, state)
                LOGGER.info("✅ Admin password configured in candidate config.")
            else:
                LOGGER.info("⏭️  Skipping admin password configuration (already complete).")

            # Example Provisioning Step A: Set Hostname
            if not state.get("hostname_set"):
                target_hostname = hostname or "Panorama-Management"
                LOGGER.info(f"Setting hostname to '{target_hostname}'...")
                ssh.send_command(f"set deviceconfig system hostname {target_hostname}", prompt_chars=['#'])

                state["hostname_set"] = True
                state["hostname"] = target_hostname
                save_state(state_file, state)
                LOGGER.info("✅ Hostname configured.")
            else:
                LOGGER.info("⏭️  Skipping hostname configuration (already complete).")

            # Step 3b: Set public management IP (optional)
            # public_ip is already resolved by main() — no _auto_ sentinel here.
            if public_ip:
                if state.get("public_ip_set") and state.get("public_ip") == public_ip:
                    LOGGER.info(f"⏭️  Public IP '{public_ip}' already configured. Skipping.")
                else:
                    LOGGER.info(f"Setting public-ip-address to '{public_ip}'...")
                    ssh.send_command(
                        f"set deviceconfig system public-ip-address {public_ip}",
                        prompt_chars=['#'],
                    )
                    state["public_ip_set"] = True
                    state["public_ip"] = public_ip
                    save_state(state_file, state)
                    LOGGER.info("✅ Public IP configured.")

            # Step 4: Commit Configuration
            if not state.get("initial_commit_done"):
                # Check whether there are actually pending candidate config changes before
                # committing. 'show config diff' returns an empty string when candidate and
                # running configs are identical, letting us skip a ~40-second commit on an
                # already-configured device that was rerun without a state file.
                diff_output = ssh.send_command("show config diff", prompt_chars=['#'], timeout=30)
                if not diff_output.strip():
                    LOGGER.info("⏭️  No pending config changes detected. Skipping commit.")
                    state["initial_commit_done"] = True
                    save_state(state_file, state)
                else:
                    LOGGER.info("Committing initial configuration... (This may take a few minutes)")
                    # Commits can take a while on Panorama, bump timeout
                    commit_output = ssh.send_command("commit", prompt_chars=['#'], timeout=600)

                    # Fix #13: Tighten commit success detection. The original "success" substring
                    # match was too broad and could pass on warning messages like
                    # "Successfully validated but commit may not succeed due to...".
                    if "committed successfully" in commit_output.lower():
                        LOGGER.info("✅ Initial commit successful.")
                        state["initial_commit_done"] = True
                        _commit_just_ran = True
                        save_state(state_file, state)
                    else:
                        LOGGER.error(f"Commit may have failed. Output:\n{commit_output}")
                        raise RuntimeError("Commit process did not return expected success message.")

            # Exit config mode
            ssh.send_command("exit", prompt_chars=['>'])
        else:
            LOGGER.info("⏭️  Skipping initial configuration and commit (already complete).")

    finally:
        # We can safely close the SSH session before interacting with the API
        ssh.close()

    # The initial commit restarts Panorama's management plane, which briefly
    # takes the network interface down. Wait before the first API attempt so
    # we don't burn all retries against a temporarily unreachable host.
    if _commit_just_ran:
        LOGGER.info("Waiting 60s for Panorama management plane to restart after commit...")
        time.sleep(60)

    # --- XML API Interactions ---

    # Fix #11: Only generate an API key if at least one API-dependent step is actually
    # needed. Avoids an unnecessary TCP connection + keygen round-trip when everything
    # is already complete in the state file.
    _api_steps_needed = (
        serial_number or otp or csp_api_key
        or upgrade_content or upgrade_av or upgrade_panos
        or plugins or vm_auth_key_hours is not None
    )

    # api_key/ctx may already be set from the pre-check above — reuse them if so.
    if _api_steps_needed:
        # Check whether all API-gated steps are already done before bothering to keygen
        _all_api_steps_done = (
            (not serial_number or state.get("serial_number_set"))
            and (not otp or state.get("certificate_fetched"))
            and (not csp_api_key or state.get("csp_api_key_set"))
            and (not upgrade_content or state.get("content_upgraded"))
            and (not upgrade_av or state.get("av_upgraded"))
            and (not upgrade_panos or state.get("panos_upgrade_verified"))
            and (not plugins or set(p.strip() for p in plugins.split(",") if p.strip())
                 .issubset(set(state.get("plugins_installed", []))))
            and (vm_auth_key_hours is None or state.get("vm_auth_key"))
        )

        if _all_api_steps_done:
            LOGGER.info("⏭️  All API steps already complete. Skipping API key generation.")
        elif api_key:
            # Reuse the key obtained during the SSH pre-check — no round-trip needed.
            LOGGER.info("Reusing API key from pre-check.")
        else:
            api_password = state.get("api_password") or password
            if not api_password:
                raise ValueError("Cannot connect to API. No password provided in ENV or generated in state file.")

            # Fix #12: Use the centralised SSL context helper.
            ctx = _make_ssl_ctx()

            LOGGER.info("Generating API Key for XML API...")
            keygen_data = urllib.parse.urlencode({
                'type': 'keygen',
                'user': username,
                'password': api_password
            }).encode('utf-8')

            try:
                req = urllib.request.Request(f"https://{ip}/api/", data=keygen_data)
                res = urllib.request.urlopen(req, context=ctx, timeout=15)
                root = ET.fromstring(res.read())
                api_key = root.find(".//key").text
                if not api_key:
                    raise ValueError("Failed to extract API key from response.")
            except Exception as e:
                raise RuntimeError(f"API Keygen failed: {e}")

    # Step 5: Execute Serial Number setting via XML API
    if serial_number:
        if not state.get("serial_number_set"):
            # Live pre-check: query system info before sending the set command.
            # Re-setting a serial that is already correct triggers an unnecessary
            # web server restart and a 15+ second wait.
            LOGGER.info(f"Checking current serial number before applying...")
            try:
                sysinfo_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10)
                if (f"<serial>{serial_number}</serial>" in sysinfo_raw
                        or f"serial: {serial_number}" in sysinfo_raw):
                    LOGGER.info(f"✅ Serial number '{serial_number}' is already set. Skipping.")
                    state["serial_number_set"] = True
                    state["serial_number"] = serial_number
                    save_state(state_file, state)
            except Exception as e:
                LOGGER.debug(f"Serial pre-check failed ({e}). Proceeding with set command.")

        if not state.get("serial_number_set"):
            LOGGER.info(f"Setting Panorama serial number to '{serial_number}' via XML API...")

            command_sent = False
            for attempt in range(40):
                try:
                    # Send exactly what the user requested, without pan-os-python auto-wrapping
                    cmd_xml = f"<set><serial-number>{serial_number}</serial-number></set>"
                    LOGGER.info(f"Sending API command (Attempt {attempt+1}/40)...")

                    _send_op_command(ip, api_key, ctx, cmd_xml, timeout=15)
                    command_sent = True
                    LOGGER.info("API command accepted. Panorama management server is likely restarting...")
                    break
                except RuntimeError as e:
                    # _send_op_command wraps the HTTP error in a RuntimeError, catch that
                    LOGGER.warning(f"API command failed: {e}. Retrying in 15 seconds...")
                    time.sleep(15)
                except Exception as e:
                    # Fix #12: Use centralised disconnect helper.
                    if _is_expected_disconnect(e):
                        LOGGER.warning(f"Connection dropped during API call (expected behavior as web server reboots): {e}")
                        command_sent = True
                        break
                    LOGGER.warning(f"API command failed: {e}. Retrying in 15 seconds...")
                    time.sleep(15)

            if not command_sent:
                # Before giving up, check whether the serial was actually set by
                # an attempt that sent successfully but lost the response mid-flight.
                LOGGER.info("All attempts exhausted. Checking whether serial was set despite response errors...")
                try:
                    _check_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=15)
                    _check_sn = ET.fromstring(_check_raw).findtext(".//serial")
                    if _check_sn and _check_sn.strip() == serial_number:
                        LOGGER.info(f"✅ Serial number '{serial_number}' is confirmed set. Continuing.")
                        command_sent = True
                    else:
                        raise RuntimeError("Failed to set serial number via XML API after 40 attempts.")
                except RuntimeError:
                    raise
                except Exception:
                    raise RuntimeError("Failed to set serial number via XML API after 40 attempts.")

            # Now wait for the web server to come back up and verify the serial number
            LOGGER.info("Waiting for Panorama web server to come back up and verifying serial number...")
            serial_verified = False
            for attempt in range(24):  # Wait up to 6 minutes (24 * 15s)
                time.sleep(15)
                try:
                    # Fix #1: Use the canonical _CMD_SHOW_SYSTEM_INFO constant.
                    sysinfo_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10)

                    if f"<serial>{serial_number}</serial>" in sysinfo_raw or f"serial: {serial_number}" in sysinfo_raw:
                        LOGGER.info(f"✅ Serial number '{serial_number}' successfully verified!")
                        serial_verified = True
                        break

                    match = re.search(r'(?:<serial>|serial:\s*)([^<\r\n]+)', sysinfo_raw)
                    current_serial = match.group(1).strip() if match else "unknown"

                    if current_serial and current_serial != "unknown":
                        LOGGER.info(f"Web server is up, but serial is currently '{current_serial}'. Waiting...")
                except Exception as e:
                    LOGGER.debug(f"Web server still unreachable (Attempt {attempt+1}/24)...")

            if not serial_verified:
                raise RuntimeError("Panorama web server did not return the expected serial number after restarting.")

            state["serial_number_set"] = True
            state["serial_number"] = serial_number
            save_state(state_file, state)
        else:
            LOGGER.info("⏭️  Skipping serial number configuration (already complete).")

    # Step 6: Fetch Device Certificate via XML API
    if otp:
        if not state.get("certificate_fetched"):
            LOGGER.info("Checking current device certificate status...")
            cert_already_valid = False

            for attempt in range(3):  # Short retry in case mgmtsrvr is just settling
                try:
                    # Fix #1: Use the canonical _CMD_SHOW_SYSTEM_INFO constant.
                    sysinfo_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10)

                    if "device-certificate-status: Valid" in sysinfo_raw or "<device-certificate-status>Valid</device-certificate-status>" in sysinfo_raw:
                        LOGGER.info("✅ Device certificate is already 'Valid'. Skipping OTP fetch.")
                        cert_already_valid = True
                        state["certificate_fetched"] = True
                        save_state(state_file, state)
                    break  # Success checking status, exit loop
                except Exception as e:
                    LOGGER.debug(f"Pre-check connection error: {e}. Retrying...")
                    time.sleep(5)

            if not cert_already_valid:
                LOGGER.info(f"Fetching device certificate using OTP via XML API...")

                # 1. Dispatch the Fetch Job
                try:
                    cmd_xml = f"<request><certificate><fetch><otp>{otp}</otp></fetch></certificate></request>"
                    job_id = _send_op_job_command(ip, api_key, ctx, cmd_xml, timeout=15)
                    if not job_id:
                        raise RuntimeError("Certificate fetch initiated, but no job ID was returned.")
                    LOGGER.info(f"Certificate fetch job enqueued with ID: {job_id}. Monitoring progress...")
                except Exception as e:
                    raise RuntimeError(f"Failed to enqueue device certificate fetch job: {e}")

                # 2. Poll the Job Status and System Info
                cert_valid = False
                for attempt in range(30):  # Wait up to 7.5 minutes (30 * 15s)
                    time.sleep(15)
                    try:
                        # Fix #1: Use the canonical _CMD_SHOW_SYSTEM_INFO constant.
                        sysinfo_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10)

                        if "device-certificate-status: Valid" in sysinfo_raw or "<device-certificate-status>Valid</device-certificate-status>" in sysinfo_raw:
                            LOGGER.info("✅ Device certificate fetched and successfully verified!")
                            cert_valid = True
                            break

                        # If not valid yet, check job status to fail fast if OTP was rejected
                        job_cmd = f"<show><jobs><id>{job_id}</id></jobs></show>"
                        job_raw = _send_op_command(ip, api_key, ctx, job_cmd, timeout=10)

                        try:
                            root = ET.fromstring(job_raw)
                            job_node = root.find('.//job')
                            if job_node is not None:
                                status = job_node.findtext('status', default='')
                                res_val = job_node.findtext('result', default='')
                                if status == 'FIN' and res_val == 'FAIL':
                                    LOGGER.error(f"Certificate fetch job {job_id} failed. Raw output:\n{job_raw}")
                                    raise RuntimeError("Device certificate fetch failed (invalid OTP or network error).")

                            result_text = root.findtext('.//result', default=job_raw)
                        except ET.ParseError:
                            result_text = job_raw

                        if result_text:
                            result_text = result_text.replace('\xa0', ' ')
                        else:
                            result_text = ""

                        if re.search(r'FIN\s+FAIL', result_text):
                            LOGGER.error(f"Certificate fetch job {job_id} failed. Raw output:\n{result_text}")
                            raise RuntimeError("Device certificate fetch failed (invalid OTP or network error).")

                        LOGGER.info(f"Job {job_id} processing, cert not yet valid... (Attempt {attempt+1}/30)")
                    except RuntimeError:
                        raise  # Re-raise the FIN FAIL runtime error immediately
                    except Exception as e:
                        LOGGER.debug(f"Connection error while polling (expected if mgmtsrvr is restarting): {e}")

                if not cert_valid:
                    raise RuntimeError(f"Timed out waiting for device certificate to become 'Valid'.")

                state["certificate_fetched"] = True
                save_state(state_file, state)
        else:
            LOGGER.info("⏭️  Skipping device certificate fetch (already complete).")

    # Step 7: Configure CSP API Key
    if csp_api_key:
        if not state.get("csp_api_key_set"):
            LOGGER.info("Setting CSP Licensing API Key via XML API...")
            try:
                cmd_xml = f"<request><license><api-key><set><key>{csp_api_key}</key></set></api-key></license></request>"
                raw_response = _send_op_command(ip, api_key, ctx, cmd_xml, timeout=30)

                if 'status="error"' in raw_response.lower() and 'same as old' in raw_response.lower():
                    LOGGER.info("✅ CSP API key is already set to the provided value.")
                elif 'status="error"' in raw_response.lower():
                    raise RuntimeError(f"Failed to set CSP API key. Raw response: {raw_response}")
                else:
                    LOGGER.info("✅ CSP API key applied successfully.")

                state["csp_api_key_set"] = True
                save_state(state_file, state)
            except Exception as e:
                LOGGER.error(f"Failed to configure CSP API key: {e}")
                raise
        else:
            LOGGER.info("⏭️  Skipping CSP API Key configuration (already complete).")

    # Step 8: Content Upgrade via XML API
    if upgrade_content:
        if not state.get("content_upgraded"):
            LOGGER.info("Starting Content Upgrade process...")
            try:
                LOGGER.info("1/3 Checking for latest content updates...")
                check_cmd = "<request><content><upgrade><check/></upgrade></content></request>"
                check_response = _send_op_command(ip, api_key, ctx, check_cmd, timeout=60)

                already_latest, version = _is_already_latest(check_response, "Content")
                if not already_latest:
                    LOGGER.info("2/3 Downloading latest content update...")
                    dl_cmd = "<request><content><upgrade><download><latest/></download></upgrade></content></request>"
                    dl_job_id = _send_op_job_command(ip, api_key, ctx, dl_cmd, timeout=30)
                    poll_panorama_job(ip, api_key, ctx, dl_job_id, "Content Download")

                    LOGGER.info("3/3 Installing latest content update...")
                    inst_cmd = "<request><content><upgrade><install><version>latest</version></install></upgrade></content></request>"
                    inst_job_id = _send_op_job_command(ip, api_key, ctx, inst_cmd, timeout=30)
                    poll_panorama_job(ip, api_key, ctx, inst_job_id, "Content Install")

                    # Confirm installed version from system info
                    sysinfo_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10)
                    m = re.search(r'<app-version>([^<]+)</app-version>', sysinfo_raw)
                    if m:
                        version = m.group(1).strip()

                state["content_upgraded"] = True
                if version:
                    state["content_version"] = version
                save_state(state_file, state)
            except Exception as e:
                LOGGER.error(f"Content upgrade failed: {e}")
                raise
        else:
            LOGGER.info("⏭️  Skipping Content upgrade (already complete).")

    # Step 9: Anti-Virus Upgrade via XML API
    if upgrade_av:
        if not state.get("av_upgraded"):
            LOGGER.info("Starting Anti-Virus Upgrade process...")
            try:
                LOGGER.info("1/3 Checking for latest Anti-Virus updates...")
                check_cmd = "<request><anti-virus><upgrade><check/></upgrade></anti-virus></request>"
                check_response = _send_op_command(ip, api_key, ctx, check_cmd, timeout=60)

                already_latest, version = _is_already_latest(check_response, "Anti-Virus")
                if not already_latest:
                    LOGGER.info("2/3 Downloading latest Anti-Virus update...")
                    dl_cmd = "<request><anti-virus><upgrade><download><latest/></download></upgrade></anti-virus></request>"
                    dl_job_id = _send_op_job_command(ip, api_key, ctx, dl_cmd, timeout=30)
                    poll_panorama_job(ip, api_key, ctx, dl_job_id, "Anti-Virus Download")

                    LOGGER.info("3/3 Installing latest Anti-Virus update...")
                    inst_cmd = "<request><anti-virus><upgrade><install><version>latest</version></install></upgrade></anti-virus></request>"
                    inst_job_id = _send_op_job_command(ip, api_key, ctx, inst_cmd, timeout=30)
                    poll_panorama_job(ip, api_key, ctx, inst_job_id, "Anti-Virus Install")

                    # Confirm installed version from system info
                    sysinfo_raw = _send_op_command(ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10)
                    m = re.search(r'<av-version>([^<]+)</av-version>', sysinfo_raw)
                    if m:
                        version = m.group(1).strip()

                state["av_upgraded"] = True
                if version:
                    state["av_version"] = version
                save_state(state_file, state)
            except Exception as e:
                LOGGER.error(f"Anti-Virus upgrade failed: {e}")
                raise
        else:
            LOGGER.info("⏭️  Skipping Anti-Virus upgrade (already complete).")

    # Step 10: PAN-OS Upgrade via XML API
    # Ordered before plugins so plugins are always installed against the final OS version.
    # Uses four granular state keys so a mid-flight failure (e.g. killed during reboot wait)
    # resumes at exactly the right sub-step without re-downloading the image.
    if upgrade_panos:
        if not state.get("panos_upgrade_verified"):
            LOGGER.info("Starting PAN-OS Upgrade process...")
            try:
                # Resolve the exact target version, reusing a previously stored result
                # so an interrupted run doesn't re-query on resume.
                if not state.get("panos_target_version"):
                    target_version, current_version = _resolve_panos_target_version(
                        ip, api_key, ctx, upgrade_panos
                    )
                    state["panos_target_version"] = target_version
                    state["panos_current_version_before_upgrade"] = current_version
                    save_state(state_file, state)
                else:
                    target_version = state["panos_target_version"]
                    current_version = state.get("panos_current_version_before_upgrade", "unknown")
                    LOGGER.info(f"Resuming PAN-OS upgrade to {target_version} (resolved in a previous run).")

                # Guard: already running the target version (covers re-runs after a successful upgrade)
                live_version = _get_current_panos_version(ip, api_key, ctx)
                if live_version == target_version:
                    LOGGER.info(f"✅ Already running target PAN-OS version {target_version}. Nothing to do.")
                    state["panos_upgrade_verified"] = True
                    save_state(state_file, state)
                else:
                    LOGGER.info(f"Upgrading PAN-OS: {current_version} → {target_version}")

                    # Sub-step 1: Download the target image.
                    # PAN-OS images are ~1 GB; allow 30 mins for the download job.
                    if not state.get("panos_upgrade_downloaded"):
                        LOGGER.info(f"Refreshing software update list before download...")
                        _send_op_command(
                            ip, api_key, ctx,
                            "<request><system><software><check/></software></system></request>",
                            timeout=60
                        )
                        LOGGER.info(f"1/4 Downloading PAN-OS {target_version}...")
                        # Fix #4: Use correct <system> XML tag for download command.
                        dl_cmd = (
                            f"<request><system><software><download>"
                            f"<version>{target_version}</version>"
                            f"</download></software></system></request>"
                        )
                        dl_job_id = _send_op_job_command(ip, api_key, ctx, dl_cmd, timeout=30)
                        poll_panorama_job(
                            ip, api_key, ctx, dl_job_id,
                            f"PAN-OS Download ({target_version})",
                            timeout_mins=30
                        )
                        state["panos_upgrade_downloaded"] = True
                        save_state(state_file, state)
                    else:
                        LOGGER.info("⏭️  Skipping PAN-OS image download (already complete).")

                    # Sub-step 2: Install the downloaded image (pre-reboot).
                    if not state.get("panos_upgrade_installed"):
                        LOGGER.info(f"2/4 Installing PAN-OS {target_version}...")
                        # Fix #4: Use correct <system> XML tag for install command.
                        inst_cmd = (
                            f"<request><system><software><install>"
                            f"<version>{target_version}</version>"
                            f"</install></software></system></request>"
                        )
                        inst_job_id = _send_op_job_command(ip, api_key, ctx, inst_cmd, timeout=30)
                        poll_panorama_job(
                            ip, api_key, ctx, inst_job_id,
                            f"PAN-OS Install ({target_version})",
                            timeout_mins=20
                        )
                        state["panos_upgrade_installed"] = True
                        save_state(state_file, state)
                    else:
                        LOGGER.info("⏭️  Skipping PAN-OS image installation (already complete).")

                    # Sub-step 3: Reboot to activate the new image.
                    # Unlike content/AV, a PAN-OS upgrade requires a full system reboot.
                    # The reboot command is fire-and-forget — the connection will drop immediately,
                    # so we mirror the serial number step's disconnect-handling pattern.
                    if not state.get("panos_upgrade_rebooted"):
                        LOGGER.info("3/4 Initiating system reboot to activate new PAN-OS version...")
                        reboot_cmd = "<request><restart><system/></restart></request>"
                        reboot_sent = False

                        for attempt in range(5):
                            try:
                                # Fix #5: Use timeout=5 so we strongly favour catching the
                                # expected connection drop rather than waiting for a full response
                                # that will never arrive once the device starts rebooting.
                                _send_op_command(ip, api_key, ctx, reboot_cmd, timeout=5)
                                LOGGER.info("Reboot command accepted by device.")
                                reboot_sent = True
                                break
                            except Exception as e:
                                # Fix #12: Use centralised disconnect helper.
                                if _is_expected_disconnect(e):
                                    LOGGER.info(
                                        "Connection dropped after reboot command (expected — "
                                        "Panorama is rebooting)."
                                    )
                                    reboot_sent = True
                                    break
                                LOGGER.warning(f"Reboot attempt {attempt+1}/5 failed: {e}. Retrying in 10 seconds...")
                                time.sleep(10)

                        if not reboot_sent:
                            raise RuntimeError("Failed to send reboot command to Panorama after multiple attempts.")

                        state["panos_upgrade_rebooted"] = True
                        save_state(state_file, state)
                    else:
                        LOGGER.info("⏭️  Skipping reboot (already triggered in a previous run). "
                                    "Proceeding directly to post-reboot verification.")

                    # Sub-step 4: Wait for Panorama to come back up and verify the new version.
                    # A PAN-OS upgrade reboot typically takes 10-20 minutes on Panorama.
                    # We poll every 15 seconds for up to ~20 minutes (80 attempts).
                    LOGGER.info("4/4 Waiting for Panorama to come back up after reboot...")
                    LOGGER.info("(A PAN-OS upgrade reboot typically takes 10–20 minutes on Panorama)")
                    version_verified = False

                    for attempt in range(80):  # Up to ~20 mins (80 * 15s)
                        time.sleep(15)
                        try:
                            # Fix #1: Use the canonical _CMD_SHOW_SYSTEM_INFO constant.
                            sysinfo_raw = _send_op_command(
                                ip, api_key, ctx, _CMD_SHOW_SYSTEM_INFO, timeout=10
                            )
                            # Check both XML-structured and plaintext response formats,
                            # mirroring the serial number verification pattern.
                            if (f"<sw-version>{target_version}</sw-version>" in sysinfo_raw
                                    or f"sw-version: {target_version}" in sysinfo_raw):
                                LOGGER.info(f"✅ PAN-OS version successfully verified: {target_version}")
                                version_verified = True
                                break

                            # Device is up but running an unexpected version — log and keep waiting
                            match = re.search(r'(?:<sw-version>|sw-version:\s*)([^<\r\n]+)', sysinfo_raw)
                            running_version = match.group(1).strip() if match else "unknown"
                            LOGGER.info(
                                f"Web server is up, but running version is '{running_version}' "
                                f"(expected '{target_version}'). Waiting... (Attempt {attempt+1}/80)"
                            )
                        except Exception as e:
                            LOGGER.debug(
                                f"Web server still unreachable — Panorama is likely still rebooting. "
                                f"(Attempt {attempt+1}/80)"
                            )

                    if not version_verified:
                        raise RuntimeError(
                            f"Timed out waiting for Panorama to come back up running PAN-OS {target_version}. "
                            f"The device may still be rebooting — re-run this script to resume verification."
                        )

                    state["panos_upgrade_verified"] = True
                    save_state(state_file, state)

            except Exception as e:
                LOGGER.error(f"PAN-OS upgrade failed: {e}")
                raise
        else:
            completed_version = state.get("panos_target_version", upgrade_panos)
            LOGGER.info(f"⏭️  Skipping PAN-OS upgrade (already on {completed_version}).")

    # Step 11: Plugin Installation via XML API
    if plugins:
        plugin_list = [p.strip() for p in plugins.split(",") if p.strip()]

        LOGGER.info("Checking currently installed plugins on the device...")
        installed_cmd = "<show><plugins><installed/></plugins></show>"

        installed_raw = ""
        for attempt in range(6):
            try:
                installed_raw = _send_op_command(ip, api_key, ctx, installed_cmd, timeout=30)
                break
            except Exception as e:
                LOGGER.debug(f"Connection error while checking installed plugins: {e}. Retrying...")
                time.sleep(10)

        installed_plugins_state = state.get("plugins_installed", [])
        plugins_to_install = []

        for p in plugin_list:
            # Fix #10: Match the full plugin name as a complete token rather than using
            # a raw substring check. The original `if p in installed_raw` would incorrectly
            # skip 'aws-5.4.3' if 'aws-5.4' was already present in the response string,
            # leading to a silently missed install.
            #
            # We use a word-boundary-aware pattern so that 'aws-5.4' does NOT match 'aws-5.4.3'.
            # The pattern anchors the plugin name and requires it to be followed by a non-version
            # character (whitespace, tag close, or end of string).
            plugin_in_device = bool(re.search(
                re.escape(p) + r'(?=[<\s"\']|$)',
                installed_raw
            ))

            if plugin_in_device:
                LOGGER.info(f"✅ Plugin '{p}' is already installed on the device. Skipping.")
                if p not in installed_plugins_state:
                    installed_plugins_state.append(p)
            elif p in installed_plugins_state:
                LOGGER.info(f"✅ Plugin '{p}' is marked as installed in state file. Skipping.")
            else:
                plugins_to_install.append(p)

        state["plugins_installed"] = installed_plugins_state
        save_state(state_file, state)

        if plugins_to_install:
            LOGGER.info(f"Starting Plugin Installation process for: {', '.join(plugins_to_install)}")
            try:
                LOGGER.info("Checking for available plugins...")
                check_cmd = "<request><plugins><check/></plugins></request>"
                _send_op_command(ip, api_key, ctx, check_cmd, timeout=60)

                for plugin in plugins_to_install:
                    LOGGER.info(f"Downloading plugin '{plugin}'...")
                    dl_cmd = f"<request><plugins><download><file>{plugin}</file></download></plugins></request>"
                    dl_job_id = _send_op_job_command(ip, api_key, ctx, dl_cmd, timeout=30)
                    poll_panorama_job(ip, api_key, ctx, dl_job_id, f"Plugin Download ({plugin})")

                    LOGGER.info(f"Installing plugin '{plugin}'...")
                    inst_cmd = f"<request><plugins><install>{plugin}</install></plugins></request>"
                    inst_job_id = _send_op_job_command(ip, api_key, ctx, inst_cmd, timeout=30)
                    poll_panorama_job(ip, api_key, ctx, inst_job_id, f"Plugin Install ({plugin})")

                    # Validation step — use the same exact-match regex as the pre-check above.
                    LOGGER.info(f"Validating installation of '{plugin}'...")
                    verified = False
                    for val_attempt in range(12):  # Wait up to 3 minutes
                        time.sleep(15)
                        try:
                            validate_raw = _send_op_command(ip, api_key, ctx, installed_cmd, timeout=15)
                            # Fix #10: Consistent exact-match check in the validation loop.
                            if re.search(re.escape(plugin) + r'(?=[<\s"\']|$)', validate_raw):
                                LOGGER.info(f"✅ Verified '{plugin}' appears in installed plugins list.")
                                verified = True
                                break
                            else:
                                LOGGER.info(f"Plugin '{plugin}' not yet in installed list. Waiting... (Attempt {val_attempt+1}/12)")
                        except Exception as e:
                            LOGGER.debug(f"Web server unreachable during validation (likely restarting): {e}")

                    if not verified:
                        LOGGER.warning(f"Plugin '{plugin}' installed via job, but could not be verified in 'show plugins installed'.")

                    installed_plugins_state.append(plugin)
                    state["plugins_installed"] = installed_plugins_state
                    save_state(state_file, state)

            except Exception as e:
                LOGGER.error(f"Plugin installation failed: {e}")
                raise
        else:
            LOGGER.info("⏭️  Skipping Plugin installation (all requested plugins already installed).")

    # Step 12: Generate VM Auth Key
    # Fix #8: Default is now None so that omitting --vm-auth-key on the CLI correctly
    # skips this step. The original default of 8760 meant the key was always generated,
    # even when the flag was never passed.
    if vm_auth_key_hours is not None:
        if not state.get("vm_auth_key"):
            LOGGER.info(f"Generating VM Auth Key with lifetime {vm_auth_key_hours} hours...")
            try:
                cmd_xml = f"<request><bootstrap><vm-auth-key><generate><lifetime>{vm_auth_key_hours}</lifetime></generate></vm-auth-key></bootstrap></request>"
                raw_response = _send_op_command(ip, api_key, ctx, cmd_xml, timeout=30)

                # Parse the response XML to extract the text
                try:
                    root = ET.fromstring(raw_response)
                    result_text = root.findtext(".//result", default=raw_response)
                except ET.ParseError:
                    result_text = raw_response

                # Expected format: "VM auth key 891933040429594 generated. Expires at: 2027/03/30 13:03:21"
                match = re.search(r"VM auth key\s+(\S+)\s+generated\.\s+Expires at:\s+(.*)", result_text)
                if match:
                    auth_key = match.group(1).strip()
                    expiry = match.group(2).strip()
                    LOGGER.info(f"✅ VM Auth Key generated: {auth_key} (Expires: {expiry})")

                    state["vm_auth_key"] = auth_key
                    state["vm_auth_key_expiry"] = expiry
                    save_state(state_file, state)
                else:
                    LOGGER.warning(f"Could not parse VM Auth Key from response: {result_text}")
                    raise RuntimeError("Failed to parse VM Auth Key from response.")

            except Exception as e:
                LOGGER.error(f"Failed to generate VM Auth Key: {e}")
                raise
        else:
            auth_key = state.get("vm_auth_key")
            expiry = state.get("vm_auth_key_expiry")
            LOGGER.info(f"⏭️  Skipping VM Auth Key generation (already generated: {auth_key}, Expires: {expiry}).")

    LOGGER.info(f"🎉 Provisioning of Panorama at {ip} is complete!")


def main():
    parser = argparse.ArgumentParser(
        description="Idempotent Initial Provisioning for Virtual Panorama VMs",
        formatter_class=argparse.RawTextHelpFormatter
    )

    # Positional argument for IP — optional when --state-file is provided (IP is read from state).
    parser.add_argument(
        "ip",
        nargs="?",
        default=None,
        help="The IP address of the Panorama VM to connect to. Optional if --state-file is provided."
    )

    # Optional arguments
    parser.add_argument(
        "--hostname",
        default=None,
        help="Hostname to set on the Panorama VM (default: Panorama-Management)."
    )
    parser.add_argument(
        "--public-ip",
        nargs="?",
        const="_auto_",
        default=None,
        metavar="IP",
        help=(
            "Set deviceconfig system public-ip-address so managed firewalls can "
            "bootstrap to Panorama via a public/NAT address.\n"
            "  --public-ip          Use the connecting IP automatically "
            "(only valid when it is non-RFC1918).\n"
            "  --public-ip 1.2.3.4  Use the specified IP (required when "
            "connecting via a jump host or private IP)."
        )
    )
    parser.add_argument(
        "--username",
        default=None,
        help="The SSH/API username. Defaults to value stored in state file, or 'admin' if not found."
    )
    parser.add_argument(
        "--ssh-key",
        default="~/.ssh/id_rsa",
        metavar="PATH",
        help="Path to your SSH private key file (default: ~/.ssh/id_rsa)."
    )
    parser.add_argument(
        "--state-file",
        default=None,
        metavar="PATH",
        help="Path to save the state JSON file. Defaults to './panorama-<ip>-state.json'."
    )
    parser.add_argument(
        "--serial-number",
        default=None,
        help="Serial number to apply to the Panorama VM via the XML API."
    )
    parser.add_argument(
        "--otp",
        default=None,
        help="One-Time Password (OTP) for fetching the device certificate."
    )
    parser.add_argument(
        "--csp-api-key",
        default=None,
        help="Customer Support Portal (CSP) API Key for licensing."
    )
    parser.add_argument(
        "--upgrade-content",
        action="store_true",
        help="Check, download, and install the latest Content update."
    )
    parser.add_argument(
        "--upgrade-av",
        action="store_true",
        help="Check, download, and install the latest Anti-Virus update."
    )
    parser.add_argument(
        "--upgrade-panos",
        default=None,
        metavar="VERSION",
        help=(
            "Upgrade PAN-OS to the specified version (e.g. 11.2.8).\n"
            "Use 'latest' to automatically select the newest available version\n"
            "within the same major.minor family as the currently running version.\n"
            "Note: This triggers a full system reboot. The script will wait up to\n"
            "20 minutes for Panorama to come back up and verify the new version.\n"
            "If the script is interrupted during the reboot wait, simply re-run\n"
            "the same command — it will resume at the verification step.\n"
            "Cross-family upgrades (e.g. 10.2 → 11.0) require stepping through\n"
            "intermediate versions and will produce a warning."
        )
    )
    parser.add_argument(
        "--plugins",
        default=None,
        help="Comma-separated list of plugins to download and install (e.g. vm_series-2.1.6,aws-3.0.0)."
    )
    parser.add_argument(
        "--vm-auth-key",
        dest="vm_auth_key_hours",
        type=int,
        nargs='?',
        const=8760,
        # Fix #8: Default changed from 8760 to None.
        # With default=8760, the VM auth key step ran unconditionally on every invocation
        # because the guard `if vm_auth_key_hours is not None` was always True.
        # Now, omitting --vm-auth-key entirely skips key generation.
        # Passing --vm-auth-key with no value uses the 8760-hour default.
        # Passing --vm-auth-key 4380 uses the specified lifetime.
        default=None,
        help=(
            "Generate a VM auth key with the specified lifetime in hours.\n"
            "Passing the flag without a value uses the default of 8760 hours (1 year).\n"
            "Omitting this flag entirely skips VM auth key generation."
        )
    )
    parser.add_argument(
        "--configure-ha",
        metavar="PEER_IP",
        default=None,
        help=(
            "Configure Active/Passive HA with the given peer Panorama IP.\n"
            "Both nodes must have been provisioned with panorama_init.py first\n"
            "(api_password is read from each node's state file).\n"
            "The current node becomes the primary (active); PEER_IP becomes secondary (passive)."
        )
    )
    parser.add_argument(
        "--connectivity",
        choices=["private", "public"],
        default="private",
        help=(
            "HA peer IP connectivity. 'private' (default): reads each node's private\n"
            "management IP from show system info and uses that as the HA peer address\n"
            "(intra-VPC/VNet, no encryption needed). 'public': uses the passed\n"
            "management IPs directly as the HA peer address."
        )
    )
    parser.add_argument(
        "--ha-peer-state-file",
        metavar="PATH",
        default=None,
        help="Explicit state file for the HA peer node. Auto-discovered by peer IP if omitted."
    )
    parser.add_argument(
        "--configure-local-lc",
        action="store_true",
        help=(
            "Configure the local log collector on a Panorama instance running in panorama-mode.\n"
            "Requires: license applied, panorama-mode, at least one attached log disk.\n"
            "See also: --collector-group-name"
        )
    )
    parser.add_argument(
        "--collector-group-name",
        metavar="NAME",
        default="default",
        help="Collector group name for --configure-local-lc (default: 'default')"
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable verbose debug logging (including XML requests/responses)."
    )

    args = parser.parse_args()

    if args.debug:
        LOGGER.setLevel(logging.DEBUG)

    # Read password from environment variable
    panorama_password = os.environ.get("PANORAMA_PASSWORD")

    # Resolve paths
    ssh_key_path = Path(args.ssh_key).expanduser().resolve()

    # Resolve state file, IP, and username. IP and username may be omitted when
    # --state-file is given explicitly; both are read from the state file if present.
    if args.state_file:
        state_file_path = Path(args.state_file).expanduser().resolve()
        stored = load_state(state_file_path)
        ip = args.ip or stored.get("ip")
        if not ip:
            parser.error(
                "No IP address found in the state file and none was provided. "
                "Please pass the IP as a positional argument."
            )
        if not args.ip:
            LOGGER.info(f"Using IP '{ip}' from state file.")
    else:
        if not args.ip:
            parser.error("ip is required unless --state-file is provided.")
        ip = args.ip
        state_file_path = _discover_state_file(ip)
        stored = load_state(state_file_path) if state_file_path.is_file() else {}

    username = args.username or stored.get("username") or "admin"
    if not args.username and stored.get("username"):
        LOGGER.info(f"Using username '{username}' from state file.")

    # Resolve --public-ip early so the value is available to both provision_panorama
    # and configure_local_log_collector without duplicating the RFC1918 logic.
    resolved_public_ip = None
    if args.public_ip == "_auto_":
        if not _is_rfc1918(ip):
            resolved_public_ip = ip
        else:
            LOGGER.warning(
                f"--public-ip with no value requires a non-RFC1918 connecting IP "
                f"({ip} is private). Pass --public-ip <public-ip> explicitly."
            )
    elif args.public_ip:
        resolved_public_ip = args.public_ip

    # --configure-ha is mutually exclusive with provisioning (operates on two nodes).
    # --configure-local-lc can run standalone or sequentially after provision_panorama
    # in the same invocation when combined with provisioning args like --serial-number.
    _provision_args = any([
        args.serial_number, args.otp, args.csp_api_key,
        args.upgrade_content, args.upgrade_av, args.upgrade_panos,
        args.plugins, args.vm_auth_key_hours is not None, args.hostname,
    ])

    if args.configure_ha:
        peer_ip = args.configure_ha
        if args.ha_peer_state_file:
            peer_state_file = Path(args.ha_peer_state_file).expanduser().resolve()
        else:
            peer_state_file = _discover_state_file(peer_ip)
        try:
            configure_panorama_ha(
                primary_ip=ip,
                peer_ip=peer_ip,
                username=username,
                primary_state_file=state_file_path,
                peer_state_file=peer_state_file,
                connectivity=args.connectivity,
            )
        except Exception as e:
            LOGGER.error(f"HA configuration failed: {e}", exc_info=True)
            sys.exit(1)
    else:
        if _provision_args or not args.configure_local_lc:
            try:
                provision_panorama(
                    ip=ip,
                    username=username,
                    ssh_key=ssh_key_path,
                    password=panorama_password,
                    state_file=state_file_path,
                    serial_number=args.serial_number,
                    otp=args.otp,
                    csp_api_key=args.csp_api_key,
                    upgrade_content=args.upgrade_content,
                    upgrade_av=args.upgrade_av,
                    upgrade_panos=args.upgrade_panos,
                    plugins=args.plugins,
                    vm_auth_key_hours=args.vm_auth_key_hours,
                    hostname=args.hostname,
                    public_ip=resolved_public_ip,
                )
            except Exception as e:
                LOGGER.error(f"Provisioning failed: {e}", exc_info=True)
                sys.exit(1)

        if args.configure_local_lc:
            try:
                configure_local_log_collector(
                    ip=ip,
                    username=username,
                    state_file=state_file_path,
                    collector_group_name=args.collector_group_name,
                    ssh_key_path=ssh_key_path,
                    public_ip=resolved_public_ip,
                )
            except Exception as e:
                LOGGER.error(f"Local log collector configuration failed: {e}", exc_info=True)
                sys.exit(1)


if __name__ == "__main__":
    main()
