data "azurerm_storage_account" "db" {
  count               = var.storage_account != null ? 1 : 0
  name                = var.storage_account.storage_name
  resource_group_name = var.storage_account.storage_rg_name
}

resource "azurerm_mssql_database" "db" {
  name           = var.db_name
  server_id      = var.mssql_server_id
  collation      = var.collation
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  read_scale     = var.read_scale
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
  tags           = var.tags
}

resource "azurerm_mssql_database_extended_auditing_policy" "db_policy" {
  count                                   = var.storage_account != null ? 1 : 0
  database_id                             = azurerm_mssql_database.db.id
  storage_endpoint                        = data.azurerm_storage_account.db[0].primary_blob_endpoint
  storage_account_access_key              = var.auditing_policy.storage_account_access_key_is_secondary == false ? data.azurerm_storage_account.db[0].primary_access_key : data.azurerm_storage_account.db[0].secondary_access_key
  storage_account_access_key_is_secondary = var.auditing_policy.storage_account_access_key_is_secondary
  retention_in_days                       = var.auditing_policy.retention_in_days
}