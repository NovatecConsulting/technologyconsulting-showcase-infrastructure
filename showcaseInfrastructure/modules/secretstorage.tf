resource "azurerm_key_vault" "vault" {
  name                        = "vlt-${azurerm_resource_group.resourceGroup.name}"
  location                    = azurerm_resource_group.resourceGroup.location
  resource_group_name         = azurerm_resource_group.resourceGroup.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.developergroup

    secret_permissions = [
      "get", "list", "set", "delete", "recover", "backup", "restore"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.spigroup

    secret_permissions = [
      "get", "list", "set", "delete"
    ]
  }

  # also need to grant the Service Principal being used with Terraform access to the KeyVault
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "get", "list", "set", "delete"
    ]

  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}
