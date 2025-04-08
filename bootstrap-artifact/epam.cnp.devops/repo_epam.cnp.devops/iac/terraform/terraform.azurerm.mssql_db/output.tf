output "database_id" {
  value       = azurerm_mssql_database.db.id
  description = "The ID of the MS SQL Database"
}