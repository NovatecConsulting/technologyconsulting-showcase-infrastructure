data "azurerm_key_vault" "vault" {
  name                  = "vault-${data.azurerm_resource_group.resourceGroup.name}"
  resource_group_name   = data.azurerm_resource_group.resourceGroup.name
}