resource "azurerm_virtual_network" "vnet" {
  name                        = "vnet-tc-showcase-${var.environment}"
  location                    = azurerm_resource_group.resourceGroup.location
  resource_group_name         = azurerm_resource_group.resourceGroup.name
  address_space               = var.vpc_adress_space
}