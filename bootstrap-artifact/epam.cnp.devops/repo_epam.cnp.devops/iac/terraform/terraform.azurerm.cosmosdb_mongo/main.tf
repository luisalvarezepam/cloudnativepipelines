resource "azurerm_cosmosdb_mongo_database" "mongodb" {
  name                = var.db_name
  resource_group_name = var.cosmosdb_account_resource_group_name
  account_name        = var.cosmosdb_account_name
  throughput          = var.db_max_throughput != null ? null : var.db_throughput

  # Autoscaling is optional and depends on max throughput parameter. Mutually exclusive vs. throughput.
  dynamic "autoscale_settings" {
    for_each = var.db_max_throughput != null ? [1] : []
    content {
      max_throughput = var.db_max_throughput
    }
  }
}

resource "azurerm_cosmosdb_mongo_collection" "mongodb_collections" {
  count                  = length(var.mongo_db_collections)
  name                   = var.mongo_db_collections[count.index].collection_name
  resource_group_name    = var.cosmosdb_account_resource_group_name
  account_name           = var.cosmosdb_account_name
  database_name          = var.db_name
  default_ttl_seconds    = var.mongo_db_collections[count.index].default_ttl_seconds
  shard_key              = var.mongo_db_collections[count.index].shard_key
  throughput             = var.mongo_db_collections[count.index].collection_max_throughput != null ? null : var.mongo_db_collections[count.index].collection_throughout
  analytical_storage_ttl = var.mongo_db_collections[count.index].analytical_storage_ttl

  # Autoscaling is optional and depends on max throughput parameter. Mutually exclusive vs. throughput. 
  dynamic "autoscale_settings" {
    for_each = var.mongo_db_collections[count.index].collection_max_throughput != null ? [1] : []
    content {
      max_throughput = var.mongo_db_collections[count.index].collection_max_throughput
    }
  }

  # Index is optional
  dynamic "index" {
    for_each = var.mongo_db_collections[count.index].indexes != null ? var.mongo_db_collections[count.index].indexes : []
    content {
      keys   = index.value.mongo_index_keys
      unique = index.value.mongo_index_unique
    }
  }

  depends_on = [
    azurerm_cosmosdb_mongo_database.mongodb
  ]
}