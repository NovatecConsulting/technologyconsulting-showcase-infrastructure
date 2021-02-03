data "azurerm_key_vault" "vault" {
  name                        = "vault-${azurerm_resource_group.resourceGroup.name}"
  resource_group_name         = azurerm_resource_group.resourceGroup.name
}