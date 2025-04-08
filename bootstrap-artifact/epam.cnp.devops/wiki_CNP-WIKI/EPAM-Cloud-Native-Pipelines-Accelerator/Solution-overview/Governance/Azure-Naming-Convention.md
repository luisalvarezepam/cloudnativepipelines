[[_TOC_]]

# Introduction
This Section describes the Naming Standards for the Azure Resources for all deployments.

Defining naming standards is a critical part of the Azure adoption because it simplifies accounting, resource manageability, gives standardization across all cloud-based assets as well as provides quick search compatibilities. Well-defined names and tags also help to align cloud usage costs with business teams by using chargeback and show back accounting mechanisms.

A well-chosen name helps you quickly identify the resource's type, its associated workload, its deployment environment, and the Azure region hosting it.

The proposed naming convention is adopted for uniqueness based on the customer name.

# Naming Convention Principles
The following Principles were followed during the creation of the Naming Convention:

* Naming of the resource must be consistent within the whole Organization
* Azure Resource Names must follow the same naming structure
* Resource names should provide the possibility to quickly identify solution/systems in case of emergency
* Resource names should provide the possibility to quickly identify the deployment environment
* Resource names should provide the possibility to quickly identify the hosted Azure Region
* Azure Naming Strategy should include business and operational details
* Naming Scope and length limits must be considered during naming convention development

# Naming Convention Structure

The following pattern is suggested to be used within the organization. The exception will be added for the resource with the Global naming scope that must be unique across the entire Azure Platform

```shell
<customerNameAcronym>-<prefix>-<azureRegion>-<environment>-<application/serviceName>-<sequenceNumber>
```

## Naming Convention Components

The table below provides an overview of the main components and their purpose:

|Component|	Description|
|----------|----------------------|
|customerNameAcronym| The customer Name component has been introduced to generate a unique name for the global scope and provide name consistency across the organization|
|prefix| Incorporating resource type prefixes into resource names makes it easier to visually identify application or service components|
|environment| Environment component is used to quickly identify the target deployment environment |
|azureRegion| Azure Region provides visibility for resource location|
|application/serviceName|	Name of the application, workload, project, or service that the resource is a part of|

### Customer Name Acronym Component

The customerNameAcronym component within the Naming convention will be used to provide uniqueness for the azure resource names across the entire Azure Platform. Usually, this is used only for the resource with the Global Naming scope and in the proposed naming convention it is included in the general pattern for each resource name(except Virtual Machines). This component is limited to 4 characters and put at the beginning of name for supporting and manageability purposes.

Example:
* Customer Name: **Microsoft**
* Customer Name Acronym: **MSFT**

### Resource Prefix Component
 
The table below provides a list of prefixes for the main Azure Resource Types, it is not a final list and it must be a live document and well maintained by the Customer or Service Provider.

|Resource Provider|	Resource Type |	Resource Name Prefix/suffix|
|----------|----------------------|----------------------|
| Subscriptions| 	Subscription| sub-|
|	|Resource Group|	rg-|
|	|	Management Group |	mg- |
|Compute|	Virtual Machines|	vm-|
|	|	Availability Set|	as-|
|	|	VM Drives|	disk-|
|	|	VM Scale Set|	vmss-|
|	|	Azure Compute Gallery|	cg-|
|Network|	Azure Firewall Network Rule|	nerl-|
|	|	Azure Firewall NAT Rule	|narl-|
|	|	Azure Firewall Application Rule	|aprl-|
|	|	Azure Firewall IP Groups|	ipgrp -| 
|	|	Application Gateway	|apgtw-|
|	|	Application Gateway – Backend Pool	|apbp-|
|	|	Application Gateway – HTTP Settings	|aphs-|
|	|	Application Gateway – Frontend IP	|apfip-|
|	|	Application Gateway - Listeners|	apls-|
|	|	Application Gateway - Rules	|aprl-|
|	|	Application Gateway – Health Probes	|aphp-|
|	|	Load Balancer	|lb-|
|	|	Load Balancer - Health Probes|	lbhp-|
|	|	Load Balancer - Backend Pool|	lbbp-|
|	|	Load Balancer - Frontend IP	|lbfip-|
|	|	Load Balancer – LB Rules|	lbrl-|
|	|	Load Balancer – NAT Rules	|lbnatrl-|
|	|	VM Network Interface|	-nic|
|	|	Virtual Network	|vnet-|
|	|	Virtual hub	|vh-|
|	|	Virtual hub connection	|vhc-|
|	|	Virtual hub route table	|vhrt-|
|	|	Virtual hub route table route	|vhrtr-|
|	|	Virtual hub security partner provider	|vhspp-|
|	|	Virtual WAN	|vwan-|
|	|	VPN Gateway |vpngtw-|
|	|	VPN Gateway Connection	|vpngtwc-|
|	|	VPN Site |vpnst-|
|	|	P2S VPN Gateway|p2svpngtw-|
|	|	Subnet|	sn-|
|	|	Public IP|	pip-|
|	|	Private endpoint|	prend-|
|	|	Network Security Group|	nsg-|
|	|	Application Security Group|	asg-|
|	|	Route Table	|udr-|
|	|	Express Route Gateway	|exrgtw-|
|	|	Express Route Circuit	|exr-|
|	|	CDN	|cdn-|
|	|	Connection|	cn-|
|	|	Virtual Network Gateway|	vgtw-|
|	|	VNET Peering|	n/a|
|	|	Local Network Gateway|	lgtw-|
|	|	Network Watcher	|netwch-|
|	|	Azure VPN Server Configuration	|vpnsc-|
|Storage|	Storage Account|	str-|
|	|	Azure Data Lake Store|	adls-|
|	|	Snapshot	|snap-|
|NetApp Files|	NetApp account|	naacc-|
|	|	NetApp pool|	napl-|
|	|	NetApp snapshot policy|nasp-|
|	|	NetApp volume|navlm-|
|SQL|	SQL Server|	sqlsrv-|
|	|	SQL Database|	sqldb-|
|	|	SQL Manage Instance	|sqlmi-|
|	|	SQL Database Elastic Pool|	sqlepool-|
|	|	Cosmos DB|	cosdb-|
|Operational Insights	|Log Analytics workspace|	la-|
|	|	Activity Log Alert|	alrt-|
|	|	Action Group|	agrp-|
|Automation|	Automation Account|	aa-|
|	|	Run As Account|	spn-|
|	|	RunBook|	rb-|
|Key Vaults	|Key Vault|	kv-|
|	|	Key Vault Secrets	|kvsec-|
|	|	Key Vault Certificates|	kvcer-|
|	|	Key Vault Keys|	kvkey-|
|Portal|	Shared Dashboard|	shd-|
|Managed Identity|	Managed Identity|	mi-|
|Recovery Service Vault	|Recovery Service Vault	|rsv-|
|	|	Backup Policy	| bp-|
|Web	|Application Service|	aps-|
|	|	App Service Plan|	asp-|
|	|	Function|	fun-|
|Blueprint	|Blueprint Definition|	bd-|
|	|	Blueprint Assignment	|ba-|
|Authorization|	Policy Definition|	pd-|
|	|	Policy Initiatives|	pi-|
|Remote Access|	Azure Bastion 	|azbst-|
|Integration	|Logic App|	lgapp-|
|	|	API Management|	apim-|
|	|	Integration Service Environment|	ise-|
|Data & Processing|	Azure Data Factory|	adf-|
|Cost Management| Azure Budget| azbg-


### Azure Regions

The table below provides a list of Acronyms that will be used to identify the Azure Target Region

|Acronym	|Location	|DisplayName|
|----------|----------------------|----------------------|
|eaas	|eastasia           	|East Asia|
|soas	|southeastasia      	|Southeast Asia|
|ceus	|centralus          	|Central US|
|eaus	|eastus             	|East US|
|eaus2	|eastus2            	|East US 2|
|weus	|westus             	|West US|
|nous	|northcentralus     	|North Central US|
|scus	|southcentralus     	|South Central US|
|noeu	|northeurope        	|North Europe|
|weeu	|westeurope         	|West Europe|
|wejp	|japanwest          	|Japan West|
|eajp	|japaneast          	|Japan East|
|sobr	|brazilsouth        	|Brazil South|
|eaau	|australiaeast      	|Australia East|
|soau	|australiasoutheast 	|Australia Southeast|
|soin	|southindia         	|South India|
|cein	|centralindia       	|Central India|
|wein	|westindia          	|West India|
|ceca	|canadacentral      	|Canada Central|
|eaca	|canadaeast         	|Canada East|
|souk	|uksouth            	|UK South|
|weuk	|ukwest             	|UK West|
|wcus	|westcentralus      	|West Central US|
|weus2	|westus2            	|West US 2|
|ceko	|koreacentral       	|Korea Central|
|soko	|koreasouth         	|Korea South|
|cefr	|francecentral      	|France Central|
|sofr	|francesouth        	|France South|
|ceau	|australiacentral   	|Australia Central
|ceau2	|australiacentral2  	|Australia Central 2|
|ceae	|uaecentral         	|UAE Central|
|noae	|uaenorth           	|UAE North|
|nosa	|southafricanorth   	|South Africa North|
|wesa	|southafricawest    	|South Africa West|
|noch	|switzerlandnorth   	|Switzerland North|
|wech	|switzerlandwest    	|Switzerland West|
|noge	|germanynorth       	|Germany North|
|wcge	|germanywestcentral 	|Germany West Central|
|weno	|norwaywest         	|Norway West|
|eano	|norwayeast         	|Norway East|

###	Enviroments 

The table below provides an overview of the defined environments:

|Acronym	| Description|
|----------|----------------------|
|p	|All resources that are related to the production environment will have in the name p Acronym |
|h	|All resources that are related to the hub environment will have in the name h Acronym|
|s	|All resources that are related to the sandbox will have in the name s Acronym |
|t	|All resources that are related to the test environment will have in the name t Acronym|
|d	|All resources that are related to the dev environment will have in the name d Acronym|


## Naming Convention Examples

### Subscriptions Resource Types

The table below provides a Naming Convention for resource type that has been identified under the Subscriptions:

| Resource Type    | Format                                                                          | Examples                                   |
|------------------|---------------------------------------------------------------------------------|--------------------------------------------|
| Subscription     | `<customerNameAcronym>-<prefix>-<environment>-<GEORegion><application/serviceName>-<sequenceNumber>` | epam-sub-p-europeShared-01; epam-sub-d-asiashared-01  |
| Resource Group   | `<customerNameAcronym>-<prefix>-<region>-<environment>-<application/serviceName>-<sequenceNumber>`   | epam-rg-noeu-t-network-01; epam-rg-weeu-p-storage-01 |
| Management Group | `<customerNameAcronym>-<prefix>-<GEORegion>-<Usage>`                                                 | epam-mg-root; epam-mg-europeDevelopment; epam-mg-europeProduction  |

### Compute Resource Types

The table below provides a Naming Convention for Compute resource types that have been identified:

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Virtual Machines|	`<prefix>+<Region>+<environment>+< Application/Service Name>+<Sequence Number>`|vmnoeupadds01; vmweeudsccm01|
|Availability Set | `<customerNameAcronym>-<prefix>-<Region>-<environment>-< Application/Service Name>-<Sequence Number>`|epam-as-noeu-t-adds1; epam-as-weeu-p-adcs1|
|VM Drives|	`<Virtual Machine Name>-OsDisk/DataDisk+<Sequence Number>`| vmnoeupadds01-OsDisk01; vmnoeupadds01-DataDisk02|
|VM Scale Set| `<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`| epam-vmss-weeu-p-app01 ; epam-vmss-weeu-t-app02| 

###	Network Resource Types

The table below provides a Naming Convention for Network resource types that have been identified:

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Azure Firewall Network Rule|	`<customerNameAcronym>-<prefix>-<allow/deny>-<Application/Service Name/protocol>-<Sequence Number>`|	epam-netrl-allow-http-01; epam-netrl-deny-smb-01
|Azure Firewall NAT Rule	|`<customerNameAcronym>-<prefix>-<Destination Application/ Service Name>-<Published port>`|epam-natrl-jumpbox-3389
|Azure Firewall Application Rule|	`<customerNameAcronym>-<prefix>-<allow/deny>-<Destination Service Name>-<Sequence Number>`|epam-aprl-allow-windowsupdate-01 ; epam-aprl-deny-facebook-01
|Azure Firewall IP Group|	`<customerNameAcronym>-<prefix>-<region>-<Destination Application/ Service Name>-<Sequence Number>`| epam-ipgrp-noeu-AzureProduction-01;epam-ipgrp-noeu-ADDC
|Application Gateway	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-apgt-noeu-h-shared-; epam-apgt-weeu-h-app2-01
|Application Gateway – Backend Pool|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-apbp-p-webapp-01 ;epam-apbp-t-webapp-01
|Application Gateway – HTTP Settings|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-apht-p-webapp-01;epam-apht-t-webapp-02
|Application Gateway – Frontend IP|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-apfip-p-webapp-03;epam-apfip-t-webapp-01
|Application Gateway - Listeners|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-apls-p-webapp-52;epam-apls-t-webapp-01
|Application Gateway - Rules|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-aprl-p-webapp-01;epam-aprl-t-webapp-01
|Application Gateway – Health Probes|	`<customerNameAcronym>-<prefix>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-aphp-p-webapp-01;epam-aphp-t-webapp-01
|Load Balancer|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-lb-noeu-h-shared-01;epam-lb-weeu-p-app2-01
|Load Balancer - Health Probes|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-lbhp-p-webapp-01;epam-lbhp-t-webapp-01
|Load Balancer - Backend Pool|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam--p-webapp-01;epam-lbbp-t-webapp-01
|Load Balancer - Frontend IP|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-lbfip-p-webapp-03;epam-lbfip-t-webapp-01
|Load Balancer – LB Rules	|`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-lbrl-p-webapp-01;epam-lbrl-t-webapp-01
|Load Balancer – NAT Rules|	`<customerNameAcronym>-<prefix>>-<environment>-<Application/Service Name>-<Published port>`|epam-lbnatrl-p-webapp-443;epam-lbnatrl-t-webapp-80
|VM Network Interface	|`<customerNameAcronym>-<Virtual Machine Name>-nic-<Sequence Number>`|	vmnoeuadds01-nic1;vmweeusccm01-nic2
|Virtual Network|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-vnet-noeu-p-common-01;epam-vnet-weeu-h-shared-01;epam-vnet-weeu-h-firewall-01
|Subnet|	`<customerNameAcronym>-<prefix>-<Application/Service Name>-<Sequence Number>`|	epam-sn-adds-01;epam-sn-sccm-01
|Public IP|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-pip-noeu-h-firewall-01;epam-pip-noeu-p-app3-01
|Network Security Group	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<SubnetName/VMName>`|epam-nsg-noeu-h-snadds01;epam-nsg-noeu-h-snsccm01
|Application Security Group	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-asg-noeu-p-app3-01;epam-asg-noeu-p-app5-01
|Route Table	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<SubnetName>`|epam-udr-weeu-p-snadds01;epam-udr-weeu-p-snsccm01
|Express Route Circuit|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-exr-noeu-p-shared-01;epam-exr-eus-p-shared-01
|CDN	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-cdn-noeu-p-app02-01;epam-cdn-eus-p-app03-01
|Connection|	`<customerNameAcronym>-< Virtual Network Gateway / Local Network Gateway > - < Virtual Network Gateway / Local Network Gateway >`|epam-vgtwnoeuhexrshared01-lgtwnoeuphq |
|Virtual Network Gateway	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<gt types>-<vnetname >`| GT Types: EXR – Express Route GT; VPN – VPN GT; Examples:epam-vgtw-noeu-h-exr-shared01 ; epam-vgtw-noeu-p-vpn-shared01|
|VNET Peering	|`<Target VNET>`|	epam-vnet-noeu-p-common-01
|Local Network Gateway|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<location name>`| epam-lgtw-noeu-p-euhq
|Azure Bastion|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`| epam-azbt-weeu-h-azurebastion-01
|Network Watcher|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`| epam-netwch-weeu-h-networkwather-01
|Azure VPN Server Configuration|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`| epam-vpnsc-weeu-h-vpn-01

###	Storage Resources Types

The table below provides a Naming Convention for Storage resource types that have been identified


|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Storage Account|	`<customerNameAcronym>+<prefix>+<Region>+<environment>+<type>+<purpose>+<Sequence Number>`| Storage types: lrs – local-redundant storage;zrs - zone-redundant storage ;grs - geo-redundant storage; rgrs - read-access geo-redundant storage;gzrs – Geo-zone-redundant storage; rgzrs - read-access geo-zone-redundant storage. Examples:	epamstrneuplrsvmdiag01|
|Azure Data Lake Store|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<purpose>-<Sequence Number>`|	epam-adls-weeu-p-lake01|
|Snapshot	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Snap type>-<drive/vm/application>-<Sequence Number>`| Snap Types: F – Full; I – Incremental. Examples: epam-snap-weeu-p-f- vmnoeupadds01-01|

### NetApp Files Resource Types

The table below provides a Naming Convention for NetApp Files resource types that have been identified

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|NetApp account	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Sequence Number>`|	epam-naacc-weeu-t-01|
|NetApp snapshot policy|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<"acc" + Account Number>-<Sequence Number>`|	epam-nasp-weeu-t-acc01-01|
|NetApp pool	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<"acc" + Account Number>-<Sequence Number>`|	epam-napl-weeu-t-acc01-01|
|NetApp volume|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<"acc" + Account Number>-<"pl" + Pool Number>-<Sequence Number>`|	epam-navlm-weeu-t-acc01-pl01-01|

### SQL Resource Types

The table below provides a Naming Convention for SQL resource types that have been identified

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|SQL Server	|`<customerNameAcronym>+<prefix>+<Region>+<environment>+<Application/Service Name>+<Sequence Number>`|	epamsqlsrvnoeuprdapp01|
|SQL Database|	`<customerNameAcronym>+<prefix>+<Region>+<environment>+<Application/Service Name>+<Sequence Number>`|	epamsqldbnoeupapp101|
|SQL Manage Instance	|`<customerNameAcronym>+<prefix>+<Region>+<environment>+ purpose>+<Sequence Number>`|	epamsqlminoeuprdapp01|
|SQL Database Elastic Pool|	`<customerNameAcronym>+<prefix>+<Region>+<environment>+<Application/Service Name>+<Sequence Number>`|	epamsqlepnoeupapp101|

### Operational Insights Resource Types

The table below provides a Naming Convention for Operational Insights resource types that have been identified


|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Log Analytics workspace|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-la-noeu-p-common-01 |
|Activity Log Alert	|`<customerNameAcronym>-<prefix>-<environment>-<Application/Service Name>`|	epam-alrt-p-AzureAdvisorAll|
|Action Group	|`<customerNameAcronym>-<prefix>-<environment>-<ActionType>-<Application/Service Name>-<Sequence Number>`| Action Types: autor- Automation Runbook; azfun- Azure Function; email- Email;mobno- SMS/Voice/Push; ITSM- ITSM;Webhk- Secure Webhook/ Webhook. Examples: epam-agrp-p-email-SubscriptionOwners-01|

### Automation Resources Naming Convention

The table below provides a Naming Convention for Automation resource types that have been identified

|Resource Type| 	Format|	Examples|
|----------|----------------------|----------------------|
|Automation Account|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-aa-noeu-p-patching-01;epam-aa-noeu-p-patching-01|
|Run As Account	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-spn-noeu-p-patching-01;epam-spn-noeu-p-patching-01|
|RunBook	|`<customerNameAcronym>-<prefix>-<purpose>`|epam-rb-windowspatching|

### Key Vaults Resources Naming Convention

The table below provides a Naming Convention for Key Vault resource types that have been identified


|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Key Vault|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`| epam-kv-noeu-p-common-01;epam-kv-noeu-t-app2-01|
|Key Vault Secrets|	`<customerNameAcronym>-<prefix>-<Application/Service Name>-<Sequence Number>`| epam-kvsec-webapp-01|
|Key Vault Certificates	|`<customerNameAcronym>-<prefix>-<Application/Service Name>-<Sequence Number>`|	epam-kvcer-webapp-01|
|Key Vault Keys|	`<customerNameAcronym>-<prefix>-<Application/Service Name>-<Sequence Number>`|epam-kvkey-webapp-01|

###	Portal Resources Naming Convention

The table below provides a Naming Convention for Portal resource types that have been identified

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Shared Dashboard|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-shd-noeu-p-overview-01|

###	Managed Identity Resources Naming Convention

The table below provides a Naming Convention for Managed Identity resource types that have been identified

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Managed Identity|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-mi-noeu-p-app4-01|

### Recovery Service Vault Resources Naming Convention 

The table below provides a Naming Convention for Recovery Service Vault resource types that have been identified


|Resource Type	|Format|	Examples|
|----------|----------------------|----------------------|
|Recovery Service Vault	|-`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Replication>-<Application/Service Name>-<Sequence Number>`|Replication Types:LRS – Local-Redundant Storage;GRS – Geo-Redundant Storage ; epam-rsv-noeu-p-lrs-common-01|
|Recovery Service Vault – Backup Policy	| `<customerNameAcronym>-<prefix>-<PolicyType>-<TypeOfBackup>-<Retention>-<Sequence Number>`| PolicyType: vm – Azure Virtual Machine; fs – Azure File Share;sql – SQL Server in Azure VM; TypeOfBackup: d – Daily; w - Weekly. Examples:	epam-bk-vm-d30-01; epam-bk-sql-d30-01|

###	Azure Blueprint Resources Naming Convention 

The table below provides a Naming Convention for Azure Blueprints resources that have been identified

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Blueprint Definition	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<purpose>-<Sequence Number>`|epam-bd-noeu-p-HubInfrastructure01
|Blueprint Assignment	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Subscription>`|	epam-ba-noeu-p-hub
|ARM Templates	|`<customerNameAcronym>-<prefix>-<ARM type>-<Resource Type / purpose>-<version>`| ARM types:restmlp – respource template; linktempl – linked template; nestmpl – nested template. Resource type: VM – Virtual Machine. Version: Current – The latest production template; 1.2.3 - MajorUpdate.MinorUpdate.Update: MajorUpdate - The Major Version should be increased when the logic of ARM templates changed (add new resource type, deployment and etc) or when many minor modifications. MinorUpdate - The Minor Version should be increased when a new parameters, variables or additional configuration item are added to the ARM template. Patch – The Update Version should be increased when a small modification of the current described resources has been performed. Examples: epam-arm-restmpl-vm-current; epam-arm-linktmpl-hubDeployment-1.3.2|

### Azure Policies Resources Naming Convention

The table below provides a Naming Convention for Policies resource types that have been identified

|Resource Type|	Format	|Examples|
|----------|----------------------|----------------------|
|Policy Definition|	`<customerNameAcronym>-<prefix>-<Layer>-<environment>-<effect><purpose>`| Layer: org- Organization Level Definitions; reg - Region Level Defintion; env- Environment Level Definitions ;sub- Subscription Level Definitions. Examples:	epam-pd-env-EnforceAudit, epam-pd-sub-p-DenyPublicIp|
|Policy Initiatives	|`<customerNameAcronym>-<prefix>-<Layer>-<environment>-<purpose>`| Layer: org- Organization Level Definitions; reg - Region Level Defintion; env- Environment Level Definitions ;sub- Subscription Level Definitions. Examples: epam-pi-env-SecuriytEnforcement|

###	Web Resources Naming Convention

The table below provides a Naming Convention for Web resource types that have been identified

|Resource Type	|Format	|Examples|
|----------|----------------------|----------------------|
|Application Service|	`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-aps-noeu-p-webapp4-01|
|App Service Plan	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-asp-noeu-p-webapp2-01|
|Function	|`<customerNameAcronym>-<prefix>-<Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-fun-noeu-p-webapp1-01|

### Remote Access Resources Naming Convention
The table below provides a Naming Convention for Remote Access resource types that have been identified

|Resource Type	|Format	|Examples|
|----------|----------------------|----------------------|
|Azure Bastion|	`<customerNameAcronym>-<prefix>-Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-azbst-noeu-h-shared-01|

### Integration Resources Naming Convention

The table below provides a Naming Convention for Integration resource types that have been identified

|Resource Type|	Format|	Examples|
|----------|----------------------|----------------------|
|Logical App	|`<customerNameAcronym>-<prefix>-Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-lgapp--noeu-p-app-01|
|API Management	|`<customerNameAcronym>-<prefix>-Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-apim--noeu-p-app-01|
|Integration Service Environment	|`<customerNameAcronym>-<prefix>-Region>-<environment>-<Application/Service Name>-<Sequence Number>`|	epam-ise-noeu-p-app-01|

###	Data & Processing Resources Naming Convention

The table below provides a Naming Convention for Data & Processing resource types that have been identified

|Resource Type|	Format	|Examples|
|----------|----------------------|----------------------|
|Azure Data Factory| `<customerNameAcronym>-<prefix>-Region>-<environment>-<Application/Service Name>-<Sequence Number>`|epam-adf-noeu-p-app-01|

###	Cost Management Resources Naming Convention

The table below provides a Naming Convention for Cost Management resource types that have been identified

|Resource Type|	Format	|Examples|
|----------|----------------------|----------------------|
|Azure Budgets| `<customerNameAcronym>-<prefix>-Region>-<environment>-<resetPeriod><Application/Service Name>-<Sequence Number>`|epam-azbg-noeu-p-m-app-01|

## Naming convention enforcement 

Azure Policies, Initiatives, and reports will be created and applied to enforce the definition of mandatory naming conventions. This means that all resources created will have their resource names validated.


# Useful Links

[DOCs: Naming rules and restrictions for Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftanalysisservices)

[CAF: Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

[CAF: Develop your naming and tagging strategy for Azure resources](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging)

[CAF: Recommended abbreviations for Azure resource types](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)


# Change Tracking

## Document Change Log

Version | Date| Author| Description
---|---|---|---
0.1n|1/26/2021|`Maksim Rotar`| First draft

## Document Review Log

Version | Date| Author| Description
---|---|---|---
-|-|-|-
