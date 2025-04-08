
data "azurerm_resource_group" "rg" {
  name = var.rg_name
}
data "azurerm_key_vault" "kv" {
  count               = var.kv != null ? 1 : 0
  name                = var.kv.kv_name
  resource_group_name = var.kv.kv_rg_name == null ? var.rg_name : var.kv.kv_rg_name
}
data "azurerm_key_vault_secret" "kv_secret" {
  count        = var.kv != null ? 1 : 0
  name         = var.administrator_login
  key_vault_id = data.azurerm_key_vault.kv[0].id
}
data "azurerm_virtual_network" "vnet" {
  count               = length(var.vnet)
  name                = var.vnet[count.index].vnet_name
  resource_group_name = var.vnet[count.index].vnet_rg_name
}

data "azurerm_subnet" "subnet" {
  count                = length(var.vnet)
  name                 = var.vnet[count.index].subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet[count.index].name
  resource_group_name  = data.azurerm_virtual_network.vnet[count.index].resource_group_name
}

data "azurerm_storage_account" "db" {
  count               = var.auditing_policy != null ? 1 : 0
  name                = var.auditing_policy.storage_name
  resource_group_name = var.auditing_policy.storage_rg_name
}

# Disable database-enable-audit check due wrong notation
# Block of type "extended_auditing_policy" is not expected for azurerm_mssql_server resource, 
# but exist for azurerm_sql_server only.
#tfsec:ignore:azure-database-enable-audit
resource "azurerm_mssql_server" "server" {
  name                          = var.server_name
  resource_group_name           = var.rg_name
  location                      = var.location == null ? data.azurerm_resource_group.rg.location : var.location
  version                       = var.server_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_password == null ? sensitive(data.azurerm_key_vault_secret.kv_secret[0].value) : var.administrator_password
  minimum_tls_version           = var.minimum_tls_version
  connection_policy             = var.connection_policy
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags
}

resource "azurerm_mssql_virtual_network_rule" "net_rule" {
  count     = length(var.vnet)
  name      = "${var.server_name}-vnet-rule-0${count.index}"
  server_id = azurerm_mssql_server.server.id
  subnet_id = data.azurerm_subnet.subnet[count.index].id
}

resource "azurerm_mssql_server_extended_auditing_policy" "srv_policy" {
  count                                   = var.auditing_policy != null ? 1 : 0
  server_id                               = azurerm_mssql_server.server.id
  storage_endpoint                        = data.azurerm_storage_account.db[0].primary_blob_endpoint
  storage_account_access_key              = var.auditing_policy.storage_account_access_key_is_secondary == false ? data.azurerm_storage_account.db[0].primary_access_key : data.azurerm_storage_account.db[0].secondary_access_key
  storage_account_access_key_is_secondary = var.auditing_policy.storage_account_access_key_is_secondary
  retention_in_days                       = var.auditing_policy.retention_in_days
}

resource "azurerm_mssql_firewall_rule" "fw_rules" {
  count            = length(var.firewall_rules)
  name             = var.firewall_rules[count.index].name
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = var.firewall_rules[count.index].start_ip_address
  end_ip_address   = var.firewall_rules[count.index].end_ip_address
}