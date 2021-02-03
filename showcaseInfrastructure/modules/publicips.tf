# INGRESS
resource "azurerm_public_ip" "kubernetes_cluster_ingress_ip" {

  for_each = toset(local.stages)
  name                         = "${each.key}-${var.environment}-ingress-ip"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  location                     = azurerm_resource_group.resourceGroup.location
  allocation_method            = "Static"
  sku                          = "Standard"
  domain_name_label            = "${each.key}-ingress-${var.environment}"
}

resource "azurerm_key_vault_secret" "ingress-ip" {
  name         = "${each.key}-ingress-ip"
  value        = azurerm_public_ip.kubernetes_cluster_ingress_ip[each.key].ip_address
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "ingress-fqdn" {
  name         = "${each.key}-ingress-fqdn"
  value        = azurerm_public_ip.kubernetes_cluster_ingress_ip[each.key].fqdn
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_role_assignment" "allowAksSpiToContributeIngressIp" {
  scope                = azurerm_public_ip.kubernetes_cluster_ingress_ip[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}

# ---- orderdomain ip for lbl service type
resource "azurerm_public_ip" "publiciporder" {
  for_each = toset(local.stages)  
  name                = "${each.key}-orderdomain-publicip-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  domain_name_label   = "${each.key}-orderdomain-${var.environment}"
  sku                 = "Standard"
}

resource "azurerm_key_vault_secret" "publicipsecretorder" {
  for_each = toset(local.stages) 
  name          = "${each.key}-orderdomain-publicip"
  value         = azurerm_public_ip.publiciporder[each.key].ip_address
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "fqdnorder" {
  for_each = toset(local.stages) 
  name          = "${each.key}-orderdomain-azurefqdn"
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
  for_each = toset(local.stages) 
  name                = "${each.key}-supplierdomain-publicip-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  domain_name_label   = "${each.key}-supplierdomain-${var.environment}"
  sku                 = "Standard"
}

resource "azurerm_key_vault_secret" "publicipsecretsupplier" {
  for_each = toset(local.stages) 
  name          = "${each.key}-supplierdomain-publicip"
  value         = azurerm_public_ip.publicipsupplier[each.key].ip_address
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "fqdnsupplier" {
  for_each = toset(local.stages) 
  name          = "${each.key}-supplierdomain-azurefqdn"
  value         = azurerm_public_ip.publicipsupplier[each.key].fqdn
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_role_assignment" "allowAksSpiToContributeSupplierIp" {
  for_each = toset(local.stages) 
  scope                = azurerm_public_ip.publicipsupplier[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}

# --- manufacturedomain ip for lbl service type
resource "azurerm_public_ip" "publicipmanu" {
  for_each = toset(local.stages) 
  name                = "${each.key}-manufacturedomain-publicip-${var.environment}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  allocation_method   = "Static"
  domain_name_label   = "${each.key}-manufacturedomain-${var.environment}"
  sku                 = "Standard"
}

resource "azurerm_key_vault_secret" "publicipsecretmanu" {
  for_each = toset(local.stages) 
  name          = "${each.key}-manufacturedomain-publicip"
  value         = azurerm_public_ip.publicipmanu[each.key].ip_address
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "fqdnmanu" {
  for_each = toset(local.stages) 
  name          = "${each.key}-manufacturedomain-azurefqdn"
  value         = azurerm_public_ip.publicipmanu[each.key].fqdn
  key_vault_id  = azurerm_key_vault.vault.id
}

resource "azurerm_role_assignment" "allowAksSpiToContributeManuIp" {
  for_each = toset(local.stages) 
  scope                = azurerm_public_ip.publicipmanu[each.key].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}

# ---- TODO integrationdomain ip for lbl service type

# ---- TODO driver ip for lbl service type
