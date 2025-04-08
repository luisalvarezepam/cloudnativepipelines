# terraform.azurerm.mssqlserver

This module creates a MSSQL Server with MSSQL Server Virtual Network Rule, MSSQL Server Virtual Extended Auditing Policy and MSSQL Server Firewall Rule

## Prerequisites

| Resource name | Required | Description |
|---------------|----------|-------------|
| Resource group        | yes   |        |
| Key Vault with the secret | no | The key vault name where administrator password stored as a secret. |
| VNet with subnets | no | It is needed for MSSQL vnet rules configuration. |
| Storage account | no | It is needed for MSSQL server extended auditing policy configuration. |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_firewall_rule.fw_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_extended_auditing_policy.srv_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) | resource |
| [azurerm_mssql_virtual_network_rule.net_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.kv_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |



## Usage example

```go
module "sql_server" {
  source                 = "git::https://ORGANIZATION_NAME@dev.azure.com/ORGANIZATION_NAME/PROJECT_NAME/_git/terraform.azurerm.mssql_server?ref=v4.2.0"
  server_name            = "example-sql-serv"
  rg_name                = "example-rg-noeu-s-mssql-01"
  location               = "estus"
  server_version         = "12.0"
  administrator_login    = "exampleuser"
  administrator_password = "ExampleP@ssw0rd"
  connection_policy      = "Default"
  firewall_rules = [
    {
      name             = "ExampleFirewallRule1"
      start_ip_address = "1.1.1.1"
      end_ip_address   = "1.1.1.2"
    }
  ]
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  vnet = [
    {
      vnet_name    = "example-vnet"
      vnet_rg_name = "example-rg-noeu-s-network-01"
      subnet_name  = "mssql-example-subnet"
    }
  ]

  kv = {
    kv_name    = "examplekv"
    kv_rg_name = "example-rg-kv-01"
  }
  auditing_policy = {
    storage_name                            = "examplestorage"
    storage_rg_name                         = "example-rg-storage-01"
    storage_account_access_key_is_secondary = false
    retention_in_days                       = 7
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | The administrator login name for the new server. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_administrator_password"></a> [administrator\_password](#input\_administrator\_password) | The password associated with the `administrator_login` user. Needs to comply with `Azure's Password Policy`. | `string` | `null` | no |
| <a name="input_auditing_policy"></a> [auditing\_policy](#input\_auditing\_policy) | The object for MSSQL server extended auditing policy configuration.<br>    `storage_name`                            - the storage account name<br>    `storage_rg_name`                         - the resource group name where storage account exists<br>    `storage_account_access_key_is_secondary` - Specifies whether storage\_account\_access\_key value is the storage's secondary key.<br>                                                Possible values are `true` or `false`<br>    `retention_in_days`                       - Specifies the number of days to retain logs for in the storage account. | <pre>object({<br>    storage_name                            = string<br>    storage_rg_name                         = string<br>    retention_in_days                       = number<br>    storage_account_access_key_is_secondary = bool<br>  })</pre> | `null` | no |
| <a name="input_connection_policy"></a> [connection\_policy](#input\_connection\_policy) | The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default | `string` | `"Default"` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | The list of objects for MSSQL firewall rules configuration.<br><br>    `name`             - the name of the firewall rule<br>    `start_ip_address` - the starting IP address to allow through the firewall for this rule<br>    `end_ip_address`   - the ending IP address to allow through the firewall for this rule | <pre>list(object({<br>    name             = string<br>    start_ip_address = string<br>    end_ip_address   = string<br>  }))</pre> | `[]` | no |
| <a name="input_kv"></a> [kv](#input\_kv) | The map that may consists of key vault name and key vault resource group name for retrieving administrator password from key vault.<br>    It is possible to exclude key vault resource groupe name if key vault and mssql server are in the same resource group. <br>    Required if `administrator_password` is `null`.<br><br>    `kv_name`    - the key vault name where administrator password stored as a secret<br>    `kv_rg_name` - the resource group name where the key vault exists | `map(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists.  If the parameter is not specified in the configuration file, the location of the resource group is used. | `string` | `null` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2. | `string` | `"1.2"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is allowed for this server. | `bool` | `false` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group in which to create the Microsoft SQL Server. | `string` | n/a | yes |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | The name of the Microsoft SQL Server. This needs to be globally unique within Azure. | `string` | n/a | yes |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version) | The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). | `string` | `"12.0"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | The list of objects that include values:<br><br>    `subnet_name`  - the subnet name from which the SQL server will accept communications exists<br>    `vnet_name`    - the VNET name where subnet from which the SQL server will accept communications exists<br>    `vnet_rg_name` - the resource group name where VNET exists | <pre>list(object({<br>    vnet_rg_name = string<br>    vnet_name    = string<br>    subnet_name  = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fully_qualified_domain_name"></a> [fully\_qualified\_domain\_name](#output\_fully\_qualified\_domain\_name) | The fully qualified domain name of the Azure SQL Server |
| <a name="output_mssql_server_id"></a> [mssql\_server\_id](#output\_mssql\_server\_id) | The ID of the Microsoft SQL Server |