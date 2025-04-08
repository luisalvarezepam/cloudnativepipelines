# terraform.azurerm.storageaccount

This module creates a storage account in a specified location with user specified name, diagnostic settings, network rules.

## Prerequisites

| Resource name | Required | Description |
|---------------|----------|-------------|
| Resource Group                | yes |                                             |
| Log Analytics Workspace       | no  | Necessary when creating a Diagnosic setting |
| Storage Account               | no  | to store Diagnostic Settings data           |
| Virtual Network (with subnet) | no  |                                             |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.35.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_share.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [azurerm_resource_group.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |



## Usage example

```go
module "storageaccount" {
  source = "git::https://ORGANIZATION_NAME@dev.azure.com/ORGANIZATION_NAME/PROJECT_NAME/_git/terraform.azurerm.storage_account?ref=v3.4.0"

  storage_name                      = "example-storage"
  rg_name                           = "example-storage-rg"
  location                          = "westus"
  account_tier                      = "Standard"
  account_kind                      = "Storagev2"
  account_replication_type          = "LRS"
  min_tls_version                   = "TLS1_2"
  access_tier                       = "Hot"
  allow_nested_items_to_be_public   = true
  blob_delete_retention_day         = 7
  change_feed_enabled               = false
  change_feed_retention_in_days     = 7
  versioning_enabled                = false
  large_file_share_enabled          = false
  enable_https_traffic_only         = true
  is_hns_enabled                    = false
  public_network_access_enabled     = false
  shared_access_key_enabled         = true
  infrastructure_encryption_enabled = false
  diagnostic_setting = {
    log_analytics_workspace_id = "/subscriptions/11111111-aaaa-ssss-ffff-222222222222/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-la"
    storage_account_id         = "/subscriptions/11111111-aaaa-ssss-ffff-222222222222/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplesa"
    diagnostic_setting_name    = "example-storage-diagnostic"
    metric = [
      {
        category = "Capacity"
        enabled  = true
      },
      {
        category = "Transaction"
        enabled  = true
      }
    ]
  }
  network_rules = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["1.2.3.4/32", "4.3.2.1/32"]
    subnet_associations = [
      {
        subnet_name = "example-subnet"
        vnet_name   = "example-vnet"
        rg_name     = "example-vnet-rg"
      }
    ]
    external_subnet_ids = []
  }
  share_collection = [
    {
      name             = "lhm1knwksto002-share001"
      enabled_protocol = "SMB"
      quota            = "5"
      access_tier      = "TransactionOptimized"
    }
  ]
  container_collection = [
    {
      name                  = "lhm1knwksto002-container001"
      container_access_type = "blob"
    }
  ]
  azure_files_authentication = {
    directory_type = "AD"
    active_directory = {
      storage_sid         = "example-storage-sid"
      domain_guid         = "example-domain-guid"
      domain_name         = "domain.forest.local"
      domain_sid          = "example-domain-sid"
      forest_name         = "forest.local"
      netbios_domain_name = "domain.forest.local"
    }
  }
  tags = {
    environment  = "DEV"
    businessUnit = "financial"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tier"></a> [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 | `string` | `"Hot"` | no |
| <a name="input_account_kind"></a> [account\_kind](#input\_account\_kind) | Defines the Kind of account. | `string` | `"StorageV2"` | no |
| <a name="input_account_replication_type"></a> [account\_replication\_type](#input\_account\_replication\_type) | Defines the type of replication to use for this storage account. | `string` | `"LRS"` | no |
| <a name="input_account_tier"></a> [account\_tier](#input\_account\_tier) | Defines the Tier to use for this storage account. | `string` | `"Standard"` | no |
| <a name="input_allow_nested_items_to_be_public"></a> [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow public access to all nested items in the storage account | `bool` | `true` | no |
| <a name="input_azure_files_authentication"></a> [azure\_files\_authentication](#input\_azure\_files\_authentication) | `directory_type` -  Specifies the directory service used. Possible values - AD;<br>`active_directory` - Required when directory\_type is AD:<br>  `storage_sid` - Specifies the security identifier (SID) for Azure Storage.<br>  `domain_name` - Specifies the primary domain that the AD DNS server is authoritative for.<br>  `domain_sid` - Specifies the security identifier (SID).<br>  `domain_guid` - Specifies the domain GUID.<br>  `forest_name` - Specifies the Active Directory forest.<br>  `netbios_domain_name` - Specifies the NetBIOS domain name. | `any` | `{}` | no |
| <a name="input_blob_delete_retention_day"></a> [blob\_delete\_retention\_day](#input\_blob\_delete\_retention\_day) | Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7 | `number` | `7` | no |
| <a name="input_change_feed_enabled"></a> [change\_feed\_enabled](#input\_change\_feed\_enabled) | Is the blob service properties for change feed events enabled? | `bool` | `false` | no |
| <a name="input_change_feed_retention_in_days"></a> [change\_feed\_retention\_in\_days](#input\_change\_feed\_retention\_in\_days) | "The duration of change feed events retention in days. The possible values are between 1 and 146000 days (400 years).<br>   Setting this to null (or omit this in the configuration file) indicates an infinite retention of the change feed." | `number` | `null` | no |
| <a name="input_container_collection"></a> [container\_collection](#input\_container\_collection) | A list of objects which contains parameters:<br>    `name` - The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.<br>    `container_access_type` - The Access Level configured for this Container. Possible values are "blob", "container" or "private". | <pre>list(object({<br>    name                  = string<br>    container_access_type = string<br>  }))</pre> | `[]` | no |
| <a name="input_diagnostic_setting"></a> [diagnostic\_setting](#input\_diagnostic\_setting) | The description of parameters for Diagnistic Setting:<br>    `diagnostic_setting_name` - specifies the name of the Diagnostic Setting;<br>    `log_analytics_workspace_id` - ID of the Log Analytics Workspace;<br>    `storage_account_id` - the ID of the Storage Account where logs should be sent;<br>      `metric` - describes metric for Diagnistic Setting:<br>      `category` -  the name of a Diagnostic Metric Category for this Resource. List of<br>        available Metrics:`Capacity`, `Transaction`, `AllMetrics`;<br>      `enabled` -  is this Diagnostic Metric enabled? | `any` | `{}` | no |
| <a name="input_enable_https_traffic_only"></a> [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Boolean flag which forces HTTPS if enabled | `bool` | `true` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | Is infrastructure encryption enabled? Changing this forces a new resource to be created | `bool` | `false` | no |
| <a name="input_is_hns_enabled"></a> [is\_hns\_enabled](#input\_is\_hns\_enabled) | Is Hierarchical Namespace enabled? | `bool` | `false` | no |
| <a name="input_large_file_share_enabled"></a> [large\_file\_share\_enabled](#input\_large\_file\_share\_enabled) | Is Large File Share Enabled? | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | "Specifies the supported Azure location where the resource exists."<br>    If the parameter is not specified in the configuration file, the location of the resource group is used. | `string` | `null` | no |
| <a name="input_min_tls_version"></a> [min\_tls\_version](#input\_min\_tls\_version) | The minimum supported TLS version for the storage account. | `string` | `"TLS1_2"` | no |
| <a name="input_network_rules"></a> [network\_rules](#input\_network\_rules) | Firewall settings for storage account:<br>    `bypass` - Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. <br>      Valid options are any combination of "Logging", "Metrics", "AzureServices", or "None".<br>    `default_action` - Specifies the default action of allow or deny when no other rules match. <br>      Valid options are "Deny" or "Allow".<br>    `ip_rules` - List of public IP or IP ranges in CIDR Format. Only IPv4 addresses are allowed.<br>      Private IP address ranges (as defined in RFC 1918) are not allowed.<br>    `subnet_associations` - A list of resource ids for subnets<br>    `external_subnet_ids` - A list of external ids for subnets | <pre>object({<br>    bypass         = string<br>    default_action = string<br>    ip_rules       = list(string)<br>    subnet_associations = list(object({<br>      subnet_name = string<br>      vnet_name   = string<br>      rg_name     = string<br>    }))<br>    external_subnet_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether the public network access is enabled? | `bool` | `true` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Name of the resource group to be imported. | `string` | n/a | yes |
| <a name="input_share_collection"></a> [share\_collection](#input\_share\_collection) | A list of objects which contains parameters: name, quota, enabled\_protocol:<br>    `name` - The name of the share. Must be unique within the storage account where the share is located.<br>    `access_tier` - The access tier of the File Share. Possible values are "Hot", "Cool" and "TransactionOptimized", "Premium".<br>    `enabled_protocol` - The protocol used for the share. Possible values are "SMB" and "NFS"<br>    `quota` - The maximum size of the share, in gigabytes. For Standard storage accounts, this must be 1GB (or higher)<br>      and at most 5120 GB (5 TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and at most 102400 GB (100 TB). | <pre>list(object({<br>    name             = string<br>    access_tier      = string<br>    enabled_protocol = string<br>    quota            = string<br>  }))</pre> | `[]` | no |
| <a name="input_shared_access_key_enabled"></a> [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key | `bool` | `true` | no |
| <a name="input_storage_name"></a> [storage\_name](#input\_storage\_name) | Name of storage account to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags which should be assigned to the resource. | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Is versioning enabled? | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_container_id"></a> [container\_id](#output\_container\_id) | The ID of the Storage Container |
| <a name="output_file_share_id"></a> [file\_share\_id](#output\_file\_share\_id) | The ID of the File Share |
| <a name="output_file_share_url"></a> [file\_share\_url](#output\_file\_share\_url) | The URL of the File Shar |
| <a name="output_primary_access_key"></a> [primary\_access\_key](#output\_primary\_access\_key) | The primary access key for the storage account |
| <a name="output_primary_blob_endpoint"></a> [primary\_blob\_endpoint](#output\_primary\_blob\_endpoint) | The endpoint URL for blob storage in the primary location |
| <a name="output_primary_connection_string"></a> [primary\_connection\_string](#output\_primary\_connection\_string) | The connection string associated with the primary location |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | Id of the storage account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | Name of the storage account |
| <a name="output_storage_account_rg_name"></a> [storage\_account\_rg\_name](#output\_storage\_account\_rg\_name) | Resource Group Name of this Storage Account |