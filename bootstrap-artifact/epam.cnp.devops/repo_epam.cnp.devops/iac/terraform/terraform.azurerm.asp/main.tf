# Get resource group data
data "azurerm_resource_group" "rg" {
  name = var.rg_name
}

# Create ASP
resource "azurerm_service_plan" "asp" {
  name                = var.name
  location            = var.location == null ? data.azurerm_resource_group.rg.location : var.location
  os_type             = var.os_type
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.tags
  sku_name            = var.sku_name
}
