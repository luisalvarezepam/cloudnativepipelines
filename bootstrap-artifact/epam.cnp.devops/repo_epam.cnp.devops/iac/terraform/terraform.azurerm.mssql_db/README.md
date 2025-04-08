# terraform.azurerm.mssqldb

This module creates a MSSQL DataBase with MSSQL DataBase Extended Auditing Policy.

## Prerequisites

| Resource name | Required | Description |
|---------------|----------|-------------|
| Resource group        | yes   |        |
| MSSQL Server | yes |  |
| Storage account | no | It is needed for MSSQL database extended auditing policy configuration. |

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
| [azurerm_mssql_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_database_extended_auditing_policy.db_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database_extended_auditing_policy) | resource |
| [azurerm_storage_account.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |



## Usage example

```go
module "sql_db" {
  source          = "git::https://ORGANIZATION_NAME@dev.azure.com/ORGANIZATION_NAME/PROJECT_NAME/_git/terraform.azurerm.mssql_db?ref=v2.2.0"
  db_name         = "example-db-name"
  mssql_server_id = "123example4321"
  collation       = "SQL_Latin1_General_CP1_CI_AS"
  zone_redundant  = false
  license_type    = "LicenseIncluded"
  max_size_gb     = 4
  read_scale      = true
  sku_name        = "BC_Gen5_2"
  storage_account = {
    storage_name    = "examplestorage"
    storage_rg_name = "example-rg-storage-01"
  }
  auditing_policy = {
    storage_account_access_key_is_secondary = false
    retention_in_days                       = 7
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auditing_policy"></a> [auditing\_policy](#input\_auditing\_policy) | The object for MSSQL database extended auditing policy configuration.<br><br>    `storage_account_access_key_is_secondary` - Specifies whether storage\_account\_access\_key value is the storage's secondary key.<br>                                                Possible values are `true` or `false`<br><br>    `retention_in_days`                       - Specifies the number of days to retain logs for in the storage account. | <pre>object({<br>    retention_in_days                       = number<br>    storage_account_access_key_is_secondary = bool<br>  })</pre> | `null` | no |
| <a name="input_collation"></a> [collation](#input\_collation) | Specifies the collation of the database. | `string` | `null` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the Ms SQL Database | `string` | n/a | yes |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice | `string` | `"LicenseIncluded"` | no |
| <a name="input_max_size_gb"></a> [max\_size\_gb](#input\_max\_size\_gb) | The max size of the database in gigabytes. | `number` | `4` | no |
| <a name="input_mssql_server_id"></a> [mssql\_server\_id](#input\_mssql\_server\_id) | The id of the Ms SQL Server on which to create the database. | `string` | n/a | yes |
| <a name="input_read_scale"></a> [read\_scale](#input\_read\_scale) | If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases. | `bool` | `false` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the name of the sku used by the database. Changing this forces a new resource to be created. For example, GP\_S\_Gen5\_2,HS\_Gen4\_1,BC\_Gen5\_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100 | `string` | `"Basic"` | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | The map that may consists of storage account name, storage account resource group name,for MSSQL database <br>    extended auditing policy configuration.<br><br>    `storage_name`                            - the storage account name<br>    `storage_rg_name`                         - the resource group name where storage account exists | `map(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_id"></a> [database\_id](#output\_database\_id) | The ID of the MS SQL Database |