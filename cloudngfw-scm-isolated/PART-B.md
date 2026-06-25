# Cloud NGFW for AWS + Strata Cloud Manager - Part B: Account Onboarding (and what it unlocks)

> &#8505; Part B builds on the core lab (`README.md` in this directory). Do not start here. You should already have a Cloud NGFW inspecting both directions of your application VPC with only your account **allowlisted**. Part B adds the cross-account IAM roles that unlock what allowlisting alone cannot: TLS decryption, CloudWatch logging and metrics, and SCM-managed endpoints.

```
Manual Last Updated: 2026-06-25
```

The lab guide syntax conventions are the same as the core lab: bullets are actions to take, code blocks are for copy / paste, `> &#8505;` blocks are extra context, and `> &#10067;` blocks are check-your-understanding questions.

## 1. Why the core lab did not need onboarding

In the core lab you inspected real traffic in both directions with **nothing but your account allowlisted**. Allowlisting let you create a customer-managed Gateway Load Balancer endpoint in your VPC pointing at the firewall, and SCM-native policy did the rest.

What allowlisting could not do on its own:

- Forward logs and metrics into your own AWS account (CloudWatch).
- Decrypt **inbound** TLS using your application's own server certificate (the firewall has to read that certificate from your account).
- Let SCM create and manage the GWLB endpoint for you.

Account onboarding is what adds those. Onboarding means deploying one CloudFormation template into your account that creates four cross-account IAM roles. Each role lets the Palo Alto Cloud NGFW service assume a role **in your account** to do one specific job.

> &#8505; **Outbound** decryption is the exception: it uses the firewall's own forward-trust CA, managed entirely in SCM, so it needs no cross-account role at all. You will turn it on in this part without onboarding anything for it. Keep that contrast in mind: outbound decryption needs nothing from your account, while inbound decryption needs a certificate stored in it.

> &#8505; This layering is deliberate. You already proved inspection works without onboarding. Now you turn the roles on and watch specific features light up, so you can see exactly what each role gates instead of treating onboarding as a black box.

> &#10067; In Part 1 you ran the VM-Series yourself and never granted Palo Alto any access to your AWS account. Why does Cloud NGFW need cross-account roles when the VM-Series did not?
>
> <details><summary>Answer</summary>
>
> Cloud NGFW is operated by Palo Alto as a managed service, so the service (running in Palo Alto's account) needs scoped permission to act inside your account. The four roles are that boundary. With the VM-Series you were the operator, running the firewall on your own EC2 instances, so no cross-account access was needed. This is the core managed-service tradeoff: less for you to run, in exchange for a scoped grant into your account.
>
> </details>

## 2. Onboard your AWS account

> &#8505; The canonical, always-current procedure is in the Cloud NGFW documentation: [Onboarding AWS Account in Strata Cloud Manager](https://docs.paloaltonetworks.com/cloud-ngfw-aws/administration/manage/aws-account-linkage#task-dqs_cbn_2hc). Follow the exact navigation there. The flow below summarizes it and calls out what matters for this lab.

- In Strata Cloud Manager, go to the Cloud NGFW area and find your AWS accounts (under `Accounts`).
- Choose `Onboard AWS Account`.
- Step 1: enter your AWS Account ID.
- Step 2: download the CloudFormation template, or launch it straight into the AWS console.
- In AWS, deploy the template (`CloudFormation` -> `Create stack`). It creates the four IAM roles and publishes their ARNs under the stack `Outputs`.
- Copy the four role ARNs from the stack `Outputs`.
- Back in SCM, paste the ARNs into the cross-account roles screen and choose `Onboard`.
- SCM validates the roles by assuming each one. When it finishes, your account shows onboarding status `Success`.

> &#8505; Leave the template's `Role Configuration` parameters at their defaults: `PaloAltoCloudNGFW` for both the CloudWatch namespace and log group, `PaloAltoCloudNGFWAuditLog` for the audit log group, `TagBasedCertificate` for the decryption certificate, and `None` for the S3 bucket. This lab is built around those defaults, and (as the next section shows) the role permissions are pinned to those exact names.

> &#8505; The lab Terraform already created the two CloudWatch log groups the template expects (`PaloAltoCloudNGFW` and `PaloAltoCloudNGFWAuditLog`). The logging role can only write to log groups with those names, so having them in place means logging is ready the moment you onboard.

> &#9888; Onboarding does not touch your traffic path. Your firewall keeps inspecting through the same customer-managed endpoint you built in the core lab. Onboarding only adds the roles; it does not move, recreate, or re-route anything.

## 3. What the four roles actually do

This is the heart of onboarding. The template creates four roles. Each one trusts the Palo Alto service account, gated by your tenant ID, and grants one narrow set of permissions.

| Role (SCM label) | Template output name | What it lets Cloud NGFW do | Feature it gates |
| --- | --- | --- | --- |
| Endpoint Role | `EndpointRole` (`ServiceManagedEndpointRole`) | Describe your VPCs, subnets, and AZs, and create or delete GWLB endpoints in your account | SCM-managed endpoints |
| Logging Role | `LogMetricRole` | Write log events to your CloudWatch log groups and publish metrics to the CloudWatch namespace | CloudWatch logging + metrics |
| Decryption Role | `DecryptionRole` | Read Secrets Manager secrets tagged `PaloAltoCloudNGFW=true` (where an inbound server certificate lives) | Inbound TLS decryption |
| Network Monitoring Role | `NetworkMonitoringRole` | Read-only inventory of your VPCs, ENIs, security groups, instances, load balancers, and tags | IP-tag / dynamic address groups |

### The trust policy (all four roles)

Every role allows `sts:AssumeRole` from the Palo Alto Networks service account, but only when the request carries an `ExternalId` equal to **your tenant ID**.

> &#10067; Why does each role require an external ID instead of simply trusting Palo Alto's account?
>
> <details><summary>Answer</summary>
>
> The external ID is the confused-deputy guard. Palo Alto's service account is shared across every customer, so trusting that account alone would not distinguish you from anyone else it serves. Tying the role to your specific tenant ID means the shared service can only assume your role when it is acting for your tenant. The external ID is your tenant (TSG) ID.
>
> </details>

### Endpoint role - SCM-managed endpoints (look, do not switch)

The endpoint role grants `ec2:CreateVpcEndpoint` and `ec2:DeleteVpcEndpoints`. With it onboarded, SCM can place and manage the GWLB endpoint for you. That is **SCM-managed** endpoint mode. In the core lab you built the endpoint yourself in Terraform, which is **customer-managed** mode.

> &#8505; Look, do not switch. In the Cloud NGFW console, open your firewall's endpoint settings. Now that the endpoint role is onboarded, you can see that SCM offers to manage endpoints for you. Leave this lab on the customer-managed endpoint you built. The goal here is to see what the role unlocks, not to rebuild your working traffic path.

> &#10067; The core lab created the GWLB endpoint in Terraform and never used the endpoint role. Why would a managed firewall still support customer-managed endpoints instead of always creating them for you?
>
> <details><summary>Answer</summary>
>
> Customer-managed endpoints keep you in control of placement, subnet choice, and routing, which fits teams that manage their networking as infrastructure-as-code (exactly what you did in the core lab). SCM-managed endpoints trade that control for convenience. Supporting both lets the same firewall serve both kinds of teams.
>
> </details>

### Logging role - and why the names are fixed

The logging role grants `logs:PutLogEvents` and `cloudwatch:PutMetricData`, but every permission is scoped by an IAM condition: metrics must go to the `PaloAltoCloudNGFW` namespace, and logs can only be written to the `PaloAltoCloudNGFW` and `PaloAltoCloudNGFWAuditLog` log groups.

> &#10067; If you pointed the firewall's log forwarding at a CloudWatch log group with a name you chose, what would happen?
>
> <details><summary>Answer</summary>
>
> It would fail with an access-denied error. The logging role's permissions are pinned to the default names by an IAM condition, so the log group names and the metrics namespace must match the template defaults. That is why this lab creates the log groups with exactly those names, and why you leave the CFT parameters at their defaults.
>
> </details>

### Decryption role - tag-based secret access (inbound only)

The decryption role grants `secretsmanager:GetSecretValue`, but only for secrets tagged `PaloAltoCloudNGFW=true`. This is how the firewall reads a certificate you store in Secrets Manager, without being handed broad access to every secret in your account.

> &#8505; This role is used for **inbound** decryption (the last section of Part B), where the firewall needs the application server's certificate and private key. **Outbound** forward-proxy decryption (the next section) does not use this role or any secret at all - the firewall signs with its own built-in forward-trust CA, managed entirely in SCM. Least-privilege by tag: the role cannot read a secret you have not explicitly tagged for Cloud NGFW, and the default `TagBasedCertificate` option on the CFT is what wires this up.

### Network monitoring role - the one SCM-managed leaves empty

The network monitoring role grants read-only inventory of your AWS resources and their tags (VPCs, ENIs, security groups, instances, load balancers, managed prefix lists). That is the data behind IP tags and dynamic address groups (policy that matches AWS resources by tag rather than by static IP).

> &#8505; SCM-managed Cloud NGFW does not wire this role. There is no field for it in SCM, and dynamic address groups are not supported in the SCM-managed model, so you register it empty. You still create it with the template, because the same template also serves the Cloud-NGFW-native management model, which does use it. It is a useful contrast: onboarding grants the capability, but your management plane decides whether to use it.

## 4. Check your understanding (onboarding)

> &#10067; You onboarded your account but have not changed any policy. Did your traffic inspection change?
>
> <details><summary>Answer</summary>
>
> No. Inspection was already working from the core lab on the allowlisted, customer-managed endpoint. Onboarding only added the four roles. Nothing inspects differently until you use one of the features the roles unlock (decryption next, plus log forwarding to CloudWatch).
>
> </details>

> &#10067; Compare this to Part 1: where did the VM-Series send its logs, and where will Cloud NGFW send its logs once you turn on forwarding? What changed about who operates the logging pipeline?
>
> <details><summary>Answer</summary>
>
> The VM-Series sent logs to Panorama, which you ran. Cloud NGFW forwards logs into your AWS account's CloudWatch through the logging role. In both cases the logs end up somewhere you can read them, but with Cloud NGFW the firewall is operated by Palo Alto and the cross-account role is what bridges its logs back into your account.
>
> </details>

## 5. Forward logs and metrics to CloudWatch

Your firewall already generates session logs (you viewed them in SCM during the core lab). This step forwards those logs, plus firewall metrics, into your own AWS account's CloudWatch, using the logging role you onboarded.

### The log groups must already exist

The logging role can write log streams and events, but it cannot create a log group. Its permissions are `logs:CreateLogStream` and `logs:PutLogEvents`, not `logs:CreateLogGroup`. So the two log groups have to exist first, with the exact names the role is scoped to: `PaloAltoCloudNGFW` (traffic) and `PaloAltoCloudNGFWAuditLog` (audit).

Create the two log groups yourself, with these exact names. Two commands from your Cloud Shell:

```
aws logs create-log-group --log-group-name PaloAltoCloudNGFW --region us-east-1
aws logs create-log-group --log-group-name PaloAltoCloudNGFWAuditLog --region us-east-1
```

> &#9888; Create them in `us-east-1`, the firewall's region, even if your Cloud Shell is open in `us-east-2`. CloudWatch log groups are regional, and the firewall writes to `us-east-1`.

> &#8505; The lab Terraform intentionally leaves these out (the resources are present but commented in `main.tf`) so that creating them is an explicit step, and so an already-deployed Part A stack does not hit an "already exists" conflict. Uncomment the two `aws_cloudwatch_log_group` resources if you would rather Terraform manage them.

> &#10067; The logging role can write log events but cannot create the log group. Why would Palo Alto scope a cross-account role that narrowly?
>
> <details><summary>Answer</summary>
>
> Least privilege. Writing events is the day-to-day job; creating log groups is an account-structure action the service does not need. Granting only write access to two named groups means the role cannot create arbitrary log groups in your account. The tradeoff is that you create the groups yourself, with the exact names the role expects.
>
> </details>

### Configure the log destination in SCM

- Open your firewall in SCM: Cloud NGFW -> your firewall -> `Log & Metrics` (left navigation). The direct URL pattern is `https://stratacloudmanager.paloaltonetworks.com/configuration/cloudngfw/firewalls/<your-firewall-id>?region=us-east-1`.
- `Log Destination Type`: `CloudWatch Log Group`.
- `Log Type`: select `Traffic`, `Threat`, and `Decryption`.
- `Policy Type`: `IAM Based Policy`.
- `Linked AWS Accounts`: your AWS account ID.
- `AWS Log Destination`: `PaloAltoCloudNGFW`.
- (optional) `Advanced Threat Log Generation`: enable it to generate additional threat logs.
- Under `Metrics`, check `Enable CloudWatch Metrics`:
  - `Linked AWS Accounts`: your AWS account ID.
  - `CloudWatch Namespace`: `PaloAltoCloudNGFW`.
  - `CloudWatch Metrics`: select the metrics you want (dataplane CPU, sessions, throughput, bytes, and so on).
- `Save`.

> &#8505; `S3` and `Kinesis Data Firehose` are the other log destination types, and `None` disables forwarding. This lab uses `CloudWatch Log Group`; the onboarding template leaves S3 and Firehose unconfigured by default, so CloudWatch is the only destination wired up.

> &#8505; `IAM Based Policy` is the option that uses the cross-account logging role you onboarded: the firewall assumes your role to write the logs. The alternative, `Resource Based Policy`, instead attaches a policy directly to the log group. Because you onboarded with the role, IAM-based is the path for this lab.

> &#8505; The screen notes it applies when the firewall is "not associated with a Cortex Data Lake (CDL)." An SCM-managed Cloud NGFW can send logs to CDL or to your own AWS account. This lab uses your AWS account so the logs land in CloudWatch alongside the rest of your infrastructure.

> &#10067; `AWS Log Destination` must be `PaloAltoCloudNGFW`. What happens if you enter a different name?
>
> <details><summary>Answer</summary>
>
> It fails with an access-denied error. The logging role is pinned by an IAM condition to the `PaloAltoCloudNGFW` and `PaloAltoCloudNGFWAuditLog` log groups and the `PaloAltoCloudNGFW` metrics namespace. A different name is outside what the role is allowed to write to. This is the same default-names rule you saw on the onboarding side, now from the logging side.
>
> </details>

### Generate traffic and find it in CloudWatch

- Make some traffic: browse to your ALB (`http://<alb_dns_name>/`) a few times, and from an app server (Session Manager) run `curl -s https://ifconfig.me`.
- In AWS, open `CloudWatch` -> `Log groups` -> `PaloAltoCloudNGFW`. You will see a log stream per firewall instance (one per AZ).
- Or query it with `Logs Insights` against `PaloAltoCloudNGFW`:

```
fields @timestamp, @message
| sort @timestamp desc
| limit 20
```

- Check metrics too: `CloudWatch` -> `Metrics` -> `PaloAltoCloudNGFW` namespace.

> &#8505; Logs can take a couple of minutes to show up. The audit log group (`PaloAltoCloudNGFWAuditLog`) carries configuration and audit events rather than traffic sessions.

> &#10067; Compare this with Part 1: where did the VM-Series send its traffic logs, and what is different about where Cloud NGFW sends them and who operates that pipeline?
>
> <details><summary>Answer</summary>
>
> The VM-Series sent logs to Panorama, which you ran. Cloud NGFW forwards logs into your own AWS account's CloudWatch through the cross-account logging role. In both cases the logs land somewhere you can query, but with Cloud NGFW the firewall is operated by Palo Alto and the role is the bridge that lands its logs back in your account.
>
> </details>

## 6. Decrypt outbound traffic (SSL forward proxy)

Your app servers reach the internet over TLS. Right now Cloud NGFW sees the handshake (the server name and certificate) but not the payload. SSL forward proxy lets the firewall decrypt that outbound TLS, inspect inside, and re-encrypt on its way out.

> &#8505; This scenario uses **no AWS Secrets Manager secret and no cross-account Decryption role.** The firewall signs with its own built-in forward-trust CA, managed by SCM. (Inbound decryption, the next section, is the one that needs a secret, because there the firewall must present the application's own certificate.)

### How forward proxy works

The firewall acts as a man in the middle. When an app server opens a TLS connection to a site, the firewall makes its own connection to the real site, then generates a fresh certificate for that site on the fly and presents it to the app server, signed by the firewall's **forward-trust CA**. The app server accepts it only if it trusts that CA. So the one client-side requirement is installing the firewall's forward-trust CA into the app servers' trust store.

> &#10067; Why must the app servers trust the firewall's CA for forward proxy to work, and why can you not just use a public CA for this?
>
> <details><summary>Answer</summary>
>
> The firewall mints a new certificate for every site it decrypts, signed by its forward-trust CA, and the client validates that certificate against its trust store. If the client does not trust the firewall's CA, the connection fails. You cannot use a public CA because no public CA will give you its signing private key, and the ability to mint trusted certificates for any site on the internet is exactly the power a public CA must never hand out. Forward proxy therefore always uses a private CA you control and distribute to your own clients.
>
> </details>

### Step 1 - Create the decryption rule

In the same `aws-cloudngfw` folder as your security rules: Manage -> Configuration -> NGFW and Prisma Access -> Configuration Scope = your folder -> Security Services -> Decryption -> Add Rule.

  - `Name`: `decrypt-outbound`
  - `Source Zone`: `any` (required)
  - `Source Address`: your app subnets (`terraform output app_subnet_cidrs`)
  - `Destination Zone`: `any` (required)
  - `Destination Address`: `any`
  - `Service / URL Category`: `any`
  - `Action`: `Decrypt`
  - `Type`: `SSL Forward Proxy`
  - `Decryption Profile`: `best-practice` (optional but recommended)

> &#9888; Same zone rule as security policy: source and destination zone must be `any` on SCM-managed Cloud NGFW.

### Step 2 - Designate the forward-trust certificate

A decrypt rule on its own does not decrypt anything until you tell the firewall which certificate to sign with. This is the step that is easy to miss.

- Go to Decryption -> `Decryption Settings` -> `Certificate Settings`.
- Under `Certificate When Proxying for Trusted Site`: set `RSA` to `Forward-Trust-CA` and `ECDSA` to `Forward-Trust-CA-ECDSA`.
- Under `Certificate When Proxying for Untrusted Site`: set `RSA` to `Forward-UnTrust-CA` and `ECDSA` to `Forward-UnTrust-CA-ECDSA`.
- Push the configuration.

> &#8505; These four CA certificates are pre-created in your tenant; you do not generate them. The trusted-site certificate is what the firewall re-signs with when the real site's certificate is valid. The untrusted-site certificate is a deliberately separate CA used when the real site's certificate is bad, so the browser warning still reaches the user instead of being hidden by the firewall.

> &#8505; You set both an `RSA` and an `ECDSA` forward-trust CA because the firewall matches the key type the client and server negotiate. Most modern sites use ECDSA, so the ECDSA CA is the one most of your traffic will actually use.

> &#9888; Cloud NGFW denies by default, and this is also when decryption begins. The moment you push, the app servers' outbound HTTPS will start failing with certificate errors until you install the CA in the next step. Your Session Manager shell keeps working: the SSM agent reaches AWS over the private interface endpoints from the core lab, so its own traffic stays inside the VPC and never hits the forward-proxy path.

<!-- WORKSHOP-TEMP: live-cohort caution; remove once everyone is on the core lab that ships the SSM interface endpoints -->
> &#9888; **If you deployed before the SSM interface endpoints were added to the core lab**, add them before turning on decryption, or add a no-decrypt rule for `*.amazonaws.com` above your decrypt rule. Otherwise the firewall will try to decrypt the SSM agent's own TLS and your Session Manager session can drop, locking you out of the next step.
<!-- /WORKSHOP-TEMP -->

### Step 3 - Trust the firewall CA on your app servers

Until the app servers trust the forward-trust CA, every decrypted connection fails with a certificate error. (That failure is itself proof the firewall is decrypting.) Install the CA:

- Export the CA from SCM: Objects -> Certificate Management -> select `Forward-Trust-CA` -> `Export Certificate` (PEM, certificate only). Do the same for `Forward-Trust-CA-ECDSA`.
- On each app server, open Session Manager and install both into the OS trust store:

```
sudo tee /etc/pki/ca-trust/source/anchors/cngfw-forward-trust-rsa.pem > /dev/null <<'EOF'
-----BEGIN CERTIFICATE-----
... paste the RSA Forward-Trust-CA ...
-----END CERTIFICATE-----
EOF
sudo tee /etc/pki/ca-trust/source/anchors/cngfw-forward-trust-ecdsa.pem > /dev/null <<'EOF'
-----BEGIN CERTIFICATE-----
... paste the ECDSA Forward-Trust-CA ...
-----END CERTIFICATE-----
EOF
sudo update-ca-trust
```

> &#8505; Install both the RSA and ECDSA CAs. If you install only the RSA one, sites that negotiate ECDSA (most of them) still fail certificate validation.

### Step 4 - Test and watch the decryption

- From an app server (Session Manager), confirm the firewall is now the certificate issuer:

```
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -issuer
```

The issuer is now your firewall's forward-trust CA (`... Forward Trust CA ...`), not the site's real CA, and `curl https://example.com` succeeds.

- View the sessions: SCM -> Cloud NGFW -> your firewall -> View Logs (or CloudWatch). Sessions that showed `app: ssl` before now show the real application (for example `web-browsing`), because the firewall can see inside the TLS.

> &#10067; Before you installed the CA, `curl https://example.com` failed with a certificate error, but the firewall logs already showed the session as allowed. What does that tell you about when decryption happens versus when trust matters?
>
> <details><summary>Answer</summary>
>
> The firewall was already decrypting (it presented its own minted certificate) before you installed the CA. Decryption happens at the firewall regardless of client trust. The certificate error was purely a client-side trust failure: the app server did not yet have the firewall's CA. Installing the CA fixes the trust, not the decryption.
>
> </details>

### Step 5 - Decryption changes what your policy sees

Now test a couple more sites from an app server:

```
curl -s -o /dev/null -w "%{http_code}\n" https://example.com
curl -s -o /dev/null -w "%{http_code}\n" https://github.com
```

`example.com` returns `200`, but `github.com` is blocked. The firewall logs show why.

> &#10067; Why does `github.com` get blocked after you turn on decryption, when it worked fine before?
>
> <details><summary>Answer</summary>
>
> Before decryption, every outbound HTTPS session was identified only as `app: ssl`, which your `allow-outbound-web` rule permits. After decryption the firewall sees inside the TLS and identifies the real application: github resolves to `github-base`, not plain `web-browsing`. Your outbound rule allows only `web-browsing`, `ssl`, and `dns`, so `github-base` no longer matches and falls through to the default deny. Decryption did exactly its job: it gave the firewall application-level visibility, and now your policy has to account for the applications it can suddenly see.
>
> </details>

> &#10067; Challenge: how would you let github through again, now that the firewall sees it as `github-base`?
>
> <details><summary>Answer</summary>
>
> Add the application to your outbound policy: either add `github-base` (and the apps it depends on) to the `allow-outbound-web` rule, or write a dedicated rule for the applications your users need. This is the payoff of decryption: you can write application-aware policy instead of allowing all of `ssl` blindly.
>
> </details>

> &#8505; Some sites cannot be decrypted (certificate pinning, mutual TLS, and the like) and show up with a decrypt error. In production you exclude those with a no-decrypt rule or decryption exclusions. For this lab they are expected and harmless.

> &#10067; Compare this with the VM-Series in Part 1. The forward-proxy concept is identical. What is different about where the forward-trust CA lives and how you manage it?
>
> <details><summary>Answer</summary>
>
> On the VM-Series you generate or import the forward-trust CA on the firewall itself and manage it in Panorama. On Cloud NGFW you never touch a box: SCM holds the forward-trust CA and you designate it in Decryption Settings, then push. Same man-in-the-middle mechanism, different management plane - and for outbound you needed no AWS secret at all, because the CA is managed entirely in SCM.
>
> </details>

## What comes next in Part B

- **Inbound decryption (SSL inbound inspection)**: decrypt TLS coming *to* your application. Unlike outbound, the firewall has to present the application's own server certificate, so this is where the AWS Secrets Manager secret and the cross-account Decryption role finally come in. You store the server certificate and private key in a secret tagged `PaloAltoCloudNGFW=true`, bind it to an SCM Cloud Certificate (`Cloud Platform = AWS`, `Cloud Secret Name`, `Algorithm = RSA`), and reference it from an SSL Inbound Inspection decryption rule.
