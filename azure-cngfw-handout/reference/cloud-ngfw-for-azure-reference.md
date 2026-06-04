---
source: pdf_url
url: https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/pdf/cloud-ngfw-azure/cloud-ngfw-for-azure-reference.pdf
title: Cloud NGFW for Azure Reference
fetched: 2026-06-04T11:39:02.884Z
pages: 94
---
## Cloud NGFW for Azure Reference 

docs.paloaltonetworks.com 

## **Contact Information** 

Corporate Headquarters: Palo Alto Networks 3000 Tannery Way Santa Clara, CA 95054 www.paloaltonetworks.com/company/contact-support 

## **About the Documentation** 

- For the most recent version of this guide or for access to related documentation, visit the Technical Documentation portal docs.paloaltonetworks.com. 

- To search for a specific topic, go to our search page docs.paloaltonetworks.com/search.html. 

- Have feedback or questions for us? Leave a comment on any page in the portal, or write to us at documentation@paloaltonetworks.com. 

## **Copyright** 

Palo Alto Networks, Inc. www.paloaltonetworks.com 

> © 2025-2026 Palo Alto Networks, Inc. Palo Alto Networks is a registered trademark of Palo Alto Networks. A list of our trademarks can be found at www.paloaltonetworks.com/company/ trademarks.html. All other marks mentioned herein may be trademarks of their respective companies. 

## **Last Revised** 

March 23, 2026 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**2** 

## Table of Contents 

**Cloud NGFW for Azure Pricing......................................................................5** Base NGFW Resource Consumption......................................................................................7 Cloud-Delivered Security Services (CDSS) Consumption..................................................8 Centralized Management Add-On........................................................................................ 10 Strata Cloud Manager...................................................................................................10 Azure Networking Charges.....................................................................................................11 Migrate to the New Pricing Plan...........................................................................................12 End of Sale Announcement: DNS and WF subscription................................................. 15 **Cloud NGFW Credit Distribution and Management...............................17** Start Using Cloud NGFW Credits.........................................................................................18 Manage Credits.............................................................................................................. 24 Manage Deployment Profiles.................................................................................................30 View an Audit Trail...................................................................................................................33 **Cloud NGFW Credit Usage Visibility..........................................................35** Use the Tenant Usage Details Page.....................................................................................38 **Cloud NGFW for Azure Limits and Quotas...............................................47** Native Policy Management (Rulestack)............................................................................... 48 Panorama Policy Management.............................................................................................. 49 Cloud NGFW for Azure Performance..................................................................................50 **Cloud NGFW for Azure Supported Regions and Zones.........................53 Cloud NGFW for Azure Certifications........................................................55 Cloud NGFW for Azure Privacy and Data Protection............................57 Cloud NGFW for Azure Security Services.................................................59** IPS and Spyware Threat Protection..................................................................................... 60 Malware and File-based Threat Protection........................................................................ 65 Web-based Threat Protection............................................................................................... 68 **Cloud NGFW for Azure Resiliency and Scalability..................................79 CNGFW for Azure Troubleshooting........................................................... 83** Panorama and Cloud NGFW Connectivity.........................................................................84 VM Auth Key Expiry................................................................................................................ 91 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**3** 

Table of Contents 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**4** 


![](images/fetchpdf-1780573130754.pdf-0005-00.png)


## Cloud NGFW for Azure Pricing 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



## **Pay-As-You-Go** 

Cloud NGFW is available as a pay-as-you-go (PAYG) subscription in the Azure Marketplace. With this model, you pay only for what you use each month, and also enjoy Azure Marketplace benefits such as consolidated billing and credit toward an organization’s Microsoft Azure Consumption Commitment (MACC). 

You pay an hourly rate for each Cloud NGFW resource. You also pay for the amount of traffic, billed by the gigabyte, processed by the NGFW resource. Additionally, you pay an hourly rate and for the amount of traffic processed by your Cloud NGFW resource when you configure security services add-ons (such as Threat Prevention, Advanced URL Filtering, DNS Security, or WildFire[®] ) or the centralized management add-on (Panorama management). 

## **Credit Pricing Model** 

You can procure and associate Cloud NGFW for Azure Credits to your tenant by paying an upfront cost for a long-term contract from a one-year to a five-year time frame. You can procure these credits directly from Azure Marketplace or at a private price from Palo Alto Networks or its partners. By purchasing credits you can also take advantage of Azure Marketplace benefits such as consolidated billing, MACC committed consumptions and automated renewals. Cloud NGFW credits allow you to consume Cloud NGFW resources in your tenant at a lower cost up to a specific capacity until your contract expires. 


![](images/fetchpdf-1780573130754.pdf-0005-08.png)


_If your average consumption per month exceeds the purchased credits, overages apply at PAYG rates._ 


![](images/fetchpdf-1780573130754.pdf-0005-10.png)


_If you add Cloud NGFW credits during a free-trial period, your contract begins immediately and overrides the free trial._ 

**5** 

Cloud NGFW for Azure Pricing 


![](images/fetchpdf-1780573130754.pdf-0006-01.png)


_Use the Cloud NGFW for Azure pricing estimator to help you determine Azure pricing for your Cloud NGFW tenant._ 


![](images/fetchpdf-1780573130754.pdf-0006-03.png)


## **Metering and Billing** 

You pay an hourly rate for each Cloud NGFW resource. You also pay for the amount of traffic, billed by the gigabyte, processed by the NGFW resource. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**6** 

Cloud NGFW for Azure Pricing 

## Base NGFW Resource Consumption 

You pay an hourly rate for each Cloud NGFW resource. You also pay for the amount of traffic, billed by the gigabyte, processed by the NGFW resource. 

|**Dimension**|**Price (Per Hour)**|**Price (Per GB)**|**Equivalent Cloud**<br>**NGFW Credits**|
|---|---|---|---|
|Base NGFW<br>Resource Usage|$1.25|—|104.17|
|Traffic Secured per<br>GB per Tenant|—|$0.016|1.33|
|Add-ons|$0.12 per 10 Cloud<br>NGFW Credits|—|See below for<br>specific billing<br>information for each<br>add-on.|
|Azure Networking<br>Charges|—|$0.010 cents per Unit|—|




![](images/fetchpdf-1780573130754.pdf-0007-04.png)


_Cloud NGFW for Azure bills the Egress usage (outbound and peering charges) under Azure Networking charges dimension. For more information, refer to the_ Azure Networking Charges _._ 

_Cloud NGFW for Azure bills the Egress usage (inbound, outbound, and east-west traffic) under Azure Networking charges dimension, and then the Azure Marketplace receives the consumption details. Azure virtual network pricing determines these charges. For more information, see_ Virtual Network Pricing _._ 


![](images/fetchpdf-1780573130754.pdf-0007-07.png)


_Each NGFW resource you deploy meters usage hours. Traffic is metered across all NGFW resources deployed in your Cloud NGFW tenant._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**7** 

Cloud NGFW for Azure Pricing 

## Cloud-Delivered Security Services (CDSS) Consumption 

Cloud NGFW for Azure bills the usages of these security services using the **add-ons dimension** . Cloud NGFW for Azure measures usage in $/hour and $/GB as detailed in the following table. 


![](images/fetchpdf-1780573130754.pdf-0008-03.png)


- _Cloud NGFW for Azure does not support per-rule billing for add-on security services. If any of your security rules have a security profile enabled (such as Threat Prevention, Advanced URL Filtering, DNS Security, or WildFire), you will be charged for add-on services for_ _**all traffic** that is processed by the NGFW, not just the traffic that matches the rule with the security profile._ 

_For example, if you have two security rules:_ 

- _**Rule 1:** Allows traffic to a specific destination with an Advanced URL Filtering profile._ 

- _**Rule 2:** Allows all other traffic with no security profile._ 

_In this scenario, you will be billed for Advanced URL Filtering for_ _**all traffic** processed by the NGFW, including the traffic that matches Rule 2. To avoid add-on charges, you must ensure that_ _**no** security profiles are enabled on_ _**any** of your security rules._ 

|**Advanced Threat**<br>**Prevention Add-On**|**Price (Per Hour)**|**Price (Per GB)**|**Equivalent Cloud**<br>**NGFW Credits**|
|---|---|---|---|
|Usage Hour*|$0.375|—|31.25|
|Traffic Secured|—|$0.005|0.4|



|**Advanced URL**<br>**Filtering Add-On**|**Price (Per Hour)**|**Price (Per GB)**|**Equivalent Cloud**<br>**NGFW Credits**|
|---|---|---|---|
|Usage Hour*|$0.375|—|31.25|
|Traffic Secured|—|$0.005|0.4|



|**Advanced WildFire**<br>**Add-On**|**Price (Per Hour)**|**Price (Per GB)**|**Equivalent Cloud**<br>**NGFW Credits**|
|---|---|---|---|
|Usage Hour*|$0.375|—|31.25|
|Traffic Secured|—|$0.005|0.4|
|||||
|**ADNS Security Add-**<br>**On**|**Price (Per Hour)**|**Price (Per GB)**|**Equivalent Cloud**<br>**NGFW Credits**|
|Usage Hour*|$0.375|—|31.25|
|Traffic Secured|—|$0.005|0.4|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**8** 

Cloud NGFW for Azure Pricing 


![](images/fetchpdf-1780573130754.pdf-0009-01.png)


_*Usage hour is metered on each NGFW resource with CDSS add-ons enabled._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**9** 

Cloud NGFW for Azure Pricing 

## Centralized Management Add-On 

You can use a Panorama virtual appliance to manage policy rules in your Cloud NGFW tenant. Centralized management add-on consumption is metered on each NGFW resource for each hour you have associated with a Panorama appliance and for the amount of traffic processed by that NGFW. The rate you’re charged for the traffic also depends on the aggregate traffic processed by all NGFWs in the tenant during the month (referred to as tiered traffic pricing). 


![](images/fetchpdf-1780573130754.pdf-0010-03.png)


_You no longer need to pay for additional device licenses to manage policy rules in Cloud NGFW for Azure resources. Panorama (version 11.2.6 or above) does not count these NGFW resources against its managed device license count._ 

|**Traffic Secured**|**Price per Hour**|**Price per GB**|**Equivalent Cloud**<br>**NGFW Credits**|
|---|---|---|---|
|Usage Hour|$0.250|—|20.83|
|Traffic Secured|—|$0.003|0.27|



## Strata Cloud Manager 

You can use Strata Cloud Manager to manage security policies in your Cloud NGFW tenant. The rate you are charged for the traffic depends on the aggregate traffic processed by all NGFWs in the tenant during the month (referred to as tiered traffic pricing). 

|**Traffic Secured**|**Price per Hour**|**Price per GB**|**Equivalent Cloud**<br>**NGFW Credits**|
|---|---|---|---|
|Usage Hour|$0.375|—|31.25|
|Traffic Secured|—|$0.005|0.4|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**10** 

Cloud NGFW for Azure Pricing 

## Azure Networking Charges 

Since Cloud NGFW hosts the resources in the Palo Alto Networks tenant on your behalf, the data transfer costs are billed to the firewall service provider (Palo Alto Networks), which we then pass on to you. 

The charges will align exactly with Microsoft's official bandwidth pricing meters. Depending on your network traffic, you may get charged for one or more of the following types of data transfer if you had hosted these firewalls in your tenant. 

- **Standard Data Transfer Out (Internet Egress)** - When your Azure applications send data to the public internet (For example: serving a website to external users or downloading updates). 

- **Inter-Region Data Transfer** - When your Azure applications send data from one Azure region to a different Azure region. 

- **VNet Peering Traffic charges** - When your applications in the Spoke VNets send or receive traffic from the firewall in the Hub VNEts (local peering and Global peering). 

These charges are calculated strictly using Microsoft's official per-gigabyte pricing for Internet Egress, peering, and Inter-Region transfers; inbound traffic remains completely free. On your invoice, these bandwidth charges are summarized into a single line item ("Azure Networking charges") showing a calculated quantity at an effective price of $0.01 per unit. 

Because these costs from Microsoft Azure, Palo Alto Networks cannot discount them. Furthermore, since they are billed directly to the firewall service provider, your Microsoft Enterprise Agreement (EA) discounts do not apply. If you need a detailed breakdown of the effective prices, contact TAC support with your Resource ID to obtain a full cost report for the previous month. 

## **Official Azure Pricing References** 

Because these are Microsoft's fees, the rates are dictated by standard Azure pricing. You can verify the exact costs per gigabyte using Microsoft's official resources: 

- Azure Bandwidth Pricing Page: Details the cost per GB for Internet Egress and Inter-Region data transfer. 

- Azure Pricing Calculator: Use the **Bandwidth** module to estimate your monthly egress costs based on your expected traffic volume. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**11** 

Cloud NGFW for Azure Pricing 

## Migrate to the New Pricing Plan 

Complete the following procedure to migrate your existing Cloud NGFW for Azure resources to the new pricing plan (described above). 


![](images/fetchpdf-1780573130754.pdf-0012-03.png)


- _Complete the following steps, regardless of the payment mode (PAYG or Private Contract), to take advantage of the new pricing option._ 


![](images/fetchpdf-1780573130754.pdf-0012-05.png)


_Complete this procedure on each Cloud NGFW for Azure firewall._ 

**1.** Log in to the Azure portal. 

**2.** Select your Cloud NGFW for the Azure firewall deployed in your tenant and navigate to the **Overview** page. 

**3.** Click **Change Plan** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**12** 

Cloud NGFW for Azure Pricing 

**4.** Select the new pricing plan. The new pricing plan does not have tiered pricing based on the amount of traffic secured. 


![](images/fetchpdf-1780573130754.pdf-0013-02.png)


**5.** Click **Change Plan** to confirm. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**13** 

Cloud NGFW for Azure Pricing 

**6.** You can verify the plan change on the firewall **Overview** page. The **Plan ID** will state **panwcngfw-payg** . 


![](images/fetchpdf-1780573130754.pdf-0014-02.png)


_Moving to the new pricing plan requires no additional actions after completing the above procedure._ 


![](images/fetchpdf-1780573130754.pdf-0014-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**14** 

Cloud NGFW for Azure Pricing 

## End of Sale Announcement: DNS and WF subscription 

Effective March 10, 2026, the DNS and WF subscription will no longer be available for sale on Cloud NGFW for any new customer onboarding the Firewall. The DNS and WF subscriptions will be replaced with ADNS and AWF. Please note that support for existing TP and DNS customers will continue until the end of FY26 (July 31, 2026). Post July 31, 2026 the existing customers will automatically be consuming ADNS and AWF subscriptions. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**15** 

Cloud NGFW for Azure Pricing 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**16** 


![](images/fetchpdf-1780573130754.pdf-0017-00.png)


## Cloud NGFW Credit Distribution and Management 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



You can procure and associate Cloud NGFW credits to your Cloud NGFW tenants by paying an upfront cost for a long-term contract of one, two, or three years. You can procure these credits directly from Palo Alto Networks and its partners. Your Palo Alto Networks sales teams and its partners can send these credits to you directly or by using the Cloud provider marketplace private offers. These private offers (also referred to as _Azure Private Offers_ , or _Azure Multiparty Private Offers_ ) allow you to take advantage of Cloud Marketplace benefits such as consolidated billing, and their spend commitments (Azure MACC). 

Cloud NGFW credits allow you to consume Cloud NGFW resources in your tenant at a lower cost than PAYG rates, up to a specific capacity until your contract expires and automated or configurable renewals. Cloud NGFW credits fund your consumption of Cloud NGFW resources and their related usage of CDSS and centralized management (Panorama, Strata Cloud Manager, and Strata Logging Service). 

Consider the following when using Cloud NGFW credits: 

- Cloud NGFW credits are term-based. Terms can be defined for any amount of time between one and five years. Both allocated and unallocated credits expire at the end of the agreed-upon term. 

- If your monthly average consumption exceeds the purchased credits, overages are charged at PAYG rates. 

- If you add Cloud NGFW credits during a free-trial period, your contract starts immediately and overrides the free trial. 

- Use the Cloud NGFW pricing estimator to help you determine pricing for your Cloud NGFW tenant. 

- You can procure credits for Cloud NGFW and all the CDSS services you intend to use for Cloud NGFW. 

**17** 

Cloud NGFW Credit Distribution and Management 

## Start Using Cloud NGFW Credits 

Once you book the order for credits, they become active immediately, and an email is sent to enable you to start using your credits; for example, if you purchased credits for a one year term on September 6, 2024, the credits are active that day while the term lasts, in the case of this example, until September 5, 2025. The person listed as the administrative contact in the quote receives the activation email. The email provides details about the subscription, the credit pool ID, the subscription start and end date, the number of credits purchased, and the description of the default credit pool. You can use these details to activate credits in your Customer Support Portal (CSP) account. 


![](images/fetchpdf-1780573130754.pdf-0018-03.png)


- _Palo Alto Networks recommends retaining this email to access information related to your account._ 

_Cloud NGFW will_ _**only begin consuming credits AFTER** the DP is associated. Failure to do so will result in continued_ _**PAYG billing** ._ 

You will select one of your CSP accounts for the credit pool during activation. Once your credit pool is active, you can manage and allocate the credits to your Cloud NGFW tenants using the Credit Management Application described below. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**18** 

Cloud NGFW Credit Distribution and Management 

## **STEP 1 |** In the email, click **Activate** . 


![](images/fetchpdf-1780573130754.pdf-0019-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**19** 

Cloud NGFW Credit Distribution and Management 

**STEP 2 |** After clicking **Activate** , you’re redirected to the CSP. Select the CSP account in which you want to activate the credits. 

**STEP 3 |** Select **Start Activation** to start using your credits by depositing them into the CSP and allocating the credits. 


![](images/fetchpdf-1780573130754.pdf-0020-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**20** 

Cloud NGFW Credit Distribution and Management 

**STEP 4 |** Select the Palo Alto Networks Customer Support portal account (you can search by account number or name) where you want to deposit the credits and click **Deposit Credits** : 


![](images/fetchpdf-1780573130754.pdf-0021-02.png)


**STEP 5 |** You can view your deposited credits in the customer support portal (CSP): 

1. In the CSP, within the left navigation panel go to **Product** , select **Software/Cloud NGFW Credits** . 

2. Use the **Account Selector** to ensure that you're viewing the correct account, then click **Cloud NGFW Credits** to display the credit pools associated with the account. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**21** 

Cloud NGFW Credit Distribution and Management 

**STEP 6 |** Click **Go to Cloud NGFW Credits** to access the Cloud NGFW Credit Management application in the Palo Alto Networks hub. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**22** 

Cloud NGFW Credit Distribution and Management 

**23** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

Cloud NGFW Credit Distribution and Management 

## Manage Credits 

The Cloud NGFW Credit Management Application provides a single location where you can manage your purchased credit pools, create deployment profiles and associate them with your Cloud NGFW tenants. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**24** 

Cloud NGFW Credit Distribution and Management 

**STEP 1 |** In the Hub, click **Cloud NGFW Credit Management** to display the app: 


![](images/fetchpdf-1780573130754.pdf-0025-02.png)


The Cloud NGFW Credit Management application displays the credit pools associated with the CSP account: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**25** 

Cloud NGFW Credit Distribution and Management 


![](images/fetchpdf-1780573130754.pdf-0026-01.png)


Each credit pool, displayed as an individual tile, provides two options: 

- **Check Details** . Use this option to display information about the credit pool. If a deployment profile already exists, it appears in the **Deployment Profile** table: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**26** 

Cloud NGFW Credit Distribution and Management 


![](images/fetchpdf-1780573130754.pdf-0027-01.png)


- **Create Deployment Profile** . Use this option to create a deployment profile to consume activated credits from the pool. 


![](images/fetchpdf-1780573130754.pdf-0027-03.png)


_Before you create a deployment profile, estimate the number of firewalls that will use the configuration. You don’t have to deploy all the firewalls at once._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**27** 

Cloud NGFW Credit Distribution and Management 

**STEP 2 |** Click **Create Deployment Profile** . In the **Create Deployment Profile** screen, specify the following information: 

1. In the **Name** field, use the drop-down menu to select the **Credit Pool ID** from the list of available options. Enter the corresponding name for the credit pool ID. 

2. Select the **Cloud Type** (either Amazon Web Services or Microsoft Azure). 

3. Use the drop-down menu to select the **Cloud NGFW Serial Number** . 


![](images/fetchpdf-1780573130754.pdf-0028-05.png)


   - _If you don’t see a Cloud NGFW Serial number in the drop-down, ensure that you're subscribed to the Cloud NGFW service, and that the tenant isn’t associated with another CSP account._ 

4. Specify the **Number of Credits** you want to allocate from the credit pool; the number of available credits from the credit pool appears. 

5. Optionally include a description. 

6. Click **Save** . 

After you have successfully created the deployment profile, the **CNGFW Credits** page displays the newly created profile along with the number of allocated credits: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**28** 

Cloud NGFW Credit Distribution and Management 


![](images/fetchpdf-1780573130754.pdf-0029-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**29** 

Cloud NGFW Credit Distribution and Management 

## Manage Deployment Profiles 

After you create your deployment profile you can edit (add or remove allocated credits), delete it, or view an audit trail. Before modifying your deployment profile, ensure that you understand the following terms— _consumption_ and _allocation_ in the context of Software NGFW credits: 

- Consumption—the number for Software NGFW credits used by a deployment profile to license deployed firewalls and subscriptions. 

- Allocation—the total number of Software NGFW credits assigned to a particular deployment profile. 

## **Edit a Deployment Profile** 

To edit an existing deployment profile: 

**STEP 1 |** In the **Cloud NGFW Credits** page, select the deployment profile you want to edit. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**30** 

Cloud NGFW Credit Distribution and Management 

## **STEP 2 |** In the **Edit Deployment Profile** screen, change the **Number of Credits** . 


![](images/fetchpdf-1780573130754.pdf-0031-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**31** 

Cloud NGFW Credit Distribution and Management 


![](images/fetchpdf-1780573130754.pdf-0032-01.png)


## _The number of available credits appears below the_ _**Number of Credits** field._ 

**STEP 3 |** After changing the number of credits, click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**32** 

Cloud NGFW Credit Distribution and Management 

## View an Audit Trail 

The Cloud NGFW Credit Management application provides an _audit trail_ that allows you to track changes made to a deployment profile. This information includes: 

- Date and time when the deployment profile was modified. 

- The serial number associated with the deployment profile. 

- The profile name. 

- The status, for example, _edited_ . 

- Modified by indicates the user who edited the deployment profile. 

- The description describes the nature of the change. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**33** 

Cloud NGFW Credit Distribution and Management 


![](images/fetchpdf-1780573130754.pdf-0034-01.png)


To view an audit trail, in the Cloud NGFW Credits page, click **Audit Trail** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**34** 


![](images/fetchpdf-1780573130754.pdf-0035-00.png)


## Cloud NGFW Credit Usage Visibility 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal (CSP) account<br>Azure Marketplace subscription|



Use the credit usage and visibility functionality to gain more insights into how your Cloud NGFW credits are consumed. With this information you can: 

- Determine how your Cloud-Delivered Security Services (CDSS) are being consumed. 

- View firewall and tenant level credit usage daily, monthly, or yearly. 


![](images/fetchpdf-1780573130754.pdf-0035-06.png)


_See_ Credit Distribution and Management _for more information._ 

To use the credit visibility functionality for your Cloud NGFW: 

- **STEP 1 |** Log in to the Palo Alto Networks Customer Support Portal. 

- **STEP 2 |** In the portal, select **Product** . 

- **STEP 3 |** Select **Software and Cloud NGFW credits** . 

- **STEP 4 |** Use the **Account Selector** to ensure that you’re viewing the correct account, then click the **Cloud NGFW credits** tab to display the credit pools associated with the account. 

**35** 

Cloud NGFW Credit Usage Visibility 

**STEP 5 |** Click **Go to Cloud NGFW Credits** to access the Cloud NGFW Credit Management application in the Palo Alto Networks hub. 


![](images/fetchpdf-1780573130754.pdf-0036-02.png)


The **Cloud NGFW Credits** page provides access to credit visibility functionality. To access it, select the Cloud NGFW serial number associated with the deployment profile you want to view. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**36** 

Cloud NGFW Credit Usage Visibility 

**STEP 6 |** The **Cloud NGFW Credits** page provides access to the credit visibility functionality. To access it, select the **Cloud NGFW serial number** associated with the deployment profile you want to view. 


![](images/fetchpdf-1780573130754.pdf-0037-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**37** 

Cloud NGFW Credit Usage Visibility 

## Use the Tenant Usage Details Page 

The **Tenant Usage Details** page displays information about how Cloud NGFW credits are consumed. When you first access this page a _table view_ provides a graphical representation of your credit consumption. You can change this view to a _chart view_ using the option in the upper right of the web interface. 

## **Tenant Usage Details Chart View** 

**Tenant Usage Details Chart View** The _chart view_ provides a color-coded graphical representation of usage details and is organized by base FW usage, traffic secured, and dimensions. The _chart view_ includes the following fields: 

- By Dimensions (Current Month). This area displays how the credits are consumed by base firewall usage, traffic secured, and any add-ons (like centralized management, or Advanced URL Filtering). 

- By Regions (Current Month). Indicates which regions are consuming credits. 

- Tenant Usage Details. Use this area of the interface to display detailed information about how credits are used over a period of time or by dimensions. You can alter this view by changing: 

   - the period in which credits are consumed, for example, the past six months. You can customize the time period by indicating monthly, yearly, or by specifying an exact day. 


![](images/fetchpdf-1780573130754.pdf-0038-09.png)


_By default, data is limited to five years for monthly or yearly views. When looking at the daily view, you can only select dates for 2 years from the current date._ 

- the dimensions displayed in the chart, for example, select only those dimensions (such as Advanced URL Filtering) to determine how many credits they consumed. See _**Dimensions**_ later in this article for more information. 

- all dimensions. Use this option to display how credits are consumed by all dimensions used by the deployment profile. 


![](images/fetchpdf-1780573130754.pdf-0038-13.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**38** 

Cloud NGFW Credit Usage Visibility 

For example, to display credit consumption based on FW Base Usage, select that dimension: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**39** 

Cloud NGFW Credit Usage Visibility 


![](images/fetchpdf-1780573130754.pdf-0040-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**40** 

Cloud NGFW Credit Usage Visibility 

## **Dimensions** 

The table below describes what dimensions you can view. 

|**Dimension**|**Description**|
|---|---|
|FW base usage|Firewall base usage.|
|Traffic secured|Indicates the amount of traffic secured by<br>Cloud NGFW. You pay an hourly rate for<br>each Cloud NGFW resource. You also pay for<br>the amount of traffic, billed by the gigabyte,<br>processed by the NGFW resource.|
|TP|Threat prevention (TP)|
|ATP|Advanced Threat Prevention (ATP) is an<br>intrusion prevention system (IPS) solution that<br>can detect and block malware, vulnerability<br>exploits, and command and control (C2)<br>across all ports and protocols, using a<br>multilayered prevention system with<br>components operating on Cloud NGFW<br>for AWS and in the cloud. The Threat<br>Prevention cloud operates a multitude of<br>detection services using the combined threat<br>data from Palo Alto Networks services to<br>create signatures, each possessing specific<br>identifiable patterns, and are used by the<br>Cloud NGFW for AWS to enforce Security<br>policy rules when matching threats and<br>malicious behaviors are detected. These<br>signatures are categorized based on the<br>threat type and are assigned unique identifier<br>numbers. To detect threats that correspond<br>with these signatures, Cloud NGFW for AWS<br>operates analysis engines that inspect and<br>classify network traffic exhibiting anomalous<br>traits.|
|WF|Cloud NGFW candetect and forwardfiles,<br>executables, and malicious scripts (such as<br>JScript and PowerShell) in your VPC traffic to<br>WildFire™cloud service for analysis. WildFire<br>then applies threat intelligence, analytics,<br>and correlations on these forwarded files<br>(executables or scripts) and delivers verdicts<br>based on the analysis. If a threat is detected<br>on them, WildFire creates protections to|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**41** 

Cloud NGFW Credit Usage Visibility 

||block malware, and globally distribute these<br>protections for that threat in a few minutes.|
|---|---|
|DNS|Domain Name Service (DNS) is a critical and<br>foundational protocol of the internet, as<br>described in thecore RFCsforthe protocol.<br>Malicious actors have utilized command<br>and control (C2) communication channels<br>over the DNS and, in some cases, have even<br>used the protocol to exfiltrate data. DNS<br>exfiltration can happen when a bad actor<br>compromises an application instance in your<br>VPC and then uses DNS lookup to send data<br>out of the VPC to a domain that they control.<br>Malicious actors can also infiltrate malicious<br>data and payloads to the VPC workloads over<br>DNS. Palo Alto Networks Unit 42 research<br>has describeddifferent types of DNS abuse<br>discovered.|
|AURL|Palo Alto Networks provides a set of<br>predefined URL filtering categories. You can<br>also specify your own URL filtering categories<br>using a customer URL category object. For<br>example, create a custom list of URLs that<br>you want to use as match criteria in a Security<br>policy rule. This is a good way to specify<br>exceptions to URL categories, where you’d<br>like to enforce specific URLs differently than<br>the URL category to which they belong.|
|DLP|Data loss prevention (DLP).|



## **Tenant Usage Details table View** 

The _table view_ displays how credits are consumed in a tabular format that you can download as a CSV file. Use this view to search for a specific deployment profile or to change how consumed credits are displayed over a period of time. This view includes the following areas: 

- Credit Info. This area displays the total number of credits allocated to the deployment profile. You can expand this view to display all deployment profiles associated with the tenant. 

- Tenant Info. This area displays the cloud type (either Amazon Web Services or Microsoft Azure), the number of firewalls, and a link to the Cloud NGFW console. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**42** 

Cloud NGFW Credit Usage Visibility 

- Tenant Usage Details. Use this area of the interface to display detailed information about how credits are used over a period of time; you can optionally customize this display by specifying the time frame for your credit consumption. It includes: 

   - Search. Locate how credits are consumed for a given deployment profile. 

   - Total Allocated Credits. The total number of credits allocated to the deployment profile. 

   - Total Consumed Credits (FW Usage). The total number of credits consumed by the deployment profile; also referred to as the total number of credits consumed by the firewall. 

   - Yearly Average Additional Usage. This represents the number of credits consumed beyond the credits allocated to the deployment profile over the course of the year. 


![](images/fetchpdf-1780573130754.pdf-0043-06.png)


   - _The Cloud NGFW does not incur additional daily usage charges. Additional usage fees are applicable only if the monthly average exceeds the total allocated credits through the deployment profile. Any additional usage credits will be charged as PayAs-You-Go (PAYG)._ 

- Download as CSV. Use this option to download credit consumption data to a .CSV file. 


![](images/fetchpdf-1780573130754.pdf-0043-09.png)


_Click_ _**Reset** to clear credit data._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**43** 

Cloud NGFW Credit Usage Visibility 


![](images/fetchpdf-1780573130754.pdf-0044-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**44** 

Cloud NGFW Credit Usage Visibility 

You can also display details for each firewall by selecting the link in the **Total Consumed Credits (FW Usage)** . By default **Firewall Usage Details** are displayed in a daily view; you can use additional options to display these details in a specific date range, or, you can display them based on an individual firewall ID, by region, or by dimensions. Options include: 

- Period. The time frame for credit consumption. 

- Firewall ID. The ID associated with the firewall. 

- Region. The region where the firewall resides. 

- FW Base Usage. Indicates the credits allocated to the base firewall. 

- Traffic Secured (based on Tier). The credits are allocated to secured traffic. 


![](images/fetchpdf-1780573130754.pdf-0045-07.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**45** 

Cloud NGFW Credit Usage Visibility 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**46** 


![](images/fetchpdf-1780573130754.pdf-0047-00.png)


## Cloud NGFW for Azure Limits and Quotas 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



The following tables list the limits and performance data for your Cloud NGFW tenant. Unless indicated otherwise, you can request an increase for these limits. 


![](images/fetchpdf-1780573130754.pdf-0047-04.png)


_Use the_ Cloud NGFW for Azure pricing estimator _to help you determine Azure limits and quotas for your Cloud NGFW subscription._ 

**47** 

Cloud NGFW for Azure Limits and Quotas 

## Native Policy Management (Rulestack) 

|**Attribute**|**Maximum Limit**<br>**per Cloud NGFW**<br>**Resource**|**Adjustable**|
|---|---|---|
|Security rules|1,000|No|
|Addresses objects (FQDN list and IP prefix<br>lists)|1,000|No|
|Number of IP prefix lists|1,000|No|
|FQDN objects across all FQDN lists|2,000|No|
|Prefix objects for each IP prefix list|2,500|No|
|URLs across all URL categories|25,000|No|
|Intelligent feeds (including the five<br>predefined feeds)|30|No|
|IP addresses across all feeds|50,000|No|
|Certificate objects|100|No|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**48** 

Cloud NGFW for Azure Limits and Quotas 

## Panorama Policy Management 

|**Attribute**|**Maximum Limit per Cloud**<br>**NGFW Resource***|
|---|---|
|**Policy**||
|Security rules|10,000|
|Decryption rules|1,000|
|**Objects**||
|Address objects|10,000|
|Address groups|1,000|
|Members per address group|2,500|
|FQDN address groups|2,000|
|Service objects|2,000|
|Service Groups|500|
|Members per Service Group|500|
|**External dynamic list**||
|Max number of DNS per domain system|500,000|
|Max number of IPs per system|50,000|
|Max number of URLs per system|100,000|
|Max number of custom lists|30|
|**URL Filtering**||
|Total entities for allow list, block list, and custom categories|25,000|
|Max custom categories|500|



* The limits on policy and objects specified are unidimensional maximum. Palo Alto Networks recommends additional testing within your environment to ensure you meet your policy authoring objectives. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**49** 

Cloud NGFW for Azure Limits and Quotas 

## Cloud NGFW for Azure Performance 

The following table provides performance information for your Cloud NGFW for Azure tenant. 


![](images/fetchpdf-1780573130754.pdf-0050-03.png)


_The information provided in the following table assumes a maximum of 40 instances._ 

|**Attribute**|**Performance Metric**|
|---|---|
|Firewall throughput (App-ID enabled)|Maximum throughput: 100 Gbps; per<br>instance is 2.92 Gbps<br>Coldstart: 8.55 Gbps<br>_Coldstart refers to initial,_<br>_baseline capacity and_<br>_performance of a newly_<br>_deployed or idle Cloud NGFW_<br>_resource before it automatically_<br>_scales up to handle increased_<br>_traffic loads._<br>_For coldstart traffic, Content_<br>_Threat Detection is enabled._<br>_Without Content threat_<br>_Protection, each firewall_<br>_instance is capped at 3.00_<br>_Gbps due to the instance type._<br>_This is an Azure limitation._|
|Threat Prevention throughput|Maximum throughput: 92 Gbps; per<br>instance is 2.31 Gbps|
|Encrypted Traffic throughput|44 Gbps (with Content Threat Detection);<br>per instance is 1.11 Gbps<br>60 Gbps (without Content Threat<br>Detection); per instance is 1.52 Gbps|
|SNAT Ports|Per Public IP SNAT port = 64000<br>CNGFW can scale maximum up to 40<br>instances behind the scene hence per<br>instance 1600 SNAT ports are available.<br>Total available ports = Number of Public IP<br>* Number of Instance * 1600<br>For example: By default, one instance is<br>deployed in each AZ. If a region has three|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**50** 

Cloud NGFW for Azure Limits and Quotas 

|**Attribute**|**Performance Metric**|
|---|---|
||AZ, and one Public IP is assigned to firewall,<br>the cold start SNAT port will be 4800.<br>You can either add more IP addresses to<br>increase the number or it will auto scale<br>instance if we reach exhaustion to the<br>scaling threshold.|



## **Metrics Integration Limits** 

Azure Monitoring Metrics Integration has the following service and platform limitations: 

- **Data Retention** : Firewall metrics are stored for a maximum of **90 days** within Application Insights. 

- **Azure Custom Metrics Limit** : The Azure custom metrics ingestion feature is subject to an Azure platform limit of **50,000** total active time series per subscription per region. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**51** 

Cloud NGFW for Azure Limits and Quotas 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**52** 


![](images/fetchpdf-1780573130754.pdf-0053-00.png)


## Cloud NGFW for Azure Supported Regions and Zones 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



An Azure region supports up to three availability zones, with only one assigned VM required in each zone. Traffic across each zone uses a VNet, eliminating any cross-zone charges. The following table illustrates zone availability for a specific region. 

|**Region Name**|**Region Code**|
|---|---|
|Australia East|australiaeast|
|Australia Southeast|australiasoutheast|
|Brazil South|brazilsouth|
|Canada Central|canadacentral|
|Canada East|canadaeast|
|Central India|centralindia|
|Central US|centralus|
|East Asia|eastasia|
|East US|eastus|
|East US 2|eastus2|
|France Central|francecentral|
|Germany West Central|germanywestcentral|
|India South|southindia|



**53** 

Cloud NGFW for Azure Supported Regions and Zones 

|**Region Name**|**Region Code**|
|---|---|
|Israel Central|israelcentral|
|Italy North (Milan)|italynorth|
|Japan East|japaneast|
|Japan West|japanwest|
|Mexico Central|mexicocentral|
|New Zealand North|nzn|
|North Central US|northcentralus|
|North Europe|northeurope|
|Norway East|norwayeast|
|South Africa North (Johannesburg)|southafricanorth|
|South Central US|southcentralus|
|South East Asia|southeastasia|
|Spain Central|spaincentral|
|Sweden Central (Gavle)|swedencentral|
|Switzerland North|switzerlandnorth|
|UAE North (Dubai)|uaenorth|
|UK South|uksouth|
|UK West|ukwest|
|West Europe|westeurope|
|West Central US (Wyoming)|westcentralus|
|West US|westus|
|West US 2|westus2|
|West US 3|westus3|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**54** 


![](images/fetchpdf-1780573130754.pdf-0055-00.png)


## Cloud NGFW for Azure Certifications 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal (CSP) account<br>Azure Marketplace subscription|



Third-party auditors assess Cloud NGFW's security and compliance as part of several Palo Alto Networks compliance programs. For general information about Palo Alto Networks' adherence to global security standards, please visit the Compliance section in the Trust Center. The Trust 360 Program details the corporate-wide security, compliance, and privacy controls to protect our customers’ most sensitive data. 

Cloud NGFW is now certified for environments with these compliance obligations. 

|**Compliance**|**Description**|
|---|---|
|**SOC 2+**|Service Organization Control 2 assesses<br>a service provider’s controls over<br>security, availability, processing integrity,<br>confidentiality, and privacy. SOC 2+<br>represents an additional level of certification<br>against an expanded control set, including<br>control alignment against the**HIPAA Security**<br>**Rule**<br>Request a SOC 2+ Report|
|**ISO Certifications**|The ISO 27000 series, consisting of ISO<br>27001, ISO 27017, ISO 27018, ISO 27032,<br>and ISO 27701, provides a robust framework<br>for implementing and managing information<br>security systems, cloud security, data<br>privacy in the cloud, and privacy information<br>management systems.<br>Request ISO (SOA) Report|
|**PCI DSS**|The Payment Card Industry Data Security<br>Standard (PCI DSS) is a globally recognized<br>set of policies and procedures intended|



**55** 

Cloud NGFW for Azure Certifications 

|**Compliance**|**Description**|
|---|---|
||to optimize the security of credit card<br>transactions.<br>Request a PCI AOC SAQ Report|
|**CSA STAR (Level 2)**|The Cloud Security Alliance STAR (Security,<br>Trust, Assurance, and Risk) demonstrates<br>adherence to the highest standards of cloud<br>security by evaluating against industry best<br>practices, enhancing trust between providers<br>and customers.<br>View listing in CSA Star Registry|
|**IRAP**|IRAP enables Australian Government<br>customers to validate that appropriate<br>controls are in place and determine the<br>appropriate responsibility model for<br>addressing the requirements of the Australian<br>Government Information Security Manual<br>(ISM) produced by the Australian Cyber<br>Security Centre (ACSC).<br>Request an IRAP Report|
|**Germany C5**|Cloud Computing Compliance Controls<br>Catalog (C5) is a German Government-<br>backed attestation scheme introduced by the<br>Federal Office for Information Security (BSI)<br>to help organizations demonstrate operational<br>security against common cyber-attacks when<br>using cloud services.<br>Request a C5 Report|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**56** 


![](images/fetchpdf-1780573130754.pdf-0057-00.png)


## Cloud NGFW for Azure Privacy and Data Protection 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal (CSP) account<br>Azure Marketplace subscription|



At Palo Alto Networks, we are dedicated to supporting a defense-in-depth security model to help protect the customer’s data at all stages of its lifecycle, in transit, in memory, and at rest, as well as through key management. For more information, please visit the Privacy section in the Trust Center. 


![](images/fetchpdf-1780573130754.pdf-0057-04.png)


- _Palo Alto Networks Privacy Datasheets describe how Personal Data may be captured, processed and stored by and within our Products and Services to help you assess the impact of adopting our Products and Services on your privacy posture. You can access White Papers outlining Palo Alto Networks data taxonomy, which ensures transparency in how we process and use data._ 

The Trust 360 Program details the corporate-wide security, compliance, and privacy controls to protect our customers’ most sensitive data. 


![](images/fetchpdf-1780573130754.pdf-0057-07.png)


- _The Trust 360 Program represents the focal point for customers when evaluating our security controls. The Trust 360 white paper encompasses and represents all of the security, compliance, and privacy controls that are in place to protect our customers’ most sensitive data and covers topics._ 

Palo Alto Networks captures, processes, stores, and protects personal data in Cloud NGFW for Azure in accordance with the terms in the Cloud NGFW for Azure Privacy Datasheet. 

**57** 

Cloud NGFW for Azure Privacy and Data Protection 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**58** 


![](images/fetchpdf-1780573130754.pdf-0059-00.png)


## Cloud NGFW for Azure Security Services 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW uses your rulestack definitions to protect your Azure Virtual Network (VNet) traffic by a two-step process. First, it enforces your rules to allow or deny your traffic. Second, it performs content inspection on the allowed traffic (URLs, threats, files) based on what you specify on the Security Profiles. Additionally, it helps you define how Cloud NGFW should scan the allowed traffic and block threats such as malware, malware, spyware, and DDoS attacks. 

**59** 

Cloud NGFW for Azure Security Services 

## IPS and Spyware Threat Protection 

- **IPS Vulnerability** —(enabled by default and preconfigured based on best practices) an intrusion prevention system (IPS) vulnerability profile stops attempts to exploit system flaws or gain unauthorized access to systems. While antispyware profiles help identify infected hosts as traffic leaves the network, IPS Vulnerability profiles protect against threats entering the network. For example, Vulnerability Protection profiles help protect against buffer overflows, illegal code execution, and other attempts to exploit system vulnerabilities. The default Vulnerability Protection profile protects clients and servers from all known critical, high, and medium-severity threats. 

## **Best practice configuration** 

The following Vulnerability best practice configuration is enabled by default on Cloud NGFW for Azure. 

|**Signature Severity**|**Action**|
|---|---|
|Critical|Reset both|
|High|Reset both|
|Medium|Reset both|
|Informational|Default|
|Low|Default|



- **Antispyware** —(enabled by default and preconfigured based on best practices) an antispyware profile blocks spyware on compromised hosts from trying to phone-home or beacon out to external command and control (C2) servers, allowing you to detect malicious traffic leaving the network from infected clients. 

## **Best practice configuration.** 

The following antispyware best practice configuration is enabled by default on Cloud NGFW for Azure. 

|**Signature Severity**|**Action**|
|---|---|
|Critical|Reset both|
|High|Reset both|
|Medium|Reset both|
|Informational|Default|
|Low|Default|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**60** 

Cloud NGFW for Azure Security Services 

## **IPS Vulnerability and antispyware signatures** 

The following table lists all possible signatures for the Vulnerability and spyware categories. These signatures are continuously updated on your NGFWs. 

|**Threat Category**|**Description**|
|---|---|
|**Vulnerability signatures**||
|Brute-force|A brute-force signature detects multiple occurrences of a condition in<br>a particular time frame. While the activity in isolation might be benign,<br>the brute-force signature indicates that the frequency and rate at<br>which the activity occurred is suspect. For example, a single FTP login<br>failure does not indicate malicious activity. However, many failed FTP<br>logins in a short period likely indicate an attacker attempting password<br>combinations to access an FTP server.|
|code execution|Detects a code execution vulnerability that an attacker can leverage to<br>run code on a system with the privileges of the logged-in user.|
|code-obfuscation|Detects code that has been transformed to conceal certain data<br>while retaining its function. Obfuscated code is difficult or impossible<br>to read, so it's not apparent what commands the code is executing<br>or with which programs it's designed to interact. Most commonly,<br>malicious actors obfuscate code to conceal malware. More rarely,<br>legitimate developers might obfuscate code to protect privacy,<br>intellectual property, or to improve user experience. For example,<br>certain types of obfuscation (like minification) reduce file size, which<br>decreases website load times and bandwidth usage.|
|DoS|Detects a denial-of-service attack, where an attacker attempts to<br>render a targeted system unavailable, temporarily disrupting the<br>system and dependent applications and services. To perform a DoS<br>attack, an attacker might flood a targeted system with traffic or send<br>information that causes it to fail. DoS attacks deprive legitimate users<br>(like employees, members, and account holders) of the service or<br>resource to which they expect access.|
|exploit-kit|Detects an exploit kit landing page. Exploit kit landing pages<br>often contain several exploits that target one or many Common<br>Vulnerabilities and Exposures (CVEs), for multiple browsers and<br>plugins. Because the targeted CVEs change quickly, exploit-kit<br>signatures trigger based on the exploit kit landing page, and not the<br>CVEs.<br>When a user visits a website with an exploit kit, the exploit kit scans<br>for the targeted CVEs and attempts to silently deliver a malicious<br>payload to the victim’s computer.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**61** 

Cloud NGFW for Azure Security Services 

|**Threat Category**|**Description**|
|---|---|
|info-leak|Detects a software vulnerability that an attacker could exploit to steal<br>sensitive or proprietary information. Often, an info-leak might exist<br>because comprehensive checks don’t exist to guard the data, and<br>attackers can exploit info-leaks by sending crafted requests.|
|insecure-credentials|Detects the use of weak, compromised, and manufacturer default<br>passwords for software, network appliances, and IoT devices.|
|Overflow|Detects an overflow vulnerability, where a lack of proper checks on<br>requests could be exploited by an attacker. A successful attack could<br>lead to remote code execution with the privileges of the application,<br>server, or operating system.|
|phishing|Detects when a user attempts to connect to a phishing kit landing<br>page (likely after receiving an email with a link to the malicious site).<br>A phishing website tricks users into submitting credentials that an<br>attacker can steal to gain access to the network.|
|protocol-anomaly|Detects protocol anomalies, where a protocol behavior deviates from<br>standard and compliant usage. For example, a malformed packet, a<br>poorly written application, or an application running on a nonstandard<br>port would all be considered protocol anomalies, and could be used as<br>evasion tools.|
|sql-injection|Detects a common hacking technique where an attacker inserts<br>SQL queries into an application’s requests to read from or modify a<br>database. This type of technique is often used on websites that don’t<br>comprehensively sanitize user input.|
|**Spyware signatures**||
|Spyware|Detect outbound C2 communication. These signatures are either<br>autogenerated or are manually created by Palo Alto Networks<br>researchers.<br>_Spyware and autogen signatures both detect outbound C2_<br>_communication; however, autogen signatures are payload-_<br>_based and can uniquely detect C2 communications with C2_<br>_hosts that are unknown or change rapidly._|
|adware|Detects programs that display potentially unwanted advertisements.<br>Some adware modifies browsers to highlight and hyperlink the most<br>frequently searched keywords on web pages-these links redirect<br>users to advertising websites. Adware can also retrieve updates from<br>a command and control (C2) server and install those updates in a<br>browser or onto a client system.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**62** 

Cloud NGFW for Azure Security Services 

|**Threat Category**|**Description**|
|---|---|
|autogen|These payload-based signatures detect command and control (C2)<br>traffic and are autogenerated. Importantly, autogen signatures can<br>detect C2 traffic even when the C2 host is unknown or changes<br>rapidly.|
|Backdoor|Detects a program that allows an attacker to gain unauthorized remote<br>access to a system.|
|Botnet|Indicates botnet activity. A botnet is a network of malware-infected<br>computers (“bots”) that an attacker controls. The attacker can centrally<br>command every computer in a botnet to simultaneously carry out a<br>coordinated action (like launching a DoS attack, for example).|
|browser-hijack|Detects a plugin or software that’s modifying browser settings. A<br>browser hijacker might take over auto search or track users’ web<br>activity and send this information to a C2 server.|
|cryptominer|(Sometimes known as cryptojacking or miners) Detects the download<br>attempt or network traffic generated from malicious programs<br>designed to use computing resources to mine cryptocurrencies<br>without the user's knowledge. Cryptominer binaries are frequently<br>delivered by a shell script downloader that attempts to determine<br>system architecture and kill other miner processes on the system.<br>Some miners execute within other processes, such as a web browser<br>rendering a malicious webpage.|
|data-theft|Detects a system sending information to a known C2 server.|
|DNS|Detects DNS requests to connect to malicious domains.|
|downloader|(Also known as droppers, stagers, or loaders) Detects programs that<br>use an internet connection to connect to a remote server to download<br>and execute malware on the compromised system. The most common<br>use case is to deploy a downloader as the culmination of_stage one_of<br>a cyberattack, where the downloader’s fetched payload execution is<br>the_second stage_. Shell scripts (Bash, PowerShell, etc.), Trojans, and<br>malicious lure documents (also known as mallocs) such as PDFs and<br>Word files are common downloader types.|
|fraud|(Including formjacking, phishing, and scams) Detects access to<br>compromised websites that have been injected with malicious<br>JavaScript code to collect sensitive user information. (For example,<br>Name, address, email, credit card number, CVV, expiration date)<br>from payment forms that are captured on the checkout pages of e-<br>commerce websites.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**63** 

Cloud NGFW for Azure Security Services 

|**Threat Category**|**Description**|
|---|---|
|hack tool|Detects traffic generated by software tools used by malicious actors<br>to conduct reconnaissance, attack or gain access to vulnerable<br>systems, exfiltrate data, or create a command and control channel<br>to surreptitiously control a computer system without authorization.<br>These programs are associated with malware and cyberattacks.<br>Hacking tools might be deployed in a benign manner when used in<br>Red and Blue Team operations, penetration tests, and R&D. The use or<br>possession of these tools may be illegal in some countries, regardless<br>of intent.|
|networm|Detects a program that self-replicates and spreads from system to<br>system. Net-worms might use shared resources or leverage security<br>failures to access target systems.|
|phishing-kit|Detects when a user attempts to connect to a phishing kit landing<br>page (likely after receiving an email with a link to the malicious site).<br>A phishing website tricks users into submitting credentials that an<br>attacker can steal to gain access to the network.|
|post-exploitation|Detects activity that indicates the post-exploitation phase of an attack,<br>where an attacker attempts to assess the value of a compromised<br>system. This might include evaluating the sensitivity of the data stored<br>on the system, and the system’s usefulness in further compromising<br>the network.|
|Webshell|Detects web shells and web shell traffic, including implant detection<br>and command and control interaction. Web shells must first be<br>implanted by a malicious actor onto the compromised host, most often<br>targeting a web server or framework. Subsequent communication with<br>the web shell file frequently enables a malicious actor to establish a<br>foothold in the system, conduct service and network enumeration,<br>data exfiltration, and remote code execution in the context of the<br>web server user. The most common web shell types are PHP, .NET,<br>and Perl markup scripts. Attackers can also use web shell-infected<br>web servers (the web servers can be both internet-facing or internal<br>systems) to target other internal systems.|
|Keylogger|Detects programs that allow attackers to secretly track user activity,<br>by logging keystrokes and capturing screenshots.<br>Keyloggers use various C2 methods to periodically send logs and<br>reports to a predefined e-mail address or a C2 server. Through<br>keylogger surveillance, an attacker could retrieve credentials that<br>would enable network access.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**64** 

Cloud NGFW for Azure Security Services 

## Malware and File-based Threat Protection 

- **Antivirus** —(enabled by default and preconfigured based on best practices) antivirus profiles protect against malware, worms, and Trojans as well as spyware downloads. Using a streambased malware prevention engine, which inspects traffic the moment the first packet is received, the Palo Alto Networks antivirus solution can provide protection for clients without significantly impacting the performance of the firewall. This profile scans for a wide variety of malware in executables, PDF files, HTML and JavaScript malware, including support for scanning inside compressed files and data encoding schemes. 

## **Best practice configuration** 

The following Antivirus best practice configuration is enabled by default on Cloud NGFW for Azure. 

|**Protocol**|**Action**|
|---|---|
|FTP|Reset both|
|HTTP|Reset both|
|HTTP2|Reset both|
|IMAP|Reset both|
|POP3|Alert|
|SMB|Reset both|
|SMTP|Reset both|



- **File blocking** —(enabled by default and preconfigured based on best practices) file blocking profiles allows you to identify specific file types that you want to block or monitor. The firewall uses file blocking profiles to block specific file types over specified applications and in the specified session flow direction (inbound/outbound/both). You can set the profile to alert or block on upload and/or download and you can specify which applications will be subject to the file blocking profile. 

   - **Alert** —when the specified file type is detected, a log is generated in the data filtering log. 

   - **Block** —when the specified file type is detected, the file is blocked. A log is also generated in the data filtering log. 

Best practice configuration. 

The following file blocking best practice configuration is enabled by default on Cloud NGFW for Azure. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**65** 

Cloud NGFW for Azure Security Services 

|**File Types**|**Application**|**Direction**|**Action**|
|---|---|---|---|
|All risky file types:<br>• 7z<br>• bat<br>• cab<br>• chm<br>• class<br>• cpl<br>• dll<br>• exe<br>• flash<br>• hip<br>• hta<br>• msi<br>• Multi-Level-<br>Encoding<br>• ocx<br>• PE<br>• pif<br>• rar<br>• scr<br>• tar<br>• torrent<br>• vbe<br>• wsf<br>• encrypted-rar<br>• encrypted-zip|Any|Both (upload and<br>download)|Block|
|All remaining file<br>types|Any|Both (upload and<br>download)|Alert|



## **Antivirus signatures** 

The following table lists all possible signatures for the Antivirus category. These signatures are continuously updated on your NGFWs. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**66** 

Cloud NGFW for Azure Security Services 

|**Threat Category**|**Description**|
|---|---|
|**Antivirus signatures**||
|apk|Malicious Android Application (APK) files.|
|Mac OS X|Malicious Mac OS X files, including:<br>• Apple disk image (DMG) files.<br>• Mach object files (Mach-O) are executables, libraries, and object<br>code.<br>• Apple software installer packages (PKGs)|
|flash|Adobe Flash applets and Flash content embedded in webpages.|
|jar|Java applets (JAR/class file types).|
|ms-office|Microsoft Office files, including documents (DOC, DOCX, RTF),<br>workbooks (XLS, XLSX), and PowerPoint presentations (PPT, PPTX).<br>This also includes Office Open XML (OOXML) 2007+ documents.|
|pdf|Portable Document Format (PDF) files.|
|pe|Portable Executable (PE) files can automatically execute on a Microsoft<br>Windows system and should only be allowed when authorized. These<br>files types include:<br>• Object code.<br>• Fonts (FONs).<br>• System files (SYS).<br>• Driver files (DRV).<br>• Windows control panel items (CPLs).<br>• DLLs (dynamic-link libraries).<br>• OCXs (libraries for OLE custom controls, or ActiveX controls).<br>• Windows screensaver files (SCRs).<br>• Extensible Firmware Interface (EFI) files, which run between an OS<br>and firmware to facilitate device updates and boot operations.<br>• Program information files (PIFs).|
|linux|Executable and Linkable Format (ELF) files.|
|archive|Roshal Archive (RAR) and 7-Zip (7z) archive files.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**67** 

Cloud NGFW for Azure Security Services 

## Web-based Threat Protection 

**URL categories and Filtering** —(enabled by default and preconfigured based on best practices) URL Filtering profiles enable you to monitor and control how users access the web over HTTP and HTTPS. The firewall comes with a default profile that is configured to block websites such as known malware sites, phishing sites, and adult content sites. URL Filtering profile isn’t enabled by default. When you enable URL Filtering profile in your rulestack, Cloud NGFW enforces the best practices URL Filtering profile on your traffic. You have an option to modify the default access option on each of the categories, based on your needs. 

## **Best practices configuration** 

By default, URL Filtering is enabled and uses a Security policy based on best practices. 

|**URL Categories**|**Site Access**|**Credential Submissions**|
|---|---|---|
|Malicious and exploitative<br>categories:<br>• adult<br>• Command-and-control<br>• ©infringement<br>• Dynamic DNS<br>• extremism<br>• Malware<br>• parked<br>• phishing<br>• proxy-avoidance-and-<br>anonymizers<br>• unknown|Block|Block|
|All other URL categories|Alert|Alert|



## **Predefined URL categories for Cloud NGFW for Azure** 

The following table describes the predefined URL categories available on Cloud NGFW on Azure. You can use these categories in security rules to block or allows access to websites that fall into them. 

|**URL Category**|**Description**|
|---|---|
|**Risk Categories**||
|High Risk|Sites that were previously confirmed to be malicious but<br>have displayed benign activity for at least 30 days. Sites<br>hosted on bulletproof ISPs or using an IP from an ASN that|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**68** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
||has known malicious content. Sites sharing a domain with<br>a known malicious site. All sites in the “Unknown” category<br>will be high risk.|
|Medium Risk|Sites confirmed to be malicious but have displayed benign<br>activity for at least 60 days. All sites in the “Online Storage<br>and Backup” category will be a medium risk by default.|
|Low Risk|Any site that isn’t High Risk or medium risk. This includes<br>sites that were previously confirmed as malicious but have<br>displayed benign activity for at least 90 days.|
|**Threat Categories**||
|Command-and-control|Command-and-control URLs and domains used by<br>malware and/or compromised systems to surreptitiously<br>communicate with an attacker's remote server to receive<br>malicious commands or exfiltrate data.|
|Malware|Sites known to host malware or used for command and<br>control (C2) traffic. May also exhibit Exploit Kits.|
|**Threat Adjacent Categories**||
|Dynamic DNS|Hosts and domain names for systems with dynamically<br>assigned IP addresses and which are oftentimes used<br>to deliver malware payloads or C2 traffic. Also, dynamic<br>DNS domains don’t go through the same vetting process<br>as domains that are registered by a reputable domain<br>registration company, and are therefore less trustworthy.|
|Grayware|Web content that does not pose a direct security<br>threat but that displays other obtrusive behavior and<br>tempt the end user to grant remote access or perform<br>other unauthorized actions. Grayware includes illegal<br>activities, criminal activities, rogue ware, adware, and other<br>unwanted or unsolicited applications, such as embedded<br>crypto miners, clickjacking, or hijackers that change the<br>elements of the browser. Typosquatting domains that<br>don’t exhibit maliciousness and are not owned by the<br>targeted domain are categorized as grayware.|
|Hacking|Sites relating to the illegal or questionable access to<br>or the use of communications equipment or software.<br>Development and distribution of programs, how-to-advice<br>and/or tips that may result in the compromise of networks|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**69** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
||and systems. Also includes sites that facilitate the bypass<br>of licensing and digital rights systems.|
|Phishing|Web content that covertly attempts to fool the user to<br>harvest information, including login credentials, credit<br>card information–voluntarily or involuntarily, account<br>numbers, PINs, and any information considered to be<br>personally identifiable information (PII) from victims<br>via social engineering techniques. Technical scam and<br>scareware are also included as phishing.|
|**Suspicious**||
|Insufficient Content|Websites and services that present test pages, no content,<br>provide API access not intended for end-user display<br>or require authentication without displaying any other<br>content suggesting a different categorization. Should<br>not include websites providing remote access, such as<br>web-based VPN solutions, web-based email services or<br>identified credential phishing pages.|
|Newly Registered Domain|Newly registered domains are often generated purposely<br>or by domain generation algorithms and used for malicious<br>activity.|
|Parked|Domains registered by individuals are oftentimes<br>later found to be used for credential phishing. These<br>domains are similar to legitimate domains, for example,<br>pal0alto0netw0rks.com, with the intent of phishing for<br>credentials or personal identifying information. Or, they<br>are domains that individual purchases rights to in hopes<br>that it may be valuable someday, such as panw.net.|
|Proxy Avoidance and<br>Anonymizers|URLs and services are often used to bypass content<br>filtering products.|
|Unknown|Sites that have not yet been identified by Palo Alto<br>Networks. If availability is critical to your business and you<br>must allow the traffic, alert on unknown sites, apply the<br>best practice Security Profiles to the traffic, and investigate<br>the alerts.|
|**Legal/Policy**||
|Abortion|Sites that pertain to information or groups in favor of or<br>against abortion, detail regarding abortion procedures,<br>help or support forums for or against abortion, or sites that|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**70** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
||provide information regarding the consequences or effects<br>of pursuing (or not) an abortion.|
|Abused Drugs|Sites that promote the abuse of both legal and illegal drugs,<br>use and sale of drug-related paraphernalia, manufacturing<br>and/or selling of drugs.|
|Adult|Sexually explicit material, media (including language), art,<br>and/or products, online groups or forums that are sexually<br>explicit in nature. Sites that promote adult services such<br>as video or telephone conferencing, escort services, strip<br>clubs, etc. Anything containing adult content (even if its<br>games or comics) are categorized as adult.|
|Alcohol and Tobacco|Sites that pertain to the sale, manufacturing, or use of<br>alcohol and/or tobacco products and related paraphernalia.<br>This includes sites related to electronic cigarettes.|
|Auctions|Sites that promote the sale of goods between individuals.|
|Business and Economy|Marketing, management, economics, and sites relating<br>to entrepreneurship or running a business. This includes<br>advertising and marketing firms. Should not include<br>corporate websites as they are categorized with their<br>technology. Also shipping sites, such as fedex.com and<br>ups.com.|
|Computer and internet Info|General information regarding computers and the<br>internet. Should include sites about computer science,<br>engineering, hardware, software, security, programming,<br>etc. Programming has some overlap with reference, but the<br>main category should remain computer and internet info.|
|Content delivery networks|Sites whose primary focus is delivering content to 3rd<br>parties such as advertisements, media, files, and includes<br>image servers.|
|©Infringement|Domains with illegal content, such as content that allows<br>illegal download of software or other intellectual property,<br>which poses a potential liability risk. This category<br>enables adherence to child protection laws required in<br>the education industry as well as laws in countries that<br>require internet providers to prevent users from sharing<br>copyrighted material through their service.|
|Cryptocurrency|Websites that promote cryptocurrencies, cryptomining<br>websites (but not embedded crypto miners),|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**71** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
||cryptocurrency exchanges and vendors, and websites that<br>manage cryptocurrency wallets and ledgers. This category<br>does not include traditional financial services websites<br>that reference cryptocurrencies, websites that explain and<br>describe how cryptocurrencies and blockchains work, or<br>websites that contain embedded cryptocurrency miners<br>(grayware).|
|Dating|Websites offering online dating services, advice, and other<br>personal ads.|
|Educational Institutions|Official websites for schools, colleges, universities, school<br>districts, online classes, and other academic institutions.<br>These refer to larger, established educational institutions<br>such as elementary schools, high schools, universities, etc.<br>Tutoring academies can go here as well.|
|Entertainment and Arts|Sites for movies, television, radio, videos, programming<br>guides or tools, comics, performing arts, museums, art<br>galleries, or libraries. Includes sites for entertainment,<br>celebrity, and industry news.|
|Extremism|Websites promoting terrorism, racism, fascism, or other<br>extremist views discriminating against people or groups<br>of different ethnic backgrounds, religions, or other beliefs.<br>This category was introduced to enable adherence to child<br>protection laws required in the education industry. In some<br>regions, laws and regulations may prohibit allowing access<br>to extremist sites, and allowing access may pose a liability<br>risk.|
|Financial Services|Websites pertaining to personal financial information<br>or advice, such as online banking, loans, mortgages,<br>debt management, credit card companies, and insurance<br>companies. Does not include sites relating to stock<br>markets, brokerages, or trading services. Includes sites<br>for foreign currency exchange. Includes sites for foreign<br>currency exchange.|
|Gambling|Lottery or gambling websites that facilitate the exchange<br>of real and/or virtual money. Related websites that provide<br>information, tutorials or advice regarding gambling,<br>including betting odds and pools. Corporate websites<br>for hotels and casinos that don’t enable gambling are<br>categorized under Travel.|
|Games|Sites that provide online play or download of video and/<br>or computer games, game reviews, tips, or cheats, as well|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**72** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
||as instructional sites for nonelectronic games, sale or trade<br>of board games, or related publications or media. Includes<br>sites that support or host online sweepstakes and/or<br>giveaways.|
|Government|Official websites for local, state, and national governments,<br>as well as related agencies, services, or laws.|
|Health and Medicine|Sites containing information regarding general health<br>information, issues, and traditional and nontraditional tips,<br>remedies, and treatments. Also includes sites for various<br>medical specialties, practices, and facilities (such as gyms<br>and fitness clubs) as well as professionals. Sites relating to<br>medical insurance and cosmetic surgery are also included.|
|Home and Garden|Information, products, and services regarding home repair<br>and maintenance, architecture, design, construction, decor,<br>and gardening.|
|Hunting and Fishing|Hunting and fishing tips, instructions, sale of related<br>equipment and paraphernalia.|
|Internet Communications and<br>Telephony|Sites that support or provide services for video chatting,<br>instant messaging, or telephony capabilities.|
|Internet Portals|Sites that serve as a starting point for users, usually by<br>aggregating a broad set of content and topics.|
|Job Search|Sites that provide job listings and employer reviews,<br>interview advice and tips, or related services for both<br>employers and prospective candidates.|
|Legal|Information, analysis or advice regarding the law, legal<br>services, legal firms, or other legal related issues|
|Military|Information or commentary regarding military branches,<br>recruitment, current or past operations, or any related<br>paraphernalia.|
|Motor Vehicles|Information relating to reviews, sales and trading,<br>modifications, parts, and other related discussions for<br>automobiles, motorcycles, boats, trucks, and RVs.|
|Music|Music sales, distribution, or information. Includes websites<br>for music artists, groups, labels, events, lyrics, and other<br>information regarding the music business. Does not include<br>streaming music.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**73** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
|News|Online publications, newswire services, and other<br>websites that aggregate current events, weather, or other<br>contemporary issues. Includes newspapers, radio stations,<br>magazines, and podcasts.|
|Not-Resolved|Indicates that the website wasn’t found in the local URL<br>filtering database and the firewall was unable to connect<br>to the cloud database to check the category. When a URL<br>category lookup is performed, the firewall first checks the<br>dataplane cache for the URL, if no match is found, it will<br>then check the management plane cache, and if no match<br>is found there, it queries the URL database in the cloud.<br>When deciding on what action to take for traffic that is<br>categorized as not-resolved, be aware that setting the<br>action to block may be very disruptive to users.|
|Nudity|Sites that contain nude or seminude depictions of the<br>human body, regardless of context or intent, such as<br>artwork. Includes nudist or naturist sites containing images<br>of participants.|
|Online Storage and Backup|Websites that provide online storage of files for free and<br>as a service.|
|Peer-to-peer|Sites that provide access to or clients for peer-to-peer<br>sharing of torrents, download programs, media files, or<br>other software applications. This is primarily for those sites<br>that provide BitTorrent download capabilities. Does not<br>include shareware or freeware sites.|
|Personal Sites and Blogs|Personal websites and blogs by individuals or groups.<br>Should try to first categorize based on content. For<br>example, if someone has a blog just about cars, then<br>the site should be categorized under "motor vehicles".<br>However, if the site is a pure blog, then it should remain<br>under "personal sites and blogs".|
|Philosophy and Political<br>Advocacy|Sites containing information, viewpoints, or campaigns<br>regarding philosophical or political views.|
|Private IP addresses|This category includes IP addresses defined in RFC 1918,<br>'Address Allocation for Private Intranets? It also includes<br>domains not registered with the public DNS system (*.local<br>and *.onion).|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**74** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
|Questionable|Websites containing tasteless humor, offensive content<br>targeting specific demographics of individuals or groups of<br>people.|
|Real Estate|Information on property rentals, sales, and related tips or<br>information. Includes sites for real estate agents, firms,<br>rental services, listings (and aggregates), and property<br>improvement.|
|Recreation and Hobbies|Information, forums, associations, groups, and publications<br>on recreations and hobbies.|
|Reference and Research|Personal, professional, or academic reference portals,<br>materials, or services. Includes online dictionaries, maps,<br>almanacs, census information, libraries, genealogy, and<br>scientific information.|
|Religion|Information regarding various religions, related activities,<br>or events. Includes websites for religious organizations,<br>officials, and places of worship. Includes sites for fortune<br>telling.|
|Search Engines|Sites that provide a search interface using keywords,<br>phrases, or other parameters that may return information,<br>websites, images, or files as results.|
|Sex Education|Information on reproduction, sexual development, safe<br>sex practices, sexually transmitted diseases, birth control,<br>tips for better sex, as well as any related products or<br>related paraphernalia. Includes websites for related groups,<br>forums, or organizations.|
|Shareware and Freeware|Sites that provide access to software, screensavers, icons,<br>wallpapers, utilities, ringtones, themes, or widgets for free<br>and/or donations. Also includes open-source projects.|
|Shopping|Sites that facilitate the purchase of goods and services.<br>Includes online merchants, websites for department stores,<br>retail stores, catalogs, as well as sites that aggregate<br>and monitor prices. Sites listed here should be online<br>merchants that sell a variety of items (or whose main<br>purpose is online sales). A webpage for a cosmetics<br>company that also happens to allow online purchasing<br>should be categorized with cosmetics and not shopping.|
|Social Networking|User communities and sites where users interact with each<br>other, post messages, pictures, or otherwise communicate|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**75** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
||with groups of people. Does not include blogs or personal<br>sites.|
|Society|Topics relating to the general population, issues that<br>impact a large variety of people, such as fashion, beauty,<br>philanthropic groups, societies, or children. Also includes<br>restaurant websites.Includes websites designed for<br>children as well as restaurants.|
|Sports|Information about sporting events, athletes, coaches,<br>officials, teams or organizations, sports scores, schedules<br>and related news, and any related paraphernalia. Includes<br>websites regarding fantasy sports and other virtual sports<br>leagues.|
|Stock Advice and Tools|Information regarding the stock market, trading of stocks<br>or options, portfolio management, investment strategies,<br>quotes, or related news.|
|Streaming Media|Sites that stream audio or video content for free and/<br>or purchase. Includes online radio stations and other<br>streaming music services.|
|Swimsuits and Intimate Apparel|Sites that include information or images concerning<br>swimsuits, intimate apparel, or other suggestive clothing|
|Training and Tools|Sites that provide online education and training and related<br>materials. Can include driving or traffic schools, workplace<br>training, etc.|
|Translation|Sites that provide translation services, including both user<br>input and URL translations. These sites can also allow<br>users to circumvent filtering as the target page's content is<br>presented within the context of the translator's URL.|
|Travel|Information regarding travel tips, deals, pricing information,<br>destination information, tourism, and related services.<br>Includes websites for hotels, local attractions, casinos,<br>airlines, cruise lines, travel agencies, vehicle rentals, and<br>sites that provide booking tools such as price monitors.<br>Includes websites for local points of interest or tourist<br>attractions such as the Eiffel Tower, the Grand Canyon,<br>etc.|
|Weapons|Sales, reviews, descriptions of or instructions regarding<br>weapons and their use.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**76** 

Cloud NGFW for Azure Security Services 

|**URL Category**|**Description**|
|---|---|
|Web Advertisements|Advertisements, media, content, and banners.|
|Web Hosting|Free or paid for hosting services for webpages, including<br>information regarding web development, publication,<br>promotion, and other methods to increase traffic.|
|Web-based Email|Any website that provides access to an email inbox and the<br>ability to send and receive emails.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**77** 

Cloud NGFW for Azure Security Services 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**78** 


![](images/fetchpdf-1780573130754.pdf-0079-00.png)


## Cloud NGFW for Azure Resiliency and Scalability 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW for Azure is a regional service similar to other Azure zone-redundant services. This service is delivered on the Azure platform to protect your Azure Virtual Network (VNet), Virtual WAN (VWAN) Hub, Branch, VPN, and ExpressRoute traffic. 

The Cloud NGFW resource provides next-generation firewall capabilities without requiring the management of underlying infrastructure. This resource has built-in resiliency, scalability, and lifecycle management. A Cloud NGFW resource is deployed either into a Hub VNet or a VWAN Hub and uses the underlying Azure VNet infrastructure to inspect the traffic. Under the hood, each Cloud NGFW resource includes a dedicated pair of Azure load balancers and a dedicated Virtual Machine Scale Set (VMSS) of Palo Alto Networks Security Processing VM instances. The **Security Processing VM instances** are the core components of the Palo Alto Networks Cloud NGFW for Azure, hosting the Palo Alto Networks software that performs the **Next-Generation Firewall (NGFW)** functions. 


![](images/fetchpdf-1780573130754.pdf-0079-05.png)


**79** 

Cloud NGFW for Azure Resiliency and Scalability 

## **Built-in Scalability** 

The Cloud NGFW for Azure resource maintains its uptime based on its built-in elastic scalability model, which dynamically scales with your VNet and Virtual WAN traffic to meet unpredictable throughput demands. 

## **Aggressive Scale-Out** 

The Cloud NGFW resource scales out by adding more Security Processing VM instances when the average of any single scaling dimension reaches a 40% threshold. This aggressive approach ensures the service can quickly handle sudden increases in traffic volume and maintain its uptime and performance. 

## **Conservative Scale-In** 

The Cloud NGFW resource scales in by removing Security Processing VM instances only when the average of each scaling dimension reaches a 20% threshold. This conservative approach prevents the service from prematurely removing instances during minor lulls in traffic, which could cause performance issues if traffic suddenly increases again. It ensures a stable and consistent level of performance. 

The Cloud NGFW resource leverages its built-in high availability and scales with your traffic based on multiple dimensions and thresholds as stated below: 

|**Dimension**|**Default Scale-Out Threshold**<br>**(for 5 min)**|**Default Scale-In Threshold (for**<br>**8 hours)**|
|---|---|---|
|CPU Utilization|40%|20%|
|Session Utilization|40%|20%|
|SSL Proxy Session Utilization|40%|20%|
|Session Throughput (Kbps)|40% of minimum capacity|20% of the minimum capacity|
|Used SNAT Ports|40% of available ports per<br>Security Processing Node|20% of the available ports per<br>Security Processing Node|



## **Built-in Resiliency** 

As discussed in the disaster recovery guide, Palo Alto Networks has built-in resilience to recover from Security Processing VM failures and AWS Availability zones failures. Cloud NGFW maintains its uptime based on its built-in resiliency model. 

## **Resiliency against VM Failures** 

Cloud NGFW resource ensures high availability by maintaining a minimum of **three Security Processing VM instances** running simultaneously in a dedicated Virtual Machine Scale Set (VMSS). 

- **Failure Detection:** The Azure Load Balancer(s) included in the Cloud NGFW resource use finegrained health checks to detect faults in a Security Processing VM instance. 

- **Automatic Recovery:** Upon detection of a failure, Cloud NGFW immediately replaces the faulty instance with a new one. Since the recovery heuristic is built into the product and does not require any action from your end, Palo Alto Networks will not notify you about this event. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**80** 

Cloud NGFW for Azure Resiliency and Scalability 

## **Resiliency across availability zones** 

The Cloud NGFW resource offers **built-in resiliency across Azure availability zones** in an Azure region by utilizing a distinct Virtual Machine Scale Set (VMSS) that distributes security processing VMs across availability zones within a given region. 

- **Limited Blast Radius:** If an entire Availability Zone fails, only the VM-Series instances in that specific zone are affected. 

- **Operation Continuity:** The Cloud NGFW resource remains intact and continues to protect traffic using the Security Processing VMs located in the other operational availability zones. 

- **Automatic Recovery:** When the failed Availability Zone comes back online, the Cloud NGFW resource automatically detects the change and brings the instances in that zone back up. Since the recovery heuristic is built into the product and does not require any action from your end, Palo Alto Networks will not notify you about this event. 

## **Resiliency across Azure Regions** 

As you deploy your applications across multiple Azure regions to service requests in an activeactive manner, you also deploy the Palo Alto Networks Cloud NGFW resources, with built-in availability, resiliency, and life-cycle management, in each region to secure the application traffic. 

- **Regional Failure:** In the rare event of a complete Azure regional failure, both the application workloads and the Cloud NGFW resource in that region will be down. There is no traffic to secure in the region during this outage. 

- **Multi-Region Continuity:** Application workloads and the corresponding Cloud NGFW services in other, unaffected regions will continue to function and secure traffic. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**81** 

Cloud NGFW for Azure Resiliency and Scalability 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**82** 


![](images/fetchpdf-1780573130754.pdf-0083-00.png)


## CNGFW for Azure Troubleshooting 

This page covers troubleshooting procedures for maintaining a stable integration between your Cloud NGFW for Azure and Panorama. If your resource displays an **Unhealthy** or **Degraded** status in the Azure portal with the reason **Firewall cannot register with Panorama** , you should investigate underlying network pathing and configuration requirements. 

For more information, see, Panorama and Cloud NGFW Connectivity. 

In cases where the network path is functional but registration still fails, the issue may be related to credential validity rather than connectivity. When a Panorama Auth Key has expired, preventing the resource from moving to a healthy state. This subsection guides you through the necessary steps to resolve the issue using the Panorama Azure Plugin (version 5.2.3 or higher), including using CLI commands to force-create a new auth key and generating a fresh registration string for the Azure portal. 

For more information, see VM Auth Key Expiry. 

**83** 

CNGFW for Azure Troubleshooting 

## Panorama and Cloud NGFW Connectivity 

## **Where Can I Use This?** 

## **What Do I Need?** 

• Cloud NGFW for Azure 


![](images/fetchpdf-1780573130754.pdf-0084-05.png)



![](images/fetchpdf-1780573130754.pdf-0084-06.png)



![](images/fetchpdf-1780573130754.pdf-0084-07.png)


Cloud NGFW subscription Palo Alto Networks Customer Support Portals (CSP) account Azure Marketplace subscription 

## **Overview** 

When you connect your Cloud NGFW for Azure resource to Panorama[®] , the Security Processing VM instances powering the Cloud NGFW for Azure resource directly connect to Panorama as devices. This integration relies heavily on your VNet routing and Network Security Groups (NSGs) to support network connectivity. 

## **How It Works** 

- The Security Processing VM instances powering the Cloud NGFW for Azure resource initiate an SSL connection to Panorama. 

- Once established, this SSL tunnel is used for dynamic content downloads, policy pushes, and log collection. 

- The Security Processing VM instances determine whether the Panorama IP is private or public (based on RFC-1918) and route the connection from the CIDRs associated with the corresponding subnet (private or public) you delegated to the Cloud NGFW for Azure resource. 

- From Panorama's perspective, these are inbound connections. Panorama simply needs to allow inbound traffic from the CIDRs associated with the subnets you delegated to your Cloud NGFW for Azure resources. 

## **Requirements for Healthy Connectivity** 

Before troubleshooting, verify that your environment meets these minimum requirements: 

- **Panorama Software:** Version 11.2.7-h4 (recommended) or 11.x or later (required for configuration pruning and Zone-Mapping). 

- **Azure Plugin:** Version 5.2.3 or later (required to enable Cloud Device Groups and registration string generation). 

- **VNet Configuration:** The VNet must have at least two subnets (public and private). A CIDR of /10 is recommended to support auto-scaling. 

- **Port Access:** Port 3978 must be open to allow inbound SSL management traffic to Panorama. 

## **Troubleshooting Workflow** 

Establishing healthy connectivity is critical. Follow these steps to resolve issues where the Cloud NGFW for Azure resource fails to register or shows an unhealthy status. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**84** 

CNGFW for Azure Troubleshooting 

## **1. Identify the Symptom** 

Check the Health Status of the Cloud NGFW for Azure resource in the Azure portal. Look for these common failure indicators: 

- Health Status shows **Unhealthy** or **Degraded** with the reason Cloud NGFW for Azure resource cannot register to Panorama. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**85** 

CNGFW for Azure Troubleshooting 


![](images/fetchpdf-1780573130754.pdf-0086-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**86** 

CNGFW for Azure Troubleshooting 

- No traffic from the Cloud NGFW IP appears on the Panorama console. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**87** 

CNGFW for Azure Troubleshooting 


![](images/fetchpdf-1780573130754.pdf-0088-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**88** 

CNGFW for Azure Troubleshooting 

- The Cloud NGFW for Azure resource is missing under **Manage Devices** in Panorama. 

## **2. Address Not Applicable Status** 

If the status reads **Not Applicable** , the Security Processing VM instances are likely still initiating. Wait for the deployment to finish. If it remains stuck indefinitely, perform a fresh deployment, as the Security Processing VM instances may have failed to provision fully. 

## **3. Resolve Unhealthy Status (Connectivity Checks)** 

If the status is **Unhealthy** , verify the underlying network path: 

- **Port Verification:** Confirm port 3978 is open. 

- **Allowlisting:** At the Panorama end, ensure you allowlist the CIDRs associated with the subnets (private or public) you delegate to the Cloud NGFW for Azure resource. 

- **SNAT Configuration:** In the Azure portal under **Networking & NAT** > **Source NAT** , ensure **Use the above public IP addresses** is selected. 

- **VPN/Gateway Routing:** For on-premises Panorama access via VPN, verify the VPN gateway is active and the hub VNet has a route pointing to the Panorama private IP. 

## **4. Resolve Asymmetric Routing Issues** 

Asymmetric routing occurs when return traffic from Panorama fails to reach the specific Security Processing VM instance that initiated the connection. To fix this: 

- **Verify Routing Table:** Look for missing User Defined Routes (UDR) in the Azure default routing table. 

- **Apply UDR Host Routes:** Create UDR host routes pointing to the Cloud NGFW for Azure resource for the Cloud NGFW DNAT IP addresses. 

- **Direct Return Path:** Define a UDR rule for the CIDRs associated with the private subnet you delegated to the Cloud NGFW for Azure resource. Set the next hop as **Virtual Network** to ensure return packets bypass the Internal Load Balancer (ILB) and go directly back to the source device. 

## **5. New Validation** 

Once routing and configuration issues are fixed: 

- The Cloud NGFW for Azure resource Health Status changes to **Healthy** in the Azure portal. 

- The device appears as **connected** under Panorama's Manage Devices. 

## **Architectural Topologies for Panorama Connectivity** 

Depending on your architecture, your Cloud NGFW for Azure resource connects to Panorama using different paths. For Panorama high availability (HA) pairs, ensure both IP addresses are either private or public — they cannot be mixed. 

## **Private and Public Connectivity** 

- **Private Connectivity:** The Cloud NGFW for Azure resource uses the CIDRs associated with the private subnet you delegated to it to connect to Panorama's private IP via VNet Peering, VPN, or VWAN. Test reachability by deploying a test VM in your VNet private subnet and pinging the Panorama private IP. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**89** 

CNGFW for Azure Troubleshooting 

- **Public Connectivity:** If the private subnet lacks access to Panorama, the Cloud NGFW for Azure resource uses its public data interface (using the Cloud NGFW public IP) to connect to Panorama's public IP. Test reachability by deploying a test VM in the public subnet. 

## **VNet Connectivity** 

- **Same VNet:** The Security Processing VM instances can directly reach the Panorama private IP since they share the same VNet. 

- **Peered VNets:** The Security Processing VM instances can directly reach the Panorama private IP across the VNet peering connection. 

## **On-Premises Panorama via VPN** 

- **Same VNet as VPN Gateway:** The Cloud NGFW for Azure resource uses the CIDRs associated with the private subnet you delegated to it to access the Panorama private IP via the VPN connection. Configure the Virtual network gateway or Route Server in the Azure portal's VPN peerings page. 

- **Peered Hub VNet:** The connection flows from the CIDRs associated with the private subnet you delegated to the Cloud NGFW for Azure resource, through VNet Peering to the Hub VNet, then via VPN to the on-premises network. 

## **On-Premises Panorama via ExpressRoute** 

The Cloud NGFW for Azure resource connects to the Panorama private IP via the ExpressRoute gateway. To avoid asymmetric routing, define a UDR rule in the ER Gateway VNet's Route Table. Set the destination as the CIDRs associated with the private subnet you delegated to the Cloud NGFW for Azure resource, and set the next hop as **Virtual Network** . 

## **Internet Access to Panorama Public IP** 

The Cloud NGFW for Azure resource connects to the internet using the CIDRs associated with the public subnet you delegated to it. Ensure your network's NSG has an inbound rule allowing traffic from the CIDRs associated with the public subnet you delegated to the Cloud NGFW for Azure resource to Panorama's required ports. 

## **Azure Virtual WAN (VWAN)** 

With VWAN, your Cloud NGFW for Azure resource deployed in a VWAN hub can connect to Panorama deployed in any connected VNet, branch office, or data center. Ensure NSG rules on the Panorama side allow inbound traffic from the CIDRs associated with the private subnet you delegated to the Cloud NGFW for Azure resource. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**90** 

CNGFW for Azure Troubleshooting 

## VM Auth Key Expiry 

## **Where Can I Use This?** 

- **Where Can I Use This? What Do I Need?** • Cloud NGFW on Azure (Managed by Panorama 11.2 or later Panorama) Panorama Azure Plugin version 5.2.3 or later Access to the Panorama CLI 

When the VM-auth key used to register your Cloud NGFW for Azure resource with Panorama[®] expires, the resource can no longer authenticate with Panorama, causing it to display **Unhealthy** or **Degraded** status in the Azure portal. Force-creating a new auth key and providing a fresh registration string restores connectivity and returns the resource to a healthy state. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**91** 

CNGFW for Azure Troubleshooting 


![](images/fetchpdf-1780573130754.pdf-0092-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**92** 

CNGFW for Azure Troubleshooting 

- **STEP 1 |** Verify that your Panorama Azure Plugin version is 5.2.3 or later. 

You can check the installed version in Panorama under **Panorama** > **Plugins** . 

- **STEP 2 |** Log in to the Panorama CLI and run the following command to force-create a new VM auth key for the Cloud Device Group: 

## **`request plugins azure cngfw-force-create-vm-auth-key name`** _**`clouddevice-group-name`**_ 

Replace _cloud-device-group-name_ with the name of your Cloud Device Group. 

- **STEP 3 |** Generate a new registration string and update your CNGFW for Azure resource in the Azure portal. 

Your Cloud NGFW on Azure resource returns to a **Healthy** state in the Azure portal. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**93** 

CNGFW for Azure Troubleshooting 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Reference 

**94** 


