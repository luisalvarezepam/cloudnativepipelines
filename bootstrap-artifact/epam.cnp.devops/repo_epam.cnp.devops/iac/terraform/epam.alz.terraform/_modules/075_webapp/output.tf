output "linux_webapp_id" {
  description = "The ID of the Linux Web App."
  value       = try([for webapp in var.linux_webapp : module.linuxwebapp[webapp.name].linuxwebapp_id], null)
}
output "linux_webapp_default_hostname" {
  description = "The default hostname of the Linux Web App."
  value       = try([for webapp in var.linux_webapp : module.linuxwebapp[webapp.name].default_hostname], null)
}
output "windows_webapp_id" {
  description = "The ID of the Windows Web App."
  value       = try([for webapp in var.windows_webapp : module.windowswebapp[webapp.name].windowswebapp_id], null)
}
output "windows_webapp_default_hostname" {
  description = "The default hostname of the Windows Web App."
  value       = try([for webapp in var.windows_webapp : module.windowswebapp[webapp.name].default_hostname], null)
}