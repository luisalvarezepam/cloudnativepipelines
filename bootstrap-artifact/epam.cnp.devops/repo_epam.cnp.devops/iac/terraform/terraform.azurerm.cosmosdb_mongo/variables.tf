variable "db_name" {
  description = "Specifies the name of the Cosmos DB Mongo Database. Changing this forces a new resource to be created."
  type        = string
}

variable "cosmosdb_account_name" {
  description = "The name of the Cosmos DB Mongo Database to create the table within. Changing this forces a new resource to be created."
  type        = string
}

variable "cosmosdb_account_resource_group_name" {
  description = "The name of the Cosmos DB Mongo Database resource group."
  type        = string
}

variable "db_throughput" {
  description = <<EOF
The throughput of the MongoDB database (RU/s). Must be set in increments of ``100``. The minimum value is ``400``. 
This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. Conflicts with ``max_throughput``.
EOF
  type        = number
  default     = null
}

variable "db_max_throughput" {
  description = <<EOF
The maximum throughput of the MongoDB database (RU/s). Must be between ``1,000`` and ``1,000,000``. Must be set in increments of 1,000. 
Used for block "autoscale_settings". Conflicts with ``throughput``.
EOF
  type        = number
  default     = null
}

variable "mongo_db_collections" {
  type = list(object({
    collection_name           = string
    default_ttl_seconds       = optional(string)
    shard_key                 = optional(string)
    collection_throughout     = optional(number)
    collection_max_throughput = optional(number)
    analytical_storage_ttl    = optional(number)
    indexes = list(object({
      mongo_index_keys   = list(string)
      mongo_index_unique = optional(bool)
    }))
  }))
  description = <<EOF
List of Cosmos DB Mongo collections to create:
  - ``collection_name``                   (Required) Specifies the name of the Cosmos DB Mongo Collection. Changing this forces a new resource to be created.
  - ``default_ttl_seconds``               (Optional) The default Time To Live in seconds. If the value is ``-1``, items are not automatically expired.
  - ``shard_key``                         (Optional) The name of the key to partition on for sharding. There must not be any other unique index keys. 
                                                     Changing this forces a new resource to be created.
  - ``collection_throughout``             (Optional) The throughput of the MongoDB collection (RU/s). Must be set in increments of ``100``. The minimum value is ``400``. 
                                                     This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply.
  - ``analytical_storage_ttl``            (Optional) The default time to live of Analytical Storage for this Mongo Collection. 
                                                     If present and the value is set to ``-1``, it is equal to infinity, and items don't expire by default. 
                                                     If present and the value is set to some number ``n`` items will expire n seconds after their last modified time.
  - ``indexes``                           (index with '_id' key is required) One or more index: 
                                                     ``mongo_index_keys`` - (Required) Specifies the list of user settable keys for each Cosmos DB Mongo Collection.
                                                     ``mongo_index_unique`` - (Optional) Is the index unique or not? Defaults to ``false``.
EOF
  default     = []
}