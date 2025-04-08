output "mssql_server_id" {
  value       = azurerm_mssql_server.server.id
  description = "The ID of the Microsoft SQL Server"
}

output "fully_qualified_domain_name" {
  value       = azurerm_mssql_server.server.fully_qualified_domain_name
  description = "The fully qualified domain name of the Azure SQL Server"
}
