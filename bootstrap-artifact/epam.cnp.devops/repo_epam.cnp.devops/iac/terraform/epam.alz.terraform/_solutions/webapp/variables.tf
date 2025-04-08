variable "webapp" {
  type        = any
  description = "Azure App Service settings."
}
variable "mssql_server" {
  type        = any
  description = "Azure MSSQL Server settings."
  default     = {}
}
variable "mssql_db" {
  type        = any
  description = "Azure MSSQL Data Base settings."
  default     = {}
}
variable "default_site_config" {
  type        = any
  description = "Default site config for Web App."
  default = {
    always_on                                     = true
    container_registry_managed_identity_client_id = null
    container_registry_use_managed_identity       = false
    ftps_state                                    = "Disabled"
    health_check_path                             = null
    http2_enabled                                 = true
    load_balancing_mode                           = "LeastRequests"
    local_mysql_enabled                           = false
    minimum_tls_version                           = "1.2"
    remote_debugging_enabled                      = false
    scm_use_main_ip_restriction                   = false
    scm_minimum_tls_version                       = "1.2"
    use_32_bit_worker                             = true
    vnet_route_all_enabled                        = false
    websockets_enabled                            = false
    worker_count                                  = null
  }
}
variable "app_service_plan" {
  type        = any
  description = "Azure App Service Plan settings."
}
variable "location" {
  type        = string
  description = "The location where solution infrastructure should located."
}
variable "rg_name" {
  type        = string
  description = "The resource group name where Data Base and Application should located."
}
variable "monitor_rg_name" {
  type        = string
  description = "The resource group name where infrastructure for monitoring should lacated."
}
variable "db_type" {
  type        = string
  description = "Type of the database which you want to use. Possible values are 'sql' and 'CosmosDb'."
}
variable "smart_detector" {
  type        = any
  description = "Azure Monitor smart detection alert rule settings."
}
variable "monitor_action_groups" {
  type        = any
  description = "Azure Action Group settings."
}
variable "app_insights" {
  type        = any
  description = "Azure App Insights settings."
}
variable "tags" {
  type        = any
  description = "Tags which shoul be assigned to the resources"
  default     = {}
}
variable "cosmosdb_account" {
  type        = any
  description = "Azure CosmosDB account settings."
  default     = {}
}