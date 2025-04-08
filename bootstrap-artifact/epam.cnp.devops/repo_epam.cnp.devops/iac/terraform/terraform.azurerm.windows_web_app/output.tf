output "default_hostname" {
  description = "The default hostname of the Windows Web App."
  value       = azurerm_windows_web_app.webapp.default_hostname
}
output "windowswebapp_id" {
  description = "The ID of the Windows Web App."
  value       = azurerm_windows_web_app.webapp.id
}