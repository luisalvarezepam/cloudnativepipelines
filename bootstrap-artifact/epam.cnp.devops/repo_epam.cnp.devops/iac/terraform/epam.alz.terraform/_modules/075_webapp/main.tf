# Define providers list
terraform {
  required_version = ">= 1.1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

# Create the Linux Web Apps
module "linuxwebapp" {
  source                       = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.linux_web_app?ref=develop"
  for_each                     = { for webapp in var.linux_webapp : webapp.name => webapp }
  name                         = each.value.name
  rg_name                      = each.value.rg_name
  location                     = try(each.value.location, null)
  service_plan_name            = each.value.service_plan_name
  https_only                   = lookup(each.value, "https_only", false)
  site_config                  = lookup(each.value, "site_config", var.default_site_config)
  application_stack            = lookup(each.value, "application_stack", null)
  auto_heal_setting            = lookup(each.value, "auto_heal_setting", null)
  ip_restriction               = lookup(each.value, "ip_restriction", [])
  scm_ip_restriction           = lookup(each.value, "scm_ip_restriction", [])
  app_settings                 = lookup(each.value, "app_settings", {})
  backup                       = lookup(each.value, "backup", null)
  connection_string            = lookup(each.value, "connection_string", null)
  identity                     = lookup(each.value, "identity", null)
  regional_network_integration = lookup(each.value, "regional_network_integration", null)
  logs                         = lookup(each.value, "logs", null)
  storage_account              = lookup(each.value, "storage_account", null)
  sticky_settings              = lookup(each.value, "sticky_settings", null)
  zip_deploy_file              = lookup(each.value, "zip_deploy_file", null)
  web_app_slots                = lookup(each.value, "web_app_slots", [])
  tags                         = lookup(each.value, "tags", {})
}

# Create the Windows Web Apps
module "windowswebapp" {
  source                       = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.windows_web_app?ref=develop"
  for_each                     = { for webapp in var.windows_webapp : webapp.name => webapp }
  name                         = each.value.name
  rg_name                      = each.value.rg_name
  location                     = try(each.value.location, null)
  service_plan_name            = each.value.service_plan_name
  https_only                   = lookup(each.value, "https_only", false)
  site_config                  = lookup(each.value, "site_config", var.default_site_config)
  application_stack            = lookup(each.value, "application_stack", null)
  virtual_application          = lookup(each.value, "virtual_application", [])
  auto_heal_setting            = lookup(each.value, "auto_heal_setting", null)
  ip_restriction               = lookup(each.value, "ip_restriction", [])
  scm_ip_restriction           = lookup(each.value, "scm_ip_restriction", [])
  app_settings                 = lookup(each.value, "app_settings", {})
  backup                       = lookup(each.value, "backup", null)
  connection_string            = lookup(each.value, "connection_string", null)
  identity                     = lookup(each.value, "identity", null)
  regional_network_integration = lookup(each.value, "regional_network_integration", null)
  logs                         = lookup(each.value, "logs", null)
  storage_account              = lookup(each.value, "storage_account", null)
  sticky_settings              = lookup(each.value, "sticky_settings", null)
  zip_deploy_file              = lookup(each.value, "zip_deploy_file", null)
  web_app_slots                = lookup(each.value, "web_app_slots", [])
  diagnostic_setting           = try(each.value.diagnostic_setting, null)
  tags                         = lookup(each.value, "tags", {})
}