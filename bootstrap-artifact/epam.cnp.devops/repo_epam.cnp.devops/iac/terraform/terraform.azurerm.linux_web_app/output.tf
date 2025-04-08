output "default_hostname" {
  description = "The default hostname of the Linux Web App."
  value       = azurerm_linux_web_app.webapp.default_hostname
}
output "linuxwebapp_id" {
  description = "The ID of the Linux Web App."
  value       = azurerm_linux_web_app.webapp.id
}