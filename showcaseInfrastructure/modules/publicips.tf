locals {
  stages = [
    "dev",
    "stag",
    "prod"
  ]
}

# ---- orderdomain ip for lbl service type
resource "azurerm_public_ip" "publiciporder" {
  for_each = toset(local.stages)  
  name                = "${each.key}-orderdomain-publicip-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  domain_name_label   = "orderdomain-${var.environment}"
  sku                 = "Standard"
}

resource "azurerm_key_vault_secret" "publicipsecretorder" {
  for_each = toset(local.stages) 
  name          = "${each.key}orderdomain-publicip"
  value         = azurerm_public_ip.publiciporder[each.key].ip_address
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "fqdnorder" {
  for_each = toset(local.stages) 
  name          = "${each.key}orderdomain-azurefqdn"
  value         = azurerm_public_ip.publiciporder[each.key].fqdn
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_role_assignment" "allowAksSpiToContributeOrderIp" {
  for_each = toset(local.stages) 
  scope                = azurerm_public_ip.publiciporder[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}

# --- supplierdomain ip for lbl service type
resource "azurerm_public_ip" "publicipsupplier" {
  name                = "supplierdomain-publicip-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  domain_name_label   = "supplierdomain-${var.environment}"
  sku                 = "Standard"
}

resource "azurerm_key_vault_secret" "publicipsecretsupplier" {
  name          = "supplierdomain-publicip"
  value         = azurerm_public_ip.publicipsupplier.ip_address
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "fqdnsupplier" {
  name          = "supplierdomain-azurefqdn"
  value         = azurerm_public_ip.publicipsupplier.fqdn
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_role_assignment" "allowAksSpiToContributeSupplierIp" {
  scope                = azurerm_public_ip.publicipsupplier.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}

# --- manufacturedomain ip for lbl service type
resource "azurerm_public_ip" "publicipmanu" {
  name                = "manufacturedomain-publicip-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  domain_name_label   = "manufacturedomain-${var.environment}"
  sku                 = "Standard"
}

resource "azurerm_key_vault_secret" "publicipsecretmanu" {
  name          = "manufacturedomain-publicip"
  value         = azurerm_public_ip.publicipmanu.ip_address
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "fqdnmanu" {
  name          = "manufacturedomain-azurefqdn"
  value         = azurerm_public_ip.publicipmanu.fqdn
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_role_assignment" "allowAksSpiToContributeManuIp" {
  scope                = azurerm_public_ip.publicipmanu.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}
