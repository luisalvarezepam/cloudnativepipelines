# terraform.azurerm.cosmosdb-mongodb

This module will create a Mongo database with collections for Azure CosmosDB Account.

## Prerequisites

| Resource name | Required | Description |
|---------------|----------|-------------|
| Resource group        | yes   |       |
| CosmosDB Account     | yes   |  The Cosmos DB Account for Mongo Database to create the table within    |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.42.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_mongo_collection.mongodb_collections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.mongodb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |



## Usage example

```go
module "example" {
  source = "git::https://ORGANIZATION_NAME@dev.azure.com/ORGANIZATION_NAME/PROJECT_NAME/_git/terraform.azurerm.cosmosdb_mongo?ref=v2.1.0"

  db_name                              = "example"
  cosmosdb_account_name                = "example-cosmosdb-account-name"
  cosmosdb_account_resource_group_name = "example-cosmosdb-account-rg-name"
  db_throughput                        = null
  db_max_throughput                    = 1000

  mongo_db_collections = [
    {
      collection_name           = "collection1"
      default_ttl_seconds       = "2592000"
      shard_key                 = "MyShardKey"
      collection_throughout     = null
      collection_max_throughput = 1000
      analytical_storage_ttl    = null
      indexes = [
        {
          mongo_index_keys   = ["_id"]
          mongo_index_unique = true
        }
      ]
    },
    {
      collection_name           = "collection2"
      default_ttl_seconds       = "2592000"
      shard_key                 = "MyShardKey"
      collection_throughout     = null
      collection_max_throughput = 1000
      analytical_storage_ttl    = null
      indexes = [
        {
          mongo_index_keys   = ["_id"]
          mongo_index_unique = true
        }
      ]
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cosmosdb_account_name"></a> [cosmosdb\_account\_name](#input\_cosmosdb\_account\_name) | The name of the Cosmos DB Mongo Database to create the table within. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_cosmosdb_account_resource_group_name"></a> [cosmosdb\_account\_resource\_group\_name](#input\_cosmosdb\_account\_resource\_group\_name) | The name of the Cosmos DB Mongo Database resource group. | `string` | n/a | yes |
| <a name="input_db_max_throughput"></a> [db\_max\_throughput](#input\_db\_max\_throughput) | The maximum throughput of the MongoDB database (RU/s). Must be between `1,000` and `1,000,000`. Must be set in increments of 1,000. <br>Used for block "autoscale\_settings". Conflicts with `throughput`. | `number` | `null` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Specifies the name of the Cosmos DB Mongo Database. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_db_throughput"></a> [db\_throughput](#input\_db\_throughput) | The throughput of the MongoDB database (RU/s). Must be set in increments of `100`. The minimum value is `400`. <br>This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. Conflicts with `max_throughput`. | `number` | `null` | no |
| <a name="input_mongo_db_collections"></a> [mongo\_db\_collections](#input\_mongo\_db\_collections) | List of Cosmos DB Mongo collections to create:<br>  - `collection_name`                   (Required) Specifies the name of the Cosmos DB Mongo Collection. Changing this forces a new resource to be created.<br>  - `default_ttl_seconds`               (Optional) The default Time To Live in seconds. If the value is `-1`, items are not automatically expired.<br>  - `shard_key`                         (Optional) The name of the key to partition on for sharding. There must not be any other unique index keys. <br>                                                     Changing this forces a new resource to be created.<br>  - `collection_throughout`             (Optional) The throughput of the MongoDB collection (RU/s). Must be set in increments of `100`. The minimum value is `400`. <br>                                                     This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply.<br>  - `analytical_storage_ttl`            (Optional) The default time to live of Analytical Storage for this Mongo Collection. <br>                                                     If present and the value is set to `-1`, it is equal to infinity, and items don't expire by default. <br>                                                     If present and the value is set to some number `n` items will expire n seconds after their last modified time.<br>  - `indexes`                           (index with '\_id' key is required) One or more index: <br>                                                     `mongo_index_keys` - (Required) Specifies the list of user settable keys for each Cosmos DB Mongo Collection.<br>                                                     `mongo_index_unique` - (Optional) Is the index unique or not? Defaults to `false`. | <pre>list(object({<br>    collection_name           = string<br>    default_ttl_seconds       = optional(string)<br>    shard_key                 = optional(string)<br>    collection_throughout     = optional(number)<br>    collection_max_throughput = optional(number)<br>    analytical_storage_ttl    = optional(number)<br>    indexes = list(object({<br>      mongo_index_keys   = list(string)<br>      mongo_index_unique = optional(bool)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_id"></a> [db\_id](#output\_db\_id) | The ID of the Mongo database. |
| <a name="output_db_name"></a> [db\_name](#output\_db\_name) | The Name of the Mongo database. |
| <a name="output_mongo_db_collection_id"></a> [mongo\_db\_collection\_id](#output\_mongo\_db\_collection\_id) | Mongo API Collection IDs. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The Resource Groupe Name of the Mongo database. |