data "azurerm_kubernetes_cluster" "k8s" {
  name                = "k8s-${azurerm_resource_group.resourceGroup.name}"
  resource_group_name = data.azurerm_resource_group.resourceGroup.name
}

resource "azurerm_key_vault_secret" "firefighter-kubeconfig" {
  name         = "firefighter-${var.firefighterName}-kubeconfig"
  value        = data.azurerm_kubernetes_cluster.k8s.kube_config_raw
  key_vault_id = data.azurerm_key_vault.vault.id
}
