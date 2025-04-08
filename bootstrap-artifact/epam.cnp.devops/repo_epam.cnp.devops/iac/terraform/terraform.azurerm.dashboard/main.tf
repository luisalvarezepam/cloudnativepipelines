# Get resource group data
data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

resource "azurerm_portal_dashboard" "my-board" {
  name                 = var.name
  resource_group_name  = var.rg_name
  location             = var.location == null ? data.azurerm_resource_group.rg.location : var.location
  dashboard_properties = file(var.config_file_name)

  tags = var.tags
}  