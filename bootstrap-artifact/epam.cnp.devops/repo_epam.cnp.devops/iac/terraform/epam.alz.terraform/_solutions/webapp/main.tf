# Define providers list
terraform {
  required_version = ">= 1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

# Deploy the resource group for the solution
module "rg" {
  source   = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.rg?ref=develop"
  name     = var.rg_name
  location = var.location
  tags     = try(var.tags, {})
}

# Deploy the resource group for the monitoring
module "monitor_rg" {
  source   = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.rg?ref=develop"
  name     = var.monitor_rg_name
  location = var.location
  tags     = try(var.tags, {})
}

# Deploys azure MSSQL server.
module "mssql_server" {
  depends_on                    = [module.rg]
  source                        = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.mssql_server?ref=develop"
  count                         = var.db_type == "sql" ? 1 : 0
  server_name                   = var.mssql_server.sql_server_name
  rg_name                       = var.rg_name
  location                      = var.location
  server_version                = lookup(var.mssql_server, "sql_server_version", "12.0")
  administrator_login           = var.mssql_server.sql_server_administrator_login
  administrator_password        = var.mssql_server.administrator_password
  connection_policy             = lookup(var.mssql_server, "sql_server_connection_policy", "Default")
  firewall_rules                = lookup(var.mssql_server, "sql_server_firewall_rules", [])
  vnet                          = lookup(var.mssql_server, "vnet", [])
  kv                            = lookup(var.mssql_server, "kv", null)
  auditing_policy               = lookup(var.mssql_server, "auditing_policy", null)
  minimum_tls_version           = lookup(var.mssql_server, "minimum_tls_version", "1.2")
  public_network_access_enabled = lookup(var.mssql_server, "public_network_access_enabled", false)
  tags                          = try(var.tags, {})
}

## Deploys MSSQL database to previusly created SQL server.
module "mssql_db" {
  source          = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.mssql_db?ref=develop"
  count           = var.db_type == "sql" ? 1 : 0
  db_name         = var.mssql_db.sql_db_name
  mssql_server_id = module.mssql_server[count.index].mssql_server_id
  collation       = lookup(var.mssql_db, "sql_db_collation", "SQL_Latin1_General_CP1_CI_AS")
  zone_redundant  = lookup(var.mssql_db, "sql_db_zone_redundant", false)
  license_type    = lookup(var.mssql_db, "license_type", "LicenseIncluded")
  max_size_gb     = lookup(var.mssql_db, "max_size_gb", "4")
  read_scale      = lookup(var.mssql_db, "read_scale", "true")
  sku_name        = lookup(var.mssql_db, "sku_name", "BC_Gen5_2")
  auditing_policy = lookup(var.mssql_db, "auditing_policy", null)
  storage_account = lookup(var.mssql_db, "storage_account", null)
  tags            = try(var.tags, {})
}

# Deploys cosmosdb account
module "cosmosdb_account" {
  depends_on                = [module.rg]
  source                    = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.cosmosdb_account?ref=develop"
  count                     = var.db_type == "CosmosDb" ? 1 : 0
  cosmosdb_account_name     = var.cosmosdb_account.cosmosdb_account_name
  rg_name                   = var.rg_name
  offer_type                = lookup(var.cosmosdb_account, "offer_type", "Standard")
  kind                      = lookup(var.cosmosdb_account, "kind", "GlobalDocumentDB")
  enable_automatic_failover = lookup(var.cosmosdb_account, "enable_automatic_failover", false)
  geo_location = lookup(var.cosmosdb_account, "geo_location", [{
    location          = var.location
    failover_priority = 0
  }])
  rg_location                       = var.location
  ip_range_filter                   = lookup(var.cosmosdb_account, "ip_range_filter", "")
  is_virtual_network_filter_enabled = lookup(var.cosmosdb_account, "is_virtual_network_filter_enabled", true)
  consistency_level                 = lookup(var.cosmosdb_account, "consistency_level", "Session")
  allowed_subnets = lookup(var.cosmosdb_account, "allowed_subnets", [{
    vnet_name                            = "epam-vnet-noeu-s-shared-01"
    vnet_rg_name                         = "epam-rg-noeu-s-network-01"
    subnet_name                          = "sn-db-01"
    ignore_missing_vnet_service_endpoint = true
  }])
  capabilities       = lookup(var.cosmosdb_account, "capabilities", [])
  diagnostic_setting = lookup(var.cosmosdb_account, "diagnostic_setting", null)
  tags               = try(var.tags, {})
}

# Deploys app service plan.
module "app_service_plan" {
  depends_on = [module.rg]
  source     = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.asp?ref=develop"
  name       = var.app_service_plan.app_service_plan_name
  rg_name    = var.rg_name
  location   = var.location
  os_type    = var.app_service_plan.os_type
  sku_name   = lookup(var.app_service_plan, "sku_name", "S1")
  tags       = try(var.tags, {})
}

# Deploy AppInsights
module "appinsigt" {
  depends_on                 = [module.monitor_rg]
  source                     = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.app_insights?ref=develop"
  rg_name                    = var.monitor_rg_name
  location                   = try(var.location, null)
  appinsights_name           = var.app_insights.app_insights_name
  workspace_id               = try(var.app_insights.workspace_id, null)
  application_type           = var.app_insights.application_type
  retention_in_days          = lookup(var.app_insights, "retention_in_days", 90)
  sampling_percentage        = lookup(var.app_insights, "sampling_percentage", null)
  disable_ip_masking         = lookup(var.app_insights, "disable_ip_masking", false)
  internet_ingestion_enabled = lookup(var.app_insights, "internet_ingestion_enabled", false)
  internet_query_enabled     = lookup(var.app_insights, "internet_query_enabled", false)
  tags                       = try(var.tags, {})
}

# Create a monitor action group for Failure Anomalies detection
module "monitor_action_group" {
  depends_on                  = [module.appinsigt]
  source                      = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.monitor_action_group?ref=develop"
  action_group_name           = var.monitor_action_groups.action_group_name
  action_group_short_name     = var.monitor_action_groups.action_group_short_name
  rg_name                     = var.monitor_rg_name
  enabled                     = try(var.monitor_action_groups.enabled, true)
  arm_role_receiver           = try(var.monitor_action_groups.arm_role_receiver, [])
  automation_runbook_receiver = try(var.monitor_action_groups.automation_runbook_receiver, [])
  azure_app_push_receiver     = try(var.monitor_action_groups.azure_app_push_receiver, [])
  azure_function_receiver     = try(var.monitor_action_groups.azure_function_receiver, [])
  email_receiver              = try(var.monitor_action_groups.email_receiver, [])
  event_hub_receiver          = try(var.monitor_action_groups.event_hub_receiver, [])
  itsm_receiver               = try(var.monitor_action_groups.itsm_receiver, [])
  logic_app_receiver          = try(var.monitor_action_groups.logic_app_receiver, [])
  sms_receiver                = try(var.monitor_action_groups.sms_receiver, [])
  voice_receiver              = try(var.monitor_action_groups.voice_receiver, [])
  webhook_receiver            = try(var.monitor_action_groups.webhook_receiver, [])
  tags                        = try(var.monitor_action_groups.tags, {})
  rule_action_group           = try(var.monitor_action_groups.rule_action_group, [])
  action_rule_suppression     = try(var.monitor_action_groups.action_rule_suppression, [])
}

# Create smart detector alert rule for Failure Anomalies detection.data "data "" "name" {
resource "azurerm_monitor_smart_detector_alert_rule" "failure_anomalies" {
  depends_on          = [module.monitor_action_group]
  name                = var.smart_detector.name
  resource_group_name = var.monitor_rg_name
  severity            = var.smart_detector.severity
  frequency           = var.smart_detector.frequency
  scope_resource_ids  = [module.appinsigt.appinsights_id]
  detector_type       = var.smart_detector.detector_type
  action_group {
    ids = [module.monitor_action_group.action_group_id]
  }
}

# Create a local with Data Base connection string settings for Web App.
locals {
  connection_string = [
    {
      name  = var.webapp.connection_string[0].name
      type  = var.webapp.connection_string[0].type
      value = sensitive("Server=tcp:${var.mssql_server.sql_server_name}.database.windows.net,1433;Initial Catalog=${var.mssql_db.sql_db_name};Persist Security Info=False;User ID=${var.mssql_server.sql_server_administrator_login};Password=${var.mssql_server.administrator_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;")
    }
  ]
  app_settings = merge(try(var.webapp.app_settings, null), tomap({
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = module.appinsigt.instrumentation_key,
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = module.appinsigt.connection_string,
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
  }))
}

# Deploys Azure web appliaction with connection string to previously created SQL database
module "linuxwebapp" {
  depends_on                   = [module.app_service_plan]
  source                       = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.linux_web_app?ref=develop"
  count                        = var.app_service_plan.os_type == "Linux" ? 1 : 0
  name                         = var.webapp.webapp_name
  rg_name                      = var.rg_name
  location                     = var.location
  service_plan_name            = var.app_service_plan.app_service_plan_name
  https_only                   = lookup(var.webapp, "https_only", false)
  site_config                  = lookup(var.webapp, "site_config", var.default_site_config)
  application_stack            = lookup(var.webapp, "application_stack", null)
  auto_heal_setting            = lookup(var.webapp, "auto_heal_setting", null)
  ip_restriction               = lookup(var.webapp, "ip_restriction", [])
  scm_ip_restriction           = lookup(var.webapp, "scm_ip_restriction", [])
  app_settings                 = try(local.app_settings, {})
  backup                       = lookup(var.webapp, "backup", null)
  connection_string            = sensitive(try(local.connection_string, null))
  identity                     = lookup(var.webapp, "identity", null)
  regional_network_integration = lookup(var.webapp, "regional_network_integration", null)
  logs                         = lookup(var.webapp, "logs", null)
  storage_account              = lookup(var.webapp, "storage_account", null)
  sticky_settings              = lookup(var.webapp, "sticky_settings", null)
  zip_deploy_file              = lookup(var.webapp, "zip_deploy_file", null)
  web_app_slots                = lookup(var.webapp, "web_app_slots", [])
  tags                         = try(var.tags, {})
}

# Create the Windows Web Apps
module "windowswebapp" {
  depends_on                   = [module.app_service_plan]
  source                       = "git::https://#{org_name}#@dev.azure.com/#{org_name}#/#{project_name}#/_git/#{project_name}#//iac/terraform/terraform.azurerm.windows_web_app?ref=develop"
  count                        = var.app_service_plan.os_type == "Windows" ? 1 : 0
  name                         = var.webapp.webapp_name
  rg_name                      = var.rg_name
  location                     = var.location
  service_plan_name            = var.app_service_plan.app_service_plan_name
  https_only                   = lookup(var.webapp, "https_only", false)
  site_config                  = lookup(var.webapp, "site_config", var.default_site_config)
  application_stack            = lookup(var.webapp, "application_stack", null)
  virtual_application          = lookup(var.webapp, "virtual_application", [])
  auto_heal_setting            = lookup(var.webapp, "auto_heal_setting", null)
  ip_restriction               = lookup(var.webapp, "ip_restriction", [])
  scm_ip_restriction           = lookup(var.webapp, "scm_ip_restriction", [])
  app_settings                 = try(local.app_settings, {})
  backup                       = lookup(var.webapp, "backup", null)
  connection_string            = try(local.connection_string, null)
  identity                     = lookup(var.webapp, "identity", null)
  regional_network_integration = lookup(var.webapp, "regional_network_integration", null)
  logs                         = lookup(var.webapp, "logs", null)
  storage_account              = lookup(var.webapp, "storage_account", null)
  sticky_settings              = lookup(var.webapp, "sticky_settings", null)
  zip_deploy_file              = lookup(var.webapp, "zip_deploy_file", null)
  web_app_slots                = lookup(var.webapp, "web_app_slots", [])
  tags                         = try(var.tags, {})
}
