# 1. Cloud NGFW for Azure: Application Gateway, XFF, and L7 source visibility (Part 3, advanced)

----------
This is an **optional advanced activity** that builds on [Part 3: Cloud NGFW for Azure](AZURE-CLOUDNGFW-ADDENDUM.md). Complete that lab first: you need your Cloud NGFW deployed in the Virtual WAN hub, registered to your Panorama, and passing inbound traffic to the WordPress VMs.

***This guide is for a guided workshop / learning environment. Do not use it as-is for production.***

----------

# 2. Overview

In the base lab, inbound traffic reaches your app through a simple **destination NAT** on the firewall's public IP (`public-ip:80` → `app1` at `10.100.0.4:80`). The firewall sees the **real client IP** as the source, because nothing sits between the client and the firewall.

Real inbound applications rarely look like that. They sit behind an **L7 load balancer** (here, an **Azure Application Gateway**) that terminates the client connection and opens a *new* connection to the backend. That single architectural change has a big consequence for the firewall:

> &#8505; **The problem you are about to see.** Once an Application Gateway is in the path, the firewall no longer sees the client. It sees the **Application Gateway's own private IP** as the source of every request. Your source-based policy, your logs, and your threat attribution all now point at the load balancer, not the user.

This activity walks three scenarios:

- **Scenario 1**: Insert an Application Gateway in front of `app1` and watch the firewall's view of the source IP change from the client to the gateway.
- **Scenario 2**: Replace the lab's wide-open rule with a real **hygiene + CDSS** policy and confirm the firewall is inspecting the App Gateway traffic.
- **Scenario 3**: Restore real client-IP visibility and enforcement with **X-Forwarded-For (XFF)**, then prove a policy that allows or blocks a specific client.

> &#10067; Before you start: in the base lab, whose IP did the firewall log as the source of inbound web traffic? Write down your answer; you will compare it after Scenario 1.

# 3. Architecture

You add **one new spoke** that holds only the Application Gateway, and you point the gateway at the **existing** `app1` VM. Because the App Gateway and `app1` live in different spokes, the gateway-to-backend traffic is steered through the Cloud NGFW by the same Virtual WAN routing intent you already deployed.

```
        client  (real source IP)
          │  HTTP to the App Gateway public IP
          ▼
 ┌───────────────────────────┐   new spoke VNet  10.100.2.0/24
 │   Application Gateway v2   │   appgw-subnet    10.100.2.0/26
 │   (L7 reverse proxy)       │   UDR: 0.0.0.0/0 -> Internet  (App GW control plane)
 └─────────────┬─────────────┘
               │  NEW connection, source = App Gateway subnet IP (10.100.2.x)
               │  routed to the hub by routing intent (PrivateTraffic)
               ▼
        ┌──────────────┐
        │  Cloud NGFW  │   Virtual WAN hub
        └──────┬───────┘   the firewall now sees 10.100.2.x as the source, not the client
               ▼
        app1-vm  10.100.0.4:80  (WordPress)   spoke VNet 10.100.0.0/25
```

> &#9888; **Application Gateway v2 cannot be force-tunneled.** Its management ("control plane") traffic must reach the internet directly. Your hub routing intent sends `0.0.0.0/0` to the firewall, so you **must** add a route on the App Gateway subnet that sends `0.0.0.0/0` straight to the internet, or the gateway will fail to deploy or go unhealthy. You will do this in Scenario 1.

# 4. Set up your shell variables

Run everything in **Azure Cloud Shell** (Bash), the same place you ran the base lab. Set these once; the rest of the guide reuses them.

```
# Your base-lab values (same prefix/RG/region you used in Part 3)
PREFIX="<your-prefix>"                 # e.g. your initials, exactly as in Part 3
RG="<your-prefix>-cngfw-rg"
LOCATION="<your-region>"               # e.g. eastus2

# Discover your firewall and the IP you route to it (the firewall's trust-subnet UDR IP)
FW_ID=$(az resource list -g "$RG" --resource-type paloaltonetworks.cloudngfw/firewalls --query "[0].id" -o tsv)
FW_TRUST_IP=$(az resource show --ids "$FW_ID" \
  --query "properties.networkProfile.vwanConfiguration.ipOfTrustSubnetForUdr.address" -o tsv)
echo "Firewall trust-subnet UDR IP: $FW_TRUST_IP"
```

> &#8505; `FW_TRUST_IP` is the next hop you use when you want a subnet's traffic to be inspected by the Cloud NGFW. It is unique to **your** deployment, so always read it back rather than hard-coding it.

# 5. Scenario 1: Insert the Application Gateway and watch the source IP change

## 5.1. Create the App Gateway spoke (VNet, subnet, NSG, routes)

- Create the new spoke VNet and a dedicated App Gateway subnet:

```
az network vnet create -g "$RG" -l "$LOCATION" -n "$PREFIX-appgw-vnet" \
  --address-prefixes 10.100.2.0/24 \
  --subnet-name appgw-subnet --subnet-prefixes 10.100.2.0/26
```

- Create the NSG. Application Gateway v2 **requires** inbound from the `GatewayManager` service tag on `65200-65535`; you also allow client HTTP on `80`:

```
az network nsg create -g "$RG" -l "$LOCATION" -n "$PREFIX-appgw-nsg"
az network nsg rule create -g "$RG" --nsg-name "$PREFIX-appgw-nsg" -n AllowGatewayManager \
  --priority 100 --direction Inbound --access Allow --protocol Tcp \
  --source-address-prefixes GatewayManager --destination-port-ranges 65200-65535
az network nsg rule create -g "$RG" --nsg-name "$PREFIX-appgw-nsg" -n AllowClientHTTP \
  --priority 120 --direction Inbound --access Allow --protocol Tcp \
  --source-address-prefixes Internet --destination-port-ranges 80
```

- Create the route table. One route keeps the gateway's control plane healthy (`0.0.0.0/0` → `Internet`); the other sends gateway-to-`app1` traffic through the firewall (`10.100.0.0/26` → the firewall trust IP):

```
az network route-table create -g "$RG" -l "$LOCATION" -n "$PREFIX-appgw-rt"
az network route-table route create -g "$RG" --route-table-name "$PREFIX-appgw-rt" \
  -n default-to-internet --address-prefix 0.0.0.0/0 --next-hop-type Internet
az network route-table route create -g "$RG" --route-table-name "$PREFIX-appgw-rt" \
  -n app1-via-cngfw --address-prefix 10.100.0.0/26 \
  --next-hop-type VirtualAppliance --next-hop-ip-address "$FW_TRUST_IP"
```

- Attach the NSG and route table to the App Gateway subnet:

```
az network vnet subnet update -g "$RG" --vnet-name "$PREFIX-appgw-vnet" -n appgw-subnet \
  --network-security-group "$PREFIX-appgw-nsg" --route-table "$PREFIX-appgw-rt"
```

> &#10067; Why does the `0.0.0.0/0 -> Internet` route not also send the gateway-to-`app1` traffic to the internet? (Hint: longest-prefix match. Which route wins for a packet destined to `10.100.0.4`?)

## 5.2. Connect the spoke to the hub and create the gateway

- Connect the new spoke to your Virtual WAN hub so it inherits routing intent:

```
az network vhub connection create -g "$RG" --vhub-name virtual_hub \
  -n appgw-to-hub --remote-vnet "$PREFIX-appgw-vnet"
```

- Create the public IP and the Application Gateway. The backend pool is the **existing** `app1` VM at `10.100.0.4`:

```
az network public-ip create -g "$RG" -l "$LOCATION" -n "$PREFIX-appgw-pip" \
  --sku Standard --allocation-method Static

az network application-gateway create -g "$RG" -l "$LOCATION" -n "$PREFIX-appgw" \
  --sku Standard_v2 --capacity 2 \
  --vnet-name "$PREFIX-appgw-vnet" --subnet appgw-subnet \
  --public-ip-address "$PREFIX-appgw-pip" \
  --frontend-port 80 \
  --http-settings-port 80 --http-settings-protocol Http \
  --servers 10.100.0.4 \
  --priority 100
```

> &#9888; **The gateway takes ~6 to 10 minutes to deploy.** Start it, then read ahead. Run `az network application-gateway show -g "$RG" -n "$PREFIX-appgw" --query provisioningState -o tsv` until it returns `Succeeded`.

## 5.3. Confirm it works and observe the source IP

- Check backend health (it should be `Healthy`; if not, see the gotcha below):

```
az network application-gateway show-backend-health -g "$RG" -n "$PREFIX-appgw" \
  --query "backendAddressPools[].backendHttpSettingsCollection[].servers[]" -o json
```

- Get the gateway's public IP and browse to it:

```
az network public-ip show -g "$RG" -n "$PREFIX-appgw-pip" --query ipAddress -o tsv
# open http://<that-ip> in your browser -> the app1 WordPress page
```

- Now open **Panorama → Monitor → Traffic** (Cloud NGFW logs flow to Strata Logging Service and surface here) and find the request you just made to `app1`.

> &#8505; **The payoff.** The session to `app1` (`10.100.0.4`, app `web-browsing`) shows a **source IP from the App Gateway subnet, `10.100.2.0/26`** (one of the gateway's instance IPs), not your browser's address. The Application Gateway terminated your connection and opened its own to the backend, so from the firewall's point of view the gateway *is* the client.

> &#10067; Compare with the answer you wrote down in §2. In the base-lab DNAT path the firewall logged the real client IP; through the Application Gateway it logs `10.100.2.x`. Where did the client IP go, and why can the firewall no longer see it?

> &#9888; **Prove the firewall is really in the path (optional, 2 min).** Add a security rule *above* `allow-web` that **denies** `source 10.100.2.0/26` to `destination 10.100.0.4`, then `Commit` + `Push`. Within a minute the App Gateway backend health goes from healthy to a probe **timeout** and the page stops loading, because the firewall is dropping the gateway-to-backend traffic on a rule keyed to the gateway's source IP. That is direct proof the firewall both sits in the path and sees `10.100.2.x` as the source. **Delete the deny rule and push again before continuing.**

> &#9888; **Backend shows `Unhealthy`?** The gateway's health probe to `app1:80` is itself traffic through the Cloud NGFW, so it must be allowed by policy. The base lab's `allow-web` rule is wide open, so it passes today; once you tighten policy in Scenario 2, make sure your rule still permits the App Gateway subnet to reach `app1` on `80`.

# 6. Scenario 2: Replace the open rule with hygiene + CDSS

> &#8505; **Why.** The base lab pushed a single `allow-web` rule (`source any`, `destination any`, `application any`) just to get traffic flowing. That is fine for a smoke test and wrong for everything after it: it permits any source to any destination, and it inspects nothing. Now that you can see the App Gateway traffic, give it a real rule and turn on the subscriptions.

> &#8505; Cloud NGFW supports only the `any` zone, so you scope with **source and destination address**, not zones. You do this work in **Panorama**, in your `cngfw-<your-prefix>` device group.

## 6.1. Build a Security Profile Group

- In Panorama, go to **Objects → Security Profile Groups**, pick your cloud device group, and **Add** a group named `appgw-cdss`. Set the predefined best-practice profiles:
  - **Antivirus** = `default`
  - **Anti-Spyware** = `strict`
  - **Vulnerability Protection** = `strict`
  - **URL Filtering** = `default`
  - **WildFire Analysis** = `default`

> &#8505; These predefined profiles map to the Cloud NGFW subscriptions (Advanced Threat Prevention, Advanced WildFire, Advanced URL Filtering, DNS Security). Starting from the predefined `strict`/`default` set is the fast path to a sane baseline; you tune from there.

## 6.2. Write a scoped rule for the App Gateway traffic

- Go to **Policies → Security**, choose your `cngfw-<your-prefix>` device group, and **Add** a rule *above* `allow-web`:
  - **Name** `allow-appgw-app1`
  - **Source Zone** `any`; **Source Address** `10.100.2.0/26` (the App Gateway subnet)
  - **Destination Zone** `any`; **Destination Address** `10.100.0.4` (app1)
  - **Application** `web-browsing`
  - **Service** `application-default`
  - **Action** `Allow`; **Profile Setting → Group Profile** = `appgw-cdss`
  - **Log at Session End** on
- **Commit → Commit to Panorama**, then **Push to Devices** → your cloud device group.

## 6.3. Confirm inspection is happening

- Browse the App Gateway public IP again, then open **Panorama → Monitor → Traffic**.

> &#8505; **What you should see.** The session now matches **rule `allow-appgw-app1`** with **application `web-browsing`** (not just "tcp/80"). That is the firewall doing L7 App-ID and running your CDSS profiles on the traffic, scoped to exactly the App Gateway source and the `app1` destination.

> &#9888; Keep this rule permitting the App Gateway subnet to `app1` on `web-browsing` / `application-default`. The gateway health probe is HTTP, so if you scope it too tightly the backend goes unhealthy.

> &#10067; Two questions to be able to answer: (1) why is `service application-default` better hygiene than `service any` on an allow rule? (2) You scoped the source to `10.100.2.0/26`. Given what you saw in Scenario 1, why is that the *right* source to match, and what would break if you tried to scope it to the real client IPs instead? (Hold that thought for Scenario 3.)

> &#10067; **Optional challenge.** With `strict` profiles attached, view **Monitor → Threat** while you send a few odd requests through the gateway. What gets logged, and which profile in the group caught it?

# 7. Scenario 3: Get the real client back with X-Forwarded-For

In Scenario 1 you lost the client IP; in Scenario 2 you wrote policy against the *gateway's* IP. That works for allowing the gateway, but it means every user looks identical to the firewall: you cannot allow, block, or attribute by real client. **X-Forwarded-For** fixes that.

> &#8505; **What XFF is.** The Application Gateway records the original client IP in an `X-Forwarded-For` HTTP header when it opens the backend connection. If you tell the firewall to read that header, it will use the **real client IP** (not the gateway IP) as the source for security-policy matching and logging.

> &#9888; **This only works because your Cloud NGFW is Panorama-managed.** XFF for security policy is a Panorama-path feature; it is **not** supported under SCM-managed Cloud NGFW. Your Part 3 lab is Panorama-managed, so you are on the right side of that line.

## 7.1. Turn on XFF in the template

- In Panorama, go to **Device**, and at the top set the **Template** to your Cloud NGFW template (the one in your `cngfw-<your-prefix>` stack).
- Navigate to **Device → Setup → Content-ID → X-Forwarded-For Headers**, click the edit icon, and set **Use X-Forwarded-For Header** to **Enabled for Security Policy**.
- Click **OK**, then **Commit → Commit to Panorama** and **Push to Devices** → your cloud device group.

> &#9888; **XFF and User-ID are mutually exclusive here.** You cannot enable *Use X-Forwarded-For Header* for security policy and for User-ID at the same time. This lab uses it for security policy.

> &#8505; **Optional hardening: strip the port.** The Application Gateway writes XFF as `client-ip:port`. The firewall matched the client IP correctly in our testing even with the port present, but Microsoft and the Cloud NGFW admin guide recommend stripping it for clean parsing and accurate `xff` logging. You do that with an Application Gateway **rewrite rule** that sets `X-Forwarded-For` to the `client_ip` server variable. See Azure's "Rewrite HTTP headers" docs for the exact rewrite-rule-set syntax.

## 7.2. Prove enforcement on the real client IP

This is the payoff. You will block *your own* browser by its real IP, even though it is hidden behind the gateway.

- Find your client's public IP (for example browse to `https://checkip.amazonaws.com` from the same machine).
- In Panorama, add a security rule **above** `allow-appgw-app1`:
  - **Name** `block-my-client`
  - **Source Zone** `any`; **Source Address** = your public IP (as a `/32`)
  - **Destination Zone** `any`; **Destination Address** `10.100.0.4`
  - **Application** `any`; **Service** `any`; **Action** `Deny`; **Log at Session End** on
- **Commit** and **Push**, then browse to the App Gateway public IP again.

> &#8505; **What you should see.** Your browser now fails (the page returns a `502` from the gateway, because the firewall dropped the gateway-to-backend request). Meanwhile **App Gateway backend health stays healthy**. That split is the whole point:
> - Your request carries `X-Forwarded-For: <your-ip>`, so the firewall evaluates it as coming from `<your-ip>` and hits the deny.
> - The gateway's health probe carries **no** XFF header, so the firewall still sees it as `10.100.2.x` and it is not denied.
>
> The firewall is now making decisions on the **real client**, through the load balancer.

> &#10067; Before XFF, a deny on your client IP did nothing through the gateway (the firewall only saw `10.100.2.x`). After XFF, the same rule blocks you but not the probe. Explain why the probe is unaffected.

- **Clean up the demo:** delete the `block-my-client` rule, then **Commit** and **Push**. (In the real world you would instead use XFF to *allow* only known client ranges, geo-block, or attribute traffic to users in the logs.)

# 8. What you built, and what is next

You inserted an L7 load balancer in front of a Cloud NGFW-protected app and worked the consequences end to end:

- **Scenario 1:** saw the firewall's source visibility collapse to the gateway IP once the App Gateway was in the path.
- **Scenario 2:** replaced the wide-open rule with a scoped, App-ID-aware rule and CDSS profiles, and confirmed inspection.
- **Scenario 3:** restored real-client visibility and enforcement with X-Forwarded-For on your Panorama-managed Cloud NGFW.

> &#8505; **Coming next (separate activity).** With the client connection still plain HTTP, the firewall can read XFF directly. When you put **TLS** on the App Gateway and re-encrypt to the backend, the firewall can no longer read the headers without decrypting. The follow-on activity terminates TLS at the App Gateway and uses Cloud NGFW **forward-proxy (MITM) decryption** on the gateway-to-backend leg, with the App Gateway trusting the firewall's CA.

# 9. Clean up

The Application Gateway and its public IP bill while they exist. When you are done, remove what this activity added (leave your Part 3 base lab intact):

```
az network application-gateway delete -g "$RG" -n "$PREFIX-appgw"
az network public-ip delete -g "$RG" -n "$PREFIX-appgw-pip"
az network vhub connection delete -g "$RG" --vhub-name virtual_hub -n appgw-to-hub
az network vnet delete -g "$RG" -n "$PREFIX-appgw-vnet"
az network route-table delete -g "$RG" -n "$PREFIX-appgw-rt"
az network nsg delete -g "$RG" -n "$PREFIX-appgw-nsg"
```

Then, in Panorama, remove the `allow-appgw-app1` rule and `appgw-cdss` profile group you added, set XFF back to `Disabled` if you wish, and **Commit** + **Push**.
