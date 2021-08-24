resource "azurerm_log_analytics_workspace" "k8sanalyticsworkspace" {
    name                = "tc-showcase-${var.environment}-loganalytics"
    resource_group_name = azurerm_resource_group.resourceGroup.name
    location            = azurerm_resource_group.resourceGroup.location
    sku                 = "Premium"
}

resource "azurerm_key_vault_secret" "workspaceid" {
  name          = "loganalytics-workspaceid"
  value         = azurerm_log_analytics_workspace.k8sanalyticsworkspace.workspace_id
  key_vault_id  = azurerm_key_vault.vault.id
 }

 resource "azurerm_key_vault_secret" "workspacekey" {
  name          = "loganalytics-workspacekey"
  value         = azurerm_log_analytics_workspace.k8sanalyticsworkspace.primary_shared_key
  key_vault_id  = azurerm_key_vault.vault.id
 }

resource "azurerm_key_vault_secret" "APP_ID" {
  name          = "appinsights-APP-ID"
  value         = azurerm_application_insights.applicationinsights.app_id
  key_vault_id  = azurerm_key_vault.vault.id
}
