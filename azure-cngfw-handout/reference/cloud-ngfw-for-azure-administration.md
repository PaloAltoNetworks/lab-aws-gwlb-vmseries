---
source: pdf_url
url: https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/pdf/cloud-ngfw-azure/cloud-ngfw-for-azure-administration.pdf
title: Cloud NGFW for Azure Administration
fetched: 2026-06-04T11:38:46.799Z
pages: 372
---
## Cloud NGFW for Azure Administration 

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

Cloud NGFW for Azure Administration 

**2** 

## Table of Contents 

**Manage Cloud NGFW for Azure Tenant......................................................7** Manage User Roles..................................................................................................................... 8 Delete a User................................................................................................................................9 Edit User Information...............................................................................................................10 Azure Built-in and Custom Roles..........................................................................................11 Assign Roles.................................................................................................................... 11 Integrate Single Sign-On......................................................................................................... 13 Enable Third-Party Identity Provider (IdP).............................................................. 13 Verify SSO Login............................................................................................................17 Integrate SSO with the Customer Support Portal for a Nondomain User Using Azure Marketplace........................................................................................................ 17 Integrate SSO with Customer Support Portal for a Domain User Using Azure Marketplace.....................................................................................................................17 Register for Support and Create a Support Case..............................................................19 Create a Support Case.............................................................................................................27 **Deploy Cloud NGFW for Azure Resources...............................................35** Deploy the Cloud NGFW in a VNet.................................................................................... 36 Verify the Deployment of the Cloud NGFW in the VNet................................... 53 Edit an Existing Firewall to Add Additional Private Addresses for Non-RFC 1918 Support..................................................................................................................56 Edit an Existing Firewall to Enable Private Source NAT...................................... 57 Sample Configuration for Post VNet Deployment........................................................... 61 Create or update a rulestack...................................................................................... 61 Add a FQDN list............................................................................................................ 65 Add a Rule.......................................................................................................................67 Configure a source and destination NAT rule........................................................73 Configure Logging..........................................................................................................81 Update the Network Security Group....................................................................... 85 Configure VNet peering...............................................................................................87 Add a Route Table to route traffic through the Cloud NGFW...........................88 Deploy the Cloud NGFW in a vWAN..................................................................................91 Verify the Deployment of the Cloud NGFW in a vWAN..................................110 Sample Configuration for Post vWAN Deployment...................................................... 113 Post deployment..........................................................................................................113 Configure Logging.......................................................................................................121 Add application vNETs as Virtual Networks Connections to the Virtual WAN...............................................................................................................................122 **Protect Traffic with Cloud NGFW for Azure......................................... 131** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**3** 

Table of Contents 

Cloud NGFW for Azure Security Features and CDSS Capabilities.............................133 Advanced Threat Protection.................................................................................... 135 Wildfire Protection......................................................................................................137 DNS Security................................................................................................................ 139 Cloud NGFW Native Policy Management........................................................................140 Security Rule Objects.................................................................................................141 Create a Rulestack on Cloud NGFW for Azure...................................................142 Create a Prefix List on Cloud NGFW for Azure.................................................. 143 Create a FQDN List on Cloud NGFW for Azure.................................................144 Configure Advanced URL Filtering......................................................................... 144 Configure DNS Security............................................................................................ 147 Add a Certificate to Cloud NGFW for Azure.......................................................150 Create Security Rules on Cloud NGFW for Azure..............................................151 Set Up Inbound Decryption on Cloud NGFW for Azure...................................153 Set Up Outbound Decryption on Cloud NGFW for Azure............................... 156 Panorama Policy Management............................................................................................158 Panorama Integration Prerequisites....................................................................... 162 Link to Panorama Policy Management.................................................................. 164 Update your Panorama Registration...................................................................... 175 Add or Delete a Cloud Device Group....................................................................181 Apply Policies............................................................................................................... 184 Enable Data Redistribution on Cloud NGFW for Azure.................................... 189 Use XFF IP Address Values in Policy.....................................................................231 Configure Advanced Threat Prevention................................................................232 Configure WildFire Protection.................................................................................233 Configure Advanced DNS Security in Panorama................................................ 241 Configure Enterprise DLP for Cloud NGFW on Azure...................................... 245 Strata Cloud Manager Policy Management......................................................................253 Create a Cloud NGFW Resource for SCM Policy Management...................... 254 View the Firewall in Strata Cloud Manager..........................................................257 Create or Move a Folder for Your Cloud NGFW Resource Using Strata Cloud Manager.........................................................................................................................261 Use Strata Cloud Manager for Cloud NGFW Policy Management..................264 Use the Strata Logging Service................................................................................267 Migrate an Azure Firewall Policy to Cloud NGFW for Azure...........................269 Tag-based Policies in Strata Cloud Manager........................................................291 **Monitor Cloud NGFW for Azure Resources...........................................305** View CNGFW for Azure Health Monitor Status............................................................ 307 View Cloud NGFW for Azure Metrics Natively in Azure..............................................308 View Traffic and Threat Logs Natively in Azure.............................................................310 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**4** 

Table of Contents 

Log Types...................................................................................................................... 310 Enable Log Settings.................................................................................................... 311 Disable Log Settings...................................................................................................312 View the Logs in Log Analytics Workspace..........................................................313 View Activity Logs Natively in Azure................................................................................ 324 Configure Logging.......................................................................................................324 View Audit Logs in a Firewall Resource................................................................326 View Audit Logs on Resource Groups...................................................................326 View Cloud NGFW Metrics in Azure Monitor................................................................ 328 Prerequisites................................................................................................................. 329 Enable Cloud NGFW Metrics...................................................................................337 View Cloud NGFW Metrics......................................................................................340 Important Considerations..........................................................................................345 View Cloud NGFW Logs and Activity in Panorama.......................................................346 View Cloud NGFW Activity in the ACC................................................................346 Prerequisites for Configuring Cloud NGFW Log Collection Using Panorama.......................................................................................................................347 Enable Strata Logging Service (SLS) for existing Panorama-managed firewalls....... 355 View Traffic and Threat Logs in Strata Cloud Manager................................................356 View Traffic and Threat Logs in Strata Logging Service............................................... 362 Forward Logs to Strata Logging Service................................................................366 Forward Logs without Strata Logging Service..................................................... 369 **Cloud NGFW for Azure as Code...............................................................371** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**5** 

Table of Contents 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**6** 


![](images/fetchpdf-1780573081890.pdf-0007-00.png)


## Manage Cloud NGFW for Azure Tenant 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



At any time, you can modify a user’s role or roles to expand or reduce their access and permissions. You can also delete a user. And individual users can view their roles and change their name or password as necessary. Information provided here is helpful for custom role creation, like creating a firewall read-only user. By default, Cloud NGFW requires owner or contributor roles on the subscription to subscribe to the resource provider and to use the Cloud NGFW resource. 


![](images/fetchpdf-1780573081890.pdf-0007-04.png)


_See_ Assign Azure roles using the Azure portal _for information about managing Cloud NGFW roles._ 

At any time, you can modify a user’s role or roles to expand or reduce their access and permissions. You can also delete a user. And individual users can view their roles and change their name or password as necessary. 

**7** 

Manage Cloud NGFW for Azure Tenant 

## Manage User Roles 

Use the following procedure to manage user roles: 

**1.** Select **Settings** > **User and Roles** . 

**2.** Select the name of the user. 

**3.** Modify the **First Name** and **Last Name** if necessary. 

**4.** Modify the user’s **Roles & Scope** . To add a role: 

   **1.** Click **Add Role** . 

   **2.** Select the **Role** and **Scope** from the respective drop-downs. 

      - To delete a role: 

   **3.** Click the delete icon ( ) located to the right of the rule. 

**5.** Click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**8** 

Manage Cloud NGFW for Azure Tenant 

## Delete a User 

If you need to completely remove a user’s access and permissions, you can delete that user. 

**1.** Select **Settings** > **User and Roles** . 

**2.** Select the check box to the left of the user’s name. 

**3.** Select **Actions** > **Delete** . 

**4.** Click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**9** 

Manage Cloud NGFW for Azure Tenant 

## Edit User Information 

A non-tenant administrator can update their name or change their password if needed. However, they cannot modify their assigned roles. 

**1.** Select **Settings** > **User and Roles** . 

**2.** Select the name of the user. 

**3.** Modify the **First Name** and **Last Name** if necessary. 

**4.** To change a password: 

   **1.** Click **Change Password** . 

   **2.** Enter the **Current Password** . 

   **3.** Enter and re-enter the **New Password** . 

**5.** Click **Change** . 


![](images/fetchpdf-1780573081890.pdf-0010-11.png)


_Changing the password logs you out of the Cloud NGFW tenant. Log back in using the new password._ 

**6.** Click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**10** 

Manage Cloud NGFW for Azure Tenant 

## Azure Built-in and Custom Roles 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Azure provides built-in roles to help manage access to resources, including Cloud NGFW by Palo Alto Networks. These roles define permissions for users, groups, and applications in Azure RoleBased Access Control (RBAC). Below are some of the key built-in roles relevant to Cloud NGFW on Azure: 

- **Owner** : An owner has full access to manage all resources, including Cloud NGFW. Assign this role to administrators who need complete control over the creation of a NGFW, configuration and policies. 

- **Contributor** : A contributor can create, manage and modify Cloud NGFW and other resources but cannot assign roles. Assign this role to administrators who need complete control over the creation of a NGFW, configuration and policies. 

- **LocalNGFirewallAdministrator** : This role can create, update and delete Cloud NGFW resources. Assign this role to administrators who need complete control over Cloud NGFW resources. 

- **LocalRuleStacksAdministrator** : This role can create, manage Cloud NGFW policies. Assign this role to administrators who need complete control the NGFW policy configuration; this role cannot create or update firewall resources. 

Choosing the proper Azure built-in role for Cloud NGFW depends on your organization's governance model, administrative structure, and access control requirements. If your needs exceed the capabilities of built-in roles, custom roles can provide a more granular permission model. You can create a custom role with specific permissions, such as: 

- Creating and managing firewalls. 

- Managing Cloud NGFW rules and policies. 

- Monitoring logs and analytics. 

- Controlling network traffic. 

## Assign Roles 

You assign roles using Azure Role-Based Access Control (Azure RBAC). You can use the Azure Portal, Azure CLI, or PowerShell to assign roles: 

**1.** Log in to the Azure Portal. 

**2.** Navigate to **Access Control (IAM) > Role Assignments** . 

**3.** Choose the role, assign users/groups and specify the resource scope (for example, the subscription, resource group, or a specific firewall instance). 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**11** 

Manage Cloud NGFW for Azure Tenant 


![](images/fetchpdf-1780573081890.pdf-0012-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**12** 

Manage Cloud NGFW for Azure Tenant 

## Integrate Single Sign-On 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



You can integrate your organization’s SSO login flow with your Palo Alto Networks Support Portal account for your Azure Cloud NGFW subscription. 

## Enable Third-Party Identity Provider (IdP) 

Enabling a third-party identity provider (IdP) in the Customer Support Portal allows you to log into the Palo Alto Networks Customer Support Portal using your own corporate login credentials. Because you set up IdP at the domain level, members within the domain can log into multiple support accounts using corporate SSO login credentials. However, _domain administrator accounts_ must continue to use Palo Alto Networks login credentials. 

To enable third party IdP for your domain: 

   - You must have the domain administrator role in the Customer Support Portal to configure third-party IdP access for your account. 

   - You must have administrator access on the identity provider to update the SSO configuration details provided by Palo Alto Networks. 

   - You need one nondomain administrator account for verification. 

- **STEP 1 |** Log into the Azure Portal and search for **Active Directory** . 

- **STEP 2 |** In Active Directory, select **Enterprise Application** and select **New Application** . 

- **STEP 3 |** Enter the name for your SSO application (for example, panorama-sso) and click **Create** . 

- **STEP 4 |** In the **Create your own application window** , select **Integrate any other application you don't find in the gallery (Non-gallery)** . 

- **STEP 5 |** Click **Create** . 

- **STEP 6 |** In the **Manage** section, click **Single sign-on** . 

- **STEP 7 |** Select the **SAML** single sign-on method. The SAML-based sign-on page contains information you need to link your new SSO enterprise application to your Palo Alto Networks support account. 

- **STEP 8 |** In the SAML-based sign-on page, scroll down to locate URLs in the **Set up [your SSO application name]** section. Copy the **Azure AD Identifier** . 

- **STEP 9 |** Log in to the Customer Support Portal. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**13** 

Manage Cloud NGFW for Azure Tenant 

**STEP 10 |** In the Customer Support Portal, select **Account Management > Account Details** . 

**STEP 11 |** In the **SSO** section, click **View Single Sign-On settings for your domain** . 

**STEP 12 |** In **Accounts Configuration** , paste the copied **Azure AD identifier** from step 8 into the **Identifier Provider ID** field. 


![](images/fetchpdf-1780573081890.pdf-0014-04.png)


**STEP 13 |** Return to the **SAML-based Sign-on screen** in the Azure portal. Scroll down to locate URLs in the **Set up [your SSO application name]** section. Copy the **Login URL** . 

**STEP 14 |** Return to the **Accounts Configuration** page in the Customer Support Portal. Paste the copied **Login URL** (from the previous step) into the **Identity Provider SSO Service URL** field. 


![](images/fetchpdf-1780573081890.pdf-0014-07.png)


## **STEP 15 |** Use the same **Identity Provider SSO Service URL** address for the **Identity Provider Destination URL** field. 

**STEP 16 |** Return to the **SAML-based Sign-on** screen in the Azure portal. Scroll down to locate the **SAML Certificates** section. 

**STEP 17 |** In the SAML Certificates section, download the **Certificate (Base64)** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**14** 

Manage Cloud NGFW for Azure Tenant 

**STEP 18 |** Return to the **Account Management > Account Details** page in the Customer Support Portal. Paste the downloaded certificate (from the previous step) into the **Identity Provider Certificate** field. 


![](images/fetchpdf-1780573081890.pdf-0015-02.png)


**STEP 19 |** The **Accounts Configuration** page changes to display **Palo Alto Service Provider Information** . Copy the **Entity ID** URL. 


![](images/fetchpdf-1780573081890.pdf-0015-04.png)


**STEP 20 |** Return to the **SAML-based Sign-on screen** in the Azure portal. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**15** 

Manage Cloud NGFW for Azure Tenant 

## **STEP 21 |** In the **Basic SAML Configuration** screen, click **Edit** . 

**STEP 22 |** In the **Identifier (Entity ID)** field, click **Add Identifier** . **STEP 23 |** Paste the Palo Alto Networks **Entity ID** (from step 21) into the **Identifier** field. 

**STEP 24 |** Return to the **Account Management > Account Details** page in the Customer Support Portal. Copy the **ACS URL** . 


![](images/fetchpdf-1780573081890.pdf-0016-04.png)


**STEP 25 |** Return to the **SAML-based Sign-on screen** in the Azure portal. 

**STEP 26 |** In the **Basic SAML Configuration** screen, click **Edit** . 

**STEP 27 |** Enter the ACS URL (copied from step 24) into the **Reply URL (Assertion Consumer Service URL)** . 

**STEP 28 |** Return to the Support Portal **Accounts Configuration** page. Use the toggle button to **Enable Identity Provider** . 

**STEP 29 |** Click **Save** . 

**STEP 30 |** Return to the Azure Portal. In the **Manage** section of your SSO application, click **Users, and groups** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**16** 

Manage Cloud NGFW for Azure Tenant 

**STEP 31 |** Use the **Add user/group** option to enable use of SSO login for each specified user. 

## Verify SSO Login 

After enabling the identity provider, all users (except domain administrators) are forced to login using SSO. To verify that the SSO login is set up properly: 

- Provide an email address on the login page. Don’t use domain administrator login credentials. 

- Verify that you’re redirected to the IdP login page for authentication. 

- After authentication, the Palo Alto Networks Customer Support Portal page appears. 

## Integrate SSO with the Customer Support Portal for a Nondomain User Using Azure Marketplace 

To integrate a user with a Customer Support Portal account using Azure Marketplace: 

- **STEP 1 |** Log in to your Azure account. 

- **STEP 2 |** In **Azure Services** , select **Cloud NGFWs by Palo Alto Networks** . 

- **STEP 3 |** Select the firewall that you want to integrate with your Customer Support Portal account. 

- **STEP 4 |** In the **Support + troubleshooting** section, click **New Support Request** . The Palo Alto Networks Support screen appears, displaying the **Tenant ID** and the **Product serial number** . 

- **STEP 5 |** Click **Register User account and create a case at Customer Support Portal** . 

- **STEP 6 |** On the **Create New Account / Use Existing Account** page, enter your email address and complete the authentication steps, then click **Next** . 

- **STEP 7 |** In the **Device Registration** section, select the **Cloud Marketplace** subscription from the dropdown menu. For example, _Azure Cloud NGFW_ . 

- **STEP 8 |** Enter the **Tenant ID** and **Serial Number** for your Azure Marketplace subscription. You can copy this information from the Palo Alto Networks Support page from step 4. Click **Next** . 

- **STEP 9 |** Enter the **Authentication code** that was sent to your email address. Click **Next** . 

- **STEP 10 |** After authenticating using SSO, the Customer Support Portal login page appears. Enter your email address and click **Next** . 

## Integrate SSO with Customer Support Portal for a Domain User Using Azure Marketplace 

To integrate a domain user with a Support Portal account using Azure Marketplace, you’ll need your Palo Alto Networks login credentials: 

**STEP 1 |** Log in to your Azure account using _domain user credentials_ . 

**STEP 2 |** In **Azure Services** , select **Cloud NGFWs by Palo Alto Networks** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**17** 

Manage Cloud NGFW for Azure Tenant 

- **STEP 3 |** Select the firewall that you want to integrate with your Customer Support Portal account. 

- **STEP 4 |** In the **Support + troubleshooting** section, click **New Support Request** . The Palo Alto Networks Support screen appears, displaying the **Tenant ID** and the **Product serial number** 

- **STEP 5 |** Click **Register User account and create a case at Customer Support Portal** . 

- **STEP 6 |** On the **Create New Account / Use Existing Account** page, enter your email address and complete the authentication steps, then click **Next** . 

- **STEP 7 |** In the **Device Registration** section, select the **Cloud Marketplace** subscription from the dropdown menu. For example, _Azure Cloud NGFW_ . 

- **STEP 8 |** Enter the **Tenant ID** and **Serial Number** for your Azure Marketplace subscription. You can copy this information from the Palo Alto Networks Support page from step 4. Click **Next** . 

- **STEP 9 |** Enter the **Authentication code** that was sent to your email address. Click **Next** . 

- **STEP 10 |** After authenticating using SSO, the Customer Support Portal login page appears. Enter your email address and click **Next** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**18** 

Manage Cloud NGFW for Azure Tenant 

## Register for Support and Create a Support Case 

## **Where Can I Use This? What Do I Need?** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



Before registering your Cloud NGFW tenant with a Palo Alto Support Account, consider the following: 

- If you are deploying the firewall for the first time and intend to use Strata Cloud Manager for policy management, you must deploy a local rulestack. 


![](images/fetchpdf-1780573081890.pdf-0019-06.png)


_Deploying a local rulestack is free._ 

- After successfully deploying the rulestack, use the information on this page to register it with your Customer Support Portal account. 


![](images/fetchpdf-1780573081890.pdf-0019-09.png)


- _Once the rulestack is registered with your Customer Support Portal account you can deploy the firewall and it will show existing Strata Cloud Manager tenants associated with the Customer Support Account._ 

Use the following steps to register your Cloud NGFW resource to the Palo Alto Networks Customer Support Portal using the Azure portal: 

**STEP 1 |** Log in to the Azure portal. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**19** 

Manage Cloud NGFW for Azure Tenant 

- **STEP 2 |** In the **Azure portal** , navigate to **Support + troubleshooting** and select **Register User account and create a case at Customer Support Portal** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**20** 

Manage Cloud NGFW for Azure Tenant 


![](images/fetchpdf-1780573081890.pdf-0021-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**21** 

Manage Cloud NGFW for Azure Tenant 

- **STEP 3 |** In the **New Support Request** page, click **Create Case at Customer Support Portal** . This redirects you to the Palo Alto Networks Customer Support Portal. 


![](images/fetchpdf-1780573081890.pdf-0022-02.png)


## _Consider the following:_ 

   - _You may have used a different email address to subscribe to Cloud NGFW and a different one to access the Palo Alto Networks Customer Support Portal account._ 

   - _Alternatively, you can_ create a dedicated Palo Alto Networks support account _for Cloud NGFW._ 

   - _In both of these cases you skip the registration option during the initial login process to the Cloud NGFW tenant but_ register your tenant in the Customer Support Portal _._ 

- **STEP 4 |** When you select the option to **Register User account and create a case at Customer Support Portal** in the Azure portal you're directed to the Customer Support Portal where you will enter your login credentials. You can use your existing Customer Support Portal login 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**22** 

Manage Cloud NGFW for Azure Tenant 

credentials, or create a new Customer Support Portal login account. Enter your email address and resolve the **Captcha** , then click **Next** . 


![](images/fetchpdf-1780573081890.pdf-0023-02.png)


- **STEP 5 |** After entering your email address, the Customer Support Portal determines if you have an existing account, or if you need a new one. If you have Palo Alto Networks products associated with the email address you have entered, information for the **Cloud Marketplace** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**23** 

Manage Cloud NGFW for Azure Tenant 

(Tenant ID and Serial Number) appear. Click **Next** to log in to the Customer Support Portal and continue with the registration process. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**24** 

Manage Cloud NGFW for Azure Tenant 


![](images/fetchpdf-1780573081890.pdf-0025-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**25** 

Manage Cloud NGFW for Azure Tenant 

- **STEP 6 |** Follow the prompts to complete the rest of the registration process. 


![](images/fetchpdf-1780573081890.pdf-0026-02.png)


   - _For existing accounts, registration information is prepopulated. For new Customer Support Portal accounts you will be prompted to set up the account (for example, which Palo Alto products you use)._ 

- **STEP 7 |** Once registration is complete a success message appears. You can use the Customer Support Portal to verify this by selecting **Products > Assets** . In the **Assets** page, select the **Cloud NGFW** tab: 


![](images/fetchpdf-1780573081890.pdf-0026-05.png)


- **STEP 8 |** You can use the Azure portal to verify that the Cloud NGFW tenant is now registered. In the **Azure portal** navigate to **Support and Troubleshooting** : 


![](images/fetchpdf-1780573081890.pdf-0026-07.png)


The **Tenant ID** and **Product serial number** now reflect the link between the Palo Alto Networks Customer Support Portal and Azure portal. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**26** 

Manage Cloud NGFW for Azure Tenant 

## Create a Support Case 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



The Cloud NGFW for Azure supports services that make it simple and easy to set up and onboard. Comprehensive digital services, technical support, and Education Services underscore our commitment to the ongoing success of your Palo Alto Networks deployment. You can access assistance through the LIVE community and the Customer Support Portal. 

Cloud NGFW for Azure is designed to get you up and running fast. You skip the lengthy deployment process by setting up must-have rule stacks and automated Security Profiles while leveraging how you work with Azure: full integration with Azure onboarding, monitoring, logging, and more. Easily invite additional users to help manage your Cloud NGFW deployment, or, manage roles for existing users. 

To create a support case using the Azure portal: you must first register a user account on the Customer Support Portal: 

**STEP 1 |** Log in to the Azure portal. 

**STEP 2 |** In the **Support + Troubleshooting** section, click **New Support Request** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**27** 

Manage Cloud NGFW for Azure Tenant 

## **1.** 


![](images/fetchpdf-1780573081890.pdf-0028-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**28** 

Manage Cloud NGFW for Azure Tenant 

- **STEP 3 |** On the **New Support Request** page, click **Register User account and create a case at Customer Support Portal** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**29** 

Manage Cloud NGFW for Azure Tenant 

## **2.** 


![](images/fetchpdf-1780573081890.pdf-0030-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**30** 

Manage Cloud NGFW for Azure Tenant 

- **STEP 4 |** Follow the prompts to create a Palo Alto Networks Customer Support Portal (CSP) account. If you already have a CSP account, use your existing login credentials. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**31** 

Manage Cloud NGFW for Azure Tenant 


![](images/fetchpdf-1780573081890.pdf-0032-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**32** 

Manage Cloud NGFW for Azure Tenant 


![](images/fetchpdf-1780573081890.pdf-0033-01.png)


## _Consider the following:_ 

- _You may have used a different email address to subscribe to Cloud NGFW and a different one to access the Palo Alto Networks Customer Support Portal account._ 

- _Alternatively, you can_ create a dedicated Palo Alto Networks support account _for Cloud NGFW._ 

- _In both of these cases you skip the registration option during the initial login process to the Cloud NGFW tenant but_ register your tenant in the Customer Support Portal _._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**33** 

Manage Cloud NGFW for Azure Tenant 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**34** 


![](images/fetchpdf-1780573081890.pdf-0035-00.png)


## Deploy Cloud NGFW for Azure Resources 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW for Azure offers multiple options for deploying NGFW resources and managing Security policy rules. 

For more information, see the following: 

- Deploy the Cloud NGFW in a VNet 

- Sample Configuration for Post VNet Deployment 

- Deploy the Cloud NGFW in a vWAN 

- Sample Configuration for Post vWAN Deployment 

**35** 

Deploy Cloud NGFW for Azure Resources 

## Deploy the Cloud NGFW in a VNet 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



The Cloud NGFW manifests as two private IP addresses (public and private) in your VNet. Using user-defined routes (with the Cloud NGFW’s private IP address as the next hop), you redirect traffic to the Cloud NGFW for packet inspection and threat prevention. 

The Azure Cloud NGFW communicates with the Cloud NGFW to add rulestacks. The Cloud NGFW continuously meters the usage of the Cloud NGFW resource, sending usage records for each Azure subscription to the Azure metering service. This service is responsible for billing. 


![](images/fetchpdf-1780573081890.pdf-0036-05.png)


- _After deploying the Cloud NGFW in a VNet, see the_ sample configuration _page for more information._ 

## **Prerequisites** 

To deploy Cloud NGFW in a VNet, you will need an Azure subscription. This subscription should have an owner or a contributor role. 


![](images/fetchpdf-1780573081890.pdf-0036-09.png)


- _When deploying the Cloud NGFW in a VNet using an existing VNet hub, the minimum size should be /25. You must have two subnets with the minimum size /26; these subnets must be delegated to the_ _**PaloAltoNetworks.Cloudngfw/firewalls** service._ 


![](images/fetchpdf-1780573081890.pdf-0036-11.png)


- _For deployments supporting 100 Gbps , you need a total of 80 free IP addresses; 40 IP addresses are used for public and 40 IP addresses are used for private._ 

The following image illustrates Private subnet NSG requirements: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**36** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0037-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**37** 

Deploy Cloud NGFW for Azure Resources 

**STEP 1 |** Log into the Azure portal and search for **Cloud NGFW** . This search displays the Cloud NGFW service, **Cloud NGFW by Palo Alto Networks** . 


![](images/fetchpdf-1780573081890.pdf-0038-02.png)


**STEP 2 |** Click **Cloud NGFWs** to start creating the Palo Alto Networks Cloud NGFW service for Azure. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**38** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 3 |** On the landing screen page for the Cloud NGFW resource, click **Create** to start creating the Cloud NGFW resource. 


![](images/fetchpdf-1780573081890.pdf-0039-02.png)


If your subscription was previously created, the landing page contains information about Cloud NGFW resources. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**39** 

Deploy Cloud NGFW for Azure Resources 

**STEP 4 |** After clicking **Create** , the **Create Palo Alto Networks Cloud NGFW** screen appears. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**40** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0041-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**41** 

Deploy Cloud NGFW for Azure Resources 

Use the information in the following table to provide **Basic information** , then click **Next:Networking** : 

|**Field**|**Description**|
|---|---|
|Subscription|Automatically selected based on the subscription used while logged in.|
|Resource Group|Use one of the existing resource groups or create a new one (using the<br>**Create New**option) in which the Cloud NGFW resource is created.|
|Firewall Name|Name of the Cloud NGFW firewall resource.<br>_For Panorama managed firewalls, don’t use all capital letters_<br>_for the firewall name._|
|Region|Region in which Cloud NGFW is provisioned.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**42** 

Deploy Cloud NGFW for Azure Resources 

**STEP 5 |** Provide information for the firewall deployment in the **Networking** screen: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**43** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0044-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**44** 

Deploy Cloud NGFW for Azure Resources 

The **Networking** screen includes fields in the following table: 

|**Field**|**Description**|
|---|---|
|Type|Automatically selected based on the subscription used while logged in.|
|Virtual Network|Choose a**Virtual network**. Create a new virtual network or select an<br>existing virtual network.|
|Private subnet|Choose a private subnet.|
|Public subnet|Choose a public subnet.|
|Public IP address<br>configuration|Specify**Public IP addresses**. Click**Create new**to establish a new<br>address, or click**Use existing**to specify an existing address.|
|Additional Prefixes<br>to Private Traffic<br>Range|If you want to support additional private IP address ranges besides those<br>specified in RFC 1918, use the option for**Additional Prefixes to Private**<br>**Traffic Range**. With this support you can use public IP address blocks in<br>your private network without routing traffic to the internet.<br>Click the**Additional Prefixes**check box. Enter addresses in CIDR format<br>(for example, 40.0.0.0/24). Use a comma-delimited list to include<br>multiple addresses.<br>_By default, RFC 1918 prefixes are automatically included in_<br>_the private traffic range. If your organization uses public IP_<br>_ranges, explicitly specify those IP prefixes. You can specify_<br>_these public IP prefixes individually, or as aggregates._<br>_See the section_Edit an Existing firewall to Add Additional<br>Private Addresses for Non-RFC 1918 Support_to add_<br>_additional prefixes after deploying the firewall._|
|Source NAT<br>Settings|Include the**Source NAT**option if network address translation is used on<br>traffic going out to the internet.|



## **STEP 6 |** Click **Next:Security Policies** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**45** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 7 |** On the **Security Policies** page, create a local rulestack or select an existing rulestack. A new rulestack contains no rules. You can define security rules after deploying the Cloud NGFW resource. 


![](images/fetchpdf-1780573081890.pdf-0046-02.png)


- _As an administrator, you can either manage a Security policy using a native Azure rulestack, or you can use Palo Alto Networks Panorama for policy management._ 


![](images/fetchpdf-1780573081890.pdf-0046-04.png)



![](images/fetchpdf-1780573081890.pdf-0046-05.png)


- _If you would like to use Palo Alto Networks advanced security services (such as Advanced Threat Prevention and Advanced URL Filtering) you must register your Azure Tenant at the_ Palo Alto Networks Customer Support Portal _after creating your firewall._ 

## **1.** 

- **STEP 8 |** Click **Next: DNS Proxy** to configure the Cloud NGFW resource as a DNS proxy. You can configure the Cloud NGFW to inspect all DNS traffic by acting as a proxy for VNet 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**46** 

Deploy Cloud NGFW for Azure Resources 

resources. When configured, the DNS Proxy forwards the DNS request to the default Azure DNS server, or a DNS server you specify. By default, the DNS Proxy is disabled. 


![](images/fetchpdf-1780573081890.pdf-0047-02.png)


- **STEP 9 |** Click **Next: Tags** to specify tags for your Azure requirements. Tags are predefined labels that can help you manage the vulnerabilities in your environment and view consolidated billing 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**47** 

Deploy Cloud NGFW for Azure Resources 

related to your Azure account. They are centrally defined and can be set to vulnerabilities and as policy exceptions. 


![](images/fetchpdf-1780573081890.pdf-0048-02.png)


Tags are used as: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**48** 

Deploy Cloud NGFW for Azure Resources 

- Vulnerability labels. They provide a convenient way to categorize the vulnerabilities in your environment. 

- Policy exceptions. They can be a part of your rules to have a specific effect on tagged vulnerabilities. 

- View consolidated billing for your Azure account. 

Tags are useful when you have large container deployments with multiple teams working in the same environment. For example, you might have different teams handling different types of vulnerabilities. Then you can set tags to define responsibilities over vulnerabilities. Other uses would be to set the status of fixing the vulnerability, or to mark vulnerabilities to ignore when they are a known problem that can’t be fixed in the near future. 


![](images/fetchpdf-1780573081890.pdf-0049-05.png)


_You can define as many tags as you like. For information about creating tags for your Azure account, see_ Use tags to organize your Azure resources and management hierarchy _._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**49** 

Deploy Cloud NGFW for Azure Resources 

**STEP 10 |** Click **Next:Terms** and accept the terms and the conditions for the deployment 


![](images/fetchpdf-1780573081890.pdf-0050-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**50** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 11 |** Click **Next:Review + create** to review your Azure subscription for the Cloud NGFW resource. The resource is validated first, then created. The screen shows **Validation Passed** . Click **Create** to deploy the Cloud NGFW service: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**51** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0052-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**52** 

Deploy Cloud NGFW for Azure Resources 

## Verify the Deployment of the Cloud NGFW in the VNet 

After creating the Cloud NGFW service, the deployment progress appears. 


![](images/fetchpdf-1780573081890.pdf-0053-03.png)



![](images/fetchpdf-1780573081890.pdf-0053-04.png)


_Deploying a Cloud NGFW resource takes approximately 30 minutes to deploy._ 

On a successful deployment, the following screen appears. Click **Go to resource group** to verify the resources created for this deployment: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**53** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0054-01.png)


Five resources are created. They include Cloud NGFW, Local rulestack, Public IP address, Virtual Network, and security group: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**54** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0055-01.png)


Once the Cloud NGFW resource is created, select it to verify that the provisioning state shows **Succeeded** . This screen also displays the public and private IP addresses associated with the Cloud NGFW service. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**55** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0056-01.png)


## Edit an Existing Firewall to Add Additional Private Addresses for Non-RFC 1918 Support 

To edit an existing firewall to add additional private addresses: 

- **STEP 1 |** Locate the Cloud NGFW in the Azure Portal. 

- **STEP 2 |** In the **Settings** section, select **Networking & NAT** . 

- **STEP 3 |** Click **Edit** . 

- **STEP 4 |** In the **Additional Prefixes to Private Traffic Range** section, select the check box for **Additional Prefixes** . 

- **STEP 5 |** Enter addresses in CIDR format (for example, 40.0.0.0/24). Use a comma-delimited list to include multiple addresses. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**56** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 6 |** Click **Save** . 


![](images/fetchpdf-1780573081890.pdf-0057-02.png)


## Edit an Existing Firewall to Enable Private Source NAT 

Use the **Private Source NAT** option if you want to perform source network address translation on requests from an instance in a nonrouteable subnet. This option allows you to send traffic to a 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**57** 

Deploy Cloud NGFW for Azure Resources 

routeable IP address assigned to the application load balancer (ALB). After enabling Private source NAT, include the destination IP address. 


![](images/fetchpdf-1780573081890.pdf-0058-02.png)


_Cloud NGFW east-west traffic relies on user-defined routes (UDR) to forward traffic to the firewall. This dependency is supported by typical east-west traffic when both ends of the network are part of the private network. However, this poses challenges for a new type of traffic; one side of the deployment is the private network, while the other side of the deployment supports a partner or PaaS service accessible over a private endpoint in the virtual network. In such environments, you may not have management access to the entire (other) network to configure UDR. Traffic is directed to the Cloud NGFW by UDR, but return traffic is sent to the client’s source IP without transiting the Cloud NGFW. As a result, an asymmetric route problem occurs, and the resulting TCP handshake can’t be completed by the firewall. Cloud NGFW uses_ _**Private Source NAT** to translate the source IP address to the firewall's instance's private interface IP, thus ensuring that return traffic is processed by the Cloud NGFW to the appropriate interface._ 

- **STEP 1 |** Locate the Cloud NGFW in the Azure Portal. 

- **STEP 2 |** In the **Settings** section, select **Networking & NAT** . 

**STEP 3 |** Click **Edit** . 

**STEP 4 |** In the **Private Source NAT** section, select the check box for **Enable Private Source NAT** . 

**STEP 5 |** Enter the destination address. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**58** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 6 |** Click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**59** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0060-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**60** 

Deploy Cloud NGFW for Azure Resources 

## Sample Configuration for Post VNet Deployment 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



After successfully deploying the Cloud NGFW in an Azure VNet, you can begin configuring the Cloud NGFW service. The information provided in this section illustrates common tasks to get the Cloud NGFW running in your Azure environment: 

- Create or update a rulestack 

- Add a FQDN list 

- Add a rule 

- Configure a source and destination NAT rule 

- Configure logging 

- Update the network security group 

- Configure VNet peering 

- Add a route table 

## Create or update a rulestack 

In this section you will update a local rulestack by adding a rule and enabling logging. 

To update an existing rulestack: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**61** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 1 |** In the Azure Resource Manager (ARM) console, click **Rulestacks** for the Cloud NGFW resource you want to configure. The rulestack associated with the Cloud NGFW service appears, along with the resource group. 


![](images/fetchpdf-1780573081890.pdf-0062-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**62** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 2 |** Modify the rulestack to add firewall rules. These rules allow some traffic while blocking specific traffic. By default, Cloud NGFW blocks all traffic. Search for the local rulestack using the global search option provided by the Azure portal. 


![](images/fetchpdf-1780573081890.pdf-0063-02.png)


- **STEP 3 |** Select the local rulestack service to navigate to the list of local rulestacks associated with your Cloud NGFW subscription. Search for a local rulestack, and verify that the state is **Succeeded** . 


![](images/fetchpdf-1780573081890.pdf-0063-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**63** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 4 |** Click the rulestack to add rules. In the **Add Rule** window, modify the rules. For example, add a rule that allows traffic; complete the mandatory fields and use the default settings for remaining fields. 


![](images/fetchpdf-1780573081890.pdf-0064-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**64** 

Deploy Cloud NGFW for Azure Resources 

**STEP 5 |** Enable logging for the rule. In the Add Rule window, select **Logging** . 


![](images/fetchpdf-1780573081890.pdf-0065-02.png)


**STEP 6 |** Click **Validate** , then **Add** to add the rule to the rulestack. 

## Add a FQDN list 

Add a FQDN list to the local rulestack that includes Facebook. Use this list to add a rule that blocks traffic to facebook.com 

**STEP 1 |** In the local rulestack page for the Cloud NGFW resource, click **FQDN List** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**65** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 2 |** Click **Add** . 

- **STEP 3 |** In the **Add FQDN List** screen, enter a name and description. In the FQDN field, enter one or more URLs, such as www.facebook.com. Only one FQDN URL can exist on a single line in the FQDN field. 

## **STEP 4 |** Click **Add** . 


![](images/fetchpdf-1780573081890.pdf-0066-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**66** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 5 |** Verify that the specified URLs appear in the FQDN list. 


![](images/fetchpdf-1780573081890.pdf-0067-02.png)


## Add a Rule 

Add a rule to the local rulestack that matches the FQDN list previously created. With the rule you can set an action, like dropping traffic. For example, you can apply an action to the FQDN rule to drop traffic attempting to access the URL www.facebook.com. 

- **STEP 1 |** In the local rulestack page for the Cloud NGFW resource, click **Rules** . 

- **STEP 2 |** Click **Add** . 

- **STEP 3 |** In the **Add Rule** screen, set the Match Criteria to Match. In the **FQDN List** field, use the drop-down menu to select Facebook 

- **STEP 4 |** In the **Actions** field, select **Drop** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**67** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 5 |** Click **Add** . 


![](images/fetchpdf-1780573081890.pdf-0068-02.png)


Both rules appear in the local rulestack header page. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**68** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0069-01.png)


As part of this Cloud NGFW service, security profiles are enabled with best practice configurations by default. Traffic is secured with the best security profiles once the Cloud NGFW is deployed in the network. View these using the **Profiles** page for the local rulestack. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**69** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0070-01.png)


After modifying rules,deploy them onto the local rulestack associated with the Cloud NGFW service. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**70** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 6 |** In the local rulestack, click **Deployment** . The deployment status page displays as Candidate; this means that the configuration was built but not deployed. 

- **STEP 7 |** Click **Deploy Configuration** to deploy the configuration onto the Cloud NGFW service. You must perform this step in order to deploy the rules onto the rulestack. 


![](images/fetchpdf-1780573081890.pdf-0071-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**71** 

Deploy Cloud NGFW for Azure Resources 

**STEP 8 |** After clicking **Deploy Configuration** , a pop-up message displays the firewalls associated with this rulestack. Click **Deploy** to configure this rulestack on all associated firewalls. 


![](images/fetchpdf-1780573081890.pdf-0072-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**72** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 9 |** After successfully deploying the configuration, the **Deployment** status is **Running** . 


![](images/fetchpdf-1780573081890.pdf-0073-02.png)


## Configure a source and destination NAT rule 

You can configure a destination NAT rule to address inbound traffic. To simplify management for applications requiring multiple ports, Cloud NGFW for Azure supports mapping port ranges in a single DNAT rule, reducing management overhead and the risk of configuration errors. 

When configuring egress NAT, consider the following: 

- If Egress NAT is disabled—The Firewall will use Public IP address assigned to it as a Source for Outbound traffic. 

- If Egress NAT is enabled—The selected public IP from the pool will be used as a Source for Outbound traffic. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**73** 

Deploy Cloud NGFW for Azure Resources 

   - You can chose more than one public IP addresses however in that case, the traffic cannot be pined for a particular source to use a particular public IP address. It will be randomly selected for each flow individually. 

- **STEP 1 |** Access the **Networking and NAT** settings for the Cloud NGFW resource. To determine if the Source NAT setting is enabled. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**74** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 2 |** Click **Edit** to add the destination NAT rule. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**75** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0076-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**76** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 3 |** Add a Destination NAT rule. The Front End IP represents the public IP address associated with the Cloud NGFW. Enter a **Frontend Port** number or a hyphen-separated **port range** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**77** 

Deploy Cloud NGFW for Azure Resources 

(such as 443-500), then click **Add** . When using a range, you must also specify a matching symmetrical **Backend Port** range. 


![](images/fetchpdf-1780573081890.pdf-0078-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**78** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0079-01.png)


- _You can enter either a single port or a range of ports for destination translation. The range defined for the Frontend Port must exactly match the range defined for the Backend Port. Mismatched ranges will result in a_ _**Bad Request** error._ 


![](images/fetchpdf-1780573081890.pdf-0079-03.png)


- _For every port specified in a range, Cloud NGFW for Azure creates one rule in the background._ 

- _The underlying Azure Standard Load Balancer (SLB) supports a maximum of 299 rules._ 

_For example: If you already have 50 single DNAT rules configured, adding a new port range of 100–350 (which consists of 251 ports) will bring your total to 301 rules. This exceeds the 299-rule NIC limit and will cause the configuration to fail._ 

- _Overlaps: Rules cannot overlap with existing DNAT entries using the same Frontend IP._ 

- _Valid Ports: The port range must be between 1 and 65534._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**79** 

Deploy Cloud NGFW for Azure Resources 

**STEP 4 |** After adding the destination NAT rule, click **Save** to deploy the configuration on the Cloud NGFW resource. 


![](images/fetchpdf-1780573081890.pdf-0080-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**80** 

Deploy Cloud NGFW for Azure Resources 

The frontend address is now redirected through the configured port through Cloud NGFW. Inbound traffic is now flowing through the Cloud NGFW. 

## Configure Logging 

Before configuring logging on the Cloud NGFW, create the Log Analytics workspace on Azure. 

- **STEP 1 |** In the Azure portal search for the **Azure Log Analytics workspace** . Click **Log Analytics Workspaces** to add it as a service. 

- **STEP 2 |** Click **Create** to establish a new **Log Analytics** workspace: 


![](images/fetchpdf-1780573081890.pdf-0081-06.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**81** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 3 |** In the Create Log Analytics workspace provide **Instance** details. Select the **Name** of the workspace from the drop-down menu, and specify the **Region** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**82** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0083-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**83** 

Deploy Cloud NGFW for Azure Resources 

**STEP 4 |** Configure log settings in the Cloud NGFW resource. Select **Log Settings** . Click **Edit** . 


![](images/fetchpdf-1780573081890.pdf-0084-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**84** 

Deploy Cloud NGFW for Azure Resources 

**STEP 5 |** In the **Log Settings** field, select the Log Analytics workspace previously created, then click **Save** . 


![](images/fetchpdf-1780573081890.pdf-0085-02.png)


## Update the Network Security Group 

Update the network security group that was created as part of the Cloud NGFW deployment. This security group is associated with both private and public subnet as part of the VNet in the Cloud NGFW subscription. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**85** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 1 |** Allow traffic as part of the frontend (destination) NAT rule configuration. Allow HTTP and HTTPS traffic so that the internet is accessible from application VNets through the Cloud NGFW. 


![](images/fetchpdf-1780573081890.pdf-0086-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**86** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 2 |** Click **Add** to incorporate this inbound security rule: 


![](images/fetchpdf-1780573081890.pdf-0087-02.png)


## Configure VNet peering 

To configure VNet peering: 

**STEP 1 |** Locate your VNet and select **Peerings** . 

- **STEP 2 |** Click **Add** to create a new peering. 

- **STEP 3 |** Provide a name for the peering and retain the default settings. 

- **STEP 4 |** Select the hub VNet that you want to peer. When deploying the Cloud NGFW in a VNet using an existing VNet hub, the minimum size should be /25. You must have 2 subnets with the minimum size /26; these subnets must be delegated to the **PaloAltoNetworks.Cloudngfw/firewalls** service 


![](images/fetchpdf-1780573081890.pdf-0087-09.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**87** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 5 |** Configure VNet peering between additional VNets by repeating the steps outlined in this section. 

## Add a Route Table to route traffic through the Cloud NGFW 

**STEP 1 |** Search for the **Route table** in the Azure portal search bar. 

- **STEP 2 |** Click **Create** to establish a new route table. 

- **STEP 3 |** Complete the route table fields, then click **Review+create** . 

- **STEP 4 |** After creating the route table, select the **Subnets** section and associate the table with the subnet. 


![](images/fetchpdf-1780573081890.pdf-0088-07.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**88** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 5 |** Configure the default route for outbound traffic, and route towards toward the subnet (for east-west traffic) with the next hop as the Cloud NGFW private IP address. 


![](images/fetchpdf-1780573081890.pdf-0089-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**89** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 6 |** Associate one or more route tables with another subnet from the VNet. Configure a default route (for outbound traffic) and route it towards a different subnet (for east-west traffic) with the next hop as the Cloud NGFW private IP address. 


![](images/fetchpdf-1780573081890.pdf-0090-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**90** 

Deploy Cloud NGFW for Azure Resources 

## Deploy the Cloud NGFW in a vWAN 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



You can deploy the Cloud NGFW in the vWAN hub as a scalable firewall solution to secure traffic between critical workloads hosted in a global hybrid network between Azure and on-premises. For more information on Azure vWAN and available features and capabilities, see the Azure Virtual WAN documentation. 

Consider the following when deploying the Cloud NGFW in a vWAN: 

- One private IP address is used for an NGFW resource. For vWAN environments, configure the vWAN hub routing policy to _hairpin_ traffic for the service. That is, the traffic exits an interface and returns before going out to the internet. 

- It may take approximately 30 minutes to provision a new vWAN hub. You can verify the status of a newly created vWAN hub in the **Routing Status** field in the **Essentials** section of the **Overview** page. 

The Cloud NGFW for Azure vWAN deployment: 

- Fully integrates into the Azure Virtual WAN using the SaaS framework. 

- Deploys into the vWAN virtual hub. 

- Utilizes routing intent and policy rules to control which traffic gets inspected by the Cloud NGFW service. 

- Enables enforcement of consistent Security policy for the inter-hub and interregion traffic 


![](images/fetchpdf-1780573081890.pdf-0091-12.png)


_When configuring DNAT rules in a vWAN hub, the ingress flow works regardless of the routing intent due to SNAT performed on the trust interface._ 

## **Prerequisites** 

To deploy Cloud NGFW in a vWAN, you will need an Azure subscription. This subscription should have an **owner** or a **contributor** role. 

Cloud NGFW requires a minimum of 40 IP addresses for the network virtual appliance (NVA). Following are the IP address allocation per defined subnet space within vWAN hub. Depending on your Subnet space, the throughput of the Firewall will vary. In order to gain maximum available throughput and auto scale to perform well, we highly recommend using at least /16 subnet space. For more information on the limitations for the vWAN hub, seeMicrosoft Virtual WAN FAQ. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**91** 

Deploy Cloud NGFW for Azure Resources 

|**Hub Address Space**|**Appliance Subnet**<br>**Space**|**Hosts per NVA subnet**|**Max Throughput**|
|---|---|---|---|
|/16|/25|123|~100 Gbps|
|/21|/27|27|~50 Gbps|
|/23|/28|11|~30 Gbps|
|/24|/28|11|~30 Gbps|



- **STEP 1 |** Log in to the Azure portal and search for **Virtual WAN** . Click **Create** to create a Virtual WAN Service. 


![](images/fetchpdf-1780573081890.pdf-0092-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**92** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 2 |** After successfully creating the Virtual WAN service, click **Go to resource** . 


![](images/fetchpdf-1780573081890.pdf-0093-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**93** 

Deploy Cloud NGFW for Azure Resources 

**STEP 3 |** Add a hub to the Virtual WAN you created. Select **Connectivity > Hubs** . Click **New Hub** . 


![](images/fetchpdf-1780573081890.pdf-0094-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**94** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 4 |** Configure **Virtual Hub Details** . Specify the **hub private address** and **virtual hub capacity** , then click **Next: Site to Site** . 


![](images/fetchpdf-1780573081890.pdf-0095-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**95** 

Deploy Cloud NGFW for Azure Resources 

**STEP 5 |** After validating the configuration, click **Create** to create the virtual WAN hub. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**96** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0097-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**97** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 6 |** Verify that the **Routing status** is **Provisioned** . 


![](images/fetchpdf-1780573081890.pdf-0098-02.png)


_It may take approximately 30 minutes to provision a new vWAN hub. Use the_ _**Overview** page to view routing status._ 


![](images/fetchpdf-1780573081890.pdf-0098-04.png)


**STEP 7 |** Log in to the Azure portal and search for **Cloud NGFWs by Palo Alto Networks** . 

- **STEP 8 |** Click **Cloud NGFWs by Palo Alto Networks** to start creating the Palo Alto Networks Cloud NGFW service for Azure. 

- **STEP 9 |** In the **Cloud NGFWs** screen, click **Create** ; this landing page is prepopulated with Cloud NGFW instances if you have previously created the resource. 


![](images/fetchpdf-1780573081890.pdf-0098-08.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**98** 

Deploy Cloud NGFW for Azure Resources 

**STEP 10 |** In the **Create Palo Alto Networks Cloud NGFW** screen, enter basic configuration information in the **Project details** section. 

Use the information in the following table to provide **Project details** . 

|**Field**|**Description**|
|---|---|
|Subscription|Automatically selected based on the subscription used while logged in.|
|Resource Group|Use one of the existing resource groups or create a new one (using the<br>**Create New**option) in which the Cloud NGFW resource is created.|
|Firewall Name|Name of the Cloud NGFW firewall resource.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**99** 

Deploy Cloud NGFW for Azure Resources 

|**Field**|**Description**|
|---|---|
|Region|Region in which Cloud NGFW is provisioned.|




![](images/fetchpdf-1780573081890.pdf-0100-02.png)


**STEP 11 |** Click **Next: Networking** . Provide information for your networking environment. Choose the **Virtual WAN Hub** for the **Network Type** . In the **Virtual WAN Hub Details** section, select the **virtual hub name** you created previously from the drop-down menu. Specify **public IP** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**100** 

Deploy Cloud NGFW for Azure Resources 

**addresses** , and the **Source NAT** option if address translation is used on traffic going out to the internet. 


![](images/fetchpdf-1780573081890.pdf-0101-02.png)


**STEP 12 |** Click **Next: Rulestack** to create a local rulestack where rules are defined; this is a placeholder for local rulestack creation; click **Create new** or **Use existing** (if a local rulestack already 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**101** 

Deploy Cloud NGFW for Azure Resources 

exists, select it from the drop-down menu). After you create the Cloud NGFW resource, you can modify this rulestack to add or edit rules, FQDN, and the prefix list. 


![](images/fetchpdf-1780573081890.pdf-0102-02.png)


- **STEP 13 |** Click **Next: DNS Proxy** . By default, the DNS proxy is disabled. You can configure the Cloud NGFW to inspect all DNS traffic by acting as a proxy for vWAN resources. When configured, 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**102** 

Deploy Cloud NGFW for Azure Resources 

the DNS Proxy forwards the DNS request to the default Azure DNS server, or a DNS server you specify. 


![](images/fetchpdf-1780573081890.pdf-0103-02.png)


- **STEP 14 |** Click **Next: Tags** to specify tags for your Azure requirements. Tags are predefined labels that can help you manage the vulnerabilities in your environment and view consolidated billing 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**103** 

Deploy Cloud NGFW for Azure Resources 

related to your Azure account They are centrally defined and are set to vulnerabilities and as policy exceptions. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**104** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0105-01.png)


Use tags for: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**105** 

Deploy Cloud NGFW for Azure Resources 

- Vulnerability labels. They provide a convenient way to categorize the vulnerabilities in your environment. 

- Policy exceptions. They can be a part of your rules to have a specific effect on tagged vulnerabilities. 

- View consolidated billing for your Azure account. 

Tags are useful when you have large container deployments with multiple teams working in the same environment. For example, you might have different teams handling different types of vulnerabilities. Then you can set tags to define responsibilities over vulnerabilities. Other uses would be to set the status of fixing the vulnerability, or to mark vulnerabilities to ignore when they are a known problem that can't be fixed in the near future. 


![](images/fetchpdf-1780573081890.pdf-0106-05.png)


_You can define as many tags as you like. For information about creating tags for your Azure account, see_ Use tags to organize your Azure resources and management hierarchy _._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**106** 

Deploy Cloud NGFW for Azure Resources 

**STEP 15 |** Click **Next:Terms** and accept the terms and the conditions for the deployment. 


![](images/fetchpdf-1780573081890.pdf-0107-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**107** 

Deploy Cloud NGFW for Azure Resources 

**STEP 16 |** Click **Review + create** to validate your Azure subscription for the Cloud NGFW resource. The resource is validated first, then created. The screen shows **Validation Passed** . Click **Create** to deploy the Cloud NGFW service. 


![](images/fetchpdf-1780573081890.pdf-0108-02.png)


After creating the Cloud NGFW service the deployment progress is displayed. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**108** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0109-01.png)



![](images/fetchpdf-1780573081890.pdf-0109-02.png)


_Deploying a Cloud NGFW resource takes approximately 30 minutes to complete._ 

On a successful deployment, the following screen appears. 


![](images/fetchpdf-1780573081890.pdf-0109-05.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**109** 

Deploy Cloud NGFW for Azure Resources 

**STEP 17 |** Four resources are created, including Cloud NGFW, a local rulestack, public IP address and the Cloud-nva. 


![](images/fetchpdf-1780573081890.pdf-0110-02.png)


**STEP 18 |** After creating the Cloud NGFW resource, select it to verify that the provisioning state is Succeeded. This page also displays the public and private IP addresses that are associated with the Cloud NGFW service. Make sure that the Network type is vWAN. 


![](images/fetchpdf-1780573081890.pdf-0110-04.png)


## Verify the Deployment of the Cloud NGFW in a vWAN 

After successfully creating the Cloud NGFW service for the vWAN network type, verify that the Cloud NGFW was added as a SaaS Solution for the vWAN. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**110** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 1 |** Go to the Virtual Hub that was used while creating the Cloud NGFW service. In the Thirdparty **providers** section, click **SaaS Solutions** . 


![](images/fetchpdf-1780573081890.pdf-0111-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**111** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 2 |** Verify that the Cloud NGFW was created; it's added as a SaaS solution to this hub. In the **SaaS Solutions** section, select **Click here** . 


![](images/fetchpdf-1780573081890.pdf-0112-02.png)


## Information related to the vWAN deployment appears. 


![](images/fetchpdf-1780573081890.pdf-0112-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**112** 

Deploy Cloud NGFW for Azure Resources 

## Sample Configuration for Post vWAN Deployment 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal (CSP) account<br>Azure Marketplace subscription|



## Post deployment 

After verifying the deployment, perform the following post deployment tasks: 

- Create or update a rulestack 

- Source/destination NAT rule on the Cloud NGFW 

- Configure logging 

- Add application vNETs as Virtual Networks Connections to the Virtual WAN 

- Configure vWAN Hub Routing Intent and Routing Policies 

## **Create or update a rulestack** 

To update an existing rulestack: 

- **STEP 1 |** In the Azure Resource Manager (ARM) console, click **Rulestacks** for the Cloud NGFW resource you want to configure. The rulestack associated with the Cloud NGFW service appears, along with the resource group. 


![](images/fetchpdf-1780573081890.pdf-0113-13.png)


- **STEP 2 |** Modify the rulestack to add firewall rules. These rules allow some traffic while blocking specific traffic. By default, Cloud NGFW blocks all traffic. Search for the local rulestack you created previously using the global search option provided by the Azure portal. 

- **STEP 3 |** Select the previously created local rulestack associated with your Cloud NGFW subscription, then select **Rules** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**113** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 4 |** In the **Local Rules** section, click **Add** . In the **Add Rule** window, modify the rules. For example, add a rule that allows traffic; complete the mandatory fields and use the default settings for remaining fields. 


![](images/fetchpdf-1780573081890.pdf-0114-02.png)


- **STEP 5 |** Enable logging for the rule. In the Add Rule window, select **Logging** . 


![](images/fetchpdf-1780573081890.pdf-0114-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**114** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 6 |** Click **Validate** , then **Add** to add the rule to the rulestack. 


![](images/fetchpdf-1780573081890.pdf-0115-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**115** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 7 |** Add a **FQDN list** that specifies a URL, then specify an action to take. For example, you can apply an action to the FQDN rule to drop traffic attempting to access the URL www.facebook.com. 


![](images/fetchpdf-1780573081890.pdf-0116-02.png)


Verify that the URL you entered appears in the FQDN list. 


![](images/fetchpdf-1780573081890.pdf-0116-04.png)


- **STEP 8 |** Return to the **Rules** setting page and add a rule that matches the newly created FQDN list. Set the action to **Drop** traffic. 

Both rules appear in the Local Rules page. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**116** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 9 |** As part of the Cloud NGFW service, security profiles are enabled with best practice configurations by default. Traffic is secured with the best security profiles when you start and deploy the service. Select **Profiles** to view these security profiles. 


![](images/fetchpdf-1780573081890.pdf-0117-02.png)


- **STEP 10 |** After modifying rules, deploy them onto the local rulestack associated with the Cloud NGFW service. Click **Deployment** . The deployment status appears as **Candidate** ; this means that the configuration was built but not yet deployed. Click **Deploy Configuration** to deploy the 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**117** 

Deploy Cloud NGFW for Azure Resources 

configuration onto the Cloud NGFW service. **You must complete this step to deploy the rulestack** . 


![](images/fetchpdf-1780573081890.pdf-0118-02.png)


- **STEP 11 |** After clicking **Deploy Configuration** , a message displays the firewalls associated with the rulestack. Click **Deploy** to configure this rulestack on all the associated firewalls using the rulestack. 


![](images/fetchpdf-1780573081890.pdf-0118-04.png)


After successfully deploying the configuration, the screen displays the deployment status as Running (the Cloud NGFW and local rulestack are successfully deployed). 

## **Source/destination NAT rule on the Cloud NGFW** 

Configure a destination NAT rule with frontend configuration on the Cloud NGFW to direct inbound traffic towards an application on the vWAN. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**118** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 1 |** Access the **Networking & NAT** settings screen for the Cloud NGFW resource. In this screen, determine if the network type is **Virtual WAN Hub** and the status of the **Source NAT** field (enabled or disabled); if Source NAT was enabled, it appears in this screen. 

- **STEP 2 |** Click **Edit** to add the Destination NAT rule. 


![](images/fetchpdf-1780573081890.pdf-0119-03.png)


- **STEP 3 | Add** a Destination NAT rule for the frontend configuration. The frontend IP address represents the public IP address associated with the Cloud NGFW. Use the drop-down menu to select the address. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**119** 

Deploy Cloud NGFW for Azure Resources 

**STEP 4 |** Add frontend setting information to the rule, and click **Add** . 


![](images/fetchpdf-1780573081890.pdf-0120-02.png)


Once the destination NAT rule is added, click Save to deploy the configuration to the Cloud NGFW resource. 

After successfully saving the configuration, the Destination Network Address Translation (DNAT) field displays the updates; the address http://frontendIP:8080 is redirected to the noted application on the specified port through the Cloud NGFW; inbound traffic is now flowing through the Cloud NGFW. 


![](images/fetchpdf-1780573081890.pdf-0120-05.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**120** 

Deploy Cloud NGFW for Azure Resources 

## Configure Logging 

Before configuring logging on the Cloud NGFW, create the **Log Analytics** workspace on Azure. 

- **STEP 1 |** In the Azure portal search for the **Azure Log Analytics workspace** . Click **Log Analytics Workspaces** to add it as a service. 

- **STEP 2 |** Click **Create** to establish a new **Log Analytics** workspace. 

- **STEP 3 |** In the Create Log Analytics workspace provide **Instance** details. Select the **Name** of the workspace from the drop-down menu, and specify the **Region** . 

- **STEP 4 |** Configure log settings in the Cloud NGFW resource. Select **Log Settings** . Click **Edit** . 


![](images/fetchpdf-1780573081890.pdf-0121-07.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**121** 

Deploy Cloud NGFW for Azure Resources 

**STEP 5 |** In the **Log Settings** field, select the Log Analytics workspace previously created, then click **Save** . 


![](images/fetchpdf-1780573081890.pdf-0122-02.png)


Add application vNETs as Virtual Networks Connections to the Virtual WAN 

Add an application vNET as Virtual Network Connections to the Virtual WAN hub. **STEP 1 |** In your vWAN resource, select **Virtual Network Connections** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**122** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 2 |** Click **Add connection** . 


![](images/fetchpdf-1780573081890.pdf-0123-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**123** 

Deploy Cloud NGFW for Azure Resources 

## **STEP 3 |** Select the vNET you want to configure as the **Virtual Network** , then click **Create** . 


![](images/fetchpdf-1780573081890.pdf-0124-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**124** 

Deploy Cloud NGFW for Azure Resources 

**STEP 4 |** Select another vNET for the second Virtual Network, then click **Create** . 


![](images/fetchpdf-1780573081890.pdf-0125-02.png)


**STEP 5 |** After successfully connecting the virtual networks to the vHub, verify that the status is **Connected** . 

## **Configure vWAN Hub Routing Intent and Routing Policies** 

Routing policies within the virtual WAN hub are used to route traffic through the Cloud NGFW service. To route internet bound traffic and private traffic (spoke to spoke) you need to configure the next hop as the vWAN Cloud NGFW. 

**STEP 1 |** In your vWAN resource, select **Routing Intent and Routing Policies** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**125** 

Deploy Cloud NGFW for Azure Resources 

**STEP 2 |** Select the Internet traffic and the Next Hop Resource from the drop-down menus, then click **Save** . 


![](images/fetchpdf-1780573081890.pdf-0126-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**126** 

Deploy Cloud NGFW for Azure Resources 

- **STEP 3 |** After configuring routing policies, verify the routing table was updated to route traffic through Cloud NGFW. Click **Route Tables** and select **Default** in the **Route Tables** section. 


![](images/fetchpdf-1780573081890.pdf-0127-02.png)


You can **Edit** the route table to provide details related to the routes associated with the Default Routing table. Traffic going out to the internet or to other vNETs is routed through the Cloud NGFW. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**127** 

Deploy Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0128-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**128** 

Deploy Cloud NGFW for Azure Resources 

**STEP 4 |** Select another vNET for the second Virtual Network, then click **Create** . 

**STEP 5 |** After successfully connecting the virtual networks to the virtual WAN hub, verify that the status is **Connected** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**129** 

Deploy Cloud NGFW for Azure Resources 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**130** 


![](images/fetchpdf-1780573081890.pdf-0131-00.png)


## Protect Traffic with Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW provides various types of protection and policy management options: 

- **Cloud-Delivered Security Services (CDSSS)** . Palo Alto Networks suite of Cloud-Delivered Security Services (CDSS) provide access to specialized subscription-based security solutions, designed specifically to defend against known, unknown, and advanced evasive threats. The threat data that is generated through advanced analysis is shared across the Palo Alto Networks security platforms to provide complete coverage across all threat vectors. For more information, see Cloud NGFW for Azure Security Features and CDSS Capabilities. 

- **Cloud NGFW native policy management** . With native policy management, you define security policy rules and group those rules together in a rulestack. While _Security policy rules_ enable you to allow or block traffic on your network, _Security Profiles_ help you define an allow but scan rule, which scans allowed applications for threats, such as malware, spyware, and DDoS attacks. When traffic matches the allow rule defined in the Security policy rule, the Security Profiles attached to the rule are applied for further content inspection rules such as antivirus checks and data filtering. For more information, see Cloud NGFW native policy management. 

- **Panorama policy management** . You can use a Panorama appliance to manage a shared set of security rules centrally on Cloud NGFW resources alongside your physical and virtual firewall appliances. You can also manage all aspects of shared objects and profiles configuration, push these rules, and generate reports on traffic patterns or security incidents of your Cloud NGFW resources, all from a single Panorama console. Panorama provides a single location from which you can have centralized policy and firewall management across hardware firewalls, virtual firewalls, and cloud firewalls, which increases operational efficiency in managing and maintaining a hybrid network of firewalls. For more information, see Panorama policy management. 

- **Strata Cloud Manager policy management** . You can integrate your Cloud NGFW resources with Strata Cloud Manager (SCM) for policy management. With this integration, you can use a single Strata Cloud Manager to centrally manage a shared set of security rules on Cloud NGFW resources alongside your physical and virtual firewall appliances. You can also manage all aspects of shared policy configurations, gain comprehensive visibility with actionable insights, and generate reports on traffic patterns or security incidents of your Cloud NGFW resources, all from a single console. For more information, see Strata Cloud Manager policy management. 

**131** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0132-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**132** 

Protect Traffic with Cloud NGFW for Azure 

## Cloud NGFW for Azure Security Features and CDSS Capabilities 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Palo Alto Networks suite of security features and Cloud-Delivered Security Services (CDSS) capabilities provide access to specialized subscription-based security solutions, designed specifically to defend against known, unknown, and advanced evasive threats. The threat data that is generated through advanced analysis is shared across the Palo Alto Networks security platforms to provide complete coverage across all threat vectors. 

To secure and protect your traffic, Cloud NGFW for Azure provides Palo Alto Networks protections through granular controls and Cloud Delivered Security Services (CDSS): 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**133** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0134-01.png)


These granular controls include: 

- App-ID. Based on patented Layer 7 traffic classification technology, the App-ID service allows you to see the applications on your network, learn how they work, observe their behavioral characteristics, and understand their relative risk. Cloud NGFW for Azure identifies applications and application functions via multiple techniques, including application signatures, decryption, protocol decoding, and heuristics. These capabilities determine the exact identity 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**134** 

Protect Traffic with Cloud NGFW for Azure 

of applications traversing your network, including those attempting to evade detection by masquerading as legitimate traffic by hopping ports or using encryption. 

- Threat Prevention. The Palo Alto Networks Threat Prevention service protects your network by providing multiple layers of prevention to confront each phase of an attack. In addition to essential intrusion prevention service (IPS) capabilities, Threat Prevention possesses the unique ability to detect and block threats on any ports—rather than simply invoking signatures based on a limited set of predefined ports. 

- Advanced URL Filtering. This critical service built into Cloud NGFW for Azure stops unknown web-based attacks in real-time to prevent patient zero with the industry’s only MLpowered Advanced URL Filtering. Advanced URL Filtering combines the renowned Palo Alto Networks malicious URL database with the industry’s first real-time web protection engine so organizations can automatically and instantly detect and prevent new malicious and targeted web-based threats. 

- DNS. DNS Security gives you real-time protection, applying industry-first protections to disrupt attacks that use DNS. Tight integration with a Palo Alto Networks Next-Generation Firewall (NGFW) gives you automated protections, prevents attackers from bypassing security measures, and eliminates the need for independent tools or changes to DNS routing. DNS Security gives your organization a critical new control point to stop attacks. 

- WildFire. Palo Alto Networks Advanced WildFire[®] is the industry’s largest cloud-based malware prevention engine that protects organizations from highly evasive threats using patented machine learning detection engines, enabling automated protections across network, cloud, and endpoints. Advanced WildFire analyzes every unknown file for malicious intent and then distributes prevention in record time—60 times faster than the nearest competitor—to reduce the risk of patient zero. 

## Advanced Threat Protection 

Advanced Threat Prevention (ATP) is an intrusion prevention system (IPS) solution that can detect and block malware, vulnerability exploits, and command and control (C2) across all ports and protocols, using a multilayered prevention system with components operating on Cloud NGFW for Azure and in the cloud. The Threat Prevention cloud operates a multitude of detection services using the combined threat data from Palo Alto Networks services to create signatures, each possessing specific identifiable patterns, and are used by the Cloud NGFW for Azure to enforce security policy rules when matching threats and malicious behaviors are detected. These signatures are categorized based on the threat type and are assigned unique identifier numbers. To detect threats that correspond with these signatures, Cloud NGFW for Azure operates analysis engines that inspect and classify network traffic exhibiting anomalous traits. 


![](images/fetchpdf-1780573081890.pdf-0135-08.png)


- _After enabling Advanced Threat Prevention, use Panorama to configure associated Advanced Threat Prevention policies._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**135** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0136-01.png)


In addition to the signature-based detection mechanism, Advanced Threat Prevention provides an inline detection system to prevent unknown and evasive C2 threats, including those produced through the Empire framework, as well as command injection and SQL injection vulnerabilities. The Advanced Threat Prevention cloud operates extensible deep learning models that enable inline analysis capabilities on Cloud NGFW for Azure, on a per-request basis to prevent zeroday threats from entering the network as well as to distribute protections. This allows you to prevent unknown threats using real-time traffic inspection with inline detectors. These deep learning, ML-based detection engines in the Advanced Threat Prevention cloud analyze traffic for unknown C2 and vulnerabilities that utilize SQL injection and command injection to protect against zero-day threats. To provide a threat context and comprehensive detection details, reports are generated that can include the tools and techniques used by the attacker, the scope, 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**136** 

Protect Traffic with Cloud NGFW for Azure 

and impact of the detection, as well as the corresponding cyberattack classification as defined by the MITRE ATT&CK[®] framework. 

## **Advanced URL Filtering** 

Advanced URL Filtering is a comprehensive URL filtering solution that protects your network and users from web-based threats. Combining the capabilities of PAN-DB with a web security engine powered by machine learning, Advanced URL Filtering categorizes and blocks malicious URLs in real-time. With an Advanced URL Filtering license (or legacy URL filtering license), you can restrict access to websites and control user interactions with web content. For example, you can prevent users from accessing websites known to host malware or entering corporate credentials into websites in specific categories. 

Palo Alto Networks provides a set of predefined URL filtering categories. You can also specify your own URL filtering categories using a customer URL category object. For example, create a custom list of URLs that you want to use as match criteria in a Security policy rule. This is a good way to specify exceptions to URL categories, where you’d like to enforce specific URLs differently than the URL category to which they belong. 


![](images/fetchpdf-1780573081890.pdf-0137-05.png)


_For a high-level summary of how Advanced URL Filtering provides best-in-class web protection for the modern enterprise, review the_ Advanced URL Filtering datasheet _._ 

## Wildfire Protection 

Cloud NGFW can now detect and forward  files, executables, and malicious scripts (such as JScript and PowerShell) in your VPC traffic to WildFire[™] cloud service for analysis. WildFire then applies threat intelligence, analytics, and correlations on these forwarded files (executables or scripts) and delivers verdicts based on the analysis. If a threat is detected on them, WildFire creates protections to block malware, and globally distribute these protection for that threat in a few minutes. 

WildFire goes beyond traditional sandboxing approaches and uses multiple techniques to identify files with potential malicious behaviors. These techniques include: 

- **Dynamic analysis** - observes files as they execute in a purpose-built, evasion-resistant virtual environment, enabling detection of previously unknown malware using hundreds of behavioral characteristics. 

- **Static analysis** - complements dynamic analysis with effective detection of malware, providing instant identification of malware variants. Static analysis further leverages dynamic unpacking to analyze threats attempting to evade detection through the use of packing tool sets. 

- **Network traffic profiles** - detect malicious traffic patterns based on malware variants such as backdoor creation, download of next-stage malware, access to low-reputation domains, and network reconnaissance. 

- **Machine learning** - extracts thousands of unique features from each file, training a predictive machine learning model to identify new malware, which isn't possible with static or dynamic analysis alone. 

- **A custom-built hypervisor** - prevents attacker evasion techniques with a robust, proprietary hypervisor that does not depend on open-source projects or proprietary software to which attackers have access. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**137** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0138-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**138** 

Protect Traffic with Cloud NGFW for Azure 

## DNS Security 

Domain Name Service (DNS) is a critical and foundational Internet Protocol, as described in the core RFCs for the protocol. Malicious actors have utilized command and control (C2) (C2) communication channels over the DNS and, in some cases, have even used the protocol to exfiltrate data. DNS exfiltration can happen when a bad actor compromises an application instance in your network and then uses DNS lookup to send data out of the network to a domain they control. Malicious actors can also infiltrate malicious data or payloads to the network workloads over DNS. Over the years, Palo Alto Networks Unit 42 research has described different types of DNS abuse discovered. 

Cloud NGFW for Azure allows you to protect your VNet and vWAN traffic from advanced DNSbased threats by monitoring and controlling the domains that your network resources query. With Cloud NGFW for Azure, you can deny access to the domains that Palo Alto Networks considers bad or suspicious and allow all other queries to pass-through. 

For this purpose, Cloud NGFW leverages the Palo Alto Networks’ DNS Security service, which proactively detects malicious domains by generating DNS signatures using advanced predictive analysis and machine learning, with data from multiple sources (such as WildFire[®] traffic analysis, passive DNS, active web crawling & malicious web content analysis, URL sandbox analysis, Honeynet, DGA reverse engineering, telemetry data, whois, the Unit 42 research organization, and Cyber Threat Alliance). The DNS security service then distributes these DNS signatures to your Cloud NGFW resources to proactively defend against malware using DNS for command and control (C2) and data theft. 

With DNS Security enabled, the Cloud NGFW takes the following actions for each DNS Security category. 

|**Category**|**Log Severity**|**Action**|
|---|---|---|
|Ad Tracking Domains|Informational|Allow|
|Command and control (C2)<br>Domains|High|Block|
|Dynamic DNS (DDNS)<br>Domains|Informational|Allow|
|Grayware Domains|Low|Block|
|Malware Domains|Medium|Block|
|Newly Registered Domains|Informational|Allow|
|Parked Domains|Informational|Allow|
|Phishing Domains|Low|Block|
|Proxy Avoidance and<br>Anonymizers|Low|Block|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**139** 

Protect Traffic with Cloud NGFW for Azure 

## Cloud NGFW Native Policy Management 

## **Where Can I Use This?** 

## **What Do I Need?** 

- Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0140-05.png)



![](images/fetchpdf-1780573081890.pdf-0140-06.png)



![](images/fetchpdf-1780573081890.pdf-0140-07.png)


- Cloud NGFW subscription 

- Palo Alto Networks Customer Support Portal account Azure Marketplace subscription 

You can use Cloud NGFW for Azure native policy management: 


![](images/fetchpdf-1780573081890.pdf-0140-11.png)


On Cloud NGFW, you define security policy rules and group those rules together in a rulestack. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**140** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0141-01.png)


_Cloud NGFW uses your rulestack definitions to protect your Azure Virtual Network (VNet) traffic. For more information, see_ Cloud NGFW for Azure Security Services _._ 

While security policy rules enable you to allow or block traffic on your network, Security Profiles help you define an `allow but scan` rule, which scans allowed applications for threats, such as malware, spyware, and DDoS attacks. When traffic matches the `allow` rule defined in the Security policy rule, the Security Profiles attached to the rule are applied for further content inspection rules such as antivirus checks and data filtering. 


![](images/fetchpdf-1780573081890.pdf-0141-04.png)


_Security Profiles are not used in the match criteria of a traffic flow. The Security Profile is applied to scan traffic after the Security policy rule allows the application or category._ 

The firewall provides default Security Profiles that you can use out of the box to begin protecting your network from threats. See Set Up a Basic Security Policy for information on using the default profiles in your Security policy rule. 

For recommendations on the best practice settings for Security Profiles, review the best practices for creating security profiles. 

You can add Security Profiles that are commonly applied together to Create a Security Profile Group; this set of profiles are treated as a unit and added to Security policy rules in one step (or included in Security policy rules by default, if you choose to set up a default Security Profile Group). 

Security profiles provide fundamental protections by scanning traffic that you allow on the network for threats. Security Profiles provide a full suite of coordinated threat prevention tools that block peer-to-peer command and control (C2) application traffic, dangerous file types, attempts to exploit vulnerabilities, and antivirus signatures, and also identify new and unknown malware. 

It takes relatively little effort to apply Security Profiles because Palo Alto Networks provides predefined profiles that you can simply add to Security policy allow rules. Customizing Security Profiles is easy because you can clone a predefined profile and then edit it. You can also create a Security Profile from scratch on the firewall or on Panorama. 

To detect known and unknown threats in your network traffic, attach Security Profiles to all Security policy rules that allow traffic on the network, so that the firewall inspects all allowed traffic. The firewall applies Security Profiles to traffic that matches the Security policy allow rule, scans traffic in accordance with the Security Profile settings, and then takes appropriate actions to protect the network. The recommendations for best practice Security Profiles apply to all four of the data center traffic flows except as noted. 


![](images/fetchpdf-1780573081890.pdf-0141-12.png)


_Download_ content updates _automatically and install them as soon as possible so that you have the latest threat prevention signatures and content (antivirus, antispyware, vulnerabilities, malware, etc.) on the firewall and block the latest threats._ 

## Security Rule Objects 

A security rule object is a single object or collective unit that groups discrete identities such as IP addresses, FQDN, or certificates. Typically, when creating a policy object, you group objects that require similar permissions in the policy. For example, if your organization uses a set of server IP addresses for authenticating users, you can group the set of server IP addresses as a prefix 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**141** 

Protect Traffic with Cloud NGFW for Azure 

list object and reference that prefix list in one or more security rules. Group object allows you to significantly reduce the administrative overhead in creating rules. 

- **Prefix** and **FQDN Lists** —prefix and FQDN lists allow you to group specific source or destination IP addresses or FQDNs that require the same policy enforcement. A prefix list can contain one or more IP addresses or Internet Protocol netmask in CIDR notation. An address object of type Internet Protocol netmask requires you to enter the IP address or network using slash notation to indicate the IPv4 network. For example, 192.168.18.0/24. An FQDN (for example, paloaltonetworks.com) object provides further ease of use because DNS provides the FQDN resolution to the IP addresses instead of you needing to know the IP addresses and manually updating them every time the FQDN resolves to new IP addresses. 

- **Certificate** —a certificate object is a reference to a TLS certificate stored in the Azure Key Vault in your Azure account, and is used in outbound decryption. 


![](images/fetchpdf-1780573081890.pdf-0142-04.png)


- _PAN-OS version 11.0.x is required when using Azure Key Vault for outbound decryption._ 

## Create a Rulestack on Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Rulestacks defines access control (App-ID, URL Filtering) and threat prevention behavior of Cloud NGFW resources. A Cloud NGFW resource uses your rulestack definitions to protect the traffic by a two-step process. First, it enforces your rules on the to allow or deny your traffic. Second, it performs content inspection on the allowed traffic based on what you specify on the Security Profiles. A rulestack includes a set of security rules, associated objects, and profiles similar to device groups on Panorama. 

Cloud NGFW for Azure supports a **local rulestack** . A Local rulestack consists of local rules and manages the local rules. A local account administrator can associate a local rulestack to an NGFW in their AWS account. To create and manage local rulestacks, you must have the Local rulestack admin role. 

In the Cloud NGFW, you can author local rulestacks if you are assigned the **LocalRuleStackAdmin** role. 


![](images/fetchpdf-1780573081890.pdf-0142-11.png)


_If you are deploying the firewall for the first time and intend to use_ Strata Cloud Manager for policy management _, you must deploy a local rulestack first. Deploying a local rulestack is free._ 

Complete the following procedure to create a local rulestack in Azure Portal. 

**STEP 1 |** In the Azure Portal, use the search bar to locate the **Local Rulestack** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**142** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 2 |** Click **Create** . 

- **STEP 3 |** Choose **Subscription** and **Resource Group** from their respective drop-downs in the Project details section of the **Basics** tab. 

- **STEP 4 |** Enter a descriptive **Name** for your rulestack. 

- **STEP 5 |** Enter the supported **Region** for your rulestack. 

- **STEP 6 |** Click the **Tags** tab. 

   1. Enter the **Name** and **Value** . 

   2. Click **Review+create** . 

- **STEP 7 |** Review the rulestack options you have selected and click **Create** . 

- **STEP 8 |** After successfully creating the local rulestack, register it in the Azure Portal by creating a customer support case. For more information, see Register for Support. 

## Create a Prefix List on Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



A security rule object is a single object or collective unit that groups discrete identities such as IP addresses, fully-qualified domain names (FQDN), intelligent feeds, or certificates. Typically, when creating a policy object, you group objects that require similar permissions in policy. For example, if your organization uses a set of server IP addresses for authenticating users, you can group the set of server IP addresses as a prefix list object and reference that prefix list in one or more security rule. Group object allows you to significantly reduce the administrative overhead in creating rules. 

A prefix list allows you to group specific IP addresses that require the same policy enforcement. A prefix list can contain one or more IP addresses or IP netmask in CIDR notation. An address object of type IP Netmask requires you to enter the IP address or network using slash notation to indicate the IPv4 network. For example, 192.168.18.0/24. 


![](images/fetchpdf-1780573081890.pdf-0143-14.png)


_To configure a prefix list, familiarize yourself with how_ rulestacks _work._ 

- **STEP 1 |** Click the **Local Rulestacks** icon from the homepage and select a previously-created rulestack on which you wish to configure a prefix list. 

- **STEP 2 |** Click **Prefix List** on the left pane and click **Add** . The Add Prefix List pane opens. 

- **STEP 3 |** Enter a descriptive **Name** for your prefix list. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**143** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 4 |** (optional) Enter a description for your prefix list. 

- **STEP 5 |** Enter one or more **Address** . You can enter IP addresses or IP netmasks in CIDR format and one value per line. 

**STEP 6 |** Click **Add** . 

## Create a FQDN List on Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



A security rule object is a single object or collective unit that groups discrete identities such as IP addresses, fully-qualified domain names (FQDN), intelligent feeds, or certificates. Typically, when creating a policy object, you group objects that require similar permissions in policy. For example, if your organization uses a set of server IP addresses for authenticating users, you can group the set of server IP addresses as a prefix list object and reference that prefix list in one or more security rule. Group object allows you to significantly reduce the administrative overhead in creating rules. 

An FQDN (for example, paloaltonetworks.com) object provides further ease of use because DNS provides the FQDN resolution to the IP addresses instead of you needing to know the IP addresses and manually updating them every time the FQDN resolves to a new IP addresses. 


![](images/fetchpdf-1780573081890.pdf-0144-08.png)


_To configure a FQDN list, familiarize yourself with how_ rulestacks _work._ 

- **STEP 1 |** Click the **Local Rulestacks** icon from the homepage and select a previously-created rulestack on which you wish to configure the FQDN list. 

- **STEP 2 |** Click **FQDN List** on the left pane and click **Add** . The Add FQDN List pane opens. 

- **STEP 3 |** Enter a descriptive **Name** for your FQDN list. 

- **STEP 4 |** (optional) Enter a description for your FQDN list. 

- **STEP 5 |** Enter one or more **FQDN** , one per line. 

- **STEP 6 |** Click **Add** . 

## Configure Advanced URL Filtering 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**144** 

Protect Traffic with Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
||Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



To configure advanced URL filtering, follow the steps on this page. 


![](images/fetchpdf-1780573081890.pdf-0145-03.png)


_To configure advanced URL filtering, you'll need to be familiar with_ rulestacks _._ 

## **Create a Custom URL Category** 

**STEP 1 |** In the Cloud NGFW console, select **Rulestacks** and select a previously-created rulestack on which to configure a custom URL category. 

- **STEP 2 |** Select **Objects** > **Custom URL Category** > **Create Custom URL Category** . 

- **STEP 3 |** Enter a descriptive **Name** for your custom URL category. 

- **STEP 4 |** (optional) Enter a description for your custom URL category. 

**STEP 5 |** Enter one or more **URL List** , one per line. 

**STEP 6 |** Click **Save** . 

## **Basic Guidelines For URL Category Exception Lists** 

- Enter the URLs of websites that you want to enforce separately from the associated URL category. 

- List entries must be an exact match and are case-insensitive. 

- Enter a string that is an exact match to the website (and possibly, specific subdomain) for which you want to control access, or use wildcard characters to allow an entry to match to multiple website subdomains. 

- Omit `http` and `https` from URL entries. 

- Each URL entry can be up to 255 characters in length. 

## **Wildcard Guidelines for URL Category Exception Lists** 

You can use wildcards in URL category exception lists to easily configure a single entry to match to multiple website subdomains and pages, without having to specify exact subdomains and pages. 

Follow these guidelines when creating wildcard entries: 

- The following characters are considered token separators: . / ? & = ; + 

   - Every string separated by one or two of these characters is a token. Use wildcard characters as token placeholders, indicating that a specific token can contain any value. 

- In place of a token, use either an asterisk (*) or a caret (^) to indicate a wildcard value. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**145** 

Protect Traffic with Cloud NGFW for Azure 

- Wildcard characters must be the only character within a token. For example, www.gmail*.com would be invalid because the asterisk follows other characters. An entry can contain multiple wildcards, however. 

## **How to Use Asterisk (*) and Caret (^) Wildcards** 

**`*`** Use to indicate one or more variable subdomains. If you use **`*`** , the entry will match any additional subdomains, whether at the beginning or the end of the URL. Ex: • **`*.paloaltonetworks.com`** matches www.paloaltonetworks.com and www.paloaltonetworks.com.uk. • **`*.paloaltonetworks.com/`** matches www.paloaltonetworks.com but not www.paloaltonetworks.com.uk. **`^`** Use to indicate one variable subdomain. Ex: **`mail.^.com`** matches to mail.company.com but not mail.company.sso.com. 


![](images/fetchpdf-1780573081890.pdf-0146-04.png)


_**Do not create an entry with consecutive asterisk (*) wildcards or more than nine consecutive caret (^) wildcards—entries like these can affect firewall performance.**_ 

_For example, do not add an entry like_ _**`mail.*.*.com`** ; instead, depending on the range of websites you want to control access to, enter_ _**`mail.*.com`** or_ _**`mail.^.^.com`** . An entry like_ _**`mail.*.com`** matches to a greater number of sites than_ _**`mail.^.^.com`** ;_ _**`mail.*.com`** matches to sites with any number of subdomains and_ _**`mail.^.^.com`** matches to sites with exactly two subdomains._ 

## **URL Category Exception List—Wildcard Examples** 

The following table displays example URL list entries using wildcards and sites matching these entries. 

|**URL Exception List Entry**|**Matching Sites**|
|---|---|
|**Example Set 1**||
|*.company.com|eng.tools.company.com<br>support.tools.company.com<br>tools.company.com<br>docs.company.com|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**146** 

Protect Traffic with Cloud NGFW for Azure 

|**URL Exception List Entry**|**Matching Sites**|
|---|---|
|^.company.com|tools.company.com<br>docs.company.com|
|^.^.company.com|eng.tools.company.com<br>support.tools.company.com|
|**Example Set 2**||
|mail.google.*|mail.google.com<br>mail.google.co.uk<br>mail.google.example.org|
|mail.google.^|mail.google.com<br>mail.google.info|
|mail.google.^.^|mail.google.co.uk<br>mail.google.example.info|
|**Example Set 3**||
|site.*.com|site.yourname.com<br>site.abc.xyz.com|
|site.^.com|site.company.com<br>site.example.com|
|site.^.^.com|site.a.b.com|
|site.com/*|site.com/photos<br>site.com/blog/latest<br>any site.com subdirectory|



## Configure DNS Security 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**147** 

Protect Traffic with Cloud NGFW for Azure 

Domain Name Service (DNS) is a critical and foundational protocol of the internet, as described in the core RFCs for the protocol. Malicious actors have utilized command and control (C2) communication channels over the DNS and, in some cases, have even used the protocol to exfiltrate data. DNS exfiltration can happen when a bad actor compromises an application instance in your VPC and then uses DNS lookup to send data out of the VPC to a domain that they control. Malicious actors can also infiltrate malicious data and payloads to the VPC workloads over DNS. Palo Alto Networks Unit 42 research has described different types of DNS abuse discovered. 

Cloud NGFW for Azure allows you to protect your VPC traffic from advanced DNS-based threats, by monitoring and controlling the domains that your VPC resources query. With Cloud NGFW for Azure. You can deny access to the domains that Palo Alto Networks considers bad or suspicious and allow all other queries. 

Cloud NGFW uses the Palo Alto Networks DNS Security service which proactively detects malicious domains by generating DNS signatures using advanced predictive analysis and machine learning, with data from multiple sources (such as WildFire traffic analysis, passive DNS, active web crawling & malicious web content analysis, URL sandbox analysis, Honeynet, DGA reverse engineering, telemetry data, whois, the Unit 42 research organization, and Cyber Threat Alliance). DNS security service then continuously distributes these DNS signatures to your Cloud NGFW resources to proactively defend against malware using DNS for command and control (C2) and data theft. 

DNS Security for Cloud NGFW requires Panorama. Configure all DNS Security-related policy rules on Panorama and push them to Cloud NGFW resources as part of a Cloud Device Group. 

To inspect DNS traffic, you must enable DNS Proxy on your Cloud NGFW using the Azure portal. 

**STEP 1 |** Log in to the Azure portal. 

**STEP 2 |** Click the Cloud NGFW icon under Azure Services. 

**STEP 3 |** Select your Cloud NGFW instance. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**148** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 4 |** Enable DNS Proxy. 

1. Select **Settings** > **DNS Proxy** . 

2. Select the **Enabled** radio button. 

3. Use the default DNS server or select **Custom** and specify a DNS server previously configured in your virtual network. 

4. Click **Save** . 


![](images/fetchpdf-1780573081890.pdf-0149-06.png)


**STEP 5 |** Navigate to the local rulestack associated with your Cloud NGFW instance. **STEP 6 |** Select **Security Services** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**149** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 7 |** Enable **DNS Security** . 


![](images/fetchpdf-1780573081890.pdf-0150-02.png)


_Enabling DNS Security requires that you enable antispyware. Additionally, both DNS Security and antispyware must be set to best practices._ 


![](images/fetchpdf-1780573081890.pdf-0150-04.png)


## Add a Certificate to Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW uses certificates to enable outbound decryption. These certificates are stored in the Azure Key Vault. 


![](images/fetchpdf-1780573081890.pdf-0150-08.png)


- _Only self-signed and root CA signed certificates are currently supported for decryption. Chained certificates are not supported._ 


![](images/fetchpdf-1780573081890.pdf-0150-10.png)


_To add a certificate, familiarize yourself with how_ rulestacks _work._ 

- **STEP 1 |** Click the **Local Rulestacks** icon from the homepage and select a previously created rulestack on which you wish to create a certificate. 

- **STEP 2 |** Click **Certificates** on the left pane and click **Add** . The Add Certificate List pane opens. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**150** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 3 |** Enter a descriptive **Name** for your certificate. 

**STEP 4 |** ( optional) Enter a description for your certificate. 

- **STEP 5 |** If the certificate is self-signed, check **Self-Signed Certificate** . 

- **STEP 6 |** If the certificate isn't self-signed, then obtain the Certificate URI by navigating to **Azure key vault** > **Certificates** and copy-paste the Secret Identifier URI in **Certificate URI** . 

- **STEP 7 |** ( optional) In the **Certificate source** field, choose the respective option: **Select from Key vault** or **Paste URI** . 

- **STEP 8 |** Click **Add** . 

- **STEP 9 |** Create a managed identity in the same resource group as the Key Vault. See, Create a userassigned managed identity. 

**STEP 10 |** Navigate to **Azure Key Vault** > **Access Policies** . 

- **STEP 11 |** Click **Create** to configure an access policy that assigns **Key Vault Certificates Officer** and **Key Vault Secrets User** to the managed identity created in **step 9** . 

## Create Security Rules on Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Security rules protect network assets from threats and disruptions and help to optimally allocate network resources for enhancing productivity and efficiency in business processes. On Cloud NGFW for Azure, individual security rules determine whether to block or allow a session based on traffic attributes, such as the source and destination IP address, source and destination FQDNs, or the application. 

All traffic passing through the firewall is matched against a session and each session is matched against a rule. When a session match occurs, the NGFW applies the matching rule to bidirectional traffic in that session (client to server and server to client). For traffic that doesn’t match any defined rules, the default rules apply. 

Security policy rules are evaluated left to right and from top to bottom. A packet is matched against the first rule that meets the defined criteria and, after a match is triggered, subsequent rules are not evaluated. Therefore, the more specific rules must precede more generic ones in order to enforce the best match criteria. 

After creating a rulestack, you can now create rules and add them to your rulestack. 


![](images/fetchpdf-1780573081890.pdf-0151-16.png)


_To create security rules, familiarize yourself with how_ rulestacks _work._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**151** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 1 |** Click the **Local Rulestacks** icon from the homepage and select a previously-created rulestack on which you wish to add Rules. 

- **STEP 2 |** Click **Rules** and then click **Add** . 

- **STEP 3 |** In the general section, enter a descriptive **Name** for your rule. 

- **STEP 4 |** (Optional) Enter a **Description** of your rule. 

- **STEP 5 |** Set the **Rule Priority** . 

The rule priority determines the order in which the rules are evaluated. Rules with a lower priority are evaluated first. Additionally, each rule within a rulestack. 

- **STEP 6 |** By default, the security rule is **Enabled** . Uncheck **Enabled** to disable the rule. You can enable or disable a rule at any time. 

- **STEP 7 |** Set the **Source** . 

   1. Select **Any** , **Match** , or **Exclude** . 

      - Selecting **Any** means the traffic is evaluated against the rule regardless of source. 

   2. If you select **Match** , specify the IP Address (CIDR), Prefix List, Countries, Intelligent Feeds, or Dynamic Prefix List. 

**STEP 8 |** Set the **Destination** . 

   1. Select **Any** , **Match** , or **Exclude** . 

      - Selecting **Any** means the traffic is evaluated against the rule regardless of destination. 

   2. If you select **Match** , specify the Prefix List, FQDN List, Countries. 

- **STEP 9 |** Set Granular Control. 

   1. Choose **Any** or **Select** . 

When choosing **Any** , traffic is evaluated regardless of the application. By specifying an application(s), traffic is evaluated against the rule if the traffic matches the specified application. 

2. If you choose **Select** , specify the applications. 

**STEP 10 |** Set **URL Category** Granular Control. 

1. Choose **Any** or **Select** . 

When choosing **Any** , traffic is evaluated regardless of the URL. 

2. If you choose **Select** , Choose one of the **Predefined Categories** from the drop-down. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**152** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 11 |** Set **Port & Protocol** Granular Control. 

1. Choose **application-default** , **any** , or **Select** . 

When choosing **any** , traffic is evaluated regardless of the port and protocol. By specifying a port and protocol, traffic is evaluated against the rule if the traffic matches the specified port and protocol. 

2. If you choose **Select** , select the protocol from the drop-down and enter the port number. You can specify a single port number. 

## **STEP 12 |** Set **Actions** . 

1. Set the Action the firewall takes when traffic matches the rule— **Allow** , **Deny** , **Drop** , or **Reset both client and server** . 

2. Enable **Egress Decryption** . 

3. Enable **Logging** . 

## **STEP 13 |** Click **Add** . 

**STEP 14 |** After creating rules for your rulestack, validate or deploy your configuration. 

## Set Up Inbound Decryption on Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW uses SSL Inbound Decryption to inspect and decrypt inbound SSL/TLS traffic from a client to a targeted network server (any server you have the certificate for and can import onto the firewall) and block suspicious sessions. The firewall acts as a proxy between the external client and the internal server and generates a new session key for each secure session. The firewall creates a secure session between the client and the firewall and another secure session between the firewall and the server to decrypt and inspect the traffic. However, Cloud NGFW keeps your traffic packet headers and payload intact, providing complete visibility of the source’s identity to your applications in your VNets. 

You must concatenate the web certificate and private key as a single `pem` or `pfx` file and upload it to the Azure key vault  to perform SSL Inbound Inspection. The firewall validates that the certificate sent by the targeted server during the SSL/TLS handshake matches a certificate in your decryption policy rule. If there is a match, the firewall forwards the server's certificate to the client requesting server access and establishes a secure connection. 


![](images/fetchpdf-1780573081890.pdf-0153-15.png)


_Don’t upload the certificate and key separately to the Azure key vault._ 

**STEP 1 |** Select **Rulestacks** and select a previously created rulestack that to apply the certificate. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**153** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 2 |** Select **Rules** , then **Create** a new **Security Rule** for decryption. 

**STEP 3 |** Provide the following details under **General** . 

   - **Name** —Name of the rule. 

   - **Description** —A description for the rule. 

   - **Priority** —A unique priority for the rule. 

   - **Enabled** —Enable the field to associate the rulestack with the rule. This field is enabled by default. 

- **STEP 4 |** Define matching criteria for the **Source** and **Destination** IP address fields. 

- **STEP 5 |** Configure **Granular Controls** . 

   - Specify the **Application Match Criteria** you want the rule to allow or block. 


![](images/fetchpdf-1780573081890.pdf-0154-10.png)


_You can create TLS decryption rules with_ _**Applications** —_ _**Any** or_ _**SSL** —_ _**Match** only._ 

- Specify a **URL category** as the match criteria for the rule. 

- Specify the **Protocol and Ports** you want the rule to allow or block. 

- **Allow** —Allow traffic. 

- **Drop** —Block traffic and enforce the default **drop action** defined for the application being denied. 

- **Reset Server** —Sends the TCP reset to the server-side device. 

- **Reset Both** —Sends a TCP reset to both client and server-side devices. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**154** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 6 |** Under **TLS Decryption** , select **Inbound** and select an **Inbound Inspection Certificate** . 


![](images/fetchpdf-1780573081890.pdf-0155-02.png)



![](images/fetchpdf-1780573081890.pdf-0155-03.png)


- Create a certificate _if you have not done so already. The Azure Resource Name (ARN) of the secret is used in the certificate ARN when creating the certificate object._ 

- _PKCS8 is the supported certificate format._ 

- _Inbound decryption supports self-signed and root CA signed certificates and does not support chained certificates._ 

- _The decryption profile for TLS decryption is set to best practice Security policy. See_ decrypt traffic for full visibility and threat inspection _for more information._ 

**STEP 7 |** Select **Logging** to enable logging. 

**STEP 8 |** Click **Validate** . 

**STEP 9 |** Click **Config Actions>Deploy Configuration>Commit** to save the rule to the running configuration of the firewall. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**155** 

Protect Traffic with Cloud NGFW for Azure 

## Set Up Outbound Decryption on Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



With Outbound decryption, Cloud NGFW behaves like an SSL Forward Proxy, and uses its associated certificates to establish itself as a trusted third party (meddler in the middle (MitM)) for the client-server session. However, Cloud NGFW keeps your traffic packet headers and payload intact, providing complete visibility of the source’s identity to your destinations. 


![](images/fetchpdf-1780573081890.pdf-0156-04.png)


_Use PAN-OS version 11.0.x when using Azure key vault for outbound decryption._ 

Outbound decryption uses two certificate objects - Trust and Untrust. The NGFW presents the trust certificate to clients during SSL decryption if the client is attempting to connect to a server that has a certificate signed by a trusted certificate authority (CA). Alternatively, the NGFW presents the untrust certificate to the client attempting to connect to a server that has a certificate signed by a CA that the NGFW does not trust. 

You can configure the NGFW resource to decrypt the SSL traffic leaving your VNet or subnet. You can then enforce App-ID and security settings on the plaintext traffic, including Antivirus, Vulnerability, antispyware, URL Filtering, and file blocking profiles. After decrypting and inspecting traffic, the firewall reencrypts the plaintext traffic as it exits the firewall to ensure privacy and security. 

This procedure only defines the certificates that the firewall uses for Outbound TLS decryption. Enable Outbound TLS decryption during rules creation. 

**STEP 1 |** Select **Rulestacks** and select a previously created rulestack that to apply the certificate. 

## **STEP 2 |** Select **Encrypted Threat Protection** > **Egress Decryption** . 

**STEP 3 |** Select a certificate. 

- Select an **Untrust Certificate** . 

- Select a **Trust Certificate** . 


![](images/fetchpdf-1780573081890.pdf-0156-14.png)


Add a Certificate to Cloud NGFW for Azure _if you have not done so already._ 

The certificate and private key are stored in the Azure key vault, and the workload uses this information to decrypt the traffic. 

The certificate must be a CA certificate. Set the CA value in the Basic Constraints to TRUE. The following is an example private CA certificate. 

```
Certificate:
```

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**156** 

Protect Traffic with Cloud NGFW for Azure 

```
    Data:
        Version: 3 (0x2)
        Serial Number: 4121 (0x1019)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=US, ST=Washington, L=Seattle,
 O=Example Company Root CA, OU=Corp, CN=www.example.com/
emailAddress=corp@www.example.com
        Validity
            Not Before: Feb 26 20:27:56 2018 GMT
            Not After : Feb 24 20:27:56 2028 GMT
        Subject: C=US, ST=WA, L=Seattle, O=Examples Company
 Subordinate CA, OU=Corporate Office, CN=www.example.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:c0: ... a3:4a:51
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Subject Key Identifier:
 F8:84:EE:37:21:F2:5E:0B:6C:40:C2:9D:C6:FE:7E:49:53:67:34:D9
            X509v3 Authority Key Identifier:
```

```
 keyid:0D:CE:76:F2:E3:3B:93:2D:36:05:41:41:16:36:C8:82:BC:CB:F8:A0
```

```
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Key Usage: critical
                Digital Signature, CRL Sign
    Signature Algorithm: sha256WithRSAEncryption
         6:bb:94: ... 80:d8
```

If you're using an End-Entity certificate for decrypting traffic, only the End Entity Cert with public and private key is stored in the Azure key vault. 


![](images/fetchpdf-1780573081890.pdf-0157-05.png)


_PKCS8 is the supported certificate format._ 


![](images/fetchpdf-1780573081890.pdf-0157-07.png)


- _Trust certificates can’t be self-signed, but the untrust certificate can be self-signed or ca-signed._ 

**STEP 4 |** Navigate to the previously created **Rulestack** and go to the **Managed Identity** page. 

**STEP 5 |** From the **Enable MI** dropdown menu, select the managed identity that was associated with the key vault. 

- **STEP 6 |** Click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**157** 

Protect Traffic with Cloud NGFW for Azure 

## Panorama Policy Management 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



You can use a Panorama appliance to manage a shared set of security rules centrally on Cloud NGFW resources alongside your physical and virtual firewall appliances. You can also manage all aspects of shared objects and profiles configuration, push these rules, and generate reports on traffic patterns or security incidents of your Cloud NGFW resources, all from a single Panorama console. 

Panorama provides a single location from which you can have centralized policy and firewall management across hardware firewalls, virtual firewalls, and cloud firewalls, which increases operational efficiency in managing and maintaining a hybrid network of firewalls. 

## **How does integration work?** 

When you create a Cloud NGFW resource using the Azure Portal, you have the option to use Palo Alto Networks Panorama to manage your security policy rules. You can then manage a shared set of security rules centrally on Cloud NGFW resources you create alongside your physical and virtual firewall appliances, and you can use logging, reporting and log analytics, all from a single Panorama console. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**158** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0159-01.png)



![](images/fetchpdf-1780573081890.pdf-0159-02.png)


- _When a firewall reaches an unhealthy state and is disconnected, it's removed from Panorama after a period of time, typically three days. This ensures that the firewall isn’t deleted prematurely._ 

## **Integration Components** 

The following Palo Alto Networks components integrate your Cloud NGFW resource with Panorama. 

**Palo Alto Networks policy management** is the primary and mandatory component of the solution. Use a **Panorama** appliance to author and manage policy rules for your Cloud NGFW resources. The policy management component also helps to associate your authored policy rules and objects to multiple Cloud NGFW resources in different Azure regions. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**159** 

Protect Traffic with Cloud NGFW for Azure 

**Panorama Azure plugin** is a mandatory component of this solution. The Panorama Azure plugin enables you to create Cloud Device Groups and Cloud template stacks which help you manage policy rules and objects on NGFW resources linked with Panorama. 

**Cloud Device Groups (Cloud DG)** are special-purpose Panorama device groups that allow you to author rules and objects for Cloud NGFW resources. You create Cloud DGs using the Panorama Azure plugin web interface by specifying the Cloud NGFW resource and Azure region information. Cloud DG manifests as a global rulestack in that region. 

- You can create multiple Cloud Device Groups using the Panorama Azure plugin. 

- You can use the native Panorama web interface’s device group page to manage policy and object configurations in Cloud Device Groups and their associated objects and Security Profiles. 

- You can also use your existing shared objects and profiles in your existing Panorama device groups by referring to them in the security rules you create in your Cloud device groups. 

- Alternatively, you can add these Cloud Device groups to the device-group hierarchy you manage in your Panorama to inherit the device group rules and objects. If inherited rules 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**160** 

Protect Traffic with Cloud NGFW for Azure 

reference zones, these zones can be mapped to the zones applicable to Cloud NGFW — Public and Private, in the **Azure Plugin > Cloud NGFW > Cloud Device Group** . 


![](images/fetchpdf-1780573081890.pdf-0161-02.png)


- You can associate the same Cloud DG with multiple regions of the Cloud NGFW resource. This Cloud DG will manifest as a dedicated global rulestack in each Azure region of your Cloud NGFW resource. 

**Cloud template stacks (Cloud TS)** are special-purpose Panorama template stacks that allow your security rules in Cloud device groups to refer to object settings that Panorama allows you to manage using templates. When creating a Cloud DG, the Panorama Azure plugin enables you to create or specify a Cloud template stack. The plugin automatically creates this Cloud TS and adds it to the Cloud device group as a reference template stack. From now on, you can use the native Panorama web interface’s template stack page to configure your templates and add them to these Cloud template stacks. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**161** 

Protect Traffic with Cloud NGFW for Azure 

- Palo Alto Networks Cloud NGFW service manages most device and network configurations in your Cloud NGFW resources. Therefore, Cloud NGFW will ignore infrastructure settings such as interfaces, zones, and routing protocols if you have configured them in templates added to the Cloud TS. 

- Cloud NGFW currently honors Certificate management and log settings in your templates as referenced by the Cloud DG configuration. It ignores all other settings. 


![](images/fetchpdf-1780573081890.pdf-0162-03.png)


_You don’t assign managed devices to Cloud Device Groups and Cloud template stacks ._ 

## **Integration steps** 

There are a few steps to integrate Cloud NGFW with Panorama. You first prepare your Panorama virtual appliance for this integration by installing the Azure plugin. Once you have successfully linked Cloud NGFW, use Panorama to manage security objects and rules. 

To integrate the Cloud NGFW service with your Panorama virtual appliance: 

- Verify Panorama meets the Panorama Integration Prerequisites. 

- Link Panorama to the Cloud NGFW. After linking use Panorama for Cloud NGFW policy management. 

## Panorama Integration Prerequisites 

## **Where Can I Use This?** 

## **What Do I Need?** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



To integrate the Cloud NGFW service with your Panorama virtual appliance: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**162** 

Protect Traffic with Cloud NGFW for Azure 

- Setup Panorama. 

   - The recommended Panorama version is 11.2 or above. Specific version requirements are phased based on your current deployment status: 

      - **Net New Customers (Effective January 2026)** : Panorama version 11.2 or above is required for deployment. 

      - **Existing Customers (Currently running 10.2 or above)** : You may continue to operate on your current version until a mandatory upgrade is announced. 

         - **Action Required** : You will be required to upgrade to 11.2 or above within 60 days of receiving an official notification. 

         - **Timeline** : Notifications are anticipated to begin around **February 2026** (via email and the What's New page). 

      - Existing Customers (Already running 11.2 or above): No action is required 


![](images/fetchpdf-1780573081890.pdf-0163-08.png)


- _Upgrading to PAN-OS version 11.2.7 resolves an issue where Cloud NGFW devices were included in the Panorama licenses device count._ 

_Panorama versions_ _**12.0** and_ _**12.1** are currently not supported._ 

- Use the Azure plugin for Cloud NGFW version 5.2.3 or above. 

- Ensure you have a registered Panorama installed with licenses with the necessary capacity to support your Cloud NGFW for Azure deployment and activated using the support license on the Customer Support Portal (CSP). 


![](images/fetchpdf-1780573081890.pdf-0163-13.png)


   - _You must install the_ device certificate _on the Panorama management server to successfully authenticate Panorama with the Palo Alto Networks Customer Support Portal (CSP) and leverage one or more_ cloud service _._ 

- Ensure you are a member of the Palo Alto Networks Customer Support Portal (CSP) account where your Organization has registered the Panorama appliance. 


![](images/fetchpdf-1780573081890.pdf-0163-16.png)


_The email used to register with the CSP account should be used for the Cloud NGFW and Panorama integration. If this email differs, you will not be able to configure Cloud NGFW and integrate with Panorama._ 

- Ensure you have a Panorama Administrator role on your Panorama. 

- Ensure that your network allows traffic that target the following ports to your Panorama virtual appliance to ensure communication between Cloud NGFW and Panorama: 3978, 28443, 28270. 


![](images/fetchpdf-1780573081890.pdf-0163-20.png)


_Consider the following when integrating your Cloud NGFW resource with Panorama:_ 

- _If you add a log collector after deploying the Cloud NGFW resource you must redeploy it._ 

- _If you change the Panorama IP address must also redeploy it._ 

## **Connectivity Scenarios** 

In addition to the items listed above, you must also consider how your Cloud NGFW resources connect to Panorama. To manage Cloud NGFW policy using Panorama, Panorama must have 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**163** 

Protect Traffic with Cloud NGFW for Azure 

connectivity with your VNet. However, depending on your network topology, connectivity between Panorama and your VNet is enabled differently. 

- **Private Network Access with Panorama Private IP** —you can deploy Panorama directly in your hub VNet private subnet or in another VNet peered with the Cloud NGFW VNet. 

   - When deployed directly in your hub VNet private subnet, Panorama connects directly with your Cloud NGFW resources because they are in the same subnet. When you deploy Panorama in a VNet peered with the private subnet of the hub VNet associated with Cloud NGFW, VNet peering enables the Cloud NGFW resource to reach the Panorama private IP address. 

- **On-Prem Panorama Access via VPN** —if your Panorama instance is deployed on-premises, Cloud NGFW resources can reach Panorama's private IP address through a VPN. Additionally, this scenario supports VNet peering. 

In this scenario, Panorama is deployed in your on-premises network and uses a VPN gateway connection directly to the Cloud NGFW hub VNet or to a hub VNet peered with the Cloud NGFW hub VNet. In each case, the hub VNet must have a route that pointing the VPN tunnel with Panorama's private IP address as the destination. See Configure VPN gateway transit for virtual network peering for more information about configuring this setup. 

- **Panorama Public IP Access via the internet** —if there is no VNet peering, VPN, or VWAN connectivity between Panorama and your Cloud NGFW hub VNet, your Cloud NGFW resources can connect to Panorama's public IP address over the internet. To allow this connectivity, you must create a Network Security Group rule in Azure to allow inbound traffic from the Cloud NGFW public IP address to Panorama the ports used by Panorama. 

- **Access Panorama from Anywhere (VWAN)** —Cloud NGFW for Azure is deployed as a managed SaaS service in the Azure VWAN, so it is able to secure all traffic going through the VWAN hub. Your Cloud NGFW resources can connect to the private IP address of a Panorama instance deployed at any location connected to your VWAN hub. 


![](images/fetchpdf-1780573081890.pdf-0164-08.png)


- _If your Azure VWAN deployment has a Network Security Group for east-west traffic, you must create a Network Security Group rule allowing inbound traffic from the Cloud NGFW resource private IP address to the Panorama private IP address._ 

## **Important Considerations** 

Configuring **Permitted IP Addresses** under **Panorama** > **Setup** > **Management** is **not supported** for Cloud NGFW for Azure resources. 

The management interface for a Cloud NGFW resource is used exclusively for management by Palo Alto Networks. This interface is fully managed and secured by Palo Alto Networks, and therefore does not require or support user-defined IP access controls. 

## Link to Panorama Policy Management 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**164** 

Protect Traffic with Cloud NGFW for Azure 

**Where Can I Use This? What Do I Need?** 


![](images/fetchpdf-1780573081890.pdf-0165-02.png)


Azure Marketplace subscription 

To link your Cloud NGFW resource to Panorama for policy management: 

**1.** Prepare your environment. 

**2.** Create a Cloud Device Group. 

**3.** Generate a registration string. 


![](images/fetchpdf-1780573081890.pdf-0165-08.png)


_After completing these steps you can start using Panorama for policy management._ 

## **Create a Cloud Device Group** 

After preparing your environment for integration, you can link your Cloud NGFW to the Panorama virtual appliance and start using policy management. You start by creating a Cloud Device Group. 

With Panorama, you group firewalls in your network into logical units called _device groups_ . A device group enables grouping based on network segmentation, geographic location, organizational function, or any other common aspect of firewalls requiring similar policy configurations. 

Using device groups, you can configure policy rules and the objects they reference. Organize device groups hierarchically, with shared rules and objects at the top, and device group-specific rules and objects at subsequent levels. This enables you to create a hierarchy of rules that enforce how firewalls handle traffic. 


![](images/fetchpdf-1780573081890.pdf-0165-14.png)


_See_ Manage Device Groups _for more information._ 

To add a cloud device group and template stack using the Panorama console: 

**STEP 1 |** In the Panorama console, select **Panorama** . 

- **STEP 2 |** In the navigation tree, select the **Azure** plugin. 

- **STEP 3 |** Expand the Azure plugin to display configuration options. Select **Cloud NGFW** to display the Cloud Device Group screen. If the Cloud NGFW option does not appear, verify that you 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**165** 

Protect Traffic with Cloud NGFW for Azure 

have installed the Azure plugin successfully; select **Panorama** > **Plugins** to display the list of installed plugins. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**166** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0167-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**167** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 4 |** In the lower left portion of the Panorama console, click **Add** to create a new Cloud Device Group. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**168** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 5 |** In the Cloud Device Group screen: 


![](images/fetchpdf-1780573081890.pdf-0169-02.png)


1. Enter a unique **Name** for the cloud device group. 

2. Enter a **Description** . 

3. Use the drop-down menu to select the **Parent Device Group** . By default, this value is shared. 

4. Select the Template Stack from the drop-down menu. Or, click **Add** to create a new one. You cannot change the template stack name after deploying the Cloud NGFW. 

5. Select the **Panorama IP** address used by the deployment. The drop-down menu allows you to select either the _private_ or _public_ IP address. 

6. Optionally select the Panorama HA **Peer IP** address. 

7. Optionally use the drop-down menu to select the Collector Group. 

8. Provide the **PIN ID** . This value is provided by the Customer Support Portal. 

9. If you have not yet registered your Cloud NGFW serial number with your Customer Support Portal (CSP) account, you can optionally provide the PIN ID and PIN Value. You can obtain the required PIN ID from the Customer Support Portal. 


![](images/fetchpdf-1780573081890.pdf-0169-12.png)


_The PIN ID should have an expiration of one year. This is optional if you have already registered the Cloud NGFW serial number. If it is not already registered, register your Cloud NGFW using the serial number in for the same CSP account where you registered your Panorama virtual appliance._ 

10. To retrieve the PIN ID and PIN Value, log into the **Customer Support Portal** as a registered user. 

11. On the Customer Support Portal page, select **Assests** > **Device Certificates** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**169** 

Protect Traffic with Cloud NGFW for Azure 

12. On the **Device Certificate** page, select **Generate Registration PIN** for the VM-Series firewall. 


![](images/fetchpdf-1780573081890.pdf-0170-02.png)


13. Copy the newly created registration IDs, and paste it into the **PIN ID** and **PIN Value** field in the Cloud Device Group screen. 

14. Confirm the PIN ID and PIN Value. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**170** 

Protect Traffic with Cloud NGFW for Azure 

15. Alternatively, you can add Cloud Device Groups to the device-group hierarchy you manage in your Panorama to inherit the device group rules and objects. If inherited rules reference zones, these zones can be mapped to the zones applicable to Cloud NGFW — Public and Private, in the **Azure Plugin > Cloud NGFW > Cloud Device Group** . Consider that only inherited zones from the parent device group can be used; applicable zones are populated (and matched) to either private or public zones only. The Cloud NGFW resource does not see the original zone; only the private or public zone pushed from Panorama are visible. 


![](images/fetchpdf-1780573081890.pdf-0171-02.png)


Source policy defines the source zone or source address from which the traffic originates. For **Source Zone** , you can select **Private** , **Public** , or **Loopback** . If you are 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**171** 

Protect Traffic with Cloud NGFW for Azure 

configuring the destination zone, select **Private** , **Public** or **Loopback** , depending on your destination. 

16. Click **OK** . 

17. Commit your change in the Panorama console to create the cloud device group. Next, Generate the registration string to create the Cloud NGFW resource and deploy in Azure. 


![](images/fetchpdf-1780573081890.pdf-0172-04.png)



![](images/fetchpdf-1780573081890.pdf-0172-05.png)


- _In some cases, you may experience a validation error when configuring a Cloud Device Group. To resolve this issue, ensure that the Azure Plugin for Panorama is properly installed using administrator credentials. For HA environments, install the plugin on the secondary node, then install the plugin on the primary node._ 

## **Generate the registration string to create the Cloud NGFW and deploy in Azure** 

After you commit the change to create the cloud device group, you can generate the registration string. This string is used to create and deploy the Cloud NGFW in Azure. 

To retrieve the PIN: 

**STEP 1 |** In the Panorama console, locate the Cloud Device Group you created in the previous section. 

- **STEP 2 |** In the Registration String field, click **Generate** . 


![](images/fetchpdf-1780573081890.pdf-0172-12.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**172** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 3 |** Select **Copy Registration String** . 


![](images/fetchpdf-1780573081890.pdf-0173-02.png)


After copying the registration string, access Azure Marketplace to create a Cloud NGFW resource. 

**STEP 4 |** In Azure Marketplace, select **Cloud NGFWs** . 


![](images/fetchpdf-1780573081890.pdf-0173-05.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**173** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 5 |** Click **+ Create** to create a new Cloud NGFW resource. 


![](images/fetchpdf-1780573081890.pdf-0174-02.png)


## **STEP 6 |** Follow the setup instructions to **Create Palo Alto Networks Cloud NGFW** . 

1. Configure Basic information. 

2. Configure Networking. 

3. Configure Security Policies. In the **Manged by** section, select **Palo Alto Networks Panorama** . 


![](images/fetchpdf-1780573081890.pdf-0174-07.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**174** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 7 |** After selecting **Managed by Palo Alto Networks Panorama** , the Security Policies page changes to include the **Panorama Registration String** field. Enter the registration string you copied in Step 3 above. 


![](images/fetchpdf-1780573081890.pdf-0175-02.png)


- **STEP 8 |** Continue creating the Cloud NGFW resource by specifying information for DNS Proxy, Tags, and Terms. Review your configuration, then click **Create** . 

Creating a Cloud NGFW resource may take approximately 10-15 minutes. 

The Panorama console is now linked to the Cloud NGFW resource. 

## Update your Panorama Registration 

## **Where Can I Use This? What Do I Need?** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**175** 

Protect Traffic with Cloud NGFW for Azure 

You can modify the Panorama parameters after you have registered the Cloud NGFW with Panorama. You generate a new registration string in Panorama and update your Cloud NGFW resource when you make the following changes: 

**1.** Migrate a Cloud NGFW resource from one Panorama to another Panorama. 

**2.** Add a log collector to Panorama after deploying the Cloud NGFW resource. 

**3.** Move the Cloud NGFW to a different cloud device group. 

**4.** Modify the Panorama IP address after deploying the Cloud NGFW resource. 

**5.** Enable or disable Strata Logging Service (SLS) for an existing Panorama-managed firewall. 

**6.** Handle changes in the Panorama serial number or its association with SLS. 

Consider the following: 

- The update process for SLS configuration changes does not involve a rolling upgrade of the firewall instances. This allows for seamless updates without traffic interruption. 

- Palo Alto Networks recommends that you don’t push any configuration changes in Panorama to ensure consistency across all Cloud NGFW resources during the update process. 

- The feature currently supports updates to the Panorama IP address, a cloud device group, a template stack, a log collector, and the Strata Logging Service configuration. 

- The update process may take long for deployments containing a large number of firewall instances to ensure thorough validation and a smooth transition. 


![](images/fetchpdf-1780573081890.pdf-0176-13.png)


- _You can generate a new registration string and update the firewall. Enable SLS support for existing Panorama-managed firewalls and handle changes in Panorama serial numbers or its association with SLS, and you can also disable SLS for a firewall._ 

_When a Cloud NGFW for Azure instance is scaled in, a_ _**72-hour** grace period begins before the device is removed from Panorama._ 

## **Requirements** 

To simplify onboarding with your Cloud NGFW resource, you’ll need the following: 

- Panorama versions 10.2, 11.0, 11.1, 11.2 or later. 

- Azure plugin for Cloud NGFW version 5.2.3 or greater. 

## **Generate a New Registration String** 

You’ll need to generate a new Panorama registration string from your Panorama instance to update your Panorama registration in the Azure Portal by following these steps: 

**STEP 1 |** Log into Panorama. 

**STEP 2 |** Select the **Panorama** tab in the upper portion of the web interface. 

- **STEP 3 |** In the **Azure** plugin section, select **Cloud NGFW** . Previously created Cloud Device Groups appear if they were established for the Cloud NGFW resource using Azure. 

- **STEP 4 |** Select the **Cloud Device Group** and make any necessary changes. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**176** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 5 |** Click **Generate** to display the registration string, then **commit** your changes. 


![](images/fetchpdf-1780573081890.pdf-0177-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**177** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 6 |** In the **Registration String** screen, click **Copy Registration String** . 


![](images/fetchpdf-1780573081890.pdf-0178-02.png)


**STEP 7 |** Log in to the Azure Portal. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**178** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 8 |** Select the Cloud NGFW, then navigate to **Settings > Security Policies** to update the generated configuration string. 


![](images/fetchpdf-1780573081890.pdf-0179-02.png)


The system automatically processes the update then creates a dry-run instance to validate the changes before applying them to your firewall instances through a rolling upgrade process. 

If the dry-run process fails: 

- Changes revert to the previous configuration, and any scale-out picks up the previous configuration. 

- The Panorama web interface indicates that **Health Status** is **Degraded** , and the **Provision Status** indicates a **Accepted** or **Succeeded** . 

If the dry run succeeds, the rolling upgrade process for the existing firewall begins: 

- The **Health Status** appears as **Healthy** . 

- Incremental firewall resources are picked up by the rolling upgrade process; with 20% of the resources updated. The remaining 80% continue to process traffic. 

- If any failures occur during the rolling upgrade process, the Palo Alto Networks support team is alerted. 

The following table illustrates the states associated with the **Health Status** : 

|**Config String Update**|**Provision State**|**Health Status**|**Health Reason**|
|---|---|---|---|
||Accepted|Degraded|• Config string<br>verification<br>failed - not able|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**179** 

Protect Traffic with Cloud NGFW for Azure 

||||to connect to<br>Panorama<br>• Unable to apply<br>config string to<br>FW - not able<br>to connect to<br>Panorama|
|---|---|---|---|
||Succeeded|Healthy|Config string<br>successfully applied|



## **Generate a New Registration String to Update Firewall for SLS** 

To enable, disable, or modify the Strata Logging Service (SLS) for an existing firewall, you will need to generate a new Panorama registration string from your Panorama instance and update your Cloud NGFW resource in the Azure Portal. 

## **Prerequisites:** 

- You have an existing Panorama-managed Cloud NGFW for Azure. 

- You have access to your Panorama appliance and the Azure portal. 

To generate a new registration string to update firewall for SLS, do the following: 

- **STEP 1 |** Log into Panorama and navigate to the appropriate settings to generate a new registration string. This may involve associating or disassociating the Panorama with an SLS instance. 

- **STEP 2 |** Copy the new registration string from Panorama. 

- **STEP 3 |** Log in to the Azure Portal and navigate to your Cloud NGFW resource. 

- **STEP 4 |** Go to **Settings** > **Security Policies** . 

- **STEP 5 |** Paste the new registration string into the Panorama Registration String field. 

- **STEP 6 | Save** the changes. The firewall will then be updated with the new SLS configuration. After the update, you can verify the firewall's health status. A healthy status indicates that the SLS configuration has been successfully applied. If there are any configuration issues, such as a mismatch between the Panorama and SLS association, the firewall status will show as **Degraded** with an error message detailing the issue. 

## **Migrate a Panorama Instance** 

Use this procedure to migrate one Panorama instance to another Panorama: 

- **STEP 1 |** Log in to your _first_ Panorama instance. 

- **STEP 2 |** Select **Panorama>Setup>Operations** and click **Save named Panorama configuration snapshot** . 

- **STEP 3 |** Select **Panorama>Setup>Operations** and click **Export named Panorama configuration snapshot** . Save the file with a .XML extension. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**180** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 4 |** Log in to your _second_ Panorama instance. 

- **STEP 5 |** Select **Panorama>Setup>Operations** and click **Import named Panorama configuration snapshot** ; load the file you previously created in step 3. 

- **STEP 6 |** Select **Panorama>Setup>Operations** and click **Load named Panorama configuration snapshot** . 

- **STEP 7 |** Generate the registration string and update the existing firewall. 

## Add or Delete a Cloud Device Group 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



After linking your Cloud NGFW resource to the Panorama virtual appliance you can start using the integration for policy management tasks, such as adding or deleting Cloud Device Groups. 


![](images/fetchpdf-1780573081890.pdf-0181-08.png)


_See_ Manage Device Groups _for more information._ 

## **Add a Cloud Device Group** 

After linking your Cloud NGFW resource to the Panorama virtual appliance you can start using the integration for policy management tasks, such as adding device groups and applying policy rules to the device group. 

With Panorama, you group firewalls in your network into logical units called _device groups_ . A device group enables grouping based on network segmentation, geographic location, organizational function, or any other common aspect of firewalls requiring similar policy configurations. 

Using device groups, you can configure policy rules and the objects they reference. Organize device groups hierarchically, with shared rules and objects at the top, and device group-specific rules and objects at subsequent levels. This enables you to create a hierarchy of rules that enforce how firewalls handle traffic. 

To add a cloud device group using the Panorama console: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**181** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 1 |** In the **Azure** plugin, select **Cloud NGFW** . 

The Cloud Device Group table is empty when you first select it. Previously created cloud device groups appear if they were established for the Cloud NGFW resource using Azure. 


![](images/fetchpdf-1780573081890.pdf-0182-03.png)


**STEP 2 |** Click **Add** in the lower left corner. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**182** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 3 |** In the **Cloud Device Group** screen: 


![](images/fetchpdf-1780573081890.pdf-0183-02.png)


1. Enter a unique **name** for the cloud device group. 

2. Enter a **description** . 

3. Use the drop-down to select the **Parent Device Group** . By default, this value is shared. 

4. Select the Template Stack from the drop-down. Or, click **Add** to create a new one. 

5. Select the **Panorama IP** address used by the deployment. The drop-down allows you to select either the _private_ or _public_ IP address. 

6. Optionally select the Panorama HA **Peer IP** address. 

7. Optionally use the drop-down to select the Collector Group. 

8. Optionally configure Zone Mapping for the Cloud Device Group. Only two zones are supported: _public or private_ . 

9. Click **OK** . 

10. Commit your change in the Panorama console to create the cloud device group. Next, Generate the registration string to create the Cloud NGFW resource and deploy in Azure. 


![](images/fetchpdf-1780573081890.pdf-0183-13.png)


## **Delete a Cloud Device Group** 

Use the Panorama console to delete a cloud device group. You can only delete a cloud device group if there are no firewalls attached to it. 

To delete a cloud device group from a resource using the Panorama console: 

**STEP 1 |** In **Panorama** , select **Cloud Device Groups** . 

**STEP 2 |** Select the **Cloud Device Group** you want to remove. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**183** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 3 |** In the lower portion of the Panorama console, click **Delete** . 


![](images/fetchpdf-1780573081890.pdf-0184-02.png)


**STEP 4 |** Click **Yes** to confirm the deletion. 

**STEP 5 |** Commit the change. 

## Apply Policies 

## **Where Can I Use This?** 

## **What Do I Need?** 

- Cloud NGFW for Azure Cloud NGFW subscription 


![](images/fetchpdf-1780573081890.pdf-0184-09.png)



![](images/fetchpdf-1780573081890.pdf-0184-10.png)


- Palo Alto Networks Customer Support Portal account 

Azure Marketplace subscription 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**184** 

Protect Traffic with Cloud NGFW for Azure 

After linking your Cloud NGFW resource to the Panorama virtual appliance you can start using the integration for policy management tasks, applying policies to your Cloud NGFW for Azure resource. 


![](images/fetchpdf-1780573081890.pdf-0185-02.png)


_For more information, see_ Defining Policies on Panorama _._ 

## **Apply Policy** 

Cloud Device Groups on Panorama allow you to centrally manage firewall policy rules. You create policy rules on Panorama either as pre-rules or post-rules. These rules allow you to create a layered approach for implementing policy. 

To configure policy rules for the cloud device group in Panorama: 

- **STEP 1 |** Select **Policies** . 

- **STEP 2 |** In the **Device Group** section, use the drop-down to select the **Cloud Device Group** previously created. 


![](images/fetchpdf-1780573081890.pdf-0185-09.png)


When you create a device group for Cloud NGFW, the name begins with _cngfw_ . For example, _cngfw-azure-demo_ 

**STEP 3 |** In the lower left portion of the console, click **Add** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**185** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 4 |** In the Security Policy Rule screen, configure elements of the policy you want to apply to the device group. 

   1. In the **General** tab, include a name for the policy. Optionally provide additional information. 

   2. **Source** policy defines the source zone or source address from which the traffic originates. For **Source Zone** , click **Any** . You can't add a specific source zone. 


![](images/fetchpdf-1780573081890.pdf-0186-04.png)


Continue applying **Source** policy rules by including the **Source Address** . Click **Any** , or use the drop-down to select an existing address, or use options to add a new address or address group. 


![](images/fetchpdf-1780573081890.pdf-0186-06.png)


For **Source User** and **Source Device** policy, click **Any** . Cloud NGFW does not support specifying specific source users or source devices. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**186** 

Protect Traffic with Cloud NGFW for Azure 

3. **Destination** policy defines the destination zone or destination address for the traffic. Use the drop-down to select an existing address, or use the options to add a new address or address group. The Destination policy includes fields for the zone, address, and device. 

For the **Destination Zone** , click **Any** . Cloud NGFW does not support adding individual destination zones. 

For the **Destination Address** , click **Any** , or use the drop-down to select an existing zone. Click **New** to add a new address, address group, or region. 

For the **Destination Device** , click **Any** . Cloud NGFW does not support adding individual destination devices. 


![](images/fetchpdf-1780573081890.pdf-0187-05.png)


4. Configure an **Application** policy to have the policy action occur based on an application or application group. An administrator can also use an existing App-ID signature and 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**187** 

Protect Traffic with Cloud NGFW for Azure 

customize it to detect proprietary applications or to detect specific attributes of an existing application. Custom applications are defined in **ObjectsApplications** . 

In the **Application** screen, click Any, or specify a specific application, like SSH. Click **Add** to include a new application policy. 


![](images/fetchpdf-1780573081890.pdf-0188-03.png)


5. Configure **Service/URL Category** policy rules for the firewall to specify a specific TCP or UDP port number or a URL category as match criteria in the policy. Specify **Service** level policy rules or **URL Category** policy rules by selecting **Any** , or use the drop-down options to individually select the policy elements you want to apply. Click **Add** to create new policy rules for Service or URL/Category. 


![](images/fetchpdf-1780573081890.pdf-0188-05.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**188** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 5 |** After applying policy rules to the cloud device group for the Cloud NGFW resource and committing the change, push the changes. In the **Push to Devices** screen, click **Edit Selections** . 


![](images/fetchpdf-1780573081890.pdf-0189-02.png)


**STEP 6 |** Select the cloud device groups you want to push to the resources, and click **OK** , then click **Push** . 

## Enable Data Redistribution on Cloud NGFW for Azure 

Cloud NGFW protects your Azure vNet and Azure virtual WAN traffic with advanced user awareness. The user identity, as opposed to an IP address, is an integral component of an effective security infrastructure. Knowing who is accessing each of the applications on your network, and who may have transmitted a threat or is transferring files, can strengthen security policies and reduce incident response times. User-ID[™] , a standard feature on the Palo Alto Networks firewalls, enables you to leverage user information stored in a wide range of repositories. To learn more about User-ID concepts, User-ID overview. 

To enforce policy from User-ID or Groups: 

- Firewall must be able to map the IP addresses to the user names. 

- User-ID provides various mechanisms for collecting the user mapping information. To learn more, see User-ID Concepts. 

If the mapping methods are unable to capture the mapping, then you can configure the Authentication Policy to redirect users to an Authentication portal login. Users can provide credentials which will be checked against the identity provider and enforce access accordingly. Learn more about authentication policy. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**189** 

Protect Traffic with Cloud NGFW for Azure 

To enable a Users—and group-based policy, the firewall requires a list of all available users and their corresponding group memberships. 

You can enable User-ID on Cloud NGFW for Azure using the following methods: 

- Enable User-ID with PAN-OS Integrated Agent 

- Enable User-ID with Windows-based User-ID Agent 

- Enable User-ID with Cloud Identity Engine (CIE) 

- Enable User-ID Redistribution with Panorama 

## **Enable User-ID with PAN-OS Integrated Agent** 

## **Prerequisites:** 

- Active Directory (AD) environment with users and groups. 

- Cloud NGFW for Azure deployed and managed via Panorama. 

- Dedicated Service account with Remote Management User and CIMV2 privileges. 

- Windows server configured for WinRM over HTTPS with Basic Authentication. For more information, see Configure server monitoring using WinRM. 

- Security policies on Cloud NGFW to allow communication to active directory or LDAP servers. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**190** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 1 |** Import Root Certificate. 


![](images/fetchpdf-1780573081890.pdf-0191-02.png)


In Panorama, go to **Device** > **Certificate Management** > **Certificates** , import the root certificate. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**191** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Add Certificate Profile. 

1. In Panorama, go to **Device** > **Certificate Management** > **Certificates** . 

2. Create a profile using the imported certificate. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**192** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0193-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**193** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 3 |** Add Certificate Profile to User-ID Connection Security. 

   1. In Panorama, go to **Device** > **User Identification** > **User Mapping** . 

   2. Edit User-ID Connection Security and assign the certificate profile. 


![](images/fetchpdf-1780573081890.pdf-0194-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**194** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 4 |** Configure Server Monitor Account. 

   1. In Panorama, go to **Device** > **User Identification** > **User Mapping** . 

   2. Provide the service account username/password for active directory. 


![](images/fetchpdf-1780573081890.pdf-0195-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**195** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 5 |** Configure Server Monitoring (WinRM-HTTPS). 

   1. In Panorama, go to **Device** > **User Identification** > **User Mapping** > **Server Monitoring** . 

   2. Select Microsoft Active Directory as **type** , WinRM-HTTPS as **transport protocol** , and **Network Address** as your Windows server address where you have an active directory configured. 


![](images/fetchpdf-1780573081890.pdf-0196-04.png)


The Cloud NGFW for Azure supports IP-to-user mapping using the Windows User-ID agent or Terminal Server Agent. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**196** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 6 |** Enable User-ID on Cloud NGFW Interfaces. 


![](images/fetchpdf-1780573081890.pdf-0197-02.png)


   - _As a best practice, always specify which networks to include and exclude from User-ID. This allows you to ensure that only your trusted assets are probed and that unwanted user mappings are not created unexpectedly._ 

1. Select **Network** > **Zones** and select Zone where you're configuring User-ID. 

2. Add your networks to **Include** and **Exclude** lists as needed. 

3. Click **OK** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**197** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0198-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**198** 

Protect Traffic with Cloud NGFW for Azure 

On your Cloud NGFW device group, enable User-ID for both Private and Public zones. 


![](images/fetchpdf-1780573081890.pdf-0199-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**199** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 7 |** Configure Service Route to LDAP Server. 

   1. In Panorama, go to **Device** > **Setup** > **Services** > **Service Route Configuration** . 


![](images/fetchpdf-1780573081890.pdf-0200-03.png)


2. Select LDAP as **Service,** loopback.3 as **Source interface,** and active directory IP address as **Source address** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**200** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0201-01.png)


## 3. **Commit** your changes. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**201** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0202-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**202** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 8 |** Configure LDAP Server Profile. 

1. In Panorama, go to **Device** > **Server Profiles** > **LDAP** , add LDAP profile. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**203** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0204-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**204** 

Protect Traffic with Cloud NGFW for Azure 

2. Use Base DN and Bind DN from AD (get via ADSI Edit). 


![](images/fetchpdf-1780573081890.pdf-0205-02.png)


3. Provide Bind DN password. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**205** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0206-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**206** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 9 |** Configure Group Mapping. 

1. In Panorama, go to **Device** > **User Identification** > **Group Mapping** . 

2. Add using the created LDAP profile. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**207** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0208-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**208** 

Protect Traffic with Cloud NGFW for Azure 

For more information, see Configure User Mappings Using the Windows User-ID Agent and Configure User Mappings for Terminal Server Users 

## **STEP 10 |** Configure User-ID Master Device. 

In the Cloud NGFW device group, select the User-ID Master Device (choose one backend instance). 


![](images/fetchpdf-1780573081890.pdf-0209-04.png)


## **STEP 11 | Commit** your changes. 

## **Enable User-ID with Windows-based User-ID Agent** 

## **Prerequisites:** 

- Active Directory (AD) environment with users and groups. 

- Cloud NGFW for Azure deployed and managed via Panorama. 

- Dedicated Service account with Remote Management User and CIMV2 privileges. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**209** 

Protect Traffic with Cloud NGFW for Azure 

- Windows-based User-ID agent installed and configured. 

- Security Policy on Cloud NGFW to allow communication with LDAP/Windows server with Active directory. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**210** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 1 |** Enable User-ID on Cloud NGFW Interfaces. 

1. In Panorama, go to **Network** > **Zones** and select the Zone where you're configuring User-ID. 

2. Add your networks to **Include** and **Exclude** lists as needed. 

3. Click **OK** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**211** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0212-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**212** 

Protect Traffic with Cloud NGFW for Azure 

On your Cloud NGFW device group, enable User-ID for both Private and Public zones. 


![](images/fetchpdf-1780573081890.pdf-0213-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**213** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Configure User-ID Agent as Data Redistribution Agent. 

In Panorama, go to **Device** > **Data distribution.** Configure your User-ID Agent as data redistribution agent. 


![](images/fetchpdf-1780573081890.pdf-0214-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**214** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 3 |** Configure Service Route for User-ID Agent. 

   1. Go to **Setup** > **Services** > **Service Route Configuration** . 


![](images/fetchpdf-1780573081890.pdf-0215-03.png)


2. Configure with source interface as **loopback.3** . 

3. Add Firewall policy to allow communication towards User-ID Agent windows server. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**215** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 4 |** Verify User-ID Agent Configuration. 

   1. On the Windows server, click **Edit** to open User-ID Agent. 


![](images/fetchpdf-1780573081890.pdf-0216-03.png)


2. Add service account username and password. 


![](images/fetchpdf-1780573081890.pdf-0216-05.png)


   - _Ensure that you have the appropriate User-ID service port (5007 by default) configured._ 

3. Configure the discovery of your active directory domain (Auto-Discover if on the same server). If you have an active directory within the same server where you have User-ID Agent installed, you can use the **Auto Discover** option. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**216** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0217-01.png)


4. **Commit** your changes. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**217** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0218-01.png)


You will be able to see the Agent status as running and the connected servers. Ensure that you disable Windows firewall on this windows server to allow communication from CNGFW to this UID Agent. 

**STEP 5 |** Configure LDAP Server Profile. 

**STEP 6 |** Configure Group Mapping. 

**STEP 7 |** Enable User-ID Master device. 

**STEP 8 |** Commit your changes. 

## **Enable User-ID with Cloud Identity Engine (CIE)** 

## **Prerequisites** : 

- Active Directory (AD) environment with users and groups. 

- Cloud NGFW for Azure deployed and managed via Panorama. 

- Security Policy on Cloud NGFW to allow communication with LDAP/Windows server with Active directory. 

- CIE deployed and connected to your active directory environment. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**218** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 1 |** Deploy Cloud Identity Engine. 

For more information, see installing, deploying CIE, and authenticating CIE documentation. After a successful authentication of Agent with Cloud Identity Engine, the agent status will be **online** on Cloud Identity Engine 


![](images/fetchpdf-1780573081890.pdf-0219-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**219** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Configure Cloud Identity Engine on Panorama and group mapping. 

CIE for User-ID on **firewalls** , in Panorama, go to **Device** > **User Redistribution** , and add a **CIE** instance 


![](images/fetchpdf-1780573081890.pdf-0220-03.png)


For Panorama to learn Group mappings through CIE, configure CIE on the Panorama tab as shown below. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**220** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0221-01.png)


The Panorama will now learn these new Group Mappings. 


![](images/fetchpdf-1780573081890.pdf-0221-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**221** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 3 |** Configure Group Mapping. 

1. For User-ID on firewalls, go to **Device** > **User Redistribution** . 

2. To configure on Panorama, go to **Cloud Identity Engine** tab 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**222** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 4 |** Enable & Add CIE in Device Group. 

In the Cloud NGFW device group, enable and add the CIE instance. 


![](images/fetchpdf-1780573081890.pdf-0223-03.png)


Enable and add Cloud Identity Engine. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**223** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0224-01.png)


## **Enable User-ID Redistribution with Panorama** 

## **Prerequisites** : 

- Active Directory (AD) environment with users and groups. 

- Cloud NGFW for Azure deployed and managed via Panorama. 

- Dedicated Service account with Remote Management User and CIMV2 privileges. 

- Windows-based User-ID agent installed and configured. 

- Security Policy on Cloud NGFW to allow communication with LDAP/Windows server with Active directory. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**224** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 1 |** Configure User-ID Redistribution Agent on Panorama. 

In Panorama, go to **Data Redistribution** > **Add** . 

In Add a Redistribution agent window, configure **VM Series** as the User-ID redistribution Agent on panorama. 


![](images/fetchpdf-1780573081890.pdf-0225-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**225** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Configure User-ID Redistribution Agent on Cloud NGFW Device Group. 

In Panorama, go to **Device** > **Data Redistribution** , and add a **Data Redistribution Agent** . 


![](images/fetchpdf-1780573081890.pdf-0226-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**226** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 3 |** Enable User-ID on Cloud NGFW on Cloud NGFW network interfaces. 

You can override Private and Public zones and enable User-ID. 


![](images/fetchpdf-1780573081890.pdf-0227-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**227** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0228-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**228** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 4 |** Commit the configuration and verify Data Redistribution from panorama. 

On Panorama commit and push the configuration. 


![](images/fetchpdf-1780573081890.pdf-0229-03.png)


Check for Cloud NGFW managed devices and take a note of the serial numbers. 


![](images/fetchpdf-1780573081890.pdf-0229-05.png)


**STEP 5 |** Configure LDAP Server Profile. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**229** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 6 |** Configure Group Mapping. 

**STEP 7 |** Enable User-ID Master device. 

**STEP 8 |** Commit your changes. 

**STEP 9 |** Define Firewall policies. 

## **Define Firewall Policies Based on User Groups** 

In Panorama, go to **Policies** > **Security** . 


![](images/fetchpdf-1780573081890.pdf-0230-07.png)


Create rules using the Source User field to define access based on active directory user groups. You can now monitor the traffic based on usernames instead of just IP addresses. 


![](images/fetchpdf-1780573081890.pdf-0230-09.png)


## **Limitations** 

- Cloud NGFW can act as a redistribution Client, but not as a redistribution agent. 

- Authentication and Authorization policy is not supported. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**230** 

Protect Traffic with Cloud NGFW for Azure 

- The XML-API method for User-ID mapping is not supported. 

## Use XFF IP Address Values in Policy 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



If you have an upstream device, such as a load balancer, deployed between the users on your network and you Cloud NGFW instance, the Cloud NGFW might see the upstream device IP address as the source IP address in HTTP/HTTPS traffic that the proxy forwards rather than the IP address of the client that requested the content. In many cases, the upstream device adds an X- Forwarded-For (XFF) header to HTTP requests that include the actual IPv4 or IPv6 address of the client that requested the content or from whom the request originated. 

In Microsoft Azure, by default, an application gateway inserts the original source IP address and port in the XFF header. To use XFF headers in policy on your firewall, you must configure the application gateway to omit the port from the XFF header. See Azure documentation to learn how to configure your application gateway. 


![](images/fetchpdf-1780573081890.pdf-0231-06.png)


_This feature is supported on Panorama-managed Cloud NGFW for Azure only._ 

When configuring security policy rules on Panorama, you can enable Cloud NGFW to use the source IP address in an XFF HTTP header field to enforce security policy. When a packet passes through a single proxy server before reaching the firewall, the XFF field contains the IP address of the originating endpoint. However, if the packet passes through multiple upstream devices, the firewall uses the most recently added IP address to enforce policy or use other features that rely on IP information. 

- **STEP 1 |** Log in to Panorama. 

- **STEP 2 |** Select your Cloud NGFW for Azure template. 

## **STEP 3 |** Select **Device** > **Setup** > **Content ID** > **X-Forwarded-For Headers** . 

**STEP 4 |** Click the edit icon. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**231** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 5 |** Select **Enabled for Security Policy** from the **Use X-Forwarded-For Header** drop-down. 


![](images/fetchpdf-1780573081890.pdf-0232-02.png)


- _You cannot enable_ _**Use X-Forwarded-For Header** for security policy and User-ID at the same time._ 


![](images/fetchpdf-1780573081890.pdf-0232-04.png)


- **STEP 6 |** Optional Select **Strip X-Forwarded-For Header** to remove the XFF field from outgoing HTTP requests. 

Selecting this option does not disable the use of XFF headers in policy. The Cloud NGFW for Azure strips the XFF field from client requests after using it to enforce policy. 

## **STEP 7 |** Click **OK** . 

**STEP 8 | Commit** your changes. 

## Configure Advanced Threat Prevention 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**232** 

Protect Traffic with Cloud NGFW for Azure 

## **Use Panorama to Setup Advanced Threat Prevention** 

Advanced Threat Prevention (similar to other Palo Alto Networks security services) is administered through security profiles, which in turn is dependent on the configuration of network enforcement policies as defined through security policy rules. 


![](images/fetchpdf-1780573081890.pdf-0233-03.png)


- _You use the Cloud NGFW for Azure to enable Advanced Threat Prevention for the rulestack, however, you must use Panorama to configure the policies that comprise the security service._ 

To configure Advanced URL Filtering policy rules using Panorama: 

- **STEP 1 |** Login to Panorama. 

- **STEP 2 |** Check that you have the appropriate license subscription for Advanced URL Filtering. In Panorama, select **Device > Licenses** . Verify that the license expiration date is in the future. 

- **STEP 3 |** Set up Advanced Threat Prevention using Panorama. 

- **STEP 4 |** Commit your changes. 


![](images/fetchpdf-1780573081890.pdf-0233-10.png)


- _Palo Alto Networks provides several options to monitor activity processed by the Advanced Threat Prevention security service. See_ Monitor Advanced Threat Prevention _for more information._ 

## Configure WildFire Protection 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



To configure WildFire on your Cloud NGFW Azure resource using Panorama, you will need to: 

- Configure a WildFire Profille 

- Define security rule in the Cloud Device Group you created in Panorama 

- View Wildfire Submission Logs 

## **Configure a WildFire Profile** 

CNGFW for Azure offers two levels of protection: **Standard WildFire** and **Advanced WildFire** (Precision AI-powered inline blocking). Use the steps below to configure either profile type: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**233** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 1 |** Create the profile. 

**1.** Log in to **Panorama** and navigate to **Objects > WildFire Analysis** . 

**2.** Select the correct **Device Group** from the drop-down. 


![](images/fetchpdf-1780573081890.pdf-0234-04.png)


**3.** Click **Add** and enter a unique **Name** for the profile. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**234** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Configure Inline Analysis (Applicable for enabling Advanced WildFire Profile). 

If you are licensed for **Advanced WildFire** and wish to block zero-day malware in real-time: 


![](images/fetchpdf-1780573081890.pdf-0235-03.png)


**1.** Go to the **Inline Cloud Analysis** tab. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**235** 

Protect Traffic with Cloud NGFW for Azure 

## **2.** Select the **Enable Cloud Inline Analysis** checkbox. 


![](images/fetchpdf-1780573081890.pdf-0236-02.png)


_Enabling this service will appear as a separate add-on in your CNGFW for Azure billing metrics at_ _**30%** of the base firewall credit cost._ 

## **STEP 3 | Define Analysis Rules** . 

Click **Add** within the profile window to create specific rules. 

- **Name:** Enter a descriptive name for the rule. 

- **Applications:** Click **Add** to select specific applications (or "any") to monitor. 

- **File Types:** Select the specific file formats you wish to analyze. 

- **Direction:** Choose **upload** , **download** , or **both** . 

- **Analysis Destination:** 

**Public Cloud:** Forwards traffic to the WildFire public cloud. 

**Private Cloud:** Forwards traffic to a local WildFire appliance. 

**STEP 4 |** Finalize and deploy. 

**1.** Click **OK** to save the profile. 

**2. Commit** the changes to Panorama. 

**3. Push** the configuration to your managed devices. 

## **Define Security Rules** 

- **STEP 1 |** Log in to Panorama, and click **policy rules** . 

- **STEP 2 |** Choose the required Device Group and click the preconfigured security rule (pre-rule or post-rule) or create a new rule. 

- **STEP 3 |** Click **Actions** . 

- **STEP 4 |** In the profile setting, select **Profiles** under the profile type. 

- **STEP 5 |** Select the WildFire profile you wish to choose in the **WildFire Analysis** drop-down. 

- **STEP 6 |** Click **OK** . 

Commit and push the device group to the Cloud NGFW resources. 

For more information, see Latest WildFire Cloud Features. 

## **View WildFire Submission Logs** 

You can view WildFire submission logs in: 

**1.** View logs in Azure 

**2.** View logs in Panorma 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**236** 

Protect Traffic with Cloud NGFW for Azure 

## **View Logs in Azure** 

After you create the Log Analytics Workspace, update the log settings under the firewall and start sending the traffic. Once the traffic is sent, you can view the logs as described in the steps below: 

- **STEP 1 |** Click the **Log Analytics Workspace** for which you need to view the logs. 

- **STEP 2 |** Click **Logs** . 

- **STEP 3 |** Click **Custom Logs** in the query window and **Run** a query you have created. 


![](images/fetchpdf-1780573081890.pdf-0237-06.png)


You can create a customized query with parameters such as number of logs, time range and so on. For example - A simple Query 

```
       fluentbit_CL
       | limit 10
```

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**237** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0238-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**238** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 4 |** Click the desired query result item for which you would want to view the detailed logs. 


![](images/fetchpdf-1780573081890.pdf-0239-02.png)



![](images/fetchpdf-1780573081890.pdf-0239-03.png)


## **View Logs in Panorama** 

On Panorama, you can view the logs on the device group using **Monitor > Threats** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**239** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0240-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**240** 

Protect Traffic with Cloud NGFW for Azure 

## Configure Advanced DNS Security in Panorama 

Cloud NGFW for Azure leverages Advanced DNS Security to provide real-time, AI-driven protection against sophisticated DNS-layer threats. The Advanced tier uses cloud-based deep learning to block zero-day malicious domains. 

**STEP 1 |** Enable DNS Proxy in the Azure Portal. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**241** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 2 |** Define Advanced DNS Categories in Panorama. 

Advanced DNS Security is managed through the Anti-Spyware profile in your Panoramamanaged device groups. 

**1.** In **Panorama** , navigate to **Objects > Security Profiles > Anti-Spyware** . 

**2.** Select the **Device Group** associated with your Cloud NGFW for Azure. 

**3.** Click **Add** (or edit your existing profile) and go to the **DNS Policies** tab. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**242** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0243-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**243** 

Protect Traffic with Cloud NGFW for Azure 

**4.** Select required log level for the respective ADNS. 

**5.** Select the required action for the respective ADNS (applicable to PAN-OS version 11.2.7 and above only). 


![](images/fetchpdf-1780573081890.pdf-0244-03.png)


**6.** Click **OK** . 


![](images/fetchpdf-1780573081890.pdf-0244-05.png)


_When you select the_ _**default options** for your_ _**Newly Registered Domains** , the Cloud NGFW automatically utilizes the Advanced DNS Security engine._ 

**STEP 3 |** Deploy the Configuration. 

**1.** Go to **Policies > Security** and ensure the Anti-Spyware profile is attached to your outbound security rules. 

**2. Commit** the changes to Panorama. 

**3. Push** the configuration to your Cloud NGFW for Azure device group. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**244** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 4 |** Billing and Credits. 

Once an Anti-Spyware profile with Advanced DNS categories is applied to a live Security Policy: 

- The service is active and billed as an add-on. 

- This appears in your Azure consumption as a credit surcharge (approximately **30% of the base firewall credit cost** ). 

For more information, see Configuring Anti Spyware profile on Panorama. 

## Configure Enterprise DLP for Cloud NGFW on Azure 

## **Where Can I Use This?** 

## **What Do I Need?** 

- Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0245-10.png)



![](images/fetchpdf-1780573081890.pdf-0245-11.png)



![](images/fetchpdf-1780573081890.pdf-0245-12.png)



![](images/fetchpdf-1780573081890.pdf-0245-13.png)



![](images/fetchpdf-1780573081890.pdf-0245-14.png)



![](images/fetchpdf-1780573081890.pdf-0245-15.png)



![](images/fetchpdf-1780573081890.pdf-0245-16.png)


- Cloud NGFW subscription Panorama with PAN-OS 11.2.7-h4 or a later 11.2 release 

- DLP plugin 5.0.8 or later on Panorama 

- Cloud Services plugin 6.0.0 or later on Panorama Azure plugin 5.2.3 or later on Panorama 

- Strata Tenant Group (TSG) with E-DLP or CASB, or Strata Cloud Manager Palo Alto Networks Customer Support Portal (CSP) account 

Enterprise Data Loss Prevention (E-DLP) is a cloud-delivered security service that protects sensitive information from unauthorized access or exfiltration. You can integrate E-DLP with Cloud NGFW for Azure and use the Panorama console to apply consistent data filtering profiles to your security policy rules across your cloud infrastructure. 


![](images/fetchpdf-1780573081890.pdf-0245-22.png)


- _Cloud NGFW for Azure exclusively supports E-DLP. Consequently, all data-filtering profiles configured in Panorama are treated as E-DLP usage and billed at the E-DLP addon price. To prevent E-DLP-related charges, verify that no data-filtering profiles remain active within your security rules._ 

Use the following workflow to integrate your Cloud NGFW for Azure with E-DLP and Panorama: 

|**Step**|**Description**|
|---|---|
|Panorama preparation|Ensure Panorama is deployed with the following software<br>versions:<br>• PAN-OS 11.2.7-h4 or a later 11.2 release (Panorama<br>versions 12.0.x and 12.1.x and above are not supported)<br>• DLP plugin 5.0.8 or later|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**245** 

Protect Traffic with Cloud NGFW for Azure 

|**Step**|**Description**|
|---|---|
||• Cloud Services plugin 6.0.0 or later<br>• Azure plugin 5.2.3 or later<br>Ensure you are a member of the Palo Alto Networks Customer<br>Support Portal (CSP) account where your organization has<br>registered the Panorama appliance.|
|Associate Panorama to a<br>Strata Tenant Group (TSG) for<br>E-DLP integration|A Strata Tenant Group (TSG) is required for this integration.<br>While an E-DLP subscription is typically required, if one does<br>not exist, Palo Alto Networks creates a new DLP service and<br>tenant during the integration process.<br>• If your Panorama is already onboarded to a Strata Tenant<br>Group (TSG) with E-DLP or CASB, proceed to the next step.<br>• If you have a TSG with E-DLP or CASB but Panorama is not<br>yet onboarded, onboard your Panorama to the TSG and<br>proceed to the next step.<br>• If you do not have a TSG, activate a new Strata Cloud<br>Manager and onboard your Panorama to the associated<br>TSG.|
|Create or update Cloud<br>NGFW resources|If you already have Cloud NGFW for Azure resources<br>registered with this Panorama:<br>• **Automated association**: If your Panorama is already TSG-<br>aware with Strata Cloud Manager (with or without E-DLP),<br>the instance is associated with E-DLP automatically as part<br>of a rolling upgrade.<br>• **Manual association**: If you are making your Panorama TSG-<br>aware for the first time, update your firewall with the same<br>registration string in the Azure portal to trigger association<br>with the appropriate DLP services. You do not need a new<br>registration string.|
|Author DLP profiles and<br>policies|Once registered, add a DLP data filtering profile to your<br>security policy rules for your Cloud NGFW resources in<br>Panorama.|
|View logs and incidents|• View detailed security events and data matches in Strata<br>Cloud Manager under the E-DLP Incidents page.<br>• If your logging destination is Strata Logging Service or<br>Panorama, view logs in either location.<br>• Configure logs to be sent to Azure Event Hub, Azure<br>Storage Account, or Azure Log Analytics Workspace, and<br>view them natively in Azure.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**246** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0247-01.png)


_When moving Panorama from one Strata Tenant Group (TSG) to another:_ 

- _If the new TSG does not have E-DLP, Palo Alto Networks creates a new DLP service. Update your policies to reference the new DLP tenant._ 

- _If the new TSG already has E-DLP, Cloud NGFW can use the existing E-DLP tenant. You must still update your policies accordingly._ 

_Generate a new registration string and update it in the Azure portal after Panorama moves to the new TSG. If you intend to move E-DLP tenants from one TSG to another, complete that migration before moving Panorama, then generate and update the registration string._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**247** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 1 |** Provision E-DLP on Panorama. 

1. Log in to Panorama. 

2. Select **Panorama** > **Azure** > **Cloud NGFW** . 


![](images/fetchpdf-1780573081890.pdf-0248-04.png)


3. Locate the **Registration String** , click **Generate** , and copy the string for use in the Azure portal. 

4. Select **Panorama** > **Setup** > **Management** and verify that a device certificate is installed. 

5. Verify that the DLP plugin is active under **Panorama** > **Plugins** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**248** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0249-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**249** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 2 |** Configure the Cloud NGFW in the Azure portal. 

   1. In the Azure portal, select **Cloud NGFWs by Palo Alto Networks** . 


![](images/fetchpdf-1780573081890.pdf-0250-03.png)


2. Click **Create** or select an existing firewall to update. 

3. On the **Basics** tab, enter the firewall name and select the subscription and resource group. 


![](images/fetchpdf-1780573081890.pdf-0250-06.png)


4. On the **Security Policies** tab, choose **Managed by Palo Alto Networks Panorama** . 

5. Enter the Panorama registration string you generated in the previous step. 

6. Complete the **Review + Create** process to deploy the firewall. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**250** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 3 |** Apply DLP profiles and verify the configuration. 

1. In Panorama, select **Objects** > **Security Profiles** > **Data Filtering** and create a data filtering profile using predefined or custom data patterns. 

2. Apply the data filtering profile to a security policy rule under the **Actions** tab. 

3. Commit the changes to Panorama and push them to the Cloud NGFW device group. 

4. Monitor DLP security events in Strata Cloud Manager under **Data Loss Prevention** > **DLP Incidents** . 

## **Update the Registration String for an Existing Cloud NGFW on Azure** 

If you have an existing Cloud NGFW on Azure that you want to associate with a new E-DLP tenant, update the registration string rather than creating a new firewall. 

**STEP 1 |** In Panorama, select **Azure** > **Cloud NGFW** . 

**STEP 2 |** Select the appropriate device group. 

**STEP 3 |** Under **Registration String** , click **Generate** and copy the string. 

**STEP 4 |** In the Azure portal, select your existing Cloud NGFW by Palo Alto Networks resource. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**251** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 5 |** Under **Security Policies** , enter the registration string. 


![](images/fetchpdf-1780573081890.pdf-0252-02.png)


**STEP 6 |** Click **Save** to associate the firewall with the E-DLP tenant. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**252** 

Protect Traffic with Cloud NGFW for Azure 

## Strata Cloud Manager Policy Management 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



You can integrate your Cloud NGFW resources with Strata Cloud Manager (SCM) for policy management. With this integration, you can now use a single Strata Cloud Manager to centrally manage a shared set of security rules on Cloud NGFW resources alongside your physical and virtual firewall appliances. You can also manage all aspects of shared policy configurations, gain comprehensive visibility with actionable insights, and generate reports on traffic patterns or security incidents of your Cloud NGFW resources, all from a single console. 

You can register your Cloud NGFW resources with an existing Strata Cloud Manager, which you had previously activated based on your AIOps, NGFW, Prisma Access, or Strata Cloud Manager Pro/Essential licenses. If you do not have a Strata Cloud Manager, you can activate a new Strata Cloud Manager Essentials (steps 1-8) to use with Cloud NGFW. In either case, the integration automatically enables Strata Cloud Manager Pro features for Cloud NGFW. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**253** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0254-01.png)


## **Prerequisites** 

To use SCM for policy management: 

- If you're deploying the firewall for the first time and your policy management choice is Strata Cloud Manager, first deploy the local rulestack  and register it in the Customer Support Portal. Once the rulestack is registered with your Customer Support Portal account, you can deploy the firewall, and it will show existing Strata Cloud Manager tenants associated with the Customer Support Account. 

- Ensure that your Cloud NGFW for Azure tenant and Strata Cloud Manager are registered to the same Customer Support Portal (CSP) account. 

## Create a Cloud NGFW Resource for SCM Policy Management 

To must create a new Cloud NGFW resource to use SCM for policy management: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**254** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 1 |** Log in to the Azure portal and search for **Cloud NGFWs by Palo Alto Networks** . This displays the Cloud NGFWs you have registered with Azure. For more information, see Start with Cloud NGFW for Azure. 

- **STEP 2 |** Create a new NGFW resource. 

For more information on creating a new Cloud NGFW for Azure, see Deploy the Cloud NGFW in a vNET or Deploy the Cloud NGFW in a vWAN. 

- **STEP 3 |** In the **Settings** section, select **Security Policies** . 


![](images/fetchpdf-1780573081890.pdf-0255-05.png)


   - _You can choose Strata Cloud Manager under_ _**Security Policies** when you deploy the Cloud NGFW resource._ 

- **STEP 4 |** In the **Security Policies** tab, select **Managed by Palo Alto Networks Strata Cloud Manager** . 


![](images/fetchpdf-1780573081890.pdf-0255-08.png)



![](images/fetchpdf-1780573081890.pdf-0255-09.png)


- _If the SCM option does not appear, ensure you have registered with the_ Customer Support Portal _. See the Prerequisites section._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**255** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 5 |** Use the drop-down to select the **SCM Tenant** . 


![](images/fetchpdf-1780573081890.pdf-0256-02.png)



![](images/fetchpdf-1780573081890.pdf-0256-03.png)


_You can filter SCM tenant names to locate the appropriate tenant. For example, enter a portion of the tenant name, or the tenant ID to locate the SCM tenant you want to use for policy management._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**256** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0257-01.png)


- _Log in to the_ SCM app _from the Palo Alto Networks_ hub _to locate your SCM tenant. In the lower left portion of the SCM interface, select the_ _**Tenant** icon. This displays the available tenants who are linked to your Cloud NGFW resource:_ 


![](images/fetchpdf-1780573081890.pdf-0257-03.png)


## View the Firewall in Strata Cloud Manager 

After creating your Cloud NGFW resource, you can use SCM to manage the policy. 


![](images/fetchpdf-1780573081890.pdf-0257-06.png)


   - _When you log into Strata Cloud Manager, the dashboard may fail to display the Cloud NGFW count under_ _**NGFW > Software** . Refresh your browser to view the newly linked firewall._ 

- **STEP 1 |** Log in to the Strata Cloud Manager app from the Palo Alto Networks hub directly at stratacloudmanager.paloaltonetworks.com. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**257** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Select **Workflows > NGFW Setup > Device Management** : 


![](images/fetchpdf-1780573081890.pdf-0258-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**258** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 3 |** The Device Management screen displays the **NGFWs** and **Cloud NGFWs** . Click **Cloud NGFWs** to display the firewalls associated with the SCM tenant: 


![](images/fetchpdf-1780573081890.pdf-0259-02.png)


The **Device Management** screen displays the Cloud NGFW resources that are currently managed by SCM: 


![](images/fetchpdf-1780573081890.pdf-0259-04.png)


If you don't see Cloud NGFW resources, refresh your screen. 

The Device Management screen displays the following fields: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**259** 

Protect Traffic with Cloud NGFW for Azure 

- Name. Represents the name of the Cloud NGFW resource. 

- Resource ID. Represents the Cloud NGFW name as it appears in the Azure. 

- CNGFW tenant ID. Indicates the Azure tenant ID associated with the subscription for the CNGFW service. 

- CNGFW Tenant Serial Number. The serial number associated with the Cloud NGFW tenant. 

- Labels. An arbitrary label assigned to the Cloud NGFW. 

- Region and Location. The region in which the Cloud NGFW resource is located. 

- Config sync Status. The status of the Cloud NGFW resource. 


![](images/fetchpdf-1780573081890.pdf-0260-08.png)


_When using SCM policy management for the first time, the Config sync status appears_ _**Out of Sync** ; after manually pushing configuration changes the status changes to reflect_ _**In sync** ._ 

The **Device Management** screen groups your Cloud NGFW resources into _folders_ . To view the structure of these folders, select **Workflows > Folder Management** . 


![](images/fetchpdf-1780573081890.pdf-0260-11.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**260** 

Protect Traffic with Cloud NGFW for Azure 

The **Folder Management** screen displays the Cloud NGFW resources associated with the SCM tenant: 


![](images/fetchpdf-1780573081890.pdf-0261-02.png)


## Create or Move a Folder for Your Cloud NGFW Resource Using Strata Cloud Manager 

After configuring the appropriate subscription to use the Strata Cloud Manager service for your Cloud NGFW resources, you create a folder to view data associated with your firewall. SCM folders are used to group your Cloud NGFW resources logically to simplify policy management. You can create a folder that contains multiple nested folders to group firewalls and deployments that require similar configurations. Folders  that are already nested can have multiple nested folders as well. By default, firewalls linked to SCM are placed in the **All Firewalls** folder. 


![](images/fetchpdf-1780573081890.pdf-0261-05.png)


- _Folders for other Palo Alto Networks applications, like Prisma Access, and your NGFWs are separate; you can't group NGFWs in a folder with Prisma Access deployments. However, you can easily apply shared settings globally across all folders or use_ Manage: Snippets _to easily apply standard settings and policy requirements across multiple folders._ 

To create a folder for your Cloud NGFW resource: 

- **STEP 1 |** Log in to the Strata Cloud Manager app from the Palo Alto Networks hub directly at stratacloudmanager.paloaltonetworks.com. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**261** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** In the Strata Cloud Manager console, select **Workflows > NGFW Setup > Folder Management** and click **Add Folder** . 


![](images/fetchpdf-1780573081890.pdf-0262-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**262** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 3 |** In the **Create Folder** screen: 

1. Enter a descriptive name for the folder. 

2. Optionally provide a description for the folder. 

3. Optionally assign one or more labels. You can select an existing label or create a new label by typing the label you want to create. For example, use the **Labels** drop-down to select **cngfw** . 

4. Specify where to create the folder using the drop-down menu. You can select **All Firewalls** , or select an existing folder to nest the folder under it. This is a required field. 

5. Click **Create** . 

To move or edit the folder containing your Cloud NGFW resources to another folder: 

**STEP 4 |** In the **Folder Management** screen, select the folder you want to move or edit. 

**STEP 5 |** In the **Actions** column, select the vertical ellipsis to **Edit** or **Move** a folder: 


![](images/fetchpdf-1780573081890.pdf-0263-10.png)


- **STEP 6 |** To move your folder to a different location, in the **Move to Different Location** screen, select the new **Destination** from the drop-down menu 

After making changes to the structure of your folder, you can use SCM for policy management and push the configuration changes. 


![](images/fetchpdf-1780573081890.pdf-0263-13.png)


_For information about pushing changes using SCM policy management, see_ Manage: Push Config _._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**263** 

Protect Traffic with Cloud NGFW for Azure 

## Use Strata Cloud Manager for Cloud NGFW Policy Management 

At this release, you can use Strata Cloud Manager to globally apply a security rule to the Cloud NGFW resources comprising a folder. All NAT policy rules (including DNS proxy) are applied using the Azure portal. 


![](images/fetchpdf-1780573081890.pdf-0264-03.png)


- _You can optionally forward logs to Azure, which requires you to configure the Azure portal._ 

## **Important Considerations** 

When using SCM for Cloud NGFW as a policy management, consider the following: 

- When you first connect to SCM, Cloud NGFW resources (for example, the resource ID) may fail to display. These resources will appear after a few moments if there are no underlying connection issues. 

- Best practices for Cloud NGFW SCM policy management differ from those using Panorama policy management with your Cloud NGFW resource. For example, some pass-through traffic in a Panorama managed environment may be dropped in an SCM managed Cloud NGFW resource. 

- X-Forwarded-For (XFF) functionality isn't supported in an SCM policy management for your Cloud NGFW resource. 

- Cloud certificate isn't supported. 

- Data loss prevention (DLP) isn't supported. 

- When configuring security rules for your SCM-managed Cloud NGFW resource, you must specify ANY for the security rule. However, from/to zone appears as public/private in the Strata Logging Service. 

- User-ID and tag-based policy rules are not yet supported. 

- Operational visibility and metrics are not supported. 

To use SCM for Cloud NGFW policy management: 

## **STEP 1 |** In Strata Cloud Manager, select **Manage > Configuration > NGFW and Prisma Access** . 


![](images/fetchpdf-1780573081890.pdf-0264-17.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**264** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Select **Configuration Scope** . 


![](images/fetchpdf-1780573081890.pdf-0265-02.png)



![](images/fetchpdf-1780573081890.pdf-0265-03.png)


_By default, the_ _**Configuration Scope** displays_ _**Global** firewall resources. The scope may represent the Cloud NGFW (rather than a folder). The configuration menu changes automatically to reflect available options. Ensure that_ device scope configuration _is enabled; device scope can't support Cloud NGFW names greater than 30 characters._ 

## **STEP 3 |** In the drop-down list, locate the folder containing the **Cloud NGFW Azure resources** : 


![](images/fetchpdf-1780573081890.pdf-0265-06.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**265** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 4 |** In the **Overview** page, select **Security Services** : 


![](images/fetchpdf-1780573081890.pdf-0266-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**266** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 5 |** In the **Security Services** drop-down list, select **Security Policy** : 


![](images/fetchpdf-1780573081890.pdf-0267-02.png)


For more information about configuring Security policy using Strata Cloud Manager, see Manage Security Policy. 

## Use the Strata Logging Service 

Cloud NGFW supports Strata Logging Service (formerly Cortex Data Lake), a cloud-based logging system that stores context-rich enhanced network logs generated by our security products, including our NGFWs, Prisma Access, and Cloud NGFW for AWS. With Strata Logging Service, you can collect ever-expanding volumes of data without needing to plan for local compute and storage, and it's ready to scale from the start. Learn how to activate and deploy Strata Logging Service in your product. 


![](images/fetchpdf-1780573081890.pdf-0267-06.png)


_In addition to using the Strata Logging Service, you can also use the Strata Cloud Manager_ Incidents and Alerts log viewer _._ 

- **STEP 1 |** Launch the Strata Logging Service from the SCM console; log in to the SCM app from the Palo Alto Networks hub. In the lower left portion of the SCM interface, select the **Tenant** icon. 

- **STEP 2 |** Select **Strata Logging Service** . 

- **STEP 3 |** In the Strata Logging Service Dashboard, click **Inventory** . Your Cloud NGFW resource should appear. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**267** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 4 |** Select the **Cloud NGFW** tab: 


![](images/fetchpdf-1780573081890.pdf-0268-02.png)


**STEP 5 |** Click **Explore** to view and interact with logs stored in your Strata Logging Service. The Query Builder along with time range preferences help you narrow down the specific logs that are of interest to you. You can view the log details and also export all log types to a compressed CSV file in GZ format. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**268** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 6 |** Select **Firewall/Threat** from the explore drop-down to select the log you want to view. 


![](images/fetchpdf-1780573081890.pdf-0269-02.png)


- _You can filter logs for your Cloud NGFW resource. For example, enter_ _`sub_typevalue=WildFire[®]` or_ _`wildFire[®] virus` to filter for WildFire logs. For more information, see_ View Strata Logging Service Logs in Explore _. You can also use the filter to query the log for a specific Cloud NGFW, for example,_ _`log source group ID = your Cloud NGFW name` ._ 


![](images/fetchpdf-1780573081890.pdf-0269-04.png)


## Migrate an Azure Firewall Policy to Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Strata Cloud Manager Essential in a<br>supported region (Canada, India, United<br>Kingdom, Singapore, or United States)<br>Security Administrator or Superuser role|



Cloud Service Provider (CSP) Native Firewall Policy Migration enables the automated transfer of existing security policies from Azure Firewall to Palo Alto Networks[®] Software Firewalls (Cloud NGFW and VM-Series) through Strata[™] Cloud Manager. This process transitions your security configurations from native cloud firewall services to a next-generation firewall platform, providing enhanced security and centralized policy management. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**269** 

Protect Traffic with Cloud NGFW for Azure 

The migration follows a structured architectural flow. It begins with identifying policies in your Azure environment. Strata Cloud Manager then translates native Azure firewall logic into compatible Palo Alto Networks Software Firewall configurations. You can apply these configurations to existing or new Software Firewall resources to ensure a consistent security posture across your environment. Policy migration to Strata Cloud Manager is currently supported in the following regions: Canada, India, United Kingdom, Singapore, and United States. 

The Policy Migration Engine processes your uploaded configuration files to translate native Azure firewall logic into Strata Cloud Manager snippets through these key steps: 

- **Export Native Configuration** : Use the Python script `export_azr_fwpolicy.py` to extract existing security policies from your Azure environment into a ZIP file. 

- **Analyze and Convert** : Upload the exported ZIP file to the Strata Cloud Manager Migration Catalog. The engine translates cloud-native logic into Strata Cloud Manager-compatible security rules and objects while identifying skipped items that require manual review. 

- **Generate Configuration Snippets** : Upon successful conversion, the tool creates a reusable Strata Cloud Manager snippet containing all migrated rules. 

- **Associate with Folders** : Link the generated snippet to a designated Strata Cloud Manager folder associated with your Software Firewall resources (Cloud NGFW or VM-Series). 

- **Deploy and Verify** : Initiate a Config Push to deploy the translated policy to your active firewall units and monitor the job log to confirm a successful transition. 

## **Supported Features and Compatibility** 

The following table outlines the policy components supported for automated migration from Azure Firewall to Strata Cloud Manager. 

|**Feature Category**|**Supported Components**|**Unsupported or Skipped**|
|---|---|---|
|Rules|Network Rules and Application<br>Rules|None|
|Services|DNS Proxy, Threat Intelligence,<br>IDPS, SNAT Rules, and TLS<br>Inspection|FQDN Tags|
|Objects|IP Groups, FQDNs, Web Categories,<br>and Service Tags|None|




![](images/fetchpdf-1780573081890.pdf-0270-11.png)


_For Azure D-NAT rules, apply the configuration based on the platform you intend to use. For Cloud NGFW, Terraform templates are provided to apply these rules within your Azure account. For VM-Series, D-NAT policies are included in the generated Strata Cloud Manager snippet._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**270** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 1 |** Start the Azure policy migration. 

1. In Strata Cloud Manager, select **Migration Catalog** and choose **Azure Firewall** . 


![](images/fetchpdf-1780573081890.pdf-0271-03.png)


2. Select **Start migration** to initiate the Azure policy migration workflow. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**271** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 2 |** Download the Azure export script. 

1. On the Azure migration page, select **Download export scripts** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**272** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0273-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**273** 

Protect Traffic with Cloud NGFW for Azure 

   2. Follow the link to GitHub and download the Python script ( `export_azr_fwpolicy.py` ). 

   3. Save the file with a `.py` extension. This script extracts your Azure Firewall policy configurations. 

- **STEP 3 |** Export the Azure Firewall policy. 

   1. Ensure Python 3 and Azure CLI are installed and configured on your local machine. 

   2. Log in to your Azure account using Azure CLI if you are not already logged in. 

## **`az account show`** 

3. In your Azure portal, identify the Azure Firewall policy you want to migrate, noting its subscription ID, resource group, and policy name. 

4. Open your command-line interface and run the export script, replacing the placeholders with your values. 

## **`python3 export_azr_fwpolicy.py --sub`** _**`your-subscription-id`**_ **`-rg`** _**`your-resource-group`**_ **`--name`** _**`your-policy-name`**_ 

5. Confirm that a ZIP file containing the exported configuration is generated in the `export_policy` folder. This ZIP file is the required input for the Strata Cloud Manager migration service. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**274** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 4 |** Upload and convert the Azure configuration in Strata Cloud Manager. 

   1. Return to the Strata Cloud Manager Azure migration page. 

   2. Select **Browse file** and upload the ZIP file from your `export_policy` folder. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**275** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0276-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**276** 

Protect Traffic with Cloud NGFW for Azure 

3. Click **Analyze and convert** . 

4. Review the summary of advanced features, objects, and rules to be imported, noting any skipped items such as FQDN tags. 

Strata Cloud Manager processes your Azure policy for conversion into Cloud NGFW format, highlighting incompatibilities or unsupported features. 


![](images/fetchpdf-1780573081890.pdf-0277-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**277** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 5 |** Review and import the converted configuration. 

   1. Select **Review converted configuration** and review the policy rules, objects, and skipped items with their reasons. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**278** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0279-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**279** 

Protect Traffic with Cloud NGFW for Azure 

## Skipped items are available in the **Skipped items** tab. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**280** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0281-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**281** 

Protect Traffic with Cloud NGFW for Azure 

2. Enter a descriptive **Snippet Name** (for example, **`azr-demo-1`** ). 


![](images/fetchpdf-1780573081890.pdf-0282-02.png)


3. Select **Import to Strata Cloud Manager** to commit the converted policy elements to a Strata Cloud Manager snippet. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**282** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0283-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**283** 

Protect Traffic with Cloud NGFW for Azure 

4. Click **Summary** to view the completed import summary. 

You can also click **Download Terraform Template for NGFW** to save a ZIP file of the Terraform templates to your local machine. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**284** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0285-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**285** 

Protect Traffic with Cloud NGFW for Azure 

Select the **Snippet** link to go to the snippet page. 


![](images/fetchpdf-1780573081890.pdf-0286-02.png)


_Do not close or navigate away from the Strata Cloud Manager migration summary page until you have completed snippet verification and downloaded all necessary artifacts. If you close the browser tab or navigate away before downloading, you cannot return to retrieve the Terraform ZIP file later. Keep the migration summary tab open while you verify the snippet in a separate window or tab._ 

- **STEP 6 |** Verify the migrated snippet. 

   1. Select **Configuration** > **NGFW and Prisma Access** > **Snippet** . 

   2. Locate and select your newly created snippet (for example, **`azr-demo-1`** ). 

   3. Review the **Security Rules** and **Address Objects** tabs to confirm the successful migration. Your Azure policy is now translated and stored as a reusable configuration snippet. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**286** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 7 |** Push the configuration to Cloud NGFW. 

1. Select **Configuration Scope** and choose **Folder** . 

2. Select the folder associated with your Azure Cloud NGFW instances. 

3. From the folder overview, select the **Add** icon next to **Snippets** . 

4. Add your migrated snippet (for example, **`azr-demo-1`** ) to the folder. 

5. Select **Close** . 

6. Select **Push** from the top-right corner. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**287** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0288-01.png)


7. Enter a **Description** and confirm the push to your Cloud NGFW units. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**288** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0289-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**289** 

Protect Traffic with Cloud NGFW for Azure 

8. Monitor the job log to confirm the push is successful. 

This deploys your new Cloud NGFW policy to the active Azure firewall instances. 

- **STEP 8 |** Download Terraform templates for Cloud NGFW. 

Because Software Firewall D-NAT rules and DNS Proxy configurations are hosted on a public load balancer rather than managed directly through Strata Cloud Manager folders, you must use Terraform to apply these specific settings to your Azure environment. Strata Cloud Manager automatically generates these templates when D-NAT or DNS Proxy configurations are detected in your policy migration. 

1. On the migration **Summary** page, locate the **Generated Snippet** section. 

2. Click **Download Terraform Templates for NGFW** . 


![](images/fetchpdf-1780573081890.pdf-0290-07.png)


3. Save the ZIP file (for example, `terraform-cngfw.zip` ) to your local machine. 

4. Unzip the file to access the Terraform directory, which includes `main.tf` , `variables.tf` , and `terraform.tfvars` . 

5. Open `terraform.tfvars` and provide the required parameters: _subscription_id_ , _resource_group_name_ , _firewall_name_ , and _public_ip_name_ for your D-NAT rules. 

6. Authenticate your Azure CLI session before running Terraform. 

## **`az login`** 

## **`az account show`** 

7. Run the following commands in your CLI to initialize and apply the Terraform configuration. 

## **`terraform init`** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**290** 

Protect Traffic with Cloud NGFW for Azure 

## **`terraform import terraform plan terraform apply -auto-approve`** 


![](images/fetchpdf-1780573081890.pdf-0291-02.png)


_A known issue may cause the push to fail on the firewall if the content version is lower than required. This is unrelated to the migration service itself._ 

## Tag-based Policies in Strata Cloud Manager 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure<br>• Strata Cloud Manager|Cloud NGFW for Azure running PAN-OS®<br>11.2 and later<br>**New Customers:**Starting March 18, 2026,<br>all new Cloud NGFW for Azure tenants will<br>have PAN-OS 11.2 enabled by default.<br>**Existing Customers:**Upgrades start<br>from**mid-April 2026**. To prepare for the<br>mandatory upgrade or to request an early<br>upgrade via**reporting a support case**.<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW for Azure allows you to enforce security policies based on Azure resource tags instead of static IP addresses. By creating Cloud IP Tag configurations in Strata Cloud Manager (SCM), the firewall automatically monitors your Azure environment for changes to resources (such as EC2 instances) and updates the associated IP addresses in your security rules. This feature uses resource tags to ensure consistent security across your network as workloads and user groups change. It supports Strata Cloud Manager (SCM) adoption and enables you to manage Cloud NGFW at scale in Azure environments. It addresses scalability and security challenges by replacing traditional, static IP-based firewall policies in dynamic cloud environments. Manual updates for individual IPs and users create operational overhead and potential vulnerabilities. Without this solution, tracking dynamic workloads requires manual intervention for new firewalls. SCM polls your Azure environment to discover existing tags and detect new or modified tags. 

Cloud IP Tags in SCM supports multi-account environments. You can repeat the onboarding process (Step 3) for multiple Azure subscriptions to aggregate and enforce tag-based policies across different Azure accounts. 

The following table identifies the specific CNGFW for Azure resource attributes and tags harvested by Strata Cloud Manager (SCM). 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**291** 

Protect Traffic with Cloud NGFW for Azure 

|**Attribute Type**|**Attribute Name (Example**<br>**Format)**|**Description**|
|---|---|---|
|VM Name|azure.vm_name (e.g.,<br>azure.web_server1)|The specific name assigned to<br>the virtual machine.|
|VM Size|azure.vm_size (e.g.,<br>azure.standard_ds2_v2)|The Azure instance size/type.|
|OS Type|azure.os_type (e.g.,<br>azure.Linux)|The operating system family.|
|OS Publisher|azure.os_publisher (e.g.,<br>azure.Canonical)|The organization that created<br>the VM image.|
|OS Offer|azure.os_offer (e.g.,<br>azure.UbuntuServer)|The specific product offering<br>from the publisher.|
|OS SKU|azure.os_sku (e.g.,<br>azure.14.04.5-LTS)|The specific version or stock<br>keeping unit of the OS.|
|Subnet Name|azure.subnet_name (e.g.,<br>azure.web)|The name of the Azure<br>subnet where the resource<br>resides.|
|VNET Name|azure.vnet_name (e.g.,<br>azure.myvnet)|The Virtual Network<br>containing the resource.|
|Azure Region|azure.region (e.g., azure.east-<br>us)|The geographic location/<br>region of the resource.|
|Resource Group|azure.resource_group (e.g.,<br>azure.myResourceGroup)|The logical container for<br>Azure resources.|
|User Tags|azure.tag.<key>.<value>|Supports up to 10 custom<br>user-defined tags.|



## **Configure Scalable IP Tag and User-ID Dynamic Policy Enforcement** 

Use this section to configure dynamic policy enforcement with IP tags within your Strata Cloud Manager environment for CNGFW for Azure. This workflow automates security policies based on cloud resource tags, ensuring consistent and scalable enforcement across your dynamic cloud environments. 


![](images/fetchpdf-1780573081890.pdf-0292-04.png)


- _Cloud IP Tag configuration currently supports only the_ _**IP Tag** data type for Cloud NGFW for Azure. Other data types, such as_ _**User Tag** ,_ _**IP User** ,_ _**IP Port User** , and_ _**Quarantine List** , are not supported at this time. This configuration is handled automatically when you associate a monitoring definition with a folder._ 

**STEP 1 |** Log in to the **Strata Cloud Manager** UI. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**292** 

Protect Traffic with Cloud NGFW for Azure 

## **STEP 2 |** Go to **Configuration > IP Tag Collection** . 


![](images/fetchpdf-1780573081890.pdf-0293-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**293** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 3 |** Onboard a cloud account. 

**1.** Click **Add New Cloud Account** . 

**2.** Select the **Cloud Type** (for example **Azure** ). 


![](images/fetchpdf-1780573081890.pdf-0294-04.png)


**3.** Enter a **Name** for the account. 

**4.** Choose the **Connection Type** . 

   - To use Terraform ( **recommended** ): Click **Connect with Terraform** : 

   - Click **Download Terraform Bundle** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**294** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0295-01.png)


- Run Terraform (for example, terraform init, terraform apply) in your cloud environment. 

- To use credentials: Click **Connect with Credentials** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**295** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0296-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**296** 

Protect Traffic with Cloud NGFW for Azure 

   - Provide the required credentials (for example, **Subscription ID** , **Tenant ID** , **Client ID** , **Client Secret** for Azure). 

**5.** Click **Test Connection** . 

**6.** Click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**297** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 4 |** Create a monitoring definition (Tag Distribution). 

**1.** On the **IP Tag Collection** page, select the cloud account, then click **Distribute** . 


![](images/fetchpdf-1780573081890.pdf-0298-03.png)


**2.** Enter a **Name** for the monitoring definition. 

**3.** Specify the **Polling Interval** (for example, 300 seconds). The minimum interval is 1 minute and the maximum is 30 minutes. 

**4.** Select the **Regions** from which to collect tags. 

**5.** Choose the **Folder** where the harvested tags will be stored. 

**6.** Click **Save** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**298** 

Protect Traffic with Cloud NGFW for Azure 

- **STEP 5 |** (Optional) Manually trigger a full sync. A full sync manually forces SCM to poll your Azure environment and refresh all IP-to-tag mappings outside of the scheduled polling interval. 

   **1.** On the **IP Tag Collection** page, locate the monitoring definition. 

   **2.** Under **Actions** , select **Full Sync** . 


![](images/fetchpdf-1780573081890.pdf-0299-04.png)


**3.** Allow time for tags to be harvested and processed. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**299** 

Protect Traffic with Cloud NGFW for Azure 

**STEP 6 |** Create a dynamic address group using harvested tags. 

**1.** Navigate to **Policies > Objects > Address Groups** . 

**2.** Click **Add Address Group** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**300** 

Protect Traffic with Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0301-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**301** 

Protect Traffic with Cloud NGFW for Azure 

**3.** Enter a **Name** for the address group. 

**4.** Set the **Type** to **Dynamic** . 

**5.** In the **Match Criteria** field, enter the tag (for example: azure.vnet-name.webserver_vnet). 


![](images/fetchpdf-1780573081890.pdf-0302-04.png)


_The format of each tag varies according to the type of resource from which it is collected._ 

**6.** Click **Save** . 

**STEP 7 |** Create a security policy rule. 

**1.** Navigate to **Policies > Security** . 

**2.** Click **Add Rule** . 

**3.** Enter a **Name** for the rule. 

**4.** Under the **Source** tab, add the dynamic address group created in the previous step. 

**5.** Configure other policy parameters ( **Destination** , **Application** , **Service/URL Category** , **Action** ). 


![](images/fetchpdf-1780573081890.pdf-0302-13.png)


**6.** Click **Save** . 

**STEP 8 |** Push the configuration to the firewall. 

**1.** Ensure your firewall is associated with the folder chosen during monitoring definition creation. 

**2.** Initiate a configuration push to the relevant firewall(s). 

## **Performance Factors for Cloud IP-Tag Harvesting** 

While the average latency for tag enforcement depends on following, configuration factors and may extend the total processing time: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**302** 

Protect Traffic with Cloud NGFW for Azure 

- **Region Selection:** Selecting all available Azure regions or a large number of regions in a single monitoring definition increases the number of queued jobs. This can lead to longer harvesting durations. 

- **Polling Interval Impacts:** Frequent polling combined with a high volume of tags and regions may increase the processing queue, potentially delaying the distribution cycle. 

## **Recommended Best Practice** 

To ensure optimal performance and lower latency, it is recommended to: 

- Only select the specific **Azure Regions** where your dynamic workloads are currently deployed rather than selecting **All** . 

- **Optimize Polling Interval** - While the minimum interval is 1 minute, you should align your polling interval with your actual operational requirements. Avoid defaulting to 1 minute for all definitions if your tags do not change that frequently, as this ensures the most efficient processing for critical updates. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**303** 

Protect Traffic with Cloud NGFW for Azure 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**304** 


![](images/fetchpdf-1780573081890.pdf-0305-00.png)


## Monitor Cloud NGFW for Azure Resources 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



You can monitor the service's overall health and gain deep insights into traffic and operations using various Cloud NGFW logs and metrics. 

## **Service Status and Notifications** 

To monitor the overall health of the Cloud NGFW service, check the Palo Alto Networks status page. This page provides region-specific status information and allows you to subscribe to service notifications, ensuring you are aware of any ongoing service events. For more information, see **Palo Alto Networks Status** page. 

## **Traffic and Threat Logs** 

Cloud NGFW publishes a variety of logs to help you monitor traffic and threats for analysis and compliance. These traffic and threat logs provide detailed information about network sessions passing through your Cloud NGFW resource. Analyze permitted and denied traffic, inspect source/destination IP addresses, URLs, port numbers, and protocols. This data is crucial for understanding traffic patterns, identifying potential security threats, and troubleshooting connectivity issues. These can be streamed to other Azure services for analysis and alarming. 

- **Destinations:** 

   - **Azure Log Analytic Workspace:** Stream logs for real-time monitoring and analysis. You can then forward these logs to a Storage Account or an Event Hub for third-party integrations. 

   - **Strata Logging Service:** Stream logs to Palo Alto Networks Strata Logging Service for realtime monitoring and advanced analysis. 

- **Viewing Logs:** 

   - **Azure:** Use the Azure Monitor Log Analytics portal. 

   - **Palo Alto Networks:** Use the Strata Cloud Management (SCM) and Panorama log viewer. 

## **Performance and Metrics** 

Cloud NGFW publishes a variety of metrics to help you monitor resource health, performance, and traffic usage. These resources assess the overall health of your Cloud NGFW resources, identify performance bottlenecks, and detect anomalies. 

- **Destination:** Cloud NGFW publishes custom metrics to Azure Application Insights. 

**305** 

Monitor Cloud NGFW for Azure Resources 

- **Monitoring:** Cloud NGFW streams these metrics to the Application Insights instance in your Azure Subscription. You can use these metrics to access historical performance data. You can query and also set alarms that monitor specific thresholds and send notifications when these thresholds are reached. 

## **Audit Logs** 

Activity logs track user and API activity within your Cloud NGFW tenant. These logs help you audit operations related to firewall resources, such as creating, updating, or deleting rules and policies. Reviewing these logs helps maintain a historical record of configuration changes and ensures compliance with security requirements. 

- **Destination:** Cloud NGFW streams audit logs to **Azure** , tracking all tenant activity. 

- **Viewing Logs:** Use the Azure Portal 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**306** 

Monitor Cloud NGFW for Azure Resources 

## View CNGFW for Azure Health Monitor Status 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Health status appears as color-coded icons, and is portrayed for both network security and cloud security. 

Health status for network security: 

- **Healthy** (green icon). Indicates that the primary and secondary Panorama is connected with the Cloud NGFW resource for network security applications. 

- **Degraded** (yellow icon). Network security is degraded on the Cloud NGFW resource. 

- **Unhealthy** (red icon). Indicates that the Cloud NGFW cannot connect to the Panorama virtual appliance. Ensure that your Cloud NGFW is registered with Panorama. 

Health status for cloud security applies to the creation and update of a firewall: 

- **Healthy** (green icon). Indicates the individual status of the rulestack associated with the Cloud NGFW resource showing the state of the primary and secondary Panorama virtual appliance connected to the Cloud NGFW resource. This information appears in the **Associated rulestack** section and is displayed as **Connected** or **Not Connected** . 

- **Degraded** (yellow icon). Cloud security is degraded. 

- **Unhealthy** (red icon). Indicates that the Cloud NGFW rulestack was not committed successfully on any instance. After resolving the issue, the health monitor changes to reflect a healthy status (green icon). 

- **Initializing** (blue icon). Indicates that the Cloud NGFW resource is initializing. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**307** 

Monitor Cloud NGFW for Azure Resources 

## View Cloud NGFW for Azure Metrics Natively in Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Following are the steps to monitor the health of your Cloud NGFW: 

- **STEP 1 |** Log into the Azure portal and search for **Cloud NGFW by Palo Alto Networks** . This displays the Cloud NGFWs you have registered with Azure. 

- **STEP 2 |** Select the Cloud NGFW you want to monitor. 


![](images/fetchpdf-1780573081890.pdf-0308-06.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**308** 

Monitor Cloud NGFW for Azure Resources 

- **STEP 3 |** On the **Overview** page, expand **Essentials** . The Essentials section displays the health status of the selected Cloud NGFW. 


![](images/fetchpdf-1780573081890.pdf-0309-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**309** 

Monitor Cloud NGFW for Azure Resources 

## View Traffic and Threat Logs Natively in Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



A log is an automatically generated, time-stamped file that provides an audit trail for system events on the firewall or network traffic events that the firewall monitors. Log entries contain artifacts, which are properties, activities, or behaviors associated with the logged event, such as the application type or the IP address of an attacker. Each log type records information for a separate event type. For example, the firewall generates a Threat log to record traffic that matches a spyware, vulnerability, or malware signature or a DoS attack that matches the thresholds configured for a port scan or host sweep activity on the firewall. 

The Cloud NGFW can send traffic, threat, and decryption logs to an Azure Log Analytics Workspace that you will create in the Azure portal. The Log Analytics Workspace is associated with a workspace ID, primary Key, and a secondary key, which is retrieved through the logging API by the control plane. 

## Log Types 

Cloud NGFW can capture and save three types of logs. 

- **Traffic** —Traffic logs display an entry for the start and end of each session. See Cloud NGFW for Azure Traffic Log Fields  for more information. 

- **Threat** —Threat logs display entries when traffic matches one of the Security Profiles attached to a security rule on the firewall. Each entry includes the following information: date and time; type of threat (such as malware or spyware); threat description or URL (Name column); alarm action (such as allow or block); and severity level. 

See Cloud NGFW for Azure Threat Log Fields for more information. 

|**Severity**|**Description**|
|---|---|
|Critical|Serious threats, such as those that affect default<br>installations of widely deployed software, result in<br>root compromise of servers, and the exploit code is<br>widely available to attackers. The attacker usually does<br>not need any special authentication credentials or<br>knowledge about the individual victims and the target<br>does not need to be manipulated into performing any<br>special functions.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**310** 

Monitor Cloud NGFW for Azure Resources 

|**Severity**|**Description**|
|---|---|
|High|Threats that have the ability to become critical but have<br>mitigating factors; for example, they may be difficult to<br>exploit, don’t result in elevated privileges, or don’t have<br>a large victim pool.|
|Medium|Minor threats in which impact is minimized, such as DoS<br>attacks that don’t compromise the target or exploits<br>that require an attacker to reside on the same LAN as<br>the victim, affect only nonstandard configurations or<br>obscure applications, or provide very limited access.|
|Low|Warning-level threats that have very little impact on an<br>organization's infrastructure. They usually require local<br>or physical system access and may often result in victim<br>privacy or DoS issues and information leakage.|
|Informational|Suspicious events that don’t pose an immediate threat,<br>but that are reported to call attention to deeper<br>problems that could possibly exist. URL Filtering log<br>entries are logged as Informational. Log entries with<br>any verdict and an action set to block are logged as<br>Informational.|



- **Decryption** —decryption logs display entries for unsuccessful TLS handshakes by default and can display entries for successful TLS handshakes if you enable them in the decryption policy. If you enable entries for successful handshakes, ensure that you have the system resources (log space) for the logs. See Cloud NGFW for Azure Decryption Log Fields for more information. 

## Enable Log Settings 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



A log is an automatically generated, time-stamped file that provides an audit trail for system events on the firewall or network traffic events that the firewall monitors. Log entries contain artifacts, which are properties, activities, or behaviors associated with the logged event, such as the application type or the IP address of an attacker. Each log type records information for a separate event type. For example, the firewall generates a Threat log to record traffic that matches a spyware, vulnerability, or malware signature or a DoS attack that matches the thresholds configured for a port scan or host sweep activity on the firewall. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**311** 

Monitor Cloud NGFW for Azure Resources 

The Cloud NGFW for Azure can send traffic, threat, and decryption logs to an Azure Log Analytics Workspace that you will create in the Azure portal. The Log Analytics Workspace is associated with a workspace ID, primary Key, and a secondary key, which is retrieved through the logging API by the control plane. 

To enable log settings: 

- **STEP 1 |** From the homepage, navigate to the Cloud NGFW firewall on which you want to enable log settings. 

- **STEP 2 |** Click **Log Settings** . 

- **STEP 3 |** Check **Enable Log Settings** . 

- **STEP 4 |** Choose the desired Log Analytics Workspace for which you wish to enable the log settings, from the **Log Settings** drop-down. 

**STEP 5 |** Click **Save** . 

## Disable Log Settings 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



A log is an automatically generated, time-stamped file that provides an audit trail for system events on the firewall or network traffic events that the firewall monitors. Log entries contain artifacts, which are properties, activities, or behaviors associated with the logged event, such as the application type or the IP address of an attacker. Each log type records information for a separate event type. For example, the firewall generates a Threat log to record traffic that matches a spyware, vulnerability, or malware signature or a DoS attack that matches the thresholds configured for a port scan or host sweep activity on the firewall. 

The Cloud NGFW for Azure can send traffic, threat, and decryption logs to an Azure Log Analytics Workspace that you will create in the Azure portal. The Log Analytics Workspace is associated with a workspace ID, primary Key, and a secondary key, which is retrieved through the logging API by the control plane. 

To disable log settings: 

- **STEP 1 |** From the homepage, navigate to the Cloud NGFW firewall on which you want to enable log settings. 

## **STEP 2 |** Click **Log Settings** . 

- **STEP 3 |** Check **Disable Log Settings** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**312** 

Monitor Cloud NGFW for Azure Resources 

**STEP 4 |** Choose the desired Log Analytics Workspace for which you wish to disable the log settings, from the **Log Settings** drop-down. 

## **STEP 5 |** Click **Save** . 

## View the Logs in Log Analytics Workspace 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



|**Field Name**|**Description**|
|---|---|
|Source Address (src_ip)|Original session source IP address.|
|Source port (sport)|Source port utilized by the session.|
|Destination Address (dst)|Original session destination IP address.|
|Destination port (dport)|Destination port utilized by the session.|
|IP Protocol (proto)|IP protocol associated with the session.|
|Application (app)|Application associated with the session.|
|Rule Name (rule)|Name of the rule that the session matched.|
|Action (action)|Action taken for the session; possible values are:<br>• allow—session permitted by policy<br>• deny—session permitted by policy<br>• reset both—session terminated and a TCP reset is sent<br>to both the sides of the connection<br>• reset client—session was terminated and a TCP reset is<br>sent to the client<br>• reset server—session terminated and a TCP reset is sent<br>to the server.|
|Bytes Received (bytes_received)|Number of bytes in the server-to-client direction of the<br>session.|
|Bytes Sent (bytes_sent)|Number of bytes in the client-to-server direction of the<br>session.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**313** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
|Packets Received (pkts_received)|Number of server-to-client packets for the session.|
|Packets Sent (pkts_sent)|Number of client-to-server packets for the session.|
|Start Time (start)|Time of session start.|
|Elapsed Time (elapsed)|Elapsed time of the session.|
|Repeat Count (repeatcnt)|Number of sessions with the same Source IP, Destination<br>IP, Application, and Subtype seen within 5 seconds.|
|Category (category)|URL category associated with the session (if applicable).|
|Source Country (srcloc)|Source country or Internal region for private addresses;<br>maximum length is 32 bytes.|
|Destination Country (dstloc)|Destination country or Internal region for private<br>addresses. The maximum length is 32 bytes.|
|Session End Reason<br>(session_end_reason)|The reason is a session terminated. If the termination had<br>multiple causes, this field displays only the highest priority<br>reason. The possible session end reason values are as<br>follows, in order of priority (where the first is highest):<br>• threat—The firewall detected a threat associated with a<br>reset, drop, or block (IP address) action.<br>• policy-deny—The session matched a security rule with a<br>deny or drop action.<br>• decrypt-cert-validation—The session terminated<br>because you configured the firewall to block when the<br>session uses client authentication or when the session<br>uses a server certificate with any of the following<br>conditions: expired, untrusted issuer, unknown<br>status, or status verification timeout. This session<br>end reason also displays when the server certificate<br>produces afatal erroralert of type bad_certificate,<br>unsupported_certificate, certificate_revoked,<br>access_denied, or no_certificate_RESERVED (SSLv3<br>only).<br>• decrypt-unsupport-param—The session terminated<br>because you configured the firewall to block SSL<br>Forward Proxy decryption or SSL Inbound Inspection<br>when the session uses an unsupported protocol version,<br>cipher, or SSH algorithm. This session end reason is<br>displayed when the session produces a fatal error alert|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**314** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
||of type unsupported_extension, unexpected_message,<br>or handshake_failure.<br>• decrypt-error—The session terminated because you<br>configured the firewall to block SSL Forward Proxy<br>decryption or SSL Inbound Inspection when firewall<br>resources were unavailable. This session end reason is<br>also displayed when you configured the firewall to block<br>SSL traffic that has SSL errors or that produced any fatal<br>error alert other than those listed for the decrypt-cert-<br>validation and decrypt-unsupport-param end reasons.<br>• tcp-rst-from-client—The client sent a TCP reset to the<br>server.<br>• tcp-rst-from-server—The server sent a TCP reset to the<br>client.<br>• resources-unavailable—The session dropped because of<br>a system resource limitation. For example, the session<br>could have exceeded the number of out-of-order<br>packets allowed per flow or the global out-of-order<br>packet queue.<br>• tcp-fin—Both hosts in the connection sent a TCP FIN<br>message to close the session.<br>• tcp-reuse—A session is reused and the firewall closes<br>the previous session.<br>• decoder—The decoder detects a new connection<br>within the protocol (such as HTTP-Proxy) and ends the<br>previous connection.<br>• aged-out—The session aged out.<br>• n/a—This value applies when the Traffic log type isn’t<br>**`end`**.|
|XFF Address (xff)|The IP address of the user who requested the webpage<br>or the IP address of the next to the last device that the<br>request traversed. If the request goes through one or more<br>proxies, load balancers, or other upstream devices, the<br>firewall displays the IP address of the most recent device.|



## **Cloud NGFW for Azure Traffic Log Fields** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**315** 

Monitor Cloud NGFW for Azure Resources 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
||Azure Marketplace subscription|



|**Field Name**|**Description**|
|---|---|
|Source Address (src_ip)|Original session source IP address.|
|Source port (sport)|Source port utilized by the session.|
|Destination Address (dst)|Original session destination IP address.|
|Destination port (dport)|Destination port utilized by the session.|
|IP Protocol (proto)|IP protocol associated with the session.|
|Application (app)|Application associated with the session.|
|Rule Name (rule)|Name of the rule that the session matched.|
|Action (action)|Action taken for the session; possible values are:<br>• allow—session permitted by policy<br>• deny—session permitted by policy<br>• reset both—session terminated and a TCP reset is sent<br>to both the sides of the connection<br>• reset client—session was terminated and a TCP reset is<br>sent to the client<br>• reset server—session terminated and a TCP reset is sent<br>to the server|
|Bytes Received (bytes_received)|Number of bytes in the server-to-client direction of the<br>session.|
|Bytes Sent (bytes_sent)|Number of bytes in the client-to-server direction of the<br>session.|
|Packets Received (pkts_received)|Number of server-to-client packets for the session.|
|Packets Sent (pkts_sent)|Number of client-to-server packets for the session.|
|Start Time (start)|Time of session start.|
|Elapsed Time (elapsed)|Elapsed time of the session.|
|Repeat Count (repeatcnt)|Number of sessions with the same Source IP, Destination<br>IP, Application, and Subtype seen within 5 seconds.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**316** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
|Category (category)|URL category associated with the session (if applicable).|
|Source Country (srcloc)|Source country or Internal region for private addresses;<br>maximum length is 32 bytes.|
|Destination Country (dstloc)|Destination country or Internal region for private<br>addresses. The maximum length is 32 bytes.|
|Session End Reason<br>(session_end_reason)|The reason is a session terminated. If the termination had<br>multiple causes, this field displays only the highest priority<br>reason. The possible session end reason values are as<br>follows, in order of priority (where the first is highest):<br>• threat—The firewall detected a threat associated with a<br>reset, drop, or block (IP address) action.<br>• policy-deny—The session matched a security rule with a<br>deny or drop action.<br>• decrypt-cert-validation—The session terminated<br>because you configured the firewall to block when the<br>session uses client authentication or when the session<br>uses a server certificate with any of the following<br>conditions: expired, untrusted issuer, unknown<br>status, or status verification timeout. This session<br>end reason also displays when the server certificate<br>produces afatal erroralert of type bad_certificate,<br>unsupported_certificate, certificate_revoked,<br>access_denied, or no_certificate_RESERVED (SSLv3<br>only).<br>• decrypt-unsupport-param—The session terminated<br>because you configured the firewall to block SSL<br>Forward Proxy decryption or SSL Inbound Inspection<br>when the session uses an unsupported protocol version,<br>cipher, or SSH algorithm. This session end reason is<br>displayed when the session produces a fatal error alert<br>of type unsupported_extension, unexpected_message,<br>or handshake_failure.<br>• decrypt-error—The session terminated because you<br>configured the firewall to block SSL Forward Proxy<br>decryption or SSL Inbound Inspection when firewall<br>resources were unavailable. This session end reason is<br>also displayed when you configured the firewall to block<br>SSL traffic that has SSL errors or that produced any fatal<br>error alert other than those listed for the decrypt-cert-<br>validation and decrypt-unsupport-param end reasons.<br>• tcp-rst-from-client—The client sent a TCP reset to the<br>server.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**317** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
||• tcp-rst-from-server—The server sent a TCP reset to the<br>client.<br>• resources-unavailable—The session dropped because of<br>a system resource limitation. For example, the session<br>could have exceeded the number of out-of-order<br>packets allowed per flow or the global out-of-order<br>packet queue.<br>• tcp-fin—Both hosts in the connection sent a TCP FIN<br>message to close the session.<br>• tcp-reuse—A session is reused and the firewall closes<br>the previous session.<br>• decoder—The decoder detects a new connection<br>within the protocol (such as HTTP-Proxy) and ends the<br>previous connection.<br>• aged-out—The session aged out.<br>• n/a—This value applies when the Traffic log type isn’t<br>**`end`**.|
|XFF Address (xff)|The IP address of the user who requested the webpage<br>or the IP address of the next to the last device that the<br>request traversed. If the request goes through one or more<br>proxies, load balancers, or other upstream devices, the<br>firewall displays the IP address of the most recent device.|



## **Cloud NGFW for Azure Threat Log Fields** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



|**Field Name**|**Description**|
|---|---|
|Source address (src_ip)|Original session source IP address.|
|Source port (sport)|Source port utilized by the session.|
|Destination address (dst)|Original session destination IP address.|
|Destination port (dport)|Destination port utilized by the session.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**318** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
|IP Protocol (proto)|IP protocol associated with the session.|
|Application (app)|Application associated with the session.|
|Rule Name (rule)|Name of the rule that the session matched.|
|Action (action)|Action taken for the session; values are alert, allow, deny, drop,<br>drop-all-packets, reset-client, reset-server, reset-both, block-url.<br>• alert—threat or URL detected but not blocked<br>• allow— flood detection alert<br>• deny—flood detection mechanism activated and deny traffic<br>based on configuration<br>• drop— threat detected and the associated session was<br>dropped<br>• reset-client —threat detected and a TCP RST sent to the client<br>• reset-server —threat detected and a TCP RST sent to the<br>server<br>• reset-both —threat detected and a TCP RST sent to both the<br>client and the server<br>• block-url —URL request blocked because it matched a URL<br>category that was blocked<br>• block-ip—threat detected and client IP is blocked<br>• random-drop—flood detected and the packet was randomly<br>dropped<br>• sinkhole—DNS sinkhole activated<br>• syncookie-sent—syncookie alert<br>• block-continue (URL subtype only)—an HTTP request is<br>blocked and redirected to a Continue page with a button for<br>confirmation to proceed<br>• continue (URL subtype only)—response to a block-continue<br>URL continue page indicating a block-continue request was<br>allowed to proceed<br>• block-override (URL subtype only)—an HTTP request is<br>blocked and redirected to an admin override page that requires<br>a pass code from the firewall administrator to continue<br>• override-lockout (URL subtype only)—too many failed admin<br>override pass code attempts from the source IP. IP is now<br>blocked from the block-override redirect page<br>• override (URL subtype only)—response to a block-override<br>page where a correct pass code is provided and the request is<br>allowed|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**319** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**<br>|
|---|---|
||• block (WildFire®only)—file blocked by the firewall and<br>uploaded to WildFire®|
|Threat Category<br>(threat_category)|Describes threatcategoriesused to classify different types of<br>threat signatures.|
|Threat/Content Type<br>(threat_content_type)|Subtype of Threat log. Values include the following:<br>• data—Data pattern matching a data filtering profile.<br>• file—File type matching a file blocking profile.<br>• flood—Flood detected via a Zone Protection profile.<br>• packet—Packet-based attack protection triggered by a Zone<br>Protection profile.<br>• scan—Scan detected via a Zone Protection profile.<br>• spyware —Spyware detected via an antispyware profile.<br>• url—URL filtering log.<br>• ml-virus—malware detected by WildFire®Inline ML via an<br>Antivirus profile.<br>• virus—malware detected via an Antivirus profile.<br>• vulnerability —Vulnerability exploit detected via a Vulnerability<br>Protection profile.<br>• wildfire —A WildFire verdict generated when the firewall<br>submits a file to WildFire per a WildFire Analysis profile and a<br>verdict (malware, phishing, grayware, or benign, depending on<br>what you're logging) is logged in the WildFire Submissions log.<br>• wildfire-virus®—malware detected via an Antivirus profile.|
|Threat/Content Name<br>(threat_content_name)|Palo Alto Networks identifier for known and custom threats. It's<br>a description string followed by a 64-bit numerical identifier in<br>parentheses for some Subtypes:<br>• 8000-8099— scan detection<br>• 8500-8599— flood detection<br>• 9999— URL filtering log<br>• 10000-19999 —spyware phone home detection<br>• 20000-29999 —spyware download detection<br>• 30000-44999 —vulnerability exploits detection<br>• 52000-52999— filetype detection<br>• 60000-69999 —data filtering detection|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**320** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
||_Threat ID ranges for virus detection, WildFire_<br>_signature feed, and DNS C2 signatures used in_<br>_previous releases are replaced with permanent,_<br>_globally unique threat IDs. Refer to the Threat/_<br>_Content Type (subtype) and threat Category_<br>_(thr_category) field names to create updated reports,_<br>_filter threat logs, and ACC activity._|
|Severity (severity)|Severity associated with the threat; values are informational, low,<br>medium, high, critical.|
|Direction (direction)|Indicates the direction of the attack, client-to-server, or server-to-<br>client:<br>• 0—direction of the threat is client to server<br>• 1—direction of the threat is server to client|
|Repeat Count (repeatcnt)|Number of sessions with the same Source IP, Destination IP,<br>Application, and Content or Threat Type seen within 5 seconds.|
|Reason<br>(data_filter_reason)|Reason for data filtering action.|
|XFF Address (xff)|The IP address of the user who requested the webpage or the IP<br>address of the next to the last device that the request traversed.<br>If the request goes through one or more proxies, load balancers,<br>or other upstream devices, the firewall displays the IP address of<br>the most recent device.|
|Content Version<br>(contentver)|Applications and Threats version on your firewall when the log is<br>generated.|



## **Cloud NGFW for Azure Decryption Log Fields** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**321** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
|Source IP address<br>(src_ip)|Original session source IP address.|
|Source port (sport)|Source port utilized by the session.|
|Destination Address<br>(dst)|Original session destination IP address.|
|Destination port (dport)|Destination port utilized by the session.|
|IP Protocol (proto)|IP protocol associated with the session.|
|Application (app)|Application associated with the session.|
|Rule (rule)|Security policy rule that controls the session traffic.|
|Action (action)|Action taken for the session; possible values are:<br>• allow—session permitted by policy<br>• deny—session denied by policy<br>• reset both—session terminated and a TCP reset sent to both the<br>sides of the connection<br>• reset client—session terminated and a TCP reset sent to the client<br>• reset server—session terminated and a TCP reset sent to the<br>server|
|TLS Version<br>(tls_version)|The version of the TLS protocol used for the session.|
|Key Exchange<br>Algorithm (tls_keyxchg)|The key exchange algorithm used for the session.|
|Encryption Algorithm<br>(tls_enc)|The algorithm used to encrypt the session data, such as AES-128-<br>CBC, AES-256-GCM, etc.|
|Hash Algorithm<br>(tls_auth)|The authentication algorithm used for the session, for example, SHA,<br>SHA256, SHA384, etc.|
|Elliptic Curve<br>(ec_curve)|The elliptic cryptography curve that the client and server negotiate<br>and use for connections that use ECDHE cipher suites.|
|Server Name Indication<br>(server_name_indication)|The Server Name Indication.|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**322** 

Monitor Cloud NGFW for Azure Resources 

|**Field Name**|**Description**|
|---|---|
|Server Name<br>Indication Length<br>(server_name_indication_|length)<br>The length of the Server Name Indication (hostname).|
|Proxy Type<br>(proxy_type)|The decryption proxy type, such as Forward for Forward Proxy,<br>Inbound for Inbound Inspection, No decrypt for undecrypted traffic,<br>GlobalProtect™, etc.<br>_Selecting_**_No Decrypt_**_, rather than_**_None_**_, causes traffic to_<br>_drop._|
|Chain Status<br>(chain_status)|Whether the chain is trusted. Values are:<br>• Uninspected<br>• Untrusted<br>• Trusted<br>• Incomplete|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**323** 

Monitor Cloud NGFW for Azure Resources 

## View Activity Logs Natively in Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Track administrator activity on Cloud NGFW for Azure to achieve real-time reporting of activity across your deployment. If you have reason to believe that an administrator account is compromised, the activity log provides you with a full history of where an administrator navigated throughout the Cloud NGFW tenant and what configuration changes they made so you can analyze in detail and respond to all actions taken by the compromised account. 

A log is an automatically generated, time-stamped file that provides an audit trail for system events on the firewall or network traffic events that the firewall monitors. Log entries contain artifacts, which are properties, activities, or behaviors associated with the logged event, such as the application type or the IP address of an attacker. Each log type records information for a separate event type. For example, the firewall generates a Threat log to record traffic that matches a spyware, vulnerability, or malware signature or a DoS attack that matches the thresholds configured for a port scan or host sweep activity on the firewall. 

The Cloud NGFW can send traffic, threat, and decryption logs to an Azure Log Analytics Workspace that you will create in the Azure portal. The Log Analytics Workspace is associated with a workspace ID, primary Key, and a secondary key, which is retrieved through the logging API by the control plane. 

## Configure Logging 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



A log is an automatically generated, time-stamped file that provides an audit trail for system events on the firewall or network traffic events that the firewall monitors. Log entries contain artifacts, which are properties, activities, or behaviors associated with the logged event, such as the application type or the IP address of an attacker. Each log type records information for a separate event type. For example, the firewall generates a Threat log to record traffic that matches a spyware, vulnerability, or malware signature or a DoS attack that matches the thresholds configured for a port scan or host sweep activity on the firewall. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**324** 

Monitor Cloud NGFW for Azure Resources 

The Cloud NGFW can send traffic, threat, and decryption logs to an Azure Log Analytics Workspace that you will create in the Azure portal. The Log Analytics Workspace is associated with a workspace ID, primary Key, and a secondary key, which is retrieved through the logging API by the control plane. 

## **Log Types** 

Cloud NGFW can capture and save three types of logs. 

- **Traffic** —Traffic logs display an entry for the start and end of each session. See Cloud NGFW for Azure Traffic Log Fields for more information. 

- **Threat** —Threat logs display entries when traffic matches one of the Security Profiles attached to a security rule on the firewall. Each entry includes the following information: date and time; type of threat (such as malware or spyware); threat description or URL (Name column); alarm action (such as allow or block); and severity level. 

See Cloud NGFW for Azure Threat Log Fields for more information. 

|**Severity**|**Description**|
|---|---|
|Critical|Serious threats, such as those that affect default<br>installations of widely deployed software, result in<br>root compromise of servers, and the exploit code is<br>widely available to attackers. The attacker usually does<br>not need any special authentication credentials or<br>knowledge about the individual victims and the target<br>does not need to be manipulated into performing any<br>special functions.|
|High|Threats that have the ability to become critical but have<br>mitigating factors; for example, they may be difficult to<br>exploit, don’t result in elevated privileges, or don’t have<br>a large victim pool.|
|Medium|Minor threats in which impact is minimized, such as DoS<br>attacks that don’t compromise the target or exploits<br>that require an attacker to reside on the same LAN as<br>the victim, affect only nonstandard configurations or<br>obscure applications, or provide very limited access.|
|Low|Warning-level threats that have very little impact on an<br>organization's infrastructure. They usually require local<br>or physical system access and may often result in victim<br>privacy or DoS issues and information leakage.|
|Informational|Suspicious events that don’t pose an immediate threat,<br>but that are reported to call attention to deeper<br>problems that could possibly exist. URL Filtering log<br>entries are logged as Informational. Log entries with|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**325** 

Monitor Cloud NGFW for Azure Resources 

**Severity Description** any verdict and an action set to block are logged as Informational. 

- **Decryption** —decryption logs display entries for unsuccessful TLS handshakes by default and can display entries for successful TLS handshakes if you enable them in the decryption policy. If you enable entries for successful handshakes, ensure that you have the system resources (log space) for the logs. See Cloud NGFW for Azure Decryption Log Fields for more information. 

## View Audit Logs in a Firewall Resource 

## **Where Can I Use This?** 

## **What Do I Need?** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



A log is an automatically generated, time-stamped file that provides an audit trail for system events on the firewall or network traffic events that the firewall monitors. Log entries contain artifacts, which are properties, activities, or behaviors associated with the logged event, such as the application type or the IP address of an attacker. Each log type records information for a separate event type. For example, the firewall generates a Threat log to record traffic that matches a spyware, vulnerability, or malware signature or a DoS attack that matches the thresholds configured for a port scan or host sweep activity on the firewall. 

The Cloud NGFW can send traffic, threat, and decryption logs to an Azure Log Analytics Workspace that you will create in the Azure portal. The Log Analytics Workspace is associated with a workspace ID, primary Key, and a secondary key, which is retrieved through the logging API by the control plane. 

To view audit logs on the firewall Resource that is deployed on a resource group: 

- **STEP 1 |** From the homepage, navigate to the Cloud NGFW firewall resource on which you want to view the logs. 

- **STEP 2 |** Click **Activity Log** on the left pane and select the desired **Timespan** for which you wish to view the logs and click **Apply** . The list of logs for the selected timespan appears. 

- **STEP 3 |** Click the desired log to view the **Summary** and **JSON** of the log. 

## View Audit Logs on Resource Groups 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**326** 

Monitor Cloud NGFW for Azure Resources 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
||Azure Marketplace subscription|



A log is an automatically generated, time-stamped file that provides an audit trail for system events on the firewall or network traffic events that the firewall monitors. Log entries contain artifacts, which are properties, activities, or behaviors associated with the logged event, such as the application type or the IP address of an attacker. Each log type records information for a separate event type. For example, the firewall generates a Threat log to record traffic that matches a spyware, vulnerability, or malware signature or a DoS attack that matches the thresholds configured for a port scan or host sweep activity on the firewall. 

The Cloud NGFW for Azure can send traffic, threat, and decryption logs to an Azure Log Analytics Workspace that you will create in the Azure portal. The Log Analytics Workspace is associated with a workspace ID, primary Key, and a secondary key, which is retrieved through the logging API by the control plane. 

To view audit logs on resource groups: 

- **STEP 1 |** Navigate to **Resource groups** from the homepage. 

- **STEP 2 |** Click the **Resource group** for which you wish to collect the activity log. 

- **STEP 3 |** Click **Activity Log** on the left pane and select the desired **Timespan** for which you wish to view the logs and click **Apply** . The list of logs for the selected timespan appears. 

- **STEP 4 |** Click the desired log to view the **Summary** and **JSON** of the log. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**327** 

Monitor Cloud NGFW for Azure Resources 

## View Cloud NGFW Metrics in Azure Monitor 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW for Azure integrates with the Azure Monitor to provide enhanced visibility into the performance and operational health of your firewall resources. By leveraging Azure Application Insights, you can ingest, query, and set alerts on key firewall metrics, all within your existing Azure ecosystem. This allows you to monitor critical data points such as throughput, session counts, SNAT port utilization, and latency to better troubleshoot issues and understand traffic patterns. 

The following tables details the metrics that are exposed through the Azure Monitor integration: 

|**Dimension**|**Metric**|
|---|---|
|Data Processed|Bytes in / Bytes out|
||Packets in / Packets out|
||Session Count|
|Throughput|Session ThroughputKbps|
||Session ThroughputPps|
|Latency|PacketLatency|
|SNAT|Load Balancer Source NAT port utilization|



Cloud NGFW for Azure publishes custom metrics in Azure Monitor to help you monitor your Cloud NGFW's health, performance, and usage patterns. With these additional metrics, you can assess the overall health of your Cloud NGFW resources, identify performance bottlenecks, and detect anomalies. These metrics are numerical values describing aspects of a Cloud NGFW at a particular time. The 5-minute collection frequency makes these metrics highly effective for alerting. 

Enable Cloud NGFW for Azure monitoring metrics in your Azure portal and view these metrics in your Azure Application Insights. Following are the prerequisites, steps to enable, and view monitoring metrics in Azure application insights page. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**328** 

Monitor Cloud NGFW for Azure Resources 

## Prerequisites 

Before you begin, you must have the following configured: 

- **STEP 1 | Create Azure Application Insights** : You must have Azure Application Insights created. For more information, see Configure Application Insights. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**329** 

Monitor Cloud NGFW for Azure Resources 

**STEP 2 | Create and Associate the Managed Identity** : 

**1. Create a User-Assigned Managed Identity** : First, you must create a user-assigned managed identity (MI). For more information, see create system managed identity. 

**2. Associate Managed Identity with the Cloud NGFW Firewall** : 


![](images/fetchpdf-1780573081890.pdf-0330-04.png)


- _When you attempt to associm ate managed identity with CNGFW firewall, ensure that you have the following:_ 

- _LocalNGFirewallAdministrator role on your Cloud NGFW firewall resource._ 

- _Managed Identity Operator role on the managed identity resource._ 

Go to your **Cloud NGFW firewall** resource in the Azure portal. In the left-hand menu, go to **Settings** > **Managed Identity** , and click **Add Identity** . Add the managed identity you just created. This step links the identity to the firewall. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**330** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0331-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**331** 

Monitor Cloud NGFW for Azure Resources 

This managed identity requires **Monitoring Metrics Publisher** role on the target Azure Application Insights resource. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**332** 

Monitor Cloud NGFW for Azure Resources 

**STEP 3 |** Assign **Monitoring Metrics Publisher** role to the managed identity. 

**1.** From the previously created **Application Insights** menu, go to Access Control (IAM). 


![](images/fetchpdf-1780573081890.pdf-0333-03.png)


_Ensure that the_ _**Local authentication** option is disabled for the selected_ _**Application Insights** ._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**333** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0334-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**334** 

Monitor Cloud NGFW for Azure Resources 

## **2.** Click **Add** . 

**3.** Select previously created Monitoring metrics publisher role. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**335** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0336-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**336** 

Monitor Cloud NGFW for Azure Resources 

**4.** In the Members tab, select **Managed Identity** checkbox and select the managed identity name. 

**5.** Click **Review and Assign** . 

## Enable Cloud NGFW Metrics 

To enable CNGFW Metrics perform the following steps: 

- **STEP 1 |** In the Azure portal, select the **Cloud NGFW Firewall** resource for which you want to enable metrics. 

- **STEP 2 |** From the left navigation menu, go to **Metrics and Logs** > **Metrics** . 

- **STEP 3 |** Click **Edit** at the top of the page. 

- **STEP 4 |** Select **Enable Metrics Settings** checkbox. 

**STEP 5 |** Select **Subscription** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**337** 

Monitor Cloud NGFW for Azure Resources 

## **STEP 6 |** Select the **Azure Application Insights** you created as a prerequisite. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**338** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0339-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**339** 

Monitor Cloud NGFW for Azure Resources 

## **STEP 7 |** Click **Save** . 

## View Cloud NGFW Metrics 

To view the metrics in your Azure Application Insights: 

**STEP 1 |** In the Azure portal, navigate to your **Cloud NGFW Firewall** . 

**STEP 2 |** In the left navigation menu, click **Metrics and Logs** . 

## **STEP 3 |** Click **Application Insights** . 


![](images/fetchpdf-1780573081890.pdf-0340-07.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**340** 

Monitor Cloud NGFW for Azure Resources 

**STEP 4 |** In the left navigation pane, go to **Monitoring** > **Metrics** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**341** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0342-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**342** 

Monitor Cloud NGFW for Azure Resources 

**STEP 5 |** Configure the chart view: 

- **Scope** : Select the Cloud NGFW firewall resource for which you enabled metrics. 

- **Metric Namespace** : Choose the custom namespace corresponding to your firewall. The namespace is formatted as `pan.cngfw.<region>.<firewall-name>` . 

- **Metric** : Select the desired metric you wish to plot from the drop-down list (For example: SessionCount, BytesIn). 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**343** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0344-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**344** 

Monitor Cloud NGFW for Azure Resources 

- **STEP 6 |** The portal will automatically plot the time-series graph for the selected metric. You can add multiple metrics to the chart and use standard Azure Monitor features for time selection, aggregation, and creating alert rules. 


![](images/fetchpdf-1780573081890.pdf-0345-02.png)


- _The metrics published to your Application Insights are not real-time. There will be a minor delay consisting of a one-minute aggregation interval plus a propagation latency of under five minutes_ 

## Important Considerations 

- If the linked **Application Insights** resource is deleted, CNGFW metrics will stop flowing. The resource link on the Cloud NGFW's **Logs and Metrics** page will become invalid or return a 404 error. 

- Metric collection will fail if the associated User-Assigned **Managed Identity** is deleted or disabled, as the firewall will lose its ability to authenticate to your Azure Application insights. 

- If the required **Monitoring Metrics Publisher** role is removed from the Managed Identity, the firewall will no longer have the authorization to send data, and metric publication will stop. In this case, add the role back to the managed identity. For any assistance contact customer support. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**345** 

Monitor Cloud NGFW for Azure Resources 

## View Cloud NGFW Logs and Activity in Panorama 

## **Where Can I Use This?** 

## **What Do I Need?** 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



When integrating Cloud NGFW resources with Panorama, logs and activity are captured and displayed in Panorama on the Monitoring and Application Command Center (ACC) tabs. Panorama collects logs generated by the Cloud NGFW and displays them on the **Monitor** tab. You can select from the Traffic, Threat, URL Filtering, and Decryption logs and filter those by ID or name. 

**STEP 1 |** Log in to Panorama. 

- **STEP 2 |** Select **Monitor** . 

**STEP 3 |** From the **Device Group** drop-down, select the **Cloud Device Group** to view activity. 

- **STEP 4 |** You can use a Panorama filter to view the log of an individual Cloud Device Group. Locate the **Device Name** . Click the **+** icon in the upper right portion of the Panorama interface to add a new filter. Enter the name for the filter, then click **Save** . Click the **Load Filter** icon. Select the newly created filter to display the logs for the individual Cloud Device Group. 

- **STEP 5 |** From the **Logs** menu on the left side on the Panorama console, you can choose a specific type of log to view. 


![](images/fetchpdf-1780573081890.pdf-0346-11.png)


## View Cloud NGFW Activity in the ACC 

The ACC is an analytical tool that provides actionable intelligence about the activity within your network. The ACC uses the Cloud NGFW logs to graphically depict traffic trends on your network. The graphical representation allows you to interact with the data and visualize the 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**346** 

Monitor Cloud NGFW for Azure Resources 

relationships between events on the network including network usage patterns, traffic patterns, and suspicious activity and anomalies. 

In Panorama, you can filter ACC content based on Cloud Device Group. To learn how to filter and view specific information about activity on your Cloud NGFW resources, see the ACC documentation for PAN-OS. 

- **STEP 1 |** Log in to Panorama. 

- **STEP 2 |** Select **ACC** . 

- **STEP 3 |** From the **Device Group** drop-down, select the **Cloud Device Group** to view activity. 


![](images/fetchpdf-1780573081890.pdf-0347-06.png)


- **STEP 4 |** You can use a Panorama filter to view the log of an individual Cloud Device Group. Locate the **Device Name** . Click the **+** icon in the upper right portion of the Panorama interface to add a new filter. Enter the name for the filter, then click **Save** . Click the **Load Filter** icon. Select the newly created filter to display the logs for the individual Cloud Device Group. 

## Prerequisites for Configuring Cloud NGFW Log Collection Using Panorama 

This section describes the prerequisites for configuring Panorama to collect logs for your Cloud NGFW for Azure resources. 

- **STEP 1 |** If you intend to store logs in Panorama, you must configure your Panorama virtual appliance to run in **Panorama Mode** with an extra attached disk for log storage. Click here for more information. 

- **STEP 2 |** If you deployed your Panorama virtual appliance behind another firewall, the policy configuration on that firewall must allow TCP connections from the hub vNET/vWAN on the following ports: 3978, 28443, 28270. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**347** 

Monitor Cloud NGFW for Azure Resources 

**STEP 3 |** If you configured the Cloud Device Group for your Azure plugin to use a public IP address to communicate with Panorama, a public IP address must be configured on the Panorama management interface. 


![](images/fetchpdf-1780573081890.pdf-0348-02.png)


**STEP 4 |** Configure a managed collector with an S/N and a disk. 


![](images/fetchpdf-1780573081890.pdf-0348-04.png)


The status must be GREEN, and in sync: 


![](images/fetchpdf-1780573081890.pdf-0348-06.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**348** 

Monitor Cloud NGFW for Azure Resources 

- **STEP 5 |** Push to the log collector Group; explicitly push to the Collector Group to resolve synchronization issues noted in the previous step. This step is necessary. In Panorama, select **Push to devices > Edit Selections > Collector Group** . 


![](images/fetchpdf-1780573081890.pdf-0349-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**349** 

Monitor Cloud NGFW for Azure Resources 

## **STEP 6 |** Configure the collector group with the managed collector. 


![](images/fetchpdf-1780573081890.pdf-0350-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**350** 

Monitor Cloud NGFW for Azure Resources 

- **STEP 7 |** The Cloud Device Group must have the log collector Group selected before deploying the Cloud NGFW; you can't perform this task after deploying your Cloud NGFW. 


![](images/fetchpdf-1780573081890.pdf-0351-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**351** 

Monitor Cloud NGFW for Azure Resources 

**STEP 8 |** Configure the log forwarding profile. Create this profile under the Cloud Device Group and configure it to forward the required log types to Panorama. 


![](images/fetchpdf-1780573081890.pdf-0352-02.png)


**STEP 9 |** Configure log forwarding in the Security policy rules. 


![](images/fetchpdf-1780573081890.pdf-0352-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**352** 

Monitor Cloud NGFW for Azure Resources 

**STEP 10 |** If you're using a Dedicated Log Collector, you must configure a destination-based service route for the log collector’s IP address. 


![](images/fetchpdf-1780573081890.pdf-0353-02.png)


Also configure an explicit policy rule to allow traffic to the log collector IP address. 


![](images/fetchpdf-1780573081890.pdf-0353-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**353** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0354-01.png)


_When using Panorama for policy management and log collection, consider that the Cloud NGFW connects to Panorama using a private IP address. If you have configured a public IP address on the management node the log collector uses the public IP address. For more information about this behavior, refer to this_ knowledge base article _in the Customer Support Portal._ 

**STEP 11 |** If you intend to use Panorama to collect system-level logs, configure the Log Settings under the device template: 


![](images/fetchpdf-1780573081890.pdf-0354-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**354** 

Monitor Cloud NGFW for Azure Resources 

## Enable Strata Logging Service (SLS) for existing Panorama-managed firewalls 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



You can now seamlessly enable Strata Logging Service (SLS) for existing Panorama-managed firewalls without requiring intervention from Palo Alto Networks support. 

As a prerequisite for using the **SLS feature** with CNGFW, Panorama must first be added to the SCM/HUB. For more information, see Associate device with a tenant. 

To handle these changes, do the following: 

- Get the Panorama device serial number (This should be the same Panorama through which Cloud NGFW Firewall is managed) 

- Add Panorama device serial number to the Tenant Service Group (TSG) where Strata Logging Service (SLS) is enabled. For more information, see Associate Devices with a Tenant. 

- Once the above is complete, generate a new configuration string. For more information, see Panorama Policy Management. 

- Update the firewall in Azure portal with the new configuration. 

## **Prerequisites:** 

Following are the prerequisites for SLS integration with Panorama-managed firewalls, as these will result in degraded statuses and messages if not met. 

- Panorama Plugin for Azure version 5.2.3 and later. 

- The Azure Service and Panorama must be located within the same Cloud Service Provider (CSP). 

- Panorama and SLS must be associated with the same Tenant Service Group (TSG). 

- When creating a firewall, a PIN/VALUE must be generated from the CSP where Panorama is, and this must be used in the registration string. 

For more information see Monitor Cloud NGFW Health. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**355** 

Monitor Cloud NGFW for Azure Resources 

## View Traffic and Threat Logs in Strata Cloud Manager 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



On Strata Cloud Manager (SCM), you can instantly access a filtered log view in the Strata Logging Service (SLS) for your Cloud NGFW resource. 

## **Prerequisites** 

Before you begin, ensure you have the following: 

- A Cloud NGFW for Azure resource successfully deployed and onboarded to Strata Cloud Manager. 

## **View Cloud NGFW logs in Strata Cloud Manager** 

Following are the steps to view traffic and threat logs for your Cloud NGFW resource: 

## **STEP 1 |** Log in to the **Strata Cloud Manager** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**356** 

Monitor Cloud NGFW for Azure Resources 

- **STEP 2 |** In the left navigation pane **System Settings** , go to **Inventory** > **Strata Logging Service** . Logs can also be viewed in **Log Viewer** section. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**357** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0358-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**358** 

Monitor Cloud NGFW for Azure Resources 

## **STEP 3 |** Select the **Cloud NGFW** tab. 

This will display a list of all your provisioned Cloud NGFW resources. 

**STEP 4 |** In the list, locate the specific Cloud NGFW resource for which you want to view logs. 


![](images/fetchpdf-1780573081890.pdf-0359-04.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**359** 

Monitor Cloud NGFW for Azure Resources 

## **STEP 5 |** In the **View Logs** column for the corresponding row, click **View Logs** . 

You will be redirected to the **Log Viewer** page. 


![](images/fetchpdf-1780573081890.pdf-0360-03.png)


The log query interface will load with a pre-populated filter, displaying only the Traffic and Threat logs from the Cloud NGFW resource you selected. You can now begin analyzing the logs. 


![](images/fetchpdf-1780573081890.pdf-0360-05.png)


_By default, the Strata Logging Service displays logs from the_ _**past 24 hours** . To view historical logs, use the time range selector located in the_ _**top-right corner** of the page. Choose a predefined period like_ _**Past 7 days** or set a custom date and time range to refine your search._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**360** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0361-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**361** 

Monitor Cloud NGFW for Azure Resources 

## View Traffic and Threat Logs in Strata Logging Service 

## **Where Can I Use This?** 

## **What Do I Need?** 

• Cloud NGFW for Azure 


![](images/fetchpdf-1780573081890.pdf-0362-05.png)



![](images/fetchpdf-1780573081890.pdf-0362-06.png)



![](images/fetchpdf-1780573081890.pdf-0362-07.png)


Cloud NGFW subscription Palo Alto Networks Customer Support Portal account Azure Marketplace subscription 


![](images/fetchpdf-1780573081890.pdf-0362-09.png)


_Strata Logging Service and Panorama licenses must be procured outside of Cloud NGFW for Azure integration. This integration does not automatically grant licenses for using the Strata Logging Service within Panorama._ 

When you integrate Cloud NGFW with Panorama and Strata Logging Service (formerly Cortex Data Lake), you forward logs created by your Cloud NGFW resources and view them in Strata Logging Service. In the Strata Logging Service web interface, you can view the Traffic, threat, and decryption logs generated by your Cloud NGFW Resources. 


![](images/fetchpdf-1780573081890.pdf-0362-12.png)


_If you're using Panorama and are not using Strata Logging Service for log collection, you can forward logs to another entity, however, you must enable Strata Logging Service in your logging profile._ 

For information about the log fields, see the Strata Logging Service Schema Reference: Traffic, Threat, and Decryption. 

## **Important Considerations** 

For existing customers who have already deployed the Cloud NGFW in Azure and would like to use Strata Logging Service: 

- Upgrade your current Panorama Plugin for Azure to version 5.2.3 or later. 

- Follow the instructions noted in this page. 

- Generate the registration string from the Panorama Plugin for Azure; contact Palo Alto Networks support to update the registration string to enable the Strata Logging Service. 

For _new_ users who are deploying the Cloud NGFW resource and would like to use the Strata Logging Service, consider the following: 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**362** 

Monitor Cloud NGFW for Azure Resources 

- You must use Panorama to enable log forwarding to the Strata Logging Service. 


![](images/fetchpdf-1780573081890.pdf-0363-02.png)


_The Panorama web interface continues to show_ _**Cortex Data Lake** , rather than the updated product name,_ _**Strata Logging Service** ._ 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**363** 

Monitor Cloud NGFW for Azure Resources 


![](images/fetchpdf-1780573081890.pdf-0364-01.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**364** 

Monitor Cloud NGFW for Azure Resources 

- You must use the Panorama for Azure plugin version 5.2.3 (or later). 

- If your Panorama is setup in a HA pair, both Panorama serial numbers should be registered to the same CSP account, and should also be associated with the same Strata Logging Service. 

To use Strata Logging Service with Cloud NGFW for Azure: 

- **STEP 1 |** Log in to your Strata Logging Service instance. 

- **STEP 2 |** Select **Explore** . 


![](images/fetchpdf-1780573081890.pdf-0365-06.png)


- **STEP 3 |** From the query drop-down, you can select the type of logs. Each page displays 100 logs. However, you can use the Strata Logging Service Queries to refine the information displayed. 

- **STEP 4 |** Select **Inventory** to display information about onboarded firewalls. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**365** 

Monitor Cloud NGFW for Azure Resources 

## **STEP 5 |** In the **Inventory** page, select **Cloud NGFW** . 


![](images/fetchpdf-1780573081890.pdf-0366-02.png)


## Forward Logs to Strata Logging Service 

To forward logs to Strata Logging Service: 

**STEP 1 |** In the Panorama console, select **Objects** under **Device Groups** . 

**STEP 2 |** Select **Log Forwarding** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**366** 

Monitor Cloud NGFW for Azure Resources 

**STEP 3 |** Click **Add** to create a new log forwarding match list profile. 


![](images/fetchpdf-1780573081890.pdf-0367-02.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**367** 

Monitor Cloud NGFW for Azure Resources 

**STEP 4 |** In the **Log Forwarding Profile Match List** screen, specify a name for the log. 

**STEP 5 |** Select a **Log Type** from the drop-down. 

**STEP 6 |** Select **Panorama/Strata Logging Service** as the **Forward Method** . 


![](images/fetchpdf-1780573081890.pdf-0368-04.png)


**STEP 7 |** Click **OK** . 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**368** 

Monitor Cloud NGFW for Azure Resources 

**STEP 8 |** Commit and push your change. 

## Forward Logs without Strata Logging Service 

If you're using Panorama and are not using Strata Logging Service for log collection, you can forward logs to another entity. 

- **STEP 1 |** In the Panorama console, select **Objects** under **Device Groups** . 

- **STEP 2 |** Select **Log Forwarding** . 

- **STEP 3 |** Click **Add** to create a new log forwarding match list profile. 

- **STEP 4 |** In the **Log Forwarding Profile Match List** screen, specify a name for the log. 

- **STEP 5 |** Select a **Log Type** from the drop-down. 

- **STEP 6 |** Enable Strata Logging Service in your logging profile even if you don't intend to send logs directly to it. 

- **STEP 7 |** Click **OK** . 

- **STEP 8 |** Commit and push your change. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**369** 

Monitor Cloud NGFW for Azure Resources 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**370** 


![](images/fetchpdf-1780573081890.pdf-0371-00.png)


## Cloud NGFW for Azure as Code 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



The Cloud NGFW for Azure supports programmatic access to native resources. 

Programmatic access to Azure native resources refers to interacting with and managing Azure services and resources through code, scripts, or automation tools rather than manually using the Azure portal. This allows developers and administrators to automate tasks, integrate Azure services into applications, and manage infrastructure efficiently. 

Palo Alto Networks Cloud NGFW is a native Azure ISV service. It integrates with the Azure Resource Manager framework to provide a native Azure experience. This integration allows you to use the Azure native portal, Azure CLI, Azure SDK, and Azure Powershell to deploy and manage Cloud NGFW resources. 

You can also use Azure native Infrastructure-as-code tools, such as ARM templates Bicep and the third-party Azure Terraform provider, to deploy Cloud NGFW resources and other Azure native resources in your environment. 

You can deploy Cloud NGFW as code and manage policies (local rulestack) in your Azure environment in multiple ways: 

|**Type**|**Cloud NGFW Command Reference**|
|---|---|
|Azure CLI|• az palo-alto|
|Azure SDK|• Phyton<br>• Java<br>• .Net<br>• Go<br>• JavaScript|
|Azure Poweshell|• Az.PaloAltoNetworks|
|ARM Templates|• ARM Template Definition|
|Azure Bicep|• Cloud NGFW Bicep Definition|
|Terraform|• Terraform Definition|



**371** 

Cloud NGFW for Azure as Code 

- Hashicorp (VNET,Virtual WAN Hub) 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Administration 

**372** 


