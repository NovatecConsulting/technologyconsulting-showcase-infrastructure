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

resource "azurerm_log_analytics_solution" "loganalyticssolution" {
    solution_name         = "ContainerInsights"
    resource_group_name   = azurerm_resource_group.resourceGroup.name
    location              = azurerm_resource_group.resourceGroup.location
    workspace_resource_id = azurerm_log_analytics_workspace.k8sanalyticsworkspace.id
    workspace_name        = azurerm_log_analytics_workspace.k8sanalyticsworkspace.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_application_insights" "applicationinsights" {
  name                = "applicationInsights"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  application_type    = "java"
  retention_in_days   = 30
}

resource "azurerm_key_vault_secret" "INSTRUMENTATION_KEY" {
  name          = "appinsights-INSTRUMENTATION-KEY"
  value         = azurerm_application_insights.applicationinsights.instrumentation_key
  key_vault_id  = azurerm_key_vault.vault.id
 }

resource "azurerm_key_vault_secret" "APP_ID" {
  name          = "appinsights-APP-ID"
  value         = azurerm_application_insights.applicationinsights.app_id
  key_vault_id  = azurerm_key_vault.vault.id
}
