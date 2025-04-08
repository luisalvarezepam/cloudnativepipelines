output "db_id" {
  description = "The ID of the Mongo database."
  value       = azurerm_cosmosdb_mongo_database.mongodb.id
}

output "db_name" {
  description = "The Name of the Mongo database."
  value       = azurerm_cosmosdb_mongo_database.mongodb.name
}

output "resource_group_name" {
  description = "The Resource Groupe Name of the Mongo database."
  value       = azurerm_cosmosdb_mongo_database.mongodb.resource_group_name
}

output "mongo_db_collection_id" {
  value       = [for mongo_db_collection_id in azurerm_cosmosdb_mongo_collection.mongodb_collections : zipmap([mongo_db_collection_id.name], [mongo_db_collection_id.id])]
  description = "Mongo API Collection IDs."
}