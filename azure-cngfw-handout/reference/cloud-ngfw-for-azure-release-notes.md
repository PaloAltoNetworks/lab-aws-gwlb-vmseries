---
source: pdf_url
url: https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/pdf/cloud-ngfw-azure/cloud-ngfw-for-azure-release-notes.pdf
title: Cloud NGFW for Azure Release Notes
fetched: 2026-06-04T11:39:07.786Z
pages: 44
---
## Cloud NGFW for Azure Release Notes 

docs.paloaltonetworks.com 

## **Contact Information** 

Corporate Headquarters: Palo Alto Networks 3000 Tannery Way Santa Clara, CA 95054 www.paloaltonetworks.com/company/contact-support 

## **About the Documentation** 

- For the most recent version of this guide or for access to related documentation, visit the Technical Documentation portal docs.paloaltonetworks.com. 

- To search for a specific topic, go to our search page docs.paloaltonetworks.com/search.html. 

- Have feedback or questions for us? Leave a comment on any page in the portal, or write to us at documentation@paloaltonetworks.com. 

## **Copyright** 

Palo Alto Networks, Inc. 

www.paloaltonetworks.com 

> © 2025-2026 Palo Alto Networks, Inc. Palo Alto Networks is a registered trademark of Palo Alto Networks. A list of our trademarks can be found at www.paloaltonetworks.com/company/ trademarks.html. All other marks mentioned herein may be trademarks of their respective companies. 

## **Last Revised** 

May 28, 2026 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**2** 

## Table of Contents 

**What's New......................................................................................................... 5** What's New in May 2026.........................................................................................................7 What's New in March 2026..................................................................................................... 8 What's New in December 2025............................................................................................10 What's New in October 2025............................................................................................... 11 What's New in September 2025...........................................................................................12 What's New in July 2025....................................................................................................... 13 What's New in June 2025......................................................................................................14 What's New in May 2025.......................................................................................................15 What's New in April 2025......................................................................................................16 What's New in March 2025...................................................................................................17 What's New in February 2025.............................................................................................. 18 What's New in January 2025................................................................................................ 19 What's New in December 2024............................................................................................20 What's New in November 2024........................................................................................... 21 What's New in October 2024............................................................................................... 22 What's New in September 2024...........................................................................................23 What's New in August 2024..................................................................................................24 What's New in July 2024....................................................................................................... 25 What's New in June 2024......................................................................................................26 What's New in May 2024.......................................................................................................27 What's New in March 2024...................................................................................................28 What's New in February 2024.............................................................................................. 29 What's New in January 2024................................................................................................ 30 What's New in December 2023............................................................................................31 What’s New in November 2023........................................................................................... 32 What’s New in October 2023............................................................................................... 33 What’s New in September 2023...........................................................................................34 What’s New in August 2023..................................................................................................35 What’s New in June 2023......................................................................................................36 What’s New in May 2023.......................................................................................................37 **Cloud NGFW for Azure Addressed Issues................................................ 39 Cloud NGFW for Azure Known Issues.......................................................41** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**3** 

Table of Contents 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**4** 


![](images/fetchpdf-1780573142924.pdf-0005-00.png)


## What's New 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



Here’s what’s new in Cloud NGFW for Azure. 

- What's New in May 2026 

- What's New in March 2026 

- What's New in December 2025 

- What's New in October 2025 

- What's New in September 2025 

- What's New in July 2025 

- What's New in June 2025 

- What's New in May 2025 

- What's New in April 2025 

- What's New in March 2025 

- What's New in February 2025 

- What's New in January 2025 

- What's New in December 2024 

- What's New in November 2024 

- What's New in October 2024 

- What's New in September 2024 

- What's New in August 2024 

- What's New in July 2024 

- What's New in June 2024 

- What's New in May 2024 

- What's New in March 2024 

- What's New in February 2024 

- What's New in January 2024 

- What's New in December 2023 

- What's New in November 2023 

- What's New in October 2023 

**5** 

What's New 

- What's New in September 2023 

- What's New in August 2023 

- What's New in June 2023 

- What's New in May 2023 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**6** 

What's New 

## What's New in May 2026 

|**New**|**Description**|
|---|---|
|Enterprise DLP Support for Cloud NGFW for<br>Azure|Cloud NGFW now integrates with<br>Enterprise Data Loss Prevention (E-DLP) to<br>safeguard your sensitive information against<br>unauthorized access and exfiltration. With this<br>integration, customers can centrally manage<br>DLP patterns and profiles across their cloud<br>infrastructure using Panorama, maintaining a<br>consistent security posture.<br>Onboarding is streamlined through automated<br>association: if you already have a Cloud<br>NGFW resource registered with Panorama,<br>simply adding it to a Strata Tenant (Tenant<br>Service Group or TSG) activates E-DLP if not<br>already present in the TSG and automatically<br>links your Cloud NGFW resources to the E-<br>DLP cloud service.<br>Cloud NGFW for Azure exclusively supports<br>E-DLP. Consequently, all data-filtering profiles<br>configured in Panorama are treated as E-DLP<br>usage and will be billed at the E-DLP add-on<br>price (40% of the base firewall credits).<br>To learn more about this capability, see<br>Enterprise DLP for Azure CNGFW.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**7** 

What's New 

## What's New in March 2026 

|**New**|**Description**|
|---|---|
|Cloud NGFW for Azure: Moving to PAN-OS<br>11.2|Any new Azure tenant deploying Cloud<br>NGFW for Azure, will now be on**PAN-OS**<br>**version 11.2**.<br>**New Customers:**Starting March 18, 2026, all<br>new Cloud NGFW for Azure tenants will have<br>PAN-OS 11.2 enabled by default.<br>**Existing Customers:**Upgrades start**mid-April**<br>**2026**. To prepare for the mandatory upgrade<br>or to request an early upgrade via TAC, please<br>ensure:<br>• **Panorama Version:**11.2.x (**11.2.7-h4**is<br>TAC preferred).<br>_If your Panorama is on 12.x,_<br>_use version_**_12.1.5_**_or higher._<br>• **Azure Panorama Plugin:**5.2.3 or higher<br>version.<br>_For SCM and LRS managed_<br>_tenants, no additional action_<br>_is needed. To perform an early_<br>_upgrade, complete the above (if_<br>_applicable) and reach out via_TAC<br>case.<br>For more information, seePanorama<br>Integration Prerequisites.|
|Cloud IP tags support for CNGFW for Azure<br>in SCM|Cloud NGFW for Azure now supports<br>native Cloud IP Tag integration within Strata<br>Cloud Manager to automate scalable policy<br>enforcement in dynamic cloud environments.<br>This feature allows you to enforce security<br>policies based on Azure resource tags instead<br>of static IP addresses, significantly simplifying<br>security management by eliminating the need<br>for manual updates as workloads change.<br>By creating monitoring definitions in SCM,<br>the firewall automatically polls your Azure<br>environment to discover existing tags and<br>detect modifications, ensuring consistent<br>security across your network workloads. For|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**8** 

What's New 

|**New**|**Description**|
|---|---|
||more information, seeCloud IP Tags for Cloud<br>NGFW for Azure.|
|Support for Advanced WildFire and Advanced<br>DNS Security|Cloud NGFW for Azure now supports<br>Advanced WildFire (AWF) and Advanced<br>DNS Security (ADNS) for Panorama and<br>SCM managed firewalls. This enhancement<br>allows you to leverage Precision AI-powered<br>detection to stop zero-day malware and<br>sophisticated DNS-based threats in real-time.<br>You can now enable**Cloud Inline Analysis**<br>within your Anti-Spyware and WildFire<br>Analysis profiles in Panorama or SCM to<br>activate these advanced capabilities. Billing is<br>seamlessly integrated, appearing as specific<br>add-ons in your usage metrics at a rate<br>of 30% of the base firewall credits when<br>enabled. For more information, seeSupported<br>Security Policy Management Featuresand<br>CNGFW for Azure Pricing.<br>AWF and ADNS are currently available for<br>all**new**Cloud NGFW for Azure tenants.<br>For existing tenants, AWF and ADNS will<br>be available following an infrastructure<br>upgrade. The infrastructure upgrades will be<br>rolled out automatically starting in**mid-April,**<br>**2026.**If you require an early access to these<br>capabilities, reach out toPalo Alto Networks<br>Support.|
|DNAT Port Range Support|You can now specify port ranges in<br>DNAT rules. This enhancement simplifies<br>configuration for applications using multiple<br>ports and improves rule scalability by allowing<br>a single entry for an entire range. For more<br>information, seeConfigure a Source and<br>Destination NAT Rule.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**9** 

What's New 

## What's New in December 2025 

|**New**|**Description**|
|---|---|
|Additional Azure Region|You can now deploy Cloud NGFW for Azure<br>in New Zealand North region.<br>For more information, seeCloud NGFW for<br>Azure Supported Regions.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**10** 

What's New 

## What's New in October 2025 

|**New**|**Description**|
|---|---|
|Billing Change for Cloud NGFW on Azure|**Effective October 2025**, Palo Alto Networks<br>is implementing a previously announced<br>change to how**Cloud NGFW on Azure**costs<br>are billed. When you deploy Cloud NGFW<br>in a Hub vNET, you also established peering<br>between the your spoke vNETs and the<br>hub VNet and redirected traffic to Cloud<br>NGFW. Until now, Palo Alto Networks<br>temporarily absorbed the cost associated<br>with this peering. This**$0.01 per GB**charge,<br>which reflects Microsoft Azure's standard<br>peering rate, will now be billed directly to<br>your**Marketplace billing account**as a**Pay-**<br>**As-You-Go (PAYG) charge**, even if you are<br>on a credit consumption plan. For more<br>information, seeCloud NGFW Azure pricing.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**11** 

What's New 

## What's New in September 2025 

|**New**|**Description**|
|---|---|
|Azure Monitor Metrics|Cloud NGFW now publishes additional<br>metrics in Azure Monitor to help you monitor<br>your Cloud NGFW's health, performance, and<br>usage patterns.<br>Key metrics available include:<br>• Throughput<br>• Sessions<br>• SNAT Port Utilization<br>• Latency<br>• Packet counts<br>For more information, seeView Cloud NGFW<br>for Azure Monitoring Metrics.|
|Support for Multi-Dimensional Scaling|Cloud NGFW for Azure can now<br>automatically scale based on additional<br>metrics such as Source NAT port utilization,<br>session throughput and session count,<br>ensuring greater reliability and performance<br>for diverse workloads. For more information,<br>seeCloud NGFW for Azure Resiliency and<br>ScalabilityandView Cloud NGFW for Azure<br>Metrics natively in Azure.|
|Strata Logging Service Support for Panorama<br>Managed Cloud NGFW resources|You can now enable SLS for existing<br>Panorama-managed Cloud NGFW for<br>Azure resources by simply generating a new<br>registration string from the Panorama plugin<br>and updating it in the Azure portal. For more<br>information, seeEnable Strata Logging Service<br>(SLS) for existing Panorama-managed firewalls<br>andView Traffic and Threat Logs in Strata<br>Logging Service.|
|Blogs, Articles, and Videos|Palo Alto Cloud NGFW deep dive, feature<br>updates, end-to-end lab (Part - 2).|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**12** 

What's New 

## What's New in July 2025 

|**New**|**Description**|
|---|---|
|Additional Azure Regions|You can now deploy Cloud NGFW for Azure<br>in the following regions:<br>• Spain Central<br>• Mexico Central<br>• India South<br>For more information, seeCloud NGFW for<br>Azure Supported Regions.|
|SNAT Port Enhancement|More SNAT ports are now allocated for each<br>firewall instance. SNAT port allocation will<br>scale based on the front-end IPs configured.|
|Blogs, Articles & Videos|Secure Traffic Based on Azure Service Tags<br>(Video)|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**13** 

What's New 

## What's New in June 2025 

|**New**|**Description**|
|---|---|
|Centralized Management Add-on- Strata<br>Cloud Manager|You can now use Strata Cloud Manager to<br>manage security policies in your Cloud NGFW<br>resources. In that case, your centralized<br>management add-on consumption is metered<br>on each NGFW resource for each hour<br>associated with a Strata Cloud Manager, as<br>well as for the amount of traffic processed by<br>that NGFW resource. For more information,<br>seeCloud NGFW for Azure Pricing.|
|Blogs, Articles & Videos|Cloud NGFW is essential for AWS & Azure<br>Traffic Protection(Blog)|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**14** 

What's New 

## What's New in May 2025 

|**New**|**Description**|
|---|---|
|Panorama Device license Waiver for Cloud<br>NGFW for Azure resources|You no longer need to pay for additional<br>device licenses to manage policy rules in<br>Cloud NGFW for Azure resources. Panorama<br>(version 11.2.6 or above) does not count<br>these NGFW resources against its managed<br>device license count.|
|Blogs, Articles & Videos|Harnessing Cloud NGFW for Azure with Palo<br>Alto Networks and Microsoft (Blog)|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**15** 

What's New 

## What's New in April 2025 

|**New**|**Description**|
|---|---|
|Cloud NGFW<br>Credit Usage<br>Visibility|You can now use the Cloud NGFW Credits Management Console to<br>gain greater visibility into how your Cloud NGFW credits are used. You<br>can now analyze your usage at different periods at a summary level for<br>your tenant and NGFW resources. You can also analyze your usage at<br>a granular level for each Cloud NGFW resource, for the traffic secured,<br>for the Cloud-Delivered Security Services (CDSS) and for Centralized<br>Management (Panorama, Strata Cloud Manager, and Strata Logging<br>Services). For more information, seeCredit Usage Visibility.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**16** 

What's New 

## What's New in March 2025 

|**New**|**Description**|
|---|---|
|Cloud NGFW<br>Policy Management<br>Using Strata Cloud<br>Manager|You can register your Cloud NGFW resources with an existing Strata<br>Cloud Manager, which you had previously activated based on Prisma<br>Access (SCM Essentials), orStrata Cloud Manager Pro/Essentiallicenses.<br>If you do not have a Strata Cloud Manager, you canactivate a new<br>Strata Cloud Manager Essentials(steps 1-8) to use with Cloud NGFW for<br>Azure. In either case, the integration automatically enables Strata Cloud<br>Manager Pro features for Cloud NGFW.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**17** 

What's New 

## What's New in February 2025 

|**New**|**Description**|
|---|---|
|Blogs, Articles, &<br>Videos|Cloud NGFW for Azure in Action<br>Cloud NGFW Credits(Video)<br>Cloud NGFW for Azure Sentinel Integration<br>(Blog)<br>Palo Alto Cloud NGFW Overview, Use cases and Demo (Part 1)(Video)<br>Understanding Cloud NGFW for Azure(Video)|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**18** 

What's New 

## What's New in January 2025 

|**New**|**Description**|
|---|---|
|Blogs, Articles, &<br>Videos|Cloud NFW for Azure Sentinel Integration<br>Palo Alto Cloud NGFW Overview, Use Cases and Demo<br>Understanding Cloud NGFW for Azure|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**19** 

What's New 

## What's New in December 2024 

|**New**|**Description**|
|---|---|
|Strata Logging<br>Service Support<br>for Panorama<br>Managed Cloud<br>NGFW resources|When managing Cloud NGFW resources with Panorama, you can now<br>stream the logs to the Strata logging service. You can then use Strata<br>Logging Service to perform Explore/Log Viewer queries to view logs<br>generated byspecific Cloud NGFW for Azure resources. When used<br>with Cloud NGFW for Azure, Strata Logging Service automatically scales.<br>As traffic throughput increases on these Cloud NGFW resources, so<br>does your available Strata Logging Service storage so that you don't<br>need to worry about making manual adjustments to storage to save<br>your log data. For more information, seeView Traffic and Threat Logs in<br>Strata Logging Service.|
|Cloud NGFW<br>Policy Management<br>using Strata Cloud<br>Manager|You can now register your Cloud NGFW resource with Strata Cloud<br>Manager (SCM) for policy management. With this feature, you can use a<br>single Strata Cloud Manager (SaaS instance) to centrally manage a shared<br>set of security rules on Cloud NGFW resources alongside your physical<br>and virtual firewall appliances.<br>SeeStrata Cloud Manager Policy Managementfor more information.|
|Pricing and Billing<br>Changes|Cloud NGFW for Azure changes the pricing structure to provide more<br>flexibility. See thePricingpage for more information.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**20** 

What's New 

## What's New in November 2024 

|**New**|**Description**|
|---|---|
|Blogs, Articles, &<br>Videos|Cloud NGFW for Azure Deployment Architectures|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**21** 

What's New 

## What's New in October 2024 

|**New**|**Descriptions**|
|---|---|
|Increased Support<br>for DNAT Rules and<br>Public IP Addresses|You can now configure up to 120 DNAT rules in Front-end settings<br>in Cloud NGFW resources. Additionally, you can associate up to 120<br>Public IP addresses with each Cloud NGFW resource. Refer to the**Step**<br>**3**in the documentationhere.|
|Blogs, Articles, &<br>Videos|• Cloud NGFW for Azure — FAQ Updated<br>• Cloud NGFW for Azure SNAT and DNAT Video|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**22** 

What's New 

## What's New in September 2024 

|**New**|**Description**|
|---|---|
|Cloud NGFW<br>Certifications|Cloud NGFW is now a Payment Card Industry Data Security Standard<br>(PCI DSS) compliant service. Additionally, Cloud NGFW complies with<br>SOC2 HIPAA, ISO ( ISO 27001, ISO 27017, ISO 27018, ISO 27701),<br>CSA STAR, IRAP, and Germany C5 standards. To learn more, visitCloud<br>NGFW for Azure Certifications.|
|Blogs, Articles, &<br>Videos|Cloud Native Security: Revolutionizing Cloud Environments with Cloud<br>NGFW Blog|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**23** 

What's New 

## What's New in August 2024 

|**New**|**Description**|
|---|---|
|Credit Distribution<br>and Management|You can now use the Cloud NGFW credits to fund both Cloud NGFW<br>resources in AWS and Azure and all related CDSS services you would<br>like to use with it. Use the credits for Panorama, Strata Cloud Manager,<br>or the Strata Logging Service. For more information, seeCloud NGFW<br>Credit Distribution and Management.|
|Blogs, Articles, &<br>Videos|Cloud NGFW Credits Video|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**24** 

What's New 

## What's New in July 2024 

|**New**|**Description**|
|---|---|
|Blogs, Articles, &<br>Videos|• Simplifying Network Security in the Public Cloud Blog<br>• Cloud NGFW for Azure Privacy Datasheet|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**25** 

What's New 

## What's New in June 2024 

|**New**|**Description**|
|---|---|
|Additional Azure<br>Region Support|Cloud NGFW for Azure is now available in the following Azure regions:<br>• Japan West (Osaka)<br>• Sweden Central (Gavle)<br>• Italy North (Milan)<br>• South Africa North (Johannesburg)<br>• Israel Central<br>• West Central US (Wyoming)<br>• UAE North (Dubai)<br>SeeSupported Regions and Zonesfor the complete list of supported<br>regions.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**26** 

What's New 

## What's New in May 2024 

|**New**|**Description**|
|---|---|
|Use XFF Header<br>Value to Enforce<br>Security Policy|Your Cloud NGFW for Azure can now use an IP address in an X-<br>Forwarded-For (XFF) header toenforce security policycreated on<br>Panorama.|
|Additional Azure<br>Region Support|Cloud NGFW for Azure is now available in the following Azure regions:<br>• Canada East<br>SeeSupported Regions and Zonesfor the complete list of supported<br>regions.|
|Credit<br>Consumption and<br>Usage Visibility|You can now use credits for Cloud NGFW consumption for long-term<br>contracts which you allocate for your firewall resources across Azure<br>cloud environments at tenant level. For more information, seeCredit<br>Usage Visibility.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**27** 

What's New 

## What's New in March 2024 

|**New**|**Description**|
|---|---|
|Additional Azure<br>Region Support|Cloud NGFW for Azure is now available in the following Azure regions:<br>• Norway East<br>• Germany West Central<br>• Central India<br>• Switzerland North<br>SeeSupported Regions and Zonesfor the complete list of supported<br>regions.|
|Azure Networking<br>Charges|Cloud NGFW for Azure bills virtual network peering charges under the<br>Azure Networking charges dimension. The consumption details are<br>shared to the Azure Marketplace. Usage is tracked for inbound (from<br>Internet to VNET), outbound (to Internet from VNET) and east-west<br>traffic (across VNETs). For more information on the charges, see the<br>Pricingpage.|
|Support for<br>Inbound<br>Decryption|Cloud NGFW for Azure usesSSL Inbound Decryptionto inspect and<br>decrypt inbound SSL/TLS traffic from a client to a targeted network<br>server and block suspicious sessions.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**28** 

What's New 

## What's New in February 2024 

|**New**|**Description**|
|---|---|
|Multiple Log<br>Destinations|You can now send logs from your Panorama-managed Cloud NGFW for<br>Azure resource to Azure Log Analytics Workspace, Syslog Servers, and<br>Panorama.See Multiple Log Destinations on Cloud NGFW for Azure<br>more information.|
|Additional Azure<br>Region Support|Cloud NGFW for Azure is now available in the following Azure regions:<br>• France Central<br>• South Central US<br>SeeSupported Regions and Zonesfor the complete list of supported<br>regions.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**29** 

What's New 

## What's New in January 2024 

|**New**|**Description**|
|---|---|
|Support for<br>100Gbps|This release enables the Cloud NGFW for Azure to automatically scale<br>up to 100Gbps for both vNET and vWAN deployments. SeeDeploy the<br>Cloud NGFW in a vNETandDeploy the Cloud NGFW in a vWANfor<br>more information.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**30** 

What's New 

## What's New in December 2023 

|**New**|**Description**|
|---|---|
|Additional Azure<br>Region Support|Cloud NGFW for Azure is now available in the following Azure regions:<br>• North Central United States<br>• Southeast Asia<br>SeeSupported Regions and Zonesfor the complete list of supported<br>regions.|
|Support for Private<br>Source NAT|This release adds support for Private Source NAT. With this support,<br>you can create a Private NAT gateway to perform network address<br>translation (NAT).|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**31** 

What's New 

## What’s New in November 2023 

|**New**|**Description**|
|---|---|
|Additional Azure<br>Region Support|Cloud NGFW for Azure is now available in the following Azure regions:<br>• Japan East<br>• Brazil South<br>SeeSupported Regions and Zonesfor the complete list of supported<br>regions.|
|Rulestack<br>enhancements|This release supports implicit rule deletions in a rulestack. With this<br>enhancement:<br>• You can delete non-empty unassociated rulestacks without deleting<br>any rules and objects.<br>• You can delete resource groups while retaining empty or non-empty<br>unassociated rulestacks.<br>• You can delete non-empty unassociated rulestacks using the Azure<br>CLI, CDK, PowerShell and Terraform.<br>_This deletion functionality applies to uncommitted and_<br>_running non-empty rulestacks._|
|Support for DNS<br>Security Service|Cloud NGFW for Azure adds support for the Palo Alto Networks DNS<br>Security service. This service allows you to protect vNET and vWAN<br>traffic from advanced DNS-based threats by monitoring and controlling<br>the domains that your network resources query. For more information,<br>seeEnable DNS Security on Cloud NGFW for Azure.|
|Support for Non-<br>RFC 1918|This release adds support for additional private IP ranges besides those<br>addresses specified in RFC 1918 for vNET and vWAN deployments.<br>With this support, you can use public IP address blocks (for example,<br>40.0.0.0/24) as your private network without routing the traffic to the<br>internet. For more information about this feature in vNET deployments,<br>see the information provided in the**Networking Section**(step 5)<br>Additional Prefixes to Private Traffic Range.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**32** 

What's New 

## What’s New in October 2023 

|**New**|**Description**|
|---|---|
|Additional Azure<br>Region Support|Cloud NGFW for Azure is now available in the following Azure regions:<br>• US West 2<br>• North Europe<br>SeeSupported Regions and Zonesfor the complete list of supported<br>regions.|
|Programmatic<br>Access|Programmatic access allows you to create and manage NGFWs and<br>rulestacks using APIs. Using these APIs, you can invoke actions on Cloud<br>NGFW resources through an application or third-party tool. The table<br>below provides information about supported tools:<br>Terraform<br>Use the Azure Provider to configure<br>infrastructure using Azure Resource<br>Manager APIs.<br>PowerShell<br>Use Microsoft Azure PowerShell cmdlets to<br>configure Cloud NGFW for Azure.<br>CLI<br>Use these commands to manage your<br>Cloud NGFW for Azure resources.<br>SDK<br>SDK package forPythonis supported.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**33** 

What's New 

## What’s New in September 2023 

|**New**|**Description**|
|---|---|
|Integrate SSO login<br>flow with your<br>Support Portal<br>account|Integrate your organization’s SSO login flow with your Palo Alto<br>NetworksCustomer Support Portal<br> account for your Cloud NGFW for<br>Azure subscription.|
|Support for public<br>domain email<br>addresses|This release adds support for public domain email addresses for<br>Customer Support Portalaccounts. Previously, users who managed<br>Cloud NGFW assets and related support cases needed a corporate email<br>address to log into the account. With this added functionality:<br>• Public domain users access assets and support cases in accounts<br>where they are members.<br>• RBAC access controls are assignable and applied to users with public<br>domain emails.<br>• A user with a public domain email address in one account can't access<br>assets and support cases in another account. Resolve this issue by<br>adding the user with the public domain email address to the account<br>they need to access.<br>• A user with a public domain email address is assigned any role,<br>including superuser and domain administrator.<br>• An account can have one or more users with a public domain email<br>address. If an account was created by a user with a public domain<br>email address, the account is considered_public_.<br>_An account can't have a mix of users with corporate and_<br>_public email addresses._<br>The following public domain email addresses are supported:<br>gmail.com<br>yahoo.*<br>hotmail.*<br>live.*<br>outlook.com<br>aol.com<br>gms.* (gmx.de,<br>gmx.net, gmx.us)<br>icloud.com<br>msn.com<br>comcast.net**<br>att.net|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**34** 

What's New 

## What’s New in August 2023 

|**New**|**Description**|
|---|---|
|General availability|Cloud NGFW for Azure has reached general availability. This<br>release includes numerous fixes, support for additionalregions, and<br>enhancements to the pay-as-you-go (PAYG)subscription model.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**35** 

What's New 

## What’s New in June 2023 

|**New**|**Description**|
|---|---|
|Health Monitoring|View the overall health status of the Cloud NGFW firewall, connection<br>status, and diagnostic information. Use this information to determine the<br>cause of an unhealthy firewall state. SeeMonitor Cloud NGFW Health<br>for more information.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**36** 

What's New 

## What’s New in May 2023 

|**New**|**Description**|
|---|---|
|Initial release of<br>Cloud NGFW for<br>Azure|The initial release of Cloud NGFW for Azure includes the following<br>features:<br>• vNETandvWAN-based firewall deployments<br>• Single and multihub for vWAN. For more information, seeConfigure<br>Palo Alto Networks Cloud NGFW in Virtual WAN.<br>• Use cases for inbound, outbound, and east-west traffic<br>• Policy Managementfor rulestacks, prefix objects, FQDN objects and<br>certificate objects<br>• Loggingsupport<br>• Autoscale support<br>• Outbound decryption<br>• Content and antivirus upgrades<br>• Rolling upgrades for firewall resources<br>• Support provided byCustomer Support Portal<br>• Support for built-in roles (LocalNGFirewall and<br>LocalRuleStacksAdministrator)|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**37** 

What's New 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**38** 


![](images/fetchpdf-1780573142924.pdf-0039-00.png)


## Cloud NGFW for Azure Addressed Issues 

The following issues have been addressed at this release of Cloud NGFW for Azure. 

|**ID**|**Description**|
|---|---|
|**PLUG-20294**|The billing issue related to URL Logging is now fixed. To use logging-<br>only functionality, you must now configure the URL filtering profiles<br>to exclusively use**custom URL categories**, setting the action for these<br>categories to alert to ensure logs are generated. All predefined categories<br>within the profile must have their action set to allow. By following this<br>specific configuration, you can now maintain full visibility of URL traffic, as<br>required for comparison with other firewall services, without the associated<br>Advanced URL Filtering billing, since the URL filtering license is only required<br>for using and enforcing actions on predefined URL categories.|
|**FWAAS-15572**|In CNGFW Azure, the firewall may incorrectly allow all traffic, even when<br>Layer 7 Rules (LRS) explicitly restrict specific ports. This occurs because the<br>firewall is not correctly retrieving port information from the LRS, leading it to<br>default to**application-default**for services instead of the configured allowed<br>ports. Consequently, traffic intended for restricted ports (such as RDP when<br>only port 443 is allowed) is permitted, effectively rendering the firewall<br>unable to enforce granular port-based security policies. This issue happens<br>only when modifying a rule from specific protocol to port to Application<br>default or any.|
|**FWAAS-12991**|When deploying CNGFW on Azure, the Standard Load Balancer (SLB) limits<br>SNAT port allocation to 1024 per instance, restricting the scaling with<br>additional public IPs. This change yields 1600 SNAT ports per instance per<br>IP, enabling proper outbound scaling, calculated as (64,000/40)×number of<br>public IPs.|
|**FWAAS-3919**|It is observed that invalid rule names could be generated in Local Rulestacks<br>that could cause commit failures.|
|**FWAAS-4546**|Rulehit counter DB entries are not deleted after deleting the rule, resulting<br>in old values if a rule is created again with the same name.|
|**FWAAS-4767**|The DNS proxy does not update simultaneously on the firewall, following a<br>firewall update call.|
|**FWAAS-4805**|Firewall host names are erroneously displayed in logs.|



**39** 

Cloud NGFW for Azure Addressed Issues 

|**ID**|**Description**|
|---|---|
|**FWAAS-7430**|If you try to delete a new Cloud NGFW resource before the creation is<br>complete, the deletion fails.|
|**FWAAS-7542**|Panorama does not always automatically push content and antivirus updates<br>to newly created Cloud NGFW for Azure resources.|
|**FWAAS-8696**|Log forwarding to a Panorama virtual appliance may take a long time to<br>complete.|
|**FWAAS-9041**|Device server profiles (for example, LDAP, syslog) erroneously appear<br>disabled in Panorama templates used for CNGFW devices.|
|**FWAAS-9050**|In some cases, a license on a VM-Series firewall may be removed from the<br>Panorama virtual appliance.|
|**FWAAS-9055**|The CNGFW reaches an unhealthy state and loses connectivity to Panorama<br>when the Cloud Device Group name is changed.|
|**PAN-217460**|Cloud NGFW resources managed by a Panorama HA pair might show<br>disconnected on the secondary Panorama. However, on the primary<br>Panorama, the Cloud NGFW resource shows connected.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**40** 


![](images/fetchpdf-1780573142924.pdf-0041-00.png)


## Cloud NGFW for Azure Known Issues 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



The following known issues have been identified in the Palo Alto Networks Cloud NGFW for Azure. 

|**ID**|**Description**|
|---|---|
|**DIT-55458**|New instances of**CNGW Azure**fail to forward logs to a**dedicated log**<br>**collector**post scale-out. When a new firewall joins**Panorama**, its serial<br>number is added to the device list. However, unlike when Panorama acts as<br>a log collector, a dedicated log collector doesn't automatically receive this<br>new device information. Consequently, it rejects connection requests from<br>the new instances.<br>**Workaround**: A manual commit and push from Panorama to the Collector<br>Group is required which will update configuration including the new<br>device's serial number to the dedicated log-collector.<br>Other workarounds are:<br>• Use Panorama as Local Log-Collector<br>• Use SLS (Strata Logging Service).<br>• Use Azure Log Analytics Workspace.|
|**DIT-48634**|In the Azure portal, health checks from an internal load balancer are not<br>received which causes the Cloud NGFW resource to reach an unhealthy<br>state; a gateway with a Deny All rule blocks communication between the<br>load balancer performing the health check to the firewall. To resolve this<br>issue, allow list the health probe IP address.|
|**DIT-40385**|After overriding the default intrazone security policy from Panorama, the<br>change may not apply correctly on the Cloud NGFW. The firewall continues<br>to use its local intrazone-default deny policy, which takes precedence and<br>results in unexpected denial of same-zone traffic. Additionally, traffic logs<br>for this denied traffic are not visible.|



**41** 

Cloud NGFW for Azure Known Issues 

|**ID**|**Description**|
|---|---|
||**Workaround:**To allow intra-zone traffic, customers should create a specific<br>security policy rule for the desired behavior and place it in the pre-rule or<br>post-rule sections. This new rule will take precedence over the default deny<br>policy, ensuring traffic is handled as intended|
|**FWAAS-10519**|When multilogging destination is enabled, the logs are seen on Panorama<br>and syslog server, but no logs are seen on the log analytics workspace.<br>Workaround: If you want to use syslog along with log analytics workspace,<br>change the service route to destination based instead of a service-based<br>route.<br>For**Destination Based Routing**configuration, select the destination, add<br>your syslog server private IP, and then select**loopback.3**as the source<br>interface.|
|**FWAAS-9688**|Default rules in Panorama are overridden by the Cloud NGFW resource.<br>Parameters such as**Profile**and**Action**are not retained. For example, if you<br>configure an action to**Allow**, it reverts to**Deny**; if you configure a logging<br>profile, it reverts to**None**.|
|**FWAAS-7531**|A self-signed certificate can erroneously be associated with a rulestack,<br>despite the absence of a resource name.|
|**FWAAS-7542**|Panorama does not always automatically push content and antivirus<br>updates to newly created Cloud NGFW for Azure resources.|
|**FWAAS-7547**|QoS Profiles (provided by a device template) are not removed when<br>displayed in the Panorama virtual appliance.|
|**FWAAS-7956**|A rulestack displays incorrect information when it shares the same name as<br>the firewall.|
|**FWAAS-8642**|Creating a large number of local rules can cause an HTTP error (503 Server<br>Error: Service Unavailable).|
|**FWAAS-9086**|Deployment status information in the Azure portal is truncated without<br>displaying complete information.|
|**FWAAS-10195**|Firewall creation fails when you enable non-RFC 1918 addresses without<br>enabling a DNS Proxy.|
|**PAN-217954**|When a Cloud NGFW for Azure resource connects to Panorama for the<br>first time, the template stack associated with the resource's Cloud Device<br>Group is out of sync.|
|**PAN-217459**|Cloud NGFW resources managed by a Panorama HA pair might be listed<br>in the cloud device group by its serial number (instead of device name) on|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**42** 

Cloud NGFW for Azure Known Issues 

|**ID**|**Description**|
|---|---|
||the secondary Panorama. However, on the primary Panorama, the Cloud<br>NGFW resource is listed by its device name.|
|**PAN-217966**|Configured Dynamic Address Group tags and IP addresses are not listed in<br>child Cloud Device Groups when the parent device group does not have a<br>Dynamic Address Group configured.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**43** 

Cloud NGFW for Azure Known Issues 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Release Notes 

**44** 


