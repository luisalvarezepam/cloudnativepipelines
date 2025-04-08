output "app_service_plan_id" {
  description = "Id of the created App Service Plan"
  value       = azurerm_service_plan.asp.id
}