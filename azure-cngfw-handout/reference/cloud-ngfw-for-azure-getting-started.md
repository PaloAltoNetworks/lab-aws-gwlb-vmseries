---
source: pdf_url
url: https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/pdf/cloud-ngfw-azure/cloud-ngfw-for-azure-getting-started.pdf
title: Cloud NGFW for Azure Getting Started
fetched: 2026-06-04T11:39:47.461Z
pages: 40
---
## Cloud NGFW for Azure Getting Started 

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

February 2, 2026 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**2** 

## Table of Contents 

**Introducing Cloud NGFW for Azure............................................................. 5** Cloud NGFW for Azure............................................................................................................. 6 Supported Cloud NGFW Management and Deployment Features.............................. 11 Supported Security Policy Management Features............................................................12 **Cloud NGFW for Azure Free Trial...............................................................39** 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**3** 

Table of Contents 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**4** 


![](images/fetchpdf-1780573179802.pdf-0005-00.png)


## Introducing Cloud NGFW for Azure 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud Next-Generation Firewall by Palo Alto Networks - an Azure Native ISV Service - is Palo Alto Networks Next-Generation Firewall (NGFW) delivered as a cloud-native service on Azure. With Cloud NGFW, you can access the core NGFW capabilities such as App-ID, URL filtering based on URL categories and geolocations, SSL/TLS decryption, etc. It provides threat prevention and detection through cloud-delivered security services and threat prevention signatures. You can discover Cloud NGFW in the Azure Portal. 

## **Cloud NGFW Components** 

Cloud NGFW for Azure creates a number of components that work together to secure your Azure environment. 

- The **Cloud NGFW tenant** is an instantiation of the Cloud NGFW service associated with your Azure account when one of your Azure users subscribes to the service. Cloud NGFW designates you, the subscribing Azure user, as the administrator of a Cloud NGFW tenant. Based on the assigned role, other users can create Cloud NGFW resources and configure rulestacks with the tenant. 

- The **Cloud NGFW Resource** (or simply NGFW) is associated with your Azure subscription and can span multiple availability zones. This resource has built-in resiliency, scalability, and lifecycle management. 

- **Rulestacks** define the NGFW traffic filtering behavior such as advanced access control (AppID, URL Filtering) and threat prevention. A rulestack includes a set of security rules and the associated objects and Security Profiles. To use a rulestack, you associate the rulestack with one or more NGFW resources. 


![](images/fetchpdf-1780573179802.pdf-0005-09.png)


- _Cloud NGFW supports a local rulestack. Local account administrators can associate a local rulestack with an NGFW in their AWS account. A local rulestack includes local rules._ 

**5** 

Introducing Cloud NGFW for Azure 

## Cloud NGFW for Azure 

## **Where Can I Use This?** 

## **What Do I Need?** 

• Cloud NGFW for Azure 


![](images/fetchpdf-1780573179802.pdf-0006-05.png)



![](images/fetchpdf-1780573179802.pdf-0006-06.png)



![](images/fetchpdf-1780573179802.pdf-0006-07.png)


Cloud NGFW subscription Palo Alto Networks Customer Support Portal (CSP) account Azure Marketplace subscription 

Cloud NGFW is a machine learning (ML) next-generation firewall delivered as a cloud-native service. With Cloud NGFW, you can run multiple applications securely at cloud speed and scale with a true cloud-native experience. Cloud NGFW combines best-in-class network security with ease of use to deliver a fully managed cloud-native service. It extends Palo Alto Networks threat prevention capabilities to cloud providers, while being natively integrated into the cloud providers various service offerings. Cloud NGFW: 

- Minimizes infrastructure management. 

- Stops zero-day, web-based threats in real-time. 

- Secures applications as they connect to legitimate web-based services. 

- Simplifies the native cloud provider experience with simple, consistent firewall policy management across multiple accounts. 

- Automates end-to-end workflows with support for API, ARM templates, and Terraform. 

The Cloud NGFW stops web-based attacks, vulnerabilities, exploits, and other known evasions, including sophisticated file-based attacks, using patented App-ID traffic classification technology. Cloud NGFW: 

- Secures traffic while crossing trust boundaries, like Azure VNets and vWANs. The managed service provided by Cloud NGFW blocks attackers from gaining access to resources, and stops data exfiltration and command and control (C2) traffic. It's purpose-built to stop unauthorized or east-west lateral movement. 

- Is designed with automation in mind. With rulestack configuration and automated Security Profiles, Cloud NGFW is designed to meet network security requirements easily with an intuitive web interface that simplifies the creation of resilient firewall resources that scale with your network traffic. 

- Incorporates an automated cloud firewall model that dynamically scales with your network traffic and meets unpredictable throughput demands with Gateway Load Balancing (GWLB) for on-demand high availability and elastic scaling. You can access as much or as little capacity as you need, and scale up and down as required. 

- Integrates security with workflows managed by cloud providers. With Cloud NGFW, the first next-generation firewall to integrate with cloud providers, you can avoid lengthy deployment cycles and get up and running quickly, even when setting up required rulestacks and automated Security Profiles. You can leverage the security model provided by the chosen cloud provider while integrating with their onboarding, monitoring, and logging capabilities. Cloud NGFW provides a unique benefit when integrating with cloud providers. You can take 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**6** 

Introducing Cloud NGFW for Azure 

advantage of automatic scaling and high availability with no maintenance requirements. This integration enables consistent firewall policy management across multiple cloud provider accounts. 

You can use the Cloud NGFW for Azure. With the Cloud NGFW, you can access core NGFW capabilities including App-ID, URL filtering based on URL categories and geolocations, and SSL/ TLS decryption. 

## **Supported features** 

The Cloud NGFW for Azure provides the following features: 

- **Cloud-native deployment and management** . Enable next-generation firewall capabilities in your Azure environment while managing day 0 and day N operations on Cloud NGFW resources seamlessly, as you would with any other Azure service. For permissions, use Azure role-based access control (RBAC) to control Cloud NGFW resources. 

- **Advanced application visibility and control** . Cloud NGFW offers advanced application awareness and access control using App-ID and URL filtering techniques 

- **Next generation threat prevention** . Palo Alto Networks NGFW features, with cloud-delivered security services and threat prevention signatures are provided across the physical and software-installed base. 

## **The Cloud NGFW for Azure Model** 

The Cloud NGFW is an Azure Native ISV Service. This approach allows Palo Alto Networks to develop and manage the FWaaS by using hooks provided by the Azure service to leverage the FWaaS natively through the Azure web interface and APIs. The Cloud NGFW for Azure is accessible in Azure Marketplace. You can use all the benefits of Palo Alto Networks NGFW for Azure’s VNets and vWANs. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**7** 

Introducing Cloud NGFW for Azure 


![](images/fetchpdf-1780573179802.pdf-0008-01.png)



![](images/fetchpdf-1780573179802.pdf-0008-02.png)


## **Cloud NGFW Components** 

The Cloud NGFW for Azure includes the following key components: 

- **The Cloud NGFW** . The Cloud NGFW is a managed Azure regional service, available in select key Azure regions. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**8** 

Introducing Cloud NGFW for Azure 

- **NGFW** . Palo Alto Networks uses the NGFW as the resource associated with the customer’s VNet or vWAN hub. It provides resiliency, scalability, and lifecycle management. The NGFW manifests as private IP addresses in the NGFW subnet specified by the user. To use the NGFW resource, update VNet UDRs to send traffic through the private IP addresses. 

- **NGFW rulestack** . This resource includes a set of security rules along with associated objects and Security Profiles to enable advanced access control, using App-ID and URL filtering, and threat prevention features. You can associate a local rulestack with one or more NGFWs. 

## **Securing traffic with the Cloud NGFW** 

Cloud NGFW provides you with the tools and functionality to secure inbound traffic, outbound traffic, and East-West traffic. 

**Inbound** traffic refers to any traffic originating outside of your Azure region and bound for resources inside your application VNets, such as servers or load balancers. Cloud NGFW can prevent malware and vulnerabilities from entering your VNet in the inbound traffic allowed by Azure security groups. 


![](images/fetchpdf-1780573179802.pdf-0009-06.png)


**Outbound** traffic refers to traffic originating within your application VNet and is bound for destinations outside of the Azure region. Cloud NGFW protects outbound traffic flows by ensuring that resources in your VNet application connect to allowed services and allowed URLs while preventing exfiltration of sensitive data and information. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**9** 

Introducing Cloud NGFW for Azure 


![](images/fetchpdf-1780573179802.pdf-0010-01.png)


**East-West** traffic moves within an Azure region. Specifically, traffic between source and destination is deployed in two different application VNets or in two different subnets in the same VNet. Cloud NGFW can stop the propagation of malware within your Azure environment. 


![](images/fetchpdf-1780573179802.pdf-0010-03.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**10** 

Introducing Cloud NGFW for Azure 

## Supported Cloud NGFW Management and Deployment Features 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



The Palo Alto Networks Cloud NGFW for Azure supports the following management and deployment features. 

|**NGFW Deployment &**<br>**Management**|**Description**|**Native NGFW**<br>**Deployment**|**Azure Deployment**|
|---|---|---|---|
|Tools|You have multiple<br>configuration options<br>to deploy and<br>manage Cloud NGFW<br>resources.|• Create Security<br>Rules Using the<br>Cloud NGFW<br>Console<br>• Cloud NGFW APIs<br>• Terraform|• Azure portal<br>• Azure API<br>• Azure Terraform|
|Azure Regions|Cloud NGFW for<br>Azure is an Azure<br>regional service. The<br>Cloud NGFWs you<br>deploy protects your<br>VPC Ingress and<br>Egress traffic in that<br>Azure region.|• Supported regions<br>and zones|Azure regions|
|Deployment<br>Architectures|There are multiple<br>deployment models<br>available with<br>Cloud NGFW for<br>Azure. The right<br>model depends on<br>the use case and<br>requirements.|• VNet deployments<br>• vWAN<br>deployments|• VNet deployments<br>• vWAN<br>deployments|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**11** 

Introducing Cloud NGFW for Azure 

## Supported Security Policy Management Features 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal (CSP) account<br>Azure Marketplace subscription|



The Palo Alto Networks Cloud NGFW for Azure supports the following security features. 

|**Security**<br>**Posture,**<br>**Health**<br>**Posture, and**<br>**Operations**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
|Log<br>Visualization<br>& Analytics|Cloud<br>NGFW can<br>deliver the<br>generated<br>logs to Azure<br>destinations,<br>Palo Alto<br>Networks<br>Log Collector<br>and Strata<br>Logging<br>Service.<br>Review<br>Cloud NGFW<br>logs to verify<br>a wealth of<br>information<br>of your VNet<br>and vWAN<br>traffic.<br>Allows you<br>to monitor<br>the traffic by<br>applications,<br>users, and<br>content<br>activity—URL<br>categories,<br>threats,|Azure Log<br>Analytics<br>Workspace|√|√|√|
|||Strata<br>Logging<br>Service|—|√|√|
|||Panorama<br>Log Collector|—|√|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**12** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Posture,**<br>**Health**<br>**Posture, and**<br>**Operations**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||security<br>policies that<br>effectively<br>block data or<br>files.|||||
|Policy<br>Analysis &<br>Optimization|Rule usage<br>monitoring<br>helps you<br>evaluate<br>whether<br>your policy<br>implementatio<br>continues to<br>match your<br>enforcement<br>needs.<br>Policy<br>Analyzer<br>analyzes your<br>Cloud NGFW<br>rules and<br>recommends<br>possible<br>consolidation<br>or removal of<br>specific rules<br>to meet your<br>intended<br>Security<br>posture. it<br>also checks<br>for aN/<br>Amalies, such<br>as shadows,<br>redundancies,<br>generalizations<br>correlations,<br>and<br>consolidations<br>in your<br>rulebase.|n<br>,|—|√|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**13** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Posture,**<br>**Health**<br>**Posture, and**<br>**Operations**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||Policy<br>Optimizer<br>identifies<br>port-based<br>rules so you<br>can convert<br>them to<br>application-<br>based allow<br>rules or add<br>applications<br>from a port-<br>based rule to<br>an existing<br>application-<br>based rule<br>without<br>compromising<br>application<br>availability.|||||
|Operational<br>Metrics|You can<br>specify<br>Palo Alto<br>Networks<br>firewalls<br>to publish<br>custom<br>metrics to<br>monitoring<br>systems in<br>Palo Alto<br>Networks<br>(AIOPs),<br>Panorama<br>or Azure<br>AppInsights .<br>These<br>metrics allow<br>you to assess<br>firewall<br>performance|Azure<br>AppInsights|—|—|—|
|||Palo Alto<br>Networks<br>AIOPs|—|—|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**14** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Posture,**<br>**Health**<br>**Posture, and**<br>**Operations**|**Description**|**Description**|||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|---|---|---|---|
||and usage<br>patterns.|||||||||
|Packet<br>Capture|You can<br>specify<br>Palo Alto<br>Networks<br>firewall to<br>perform<br>a custom<br>packet<br>capture or a<br>threat packet<br>capture.||Threat<br>Packet<br>Captures||—||—||—|
||||Traffic<br>Packet<br>Captures||—||—||—|
|||||||||||
|**Policy Objects**||**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**||**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**||**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**||
|Address||You can specify<br>an address<br>object to include<br>either IPv4 or<br>IPv6 addresses<br>(a single IP<br>address, a range<br>of addresses,<br>or a subnet),<br>an FQDN, or a<br>wildcard address<br>(IPv4 address<br>followed by<br>a slash and<br>wildcard mask).||√||√||√||
|Address Groups||You can group<br>specific source<br>or destination<br>addresses that<br>require the||—||√||√||



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**15** 

Introducing Cloud NGFW for Azure 

|**Policy Objects**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
||same policy<br>enforcement.||||
|Regions|You can allow<br>or block traffic<br>from (or to) an<br>IP addresses<br>based on their<br>geographic<br>location such<br>as a county.<br>The region is<br>available as an<br>option when<br>specifying the<br>source and<br>destination for<br>your policy rules.<br>You can choose<br>from a standard<br>list of countries<br>or specify a<br>custom region<br>or geolocation<br>along with its<br>associated IP<br>addresses|√|√|√|
|Service (Port &<br>Protocol)|You can<br>granularly<br>control vNET<br>traffic session<br>usage to specific<br>ports on your<br>network (in<br>other words, you<br>can define the<br>default port for<br>the application).<br>Cloud NGFW<br>includes two<br>predefined<br>services—<br>service-http<br>and service-|√|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**16** 

Introducing Cloud NGFW for Azure 

|**Policy Objects**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
||https— that use<br>TCP ports 80<br>and 8080 for<br>HTTP, and TCP<br>port 443 for<br>HTTPS. You can<br>however create<br>any custom<br>service on any<br>TCP/UDP port<br>of your choice.||||
|Service Groups|You can<br>combine<br>services that<br>have the same<br>security settings<br>into Service<br>Groups to<br>reduce the<br>number of rules<br>in Security<br>policy.|—|√|√|
|External<br>dynamic list|You can<br>granularly<br>control your<br>vNET traffic<br>using a dynamic<br>list of IP<br>addresses,<br>Domains, or<br>URLs. Stored<br>in a file hosted<br>on an external<br>web server. Palo<br>Alto Networks<br>also offersbuilt-<br>in (Bulletproof,<br>High-Risk,<br>Known<br>Malicious, and<br>Tor Exit IP<br>address) EDLs.<br>Additionally,|—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**17** 

Introducing Cloud NGFW for Azure 

|**Policy Objects**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
||Palo Alto<br>Networks offers<br>a freeEDL<br>hosting service<br>that maintains<br>the ever-<br>dynamic list of<br>IP addresses for<br>Microsoft 365,<br>Azure, Amazon<br>Web Services<br>(AWS), and<br>Google Cloud<br>Platform (GCP).<br>You can use<br>these EDLs to<br>control your<br>vNET Ingress<br>and Egress<br>traffic.||||
|Applications|You can<br>granularly<br>control your<br>vNET traffic<br>by using a Palo<br>Alto Networks<br>App-ID traffic<br>classification<br>system that<br>relies on<br>application<br>signatures to<br>accurately<br>identify<br>applications in<br>your network.|√|√|√|
|Application<br>group|You can group<br>together a set<br>of App-IDs that<br>require the<br>same policy<br>enforcement.|—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**18** 

Introducing Cloud NGFW for Azure 

|**Policy Objects**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
|Application<br>filters|You can<br>granularly<br>control your<br>vNET traffic<br>by defining an<br>application filter<br>that groups<br>current App-IDs<br>and any future<br>App-IDs that<br>match certain<br>attributes. For<br>example, You<br>can create an<br>application<br>filter by one or<br>more attributes<br>—category,<br>subcategory,<br>technology, risk,<br>characteristics.<br>From now on,<br>whenever a<br>new App-ID<br>is introduced<br>to Cloud<br>NGFW based<br>on a content<br>update, all new<br>applications<br>matching the<br>filter criteria are<br>automatically<br>added to your<br>set.|—|√|√|
|Tags|Tags allow you<br>to group objects<br>using keywords<br>or phrases.<br>You can apply<br>tags to address<br>objects, address<br>groups (static|—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**19** 

Introducing Cloud NGFW for Azure 

|**Policy Objects**|**Policy Objects**|**Description**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|---|---|---|---|
|||and dynamic),<br>applications,<br>zones, services,<br>Service Groups,<br>and to policy<br>rules.||||||||
|Dynamic User<br>Group||Allow you to<br>create a list of<br>users from the<br>local database,<br>an external<br>database, or<br>match criteria<br>and group them.||—||√||—||
|App-ID Cloud||Also known<br>as the device<br>dictionary, this<br>page contains<br>metadata for<br>device objects.||—||—||—||
|||||||||||
|**Certificates**<br>**and**<br>**Decryption**|**Description**||||**Native Policy**<br>**Management**<br>**(Rulestacks)**||**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**||**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|Certificates<br>Management|Cloud<br>NGFW uses<br>certificates<br>to access an<br>intelligent<br>feed and<br>to enable<br>inbound and<br>outbound<br>decryption.<br>Each<br>certificate<br>contains a<br>cryptographic||Self signed<br>Root CA<br>Certificates||—||√||√|
||||Import a<br>Certificate<br>and Private<br>Key||—||√||√|
||||Cloud<br>Certificates<br>(Azure Secret<br>Manager)||√|||||



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**20** 

Introducing Cloud NGFW for Azure 

|**Certificates**<br>**and**<br>**Decryption**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||key to<br>encrypt<br>plaintext<br>or decrypt<br>ciphertext.<br>Each<br>certificate<br>also includes<br>a digital<br>signature to<br>authenticate<br>the identity<br>of the issuer.|||||
|Decryption|Cloud NGFW<br>can decrypt,<br>inspect, and<br>reencrypt<br>your vNET<br>Ingress<br>and Egress<br>traffic as a<br>policy-based<br>decision.<br>You can<br>granularly<br>control what<br>vNET traffic<br>is decrypted<br>and what<br>traffic can’t<br>be decrypted<br>and the<br>type of SSL<br>decryption<br>you want to<br>perform on<br>the indicated<br>traffic. To<br>enable<br>decryption,<br>you set<br>up the<br>certificates|SSL Forward<br>Proxy|√|√|√|
|||SSL Inbound<br>Inspection|√|√|√|
|||SSH Proxy|N/A|√||



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**21** 

Introducing Cloud NGFW for Azure 

|**Certificates**<br>**and**<br>**Decryption**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||required<br>to act as a<br>trusted third<br>party to a<br>session.|||||
|||||||
|**Security**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|Security<br>Policy|Security<br>policy<br>protects<br>your VNet<br>traffic from<br>threats and<br>disruptions.<br>Individual<br>Security<br>policy rules<br>determine<br>whether<br>to block<br>or allow<br>a VNet/<br>VNet traffic<br>session based<br>on traffic<br>attributes,<br>such as the<br>source and<br>destination<br>security<br>zone, the<br>source and<br>destination IP<br>address, the<br>application,<br>the user, and<br>the service.||√|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**22** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
|IPS<br>Vulnerability<br>Protection|Vulnerability<br>Protection<br>protects<br>against on<br>inbound<br>threats,<br>where an<br>attacker is<br>attempting<br>to exploit<br>a system<br>vulenrability<br>to breach<br>your<br>network,<br>The system<br>vulnerabilies<br>may be in the<br>form buffer<br>overflows,<br>illegal code<br>execution<br>etc.|Default<br>Profile|√|√|√|
|||Custom<br>Profile|—|√|√|
|Anti-spyware|Anti-Spyware<br>detects<br>and blocks<br>outbound<br>threats,<br>especially<br>command-<br>and-control<br>(C2) activity,<br>initiated by a<br>(cyber-attack<br>leveraged)<br>malware<br>infected<br>workloads<br>in your<br>Azure vNet.<br>You can<br>also define|Default<br>Profile|√|√|√|
|||Custom<br>Profile|—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**23** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||custom<br>regular<br>expression<br>patterns<br>to identify<br>spyware<br>phone home<br>communication|.||||
|File blocking|File blocking<br>allows you<br>to granularly<br>control file<br>types in your<br>vNET traffic<br>in a specified<br>direction<br>(inbound/<br>outbound/<br>both).<br>You can<br>proactively<br>block files<br>known to<br>carry threats<br>or that have<br>no real use<br>case for<br>upload and<br>download.|Default<br>Profile|√|√|√|
|||Custom<br>Profile|—|√|√|
|Antivirus|Antivirus<br>detects and<br>protects<br>against<br>malware<br>concealed in<br>compressed<br>files,<br>executables,<br>PDF<br>files, and<br>HTML and<br>JavaScript|Default<br>Profile|√|√|√|
|||Custom<br>Profile|—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**24** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||malware in<br>your vNET<br>traffic|||||
|Advanced<br>WildFire<br>Analysis|Cloud NGFW<br>detects and<br>forwards<br>files and<br>executables<br>in your vNET<br>traffic to<br>WildFire™<br>cloud service<br>for analysis,<br>and also<br>performs<br>inline ML<br>analysis for<br>certain files.<br>If a threat<br>is detected<br>on the files,<br>WildFire<br>creates<br>protections<br>to block<br>malware,<br>and globally<br>distributes<br>protection<br>for that<br>threat in<br>under five<br>minutes.<br>Advanced<br>wildfire<br>analysis<br>provides real-<br>time zero-<br>day malware<br>prevention<br>using inline||—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**25** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||cloud<br>analysis.|||||
|URL Filtering|URL Filtering<br>analyzes the<br>vNET traffic<br>and controls<br>the URLs<br>accessed by<br>your vNET<br>workloads (in<br>both clear-<br>text and<br>encrypted<br>traffic) by<br>performing<br>inline<br>analysis and<br>comparing<br>against<br>Palo Alto<br>Networks<br>managed<br>URL<br>categories or<br>the custom<br>categories<br>you provide.|Default<br>Profile|√|√|√|
|||Custom<br>Profile|—|√|√|
|Advanced<br>DNS Security|DNS Security<br>protects<br>outbound<br>DNS<br>requests<br>from your<br>vNETs<br>against<br>threats such<br>as DNS<br>tunneling,<br>Domain<br>Generation<br>Algorithm<br>(DGA)|Default<br>Profile|√|√|√|
|||Custom<br>Profile|—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**26** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||detection,<br>malware<br>domains and<br>more.<br>Advanced<br>DNS Security<br>extends<br>standard<br>DNS Security<br>by using<br>Precision<br>AI to<br>detect DNS<br>tunneling,<br>domain<br>generation<br>algorithms<br>(DGA), and<br>ultra-low-<br>TTL threats.<br>By enabling<br>Cloud Inline<br>Analysis,<br>the firewall<br>can stop<br>malicious<br>DNS traffic<br>before a<br>connection<br>is ever<br>established.|||||
|Enterprise<br>DLP and<br>Data Filtering|Enterprise<br>Data Loss<br>Prevention<br>(E-DLP)<br>safeguard<br>your<br>sensitive<br>information<br>against<br>unauthorized<br>access and||—|√|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**27** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||exfiltration.<br>You can<br>centrally<br>manage DLP<br>patterns<br>and profiles<br>across<br>their cloud<br>infrastructure,<br>maintaining<br>a consistent<br>security<br>posture.<br>Cloud NGFW<br>for Azure<br>exclusively<br>supports<br>E-DLP.<br>Consequently,<br>all data-<br>filtering<br>profiles<br>configured<br>in Panorama<br>are treated as<br>E-DLP usage<br>and will be<br>billed at the<br>E-DLP add-<br>on price.|||||
|Security<br>Profile<br>Groups|A Security<br>Profile Group<br>is a set of<br>Security<br>Profiles<br>treated as a<br>unit and then<br>easily added<br>to security<br>policy rules.||—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**28** 

Introducing Cloud NGFW for Azure 

|**Networking**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
|Application<br>Override|You can<br>configure<br>Cloud NGFW<br>to override<br>the N/Armal<br>Application<br>Identification<br>(App-ID)<br>of specific<br>traffic<br>passing<br>through the<br>firewall. As<br>soon as the<br>Application<br>Override<br>policy takes<br>effect, all<br>further App-<br>ID inspection<br>of the traffic<br>is stopped<br>and the<br>session is<br>identified<br>with the<br>custom<br>application<br>signatures<br>your provide.||—|√|√|
|NAT|Palo Alto<br>Networks<br>Fiirewalls<br>can enforce<br>Destination<br>NAT on your<br>Ingress vNet<br>traffic and<br>Source NAT<br>your Egress<br>vNet traffic|Ingress<br>(destination)<br>NAT|√|√|√|
|||Egress<br>(source) NAT|√|√|√|
|||Private NAT<br>to Azure<br>native PaaS|√|√|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**29** 

Introducing Cloud NGFW for Azure 

|**Networking**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
|Policy-based<br>forwarding|Palo Alto<br>Networks<br>firewalls<br>policy-based<br>forwarding<br>rules allow<br>traffic to take<br>an alternative<br>path for<br>security or<br>performance<br>reasons. Let's<br>say your<br>company<br>has two links<br>between the<br>corporate<br>office and<br>the branch<br>office: a<br>cheaper<br>internet link<br>and a more<br>expensive<br>leased line.<br>For enhanced<br>security,<br>you can use<br>PBF to send<br>applications<br>that are not<br>encrypted<br>traffic, such<br>as FTP<br>traffic, over<br>the private<br>leased line<br>and all other<br>traffic over<br>the internet<br>link. Or, for<br>performance,<br>you can||—|—|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**30** 

Introducing Cloud NGFW for Azure 

|**Networking**<br>**Services**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|
||choose<br>to route<br>business-<br>critical<br>applications<br>over the<br>leased line<br>while sending<br>all other<br>traffic, such<br>as web<br>browsing,<br>over the<br>cheaper link.|||||
|||||||
|**Security**<br>**Zones &**<br>**Protection**|**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|Security<br>zones|Security<br>zones are a<br>logical way<br>to group<br>interfaces on<br>the firewall,<br>and Cloud<br>NGFW<br>endpoints to<br>control and<br>log the vNET<br>traffic.|Private and<br>Public Zones|—|√|—|
|||Zone<br>Mapping|—|√|—|
|Zone<br>protection|Zone<br>protection<br>defends<br>network<br>security<br>zones against<br>flood attacks,<br>reconnaissance<br>attempts, and||—|√|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**31** 

Introducing Cloud NGFW for Azure 

|**Security**<br>**Zones &**<br>**Protection**|**Description**|**Description**|||**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Panorama**<br>**Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|---|---|---|---|---|
||packet-based<br>attacks.|||||||||
|||||||||||
|**Device Settings**||**Description**||**Native Policy**<br>**Management**<br>**(Rulestacks)**||**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**||**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**||
|XFF||Traffic to your<br>vNET workloads<br>might have<br>passed more<br>than one proxy<br>server (such<br>as CDN or<br>ALB) before<br>it reaches the<br>Cloud NGFW.<br>If there is an<br>existing XFF<br>header, these<br>proxies append<br>its IP address<br>to it or adds the<br>XFF header with<br>its IP address.<br>Therefore, the<br>XFF request<br>header might<br>contain multiple<br>IP addresses<br>separated by<br>commas. Cloud<br>NGFW uses the<br>X-Forwarded-<br>For (XFF) HTTP<br>header field that<br>identifies the<br>original client IP<br>address. Cloud<br>NGFW always<br>uses the most<br>recently added||—||√||—||



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**32** 

Introducing Cloud NGFW for Azure 

|**Device Settings**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
||address in the<br>XFF header to<br>enforce the<br>policy.||||
|DNS Proxy|When you<br>configure Cloud<br>NGFW as a DNS<br>proxy, it acts as<br>an intermediary<br>between clients<br>and servers and<br>as a DNS server<br>by resolving<br>queries from<br>its DNS cache<br>or forwarding<br>queries to other<br>DNS servers.<br>Use this page<br>to configure<br>the settings<br>that determine<br>how the firewall<br>serves as a DNS<br>proxy.|√|√|—|
|Interface<br>Management|Palo Alto<br>Networks<br>Firewalls allow<br>you to configure<br>VLANs, virtual<br>wires Link<br>Layer Discovery<br>Protocol,<br>Bidirectional<br>Forwarding<br>Detection (BFD)<br>on its interfaces|—|—|—|
|QoS|Palo Alto<br>Networks<br>firewalls<br>allow you to<br>specify traffic|—|—|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**33** 

Introducing Cloud NGFW for Azure 

|**Device Settings**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
||that requires<br>preferential<br>treatment or<br>bandwidth<br>limiting. QoS<br>rules allow you<br>to dependably<br>run high-priority<br>applications and<br>traffic under<br>limited network<br>capacity.||||
|Routing<br>Management|Palo Alto<br>Networks<br>Firewalls allow<br>you to configure<br>Static Routing<br>and Routing<br>Protocols<br>(BGP, BFD,<br>OSPF, OSPFv3,<br>multicast, RIPv2,<br>and filters).|—|—|—|
|IPSec Tunnel<br>Management|Palo Alto<br>Networks<br>firewalls<br>terminate IPSec<br>tunnels and<br>inspect tunneled<br>traffic|—|—|—|
|GlobalProtect™<br>Management|Palo Alto<br>Networks<br>firewalls<br>secure mobile<br>workforces<br>by specifying<br>algorithms for<br>authentication<br>and encryption<br>in VPN tunnels<br>between a<br>GlobalProtect|—|—|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**34** 

Introducing Cloud NGFW for Azure 

|**Device Settings**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
||gateway module<br>and client.||||
|GRE Tunnel<br>Management|Palo Alto<br>Networks<br>firewalls<br>terminate<br>generic routing<br>encapsulation<br>(GRE) tunnels<br>and inspect<br>tunneled traffic.|—|—|—|
|SD-WAN Link<br>Management|Palo Alto<br>Networks<br>firewalls bind<br>multiple WAN<br>connections<br>(ADSL/DSL,<br>cable modem,<br>Ethernet,<br>fiber optic,<br>LTE/3G/4G/5G,<br>MPLS,<br>microwave/<br>radio, satellite,<br>Wi-Fi) to a<br>virtual interface<br>and support<br>dynamic,<br>intelligent path<br>selection based<br>on applications<br>and services and<br>the conditions<br>of links that<br>each application<br>or service is<br>allowed to use.|—|—|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**35** 

Introducing Cloud NGFW for Azure 

|**Identity Services**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
|User-ID based<br>policies|User-ID™, a<br>standard feature<br>on the Palo<br>Alto Networks<br>firewall, enables<br>you to author<br>user- and<br>group-based<br>policies. User-ID<br>provides many<br>mechanisms<br>to collect this<br>User Mapping<br>information.<br>For example,<br>the User-ID<br>agent monitors<br>server logs for<br>login events and<br>listens for syslog<br>messages from<br>authenticating<br>services.<br>leverage user<br>information<br>stored in a<br>wide range of<br>repositories.|N/A|Supported<br>methods:<br>• TS Agent<br>• Agentless<br>with**winrm-**<br>**https**||
|Panorama/<br>Firewall based<br>data redirection|You can<br>congfigure some<br>firewalls to<br>collect user-<br>ID mapping<br>information<br>from various<br>sources and<br>then redistribute<br>them to other<br>firewalls such as<br>Cloud NGFWs.|—|√|√|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**36** 

Introducing Cloud NGFW for Azure 

|**Identity Services**|**Description**|**Native Policy**<br>**Management**<br>**(Rulestacks)**|**Panorama Policy**<br>**Management**<br>**(Cloud Device**<br>**Groups)**|**Strata Cloud**<br>**Manager**<br>**(SCM) Policy**<br>**Management**|
|---|---|---|---|---|
|Cloud Identity<br>Engine (CIE)<br>Directory Sync|Cloud Identity<br>Engine<br>(Directory Sync)<br>allows Palo<br>Alto Networks<br>Firewalls to<br>access your<br>Active Directory<br>information, so<br>that you can<br>easily set up and<br>manage security<br>and decryption<br>policies for users<br>and groups.|—|—|—|
|Cloud Identity<br>Engine (CIE)<br>based Identity<br>Redistribution|Cloud Identity<br>Engine (User<br>Context) collects<br>and distributes<br>IP address-<br>to-user name<br>mappings,<br>IP port to<br>username<br>mappings, user<br>tags IP address<br>tags, Host IDs,<br>and quarantine<br>list information<br>to Palo Alto<br>Networks<br>firewalls.|—|—|—|



> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**37** 

Introducing Cloud NGFW for Azure 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**38** 


![](images/fetchpdf-1780573179802.pdf-0039-00.png)


## Cloud NGFW for Azure Free Trial 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portals (CSP) account<br>Azure Marketplace subscription|



When you create the first Cloud NGFW or rulestack in your Azure Active Directory (AD) tenant, you are automatically enrolled for a 30-day free trial. The free trial period begins upon creation of your first Cloud NGFW for the Azure resource. 


![](images/fetchpdf-1780573179802.pdf-0039-04.png)


_To start a free trial today, go to the Cloud NGFW listing in Azure Marketplace and click_ **Get It Now** _. The free trial is effective across all subscriptions in the Azure AD tenant._ 

During the free trial period, you can use the following free of charge: 

- Two Cloud NGFW resources 

- 1 TB of traffic is inspected into total (average of 500 GB per Cloud NGFW resource) 

- Panorama integration 

- Cloud-Delivered Security Services (CDSS) 

- Strata Cloud Manager 

When the free trial period ends or your usage exceeds the limits of the free trial, you incur charges based on the terms described in the Azure marketplace **Palo Alto Networks Cloud NGFW Pay-As-You-Go** subscription listing. Consider the following when using the free trial. 

- You can’t pause the free trial 

- At the end of your free trial period, you begin incurring charges when using the Cloud NGFW 

**39** 

Cloud NGFW for Azure Free Trial 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Getting Started 

**40** 


