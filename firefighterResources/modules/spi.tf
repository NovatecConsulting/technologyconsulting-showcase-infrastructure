resource "azuread_application" "firefighterApp" {
  display_name               = "tc-showcase-firefighter-${var.environment}-${var.firefighterName}"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "firefighterAppSpi" {
  application_id = azuread_application.firefighterApp.application_id
}

resource "random_string" "firefighterAppSpiPasswordGen" {
  length  = 128
  upper   = true
  lower   = true
  number  = true
  special = true
}

resource "azuread_application_password" "firefighterAppSpiSecret" {
  application_object_id = azuread_application.firefighterApp.id
  value                 = random_string.firefighterAppSpiPasswordGen.result
  description           = "tc-showcase-firefighter-${var.environment}-${var.firefighterName}"
  end_date_relative     = "2h"
}

resource "azurerm_key_vault_secret" "firefighter-azure-creds" {
  name         = "firefighter-${var.firefighterName}-credentials"
  value        = "{ 'clientId': '${azuread_service_principal.firefighterAppSpi.object_id}', 'clientSecret': '${random_string.firefighterAppSpiPasswordGen.result}', 'subscriptionId': '${data.azurerm_client_config.current.subscription_id}', 'tenantId': '${data.azurerm_client_config.current.tenant_id}' }"
  key_vault_id = data.azurerm_key_vault.vault.id
}