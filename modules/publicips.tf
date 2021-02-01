# ---- orderdomain ip for lbl service type
resource "azurerm_public_ip" "publicip" {
  name                = "orderdomain-publicip-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  domain_name_label   = "orderdomain-${var.environment}"
  sku                 = "Standard"
}

resource "azurerm_key_vault_secret" "publicip" {
  name          = "orderdomain-publicip"
  value         = azurerm_public_ip.publicip.ip_address
  key_vault_id  = data.azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "fqdn" {
  name          = "orderdomain-azurefqdn"
  value         = azurerm_public_ip.publicip.fqdn
  key_vault_id  = data.azurerm_key_vault.vault.id
}
