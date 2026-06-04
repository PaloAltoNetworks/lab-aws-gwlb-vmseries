---
source: pdf_url
url: https://docs.paloaltonetworks.com/content/dam/techdocs/en_US/pdf/cloud-ngfw-azure/cloud-ngfw-for-azure-deployment.pdf
title: Cloud NGFW for Azure Deployment
fetched: 2026-06-04T11:38:50.724Z
pages: 20
---
## Cloud NGFW for Azure Deployment 

docs.paloaltonetworks.com 

## **Contact Information** 

Corporate Headquarters: Palo Alto Networks 3000 Tannery Way Santa Clara, CA 95054 www.paloaltonetworks.com/company/contact-support 

## **About the Documentation** 

- For the most recent version of this guide or for access to related documentation, visit the Technical Documentation portal docs.paloaltonetworks.com. 

- To search for a specific topic, go to our search page docs.paloaltonetworks.com/search.html. 

- Have feedback or questions for us? Leave a comment on any page in the portal, or write to us at documentation@paloaltonetworks.com. 

## **Copyright** 

Palo Alto Networks, Inc. www.paloaltonetworks.com 

> © 2025-2025 Palo Alto Networks, Inc. Palo Alto Networks is a registered trademark of Palo Alto Networks. A list of our trademarks can be found at www.paloaltonetworks.com/company/ trademarks.html. All other marks mentioned herein may be trademarks of their respective companies. 

## **Last Revised** 

September 12, 2025 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**2** 

## Table of Contents 

**Cloud NGFW for Azure Deployment Architectures..................................5** Cloud NGFW for Azure Hub-and-Spoke Virtual Networks.............................................. 6 Centralized VNet Deployment Model: Internet Egress Traffic Inspection via Application Gateway VNET...........................................................................................7 Centralized VNet Deployment Model: Internet Ingress Traffic Inspection via Application Gateway Subnet.........................................................................................8 Centralized VNet Deployment Model: Internet Ingress via Application Gateway..............................................................................................................................9 Centralized VNet Deployment Model: East-West Traffic Inspection............... 10 Cloud NGFW for Azure Virtual WAN................................................................................. 11 Centralized vWAN Deployment Model: Internet Egress Traffic Inspection.........................................................................................................................12 Centralized vWAN Deployment Model: Internet Ingress Traffic Inspection.........................................................................................................................13 Centralized vWAN Deployment Model: Internet Ingress via Application Gateway........................................................................................................................... 14 Centralized vWAN Deployment Model: Internet Ingress via Application Gateway Subnet.............................................................................................................15 Centralized vWAN Deployment Model: East-West Traffic Inspection.............16 Centralized vWAN Deployment Model: East-West Traffic Inspection - On Prem to Cloud................................................................................................................ 17 Centralized vWAN Deployment Model: East-West vWAN Multi-Hub Traffic Inspection.........................................................................................................................18 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**3** 

Table of Contents 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**4** 


![](images/fetchpdf-1780573126841.pdf-0005-00.png)


## Cloud NGFW for Azure Deployment Architectures 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



There are multiple deployment models available with Cloud NGFW for Azure. The right model depends on the use case and requirements. You can use the native NGFW deployment method when you subscribe to Cloud NGFW via the Azure portal to procure a tenant. You can then deploy the Cloud NGFW resource for your VPCs using the Cloud NGFW console. These resources come with built-in resilience, scalability and life cycle management. Once you create the resource, you can author security policy rules using native policy management (rulestacks) or using Panorama or Strata Cloud Manager policy management. 

For policy management, use Panorama to link your Cloud NGFW tenant with a Panorama appliance to author and manage policy rules for your Cloud NGFW resources. You'll use Panorama to author security rules on cloud device groups; the policy you author in the Panorama cloud device group manifests as global rulestacks in your Cloud NGFW tenant. In addition to Panorama, you can use Strata Cloud Manager for policy management. Strata Cloud Manager provides unified management for your entire network security deployment, which allows you to easily manage your Palo Alto Networks security infrastructure from a single, streamlined web interface. With this interface you gain comprehensive visibility into users, branch sites, applications, and threats across all network security enforcement points. 

You can then use these Cloud NGFW for Azure resources to secure your Internet Ingress, Internet Egress, and lateral traffic traversing the hub virtual network or a virtual WAN hub. For a detailed traffic protection illustration, refer to Cloud NGFW for Azure deployment architectures. 


![](images/fetchpdf-1780573126841.pdf-0005-06.png)


_Refer to the_ Securing Applications with Cloud NGFW for Azure _reference architecture pages for design and deployment guides._ 

For additional information, refer to the following pages: 

- Cloud NGFW for Azure deployment behind Azure Application Gateway 

- Configure Palo Alto Networks Cloud NGFW in Virtual WAN 

**5** 

Cloud NGFW for Azure Deployment Architectures 

## Cloud NGFW for Azure Hub-and-Spoke Virtual Networks 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



This architecture connects Azure virtual networks to the hub Virtual networks by using peering connections that are non-transitive, low-latency connections between virtual networks. Peered virtual networks can exchange traffic over the Azure backbone without a router. In this model, Cloud NGFW is deployed into the centralized hub VNet to secure traffic from multiple spoke VNets in multiple Azure subscriptions. The deployed Cloud NGFW can protect inbound, outbound, and lateral traffic that traverses a hub virtual network. 

To implement Cloud NGFW into a Hub virtual network, you create two subnets—private and public. Both subnets should have _subnet delegation_ enabled. Cloud NGFW private and public interfaces will reside in these two subnets. 


![](images/fetchpdf-1780573126841.pdf-0006-05.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**6** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized VNet Deployment Model: Internet Egress Traffic Inspection via Application Gateway VNET 


![](images/fetchpdf-1780573126841.pdf-0007-02.png)


## In this deployment model: 

- **STEP 1 |** Traffic from a App01 VNet workload VM is destined for the internet. 

- **STEP 2 |** Traffic from the spoke VM is forwarded to the private IP address of the Cloud NGFW using the User-Defined Route (UDR) associated with the workload subnet. 

- **STEP 3 |** Since the private IP address was internally associated with the Cloud NGFW, the packet arrives at the Cloud NGFW for inspection. 

- **STEP 4 |** After inspection, Cloud NGFW performs source NAT by changing the private IP address to the public IP address of the Cloud NGFW. 

- **STEP 5 |** After performing SNAT, the traffic is sent to the actual internet destination. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**7** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized VNet Deployment Model: Internet Ingress Traffic Inspection via Application Gateway Subnet 


![](images/fetchpdf-1780573126841.pdf-0008-02.png)


## In this deployment model: 

- **STEP 1 |** Traffic is destined from the internet to Web server-1 in App01 VNet. 

- **STEP 2 |** Traffic from the internet lands on the front-end or public IP address of the Cloud NGFW. 

- **STEP 3 |** The Cloud NGFW performs destination NAT is changed from the public IP address to the actual spoke VM IP address. 

- **STEP 4 |** After inspecting the traffic, the Cloud NGFW performs source NAT using the private IP address subnet. 

- **STEP 5 |** Traffic is sent to the actual destination across the VNet peering connection. 

- **STEP 6 |** Traffic with the source IP address as one of the IP addresses from within the private subnet and the destination IP address as the spoke VM IP arrives at the web server. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**8** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized VNet Deployment Model: Internet Ingress via Application Gateway 


![](images/fetchpdf-1780573126841.pdf-0009-02.png)


## In this deployment model: 

- **STEP 1 |** Internet inbound web traffic is routed to the App-01 web server through an App Gateway and the Cloud NGFW to achieve zero trust security. 

- **STEP 2 |** Traffic from the internet lands on the front-end IP of the Application Gateway for which the App-01 Web server acts as the backend pool. 

- **STEP 3 |** Configure UDR on the App Gateway subnet with the next hop as the Cloud NGFW private IP address. 

- **STEP 4 |** The packet arrives at the Cloud NGFW for inspection. 

- **STEP 5 |** After inspection, Cloud NGFW sends the allowed traffic to the web server using VNet peering. 

- **STEP 6 |** The web server and it uses UDR to redirect the response traffic to the Cloud NGFW for inspection. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**9** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized VNet Deployment Model: East-West Traffic Inspection 


![](images/fetchpdf-1780573126841.pdf-0010-02.png)


## In this deployment model: 

- **STEP 1 |** Traffic from the App01 VNet workload VM is destined for the App02 VNet workload VM. 

- **STEP 2 |** Traffic from the App01 VM is forwarded to the private IP address of the Cloud NGFW based on the User-Defined Route (UDR) associated with the workload subnet. 

- **STEP 3 |** Since the private IP address was internally associated with the Cloud NGFW, the packet arrives at the Cloud NGFW for inspection. 

- **STEP 4 |** After inspection, Cloud NGFW forwards the traffic to App02. 

- **STEP 5 |** There is no source NAT performed on east-west traffic. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**10** 

Cloud NGFW for Azure Deployment Architectures 

## Cloud NGFW for Azure Virtual WAN 

|**Where Can I Use This?**|**What Do I Need?**|
|---|---|
|• Cloud NGFW for Azure|Cloud NGFW subscription<br>Palo Alto Networks Customer Support<br>Portal account<br>Azure Marketplace subscription|



Cloud NGFW for Azure supports a centralized vWAN deployment model. With this model: 

- a centralized vWAN Cloud NGFW is deployed for securing traffic in multiple spoke VNets connected to the Azure Virtual WAN. 

- the vWAN hub is pre-created to allow for integration with the Cloud NGFW. 

- the Cloud NGFW seemlessly integrates into the vWAN hub. 

- routing intent is used to redirect traffic to the Cloud NGFW for inspection. 


![](images/fetchpdf-1780573126841.pdf-0011-08.png)


> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**11** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized vWAN Deployment Model: Internet Egress Traffic Inspection 


![](images/fetchpdf-1780573126841.pdf-0012-02.png)


## In this deployment model: 

- **STEP 1 |** Traffic from a the spoke1 VNet workload VM is destined for the internet. 

- **STEP 2 |** Traffic destined to the internet from the spoke-1 web server VM is forwarded to the vWAN hub using the VNet connection. 

- **STEP 3 |** Routing intent on the vWAN hub is used to redirect traffic from the vWAN hub to the Cloud NGFW. 

- **STEP 4 |** Routing intent is enabled for internet traffic with the Cloud NGFW as a next hop to redirect internet egress traffic to the Cloud NGFW for inspection. 

- **STEP 5 |** Post inspection source NAT is performed on the Cloud NGFW using the public IP address associated with the Cloud NGFW. 

- **STEP 6 |** Traffic is now sent out onto the internet. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**12** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized vWAN Deployment Model: Internet Ingress Traffic Inspection 


![](images/fetchpdf-1780573126841.pdf-0013-02.png)


## In this deployment model: 

- **STEP 1 |** Traffic from the internet lands on the front-end or public IP address of the Cloud NGFW. 

- **STEP 2 |** Using routing intent, the traffic is redirected to the Cloud NGFW by the vWAN hub. 

- **STEP 3 |** The Cloud NGFW performs destination NAT where the destination of the packet is changed from public IP address to the actual spoke VM IP address. 

- **STEP 4 |** After inspecting the traffic, the Cloud NGFW performs source NAT using the private IP address subnet (which is automatically extracted from the vWAN Hub VNet). 

- **STEP 5 |** Traffic is now sent to the actual destination (spoke VM) with the source IP address as one of the IP addresses from within the vWAN Hub VNet and the destination IP address as the spoke VM IP. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**13** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized vWAN Deployment Model: Internet Ingress via Application Gateway 


![](images/fetchpdf-1780573126841.pdf-0014-02.png)


In this deployment model: 

- **STEP 1 |** To access backend applications, internet users access the frontend IP address of the Application Gateway. The packet will first land on the frontend IP. 

- **STEP 2 |** The backend pool of the Application Gateway is a web server IP address that's part of application/spoke VNet. 

- **STEP 3 |** The application VNet and Application Gateway VNet are connected to Azure Virtual WAN and hence they can talk to each other through the vWAN hub. 

- **STEP 4 |** The Application Gateway sends the packet to vWAN hub after performing source and destination NAT; the destination will be the actual backend application IP address(192.168.1.10). 

- **STEP 5 |** Because of routing intent, the vWAN hub forwards the traffic to the Cloud NGFW for inspection. 

- **STEP 6 |** Post inspection, the vWAN sends the packet to actual backend application that's part of spoke VNet that's connected to the Azure Virtual WAN. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**14** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized vWAN Deployment Model: Internet Ingress via Application Gateway Subnet 


![](images/fetchpdf-1780573126841.pdf-0015-02.png)


In this deployment model: 

- **STEP 1 |** To access backend applications, internet users access the frontend IP address of the Application Gateway. 

- **STEP 2 |** The backend pool of the Application Gateway is a web server IP address that's part of the same VNet. 

- **STEP 3 |** Using the UDRs associated with the Application Gateway subnet, the gateway sends the packet to vWAN hub after performing source and destination NAT. The source of the packet will be one of the IP addresses of the Application Gateway subnet and the destination will be the actual backend application IP address. 

- **STEP 4 |** Because of routing intent, the vWAN hub forwards the traffic to the Cloud NGFW for inspection. 

- **STEP 5 |** Post inspection, the packet is sent back to vWAN hub by the Cloud NGFW. 

- **STEP 6 |** The vWAN hub sends the packet to actual backend application that is part of spoke VNet that's connected to the Azure Virtual WAN. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**15** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized vWAN Deployment Model: East-West Traffic Inspection 


![](images/fetchpdf-1780573126841.pdf-0016-02.png)


In this deployment model: 

- **STEP 1 |** Traffic from a the spoke-1 VNet workload VM is destined to the spoke-2 VNet workload VM. 

- **STEP 2 |** Traffic from the spoke-1 VM is forwarded to the Azure Virtual WAN hub based on the VNet connection. 

- **STEP 3 |** Routing intent enabled for private traffic is used to redirect traffic from the vWAN hub to the Cloud NGFW. 

- **STEP 4 |** The Cloud NGFW inspects the traffic based on the defined security policies. 

- **STEP 5 |** Post inspection, the Cloud NGFW is going to forward the traffic to the vWAN hub which in turn sends the traffic to spoke 2 VM. 

There is no Source NAT performed on east-west traffic 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**16** 

Cloud NGFW for Azure Deployment Architectures 

## Centralized vWAN Deployment Model: East-West Traffic Inspection - On Prem to Cloud 


![](images/fetchpdf-1780573126841.pdf-0017-02.png)


## In this deployment model: 

- **STEP 1 |** Traffic from the on-prem data center is destined to the spoke-2 VNet workload VM. 

- **STEP 2 |** This traffic is considered as east-west traffic. 

- **STEP 3 |** Traffic from the on-prem data center is forwarded to the Azure Virtual WAN hub using the VPN tunnel from the on-prem to Azure vWAN. 

- **STEP 4 |** Routing intent enabled for private traffic is used to redirect traffic from the vWAN hub to the Cloud NGFW. 

- **STEP 5 |** The Cloud NGFW inspects the traffic based on the defined security policies. 

- **STEP 6 |** Post inspection, the Cloud NGFW forwards the traffic to vWAN hub which in turn sends the traffic to spoke2 VM. 

There is no Source NAT performed on east-west traffic 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**17** 

Cloud NGFW for Azure Deployment Architectures 

Centralized vWAN Deployment Model: East-West vWAN MultiHub Traffic Inspection 


![](images/fetchpdf-1780573126841.pdf-0018-02.png)


In this deployment model: 

- **STEP 1 |** Traffic from a spoke-1 Webserver connected to the vWAN hub-1 is destined to the spoke-2 DB server connected to the vWAN hub-2. 

- **STEP 2 |** Traffic from Webserver-1 arrives at the vWAN hub-1 because of the VNet connection. 

- **STEP 3 |** Routing intent configured for private traffic in hub-1 redirects traffic to the Cloud NGFW for inspection. 

- **STEP 4 |** Post inspection, traffic is sent back to vWAN hub-1. 

- **STEP 5 |** Since the destination of the traffic is connected to vWAN hub-2, using the hub-to-hub connectivity the traffic is forwarded to vWAN hub-2. 

- **STEP 6 |** Traffic is received at vWAN hub-2. 

- **STEP 7 |** Routing intent sends the traffic to the Cloud NGFW connected to hub-2 for inspection. 

- **STEP 8 |** Post inspection, the traffic is sent back to hub-2. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**18** 

Cloud NGFW for Azure Deployment Architectures 

**STEP 9 |** Using the VNet connection, the vWAN forwards the traffic to the VM in spoke-2 which is the actual destination. 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**19** 

Cloud NGFW for Azure Deployment Architectures 

> © 2026 Palo Alto Networks, Inc. 

Cloud NGFW for Azure Deployment 

**20** 


