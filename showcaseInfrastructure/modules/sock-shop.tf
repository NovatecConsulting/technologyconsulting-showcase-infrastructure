#With this provider you can deploy helm charts in the new created aks 
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
    load_config_file="false"
    }
    debug = "true" 
}

resource "kubernetes_namespace" "sock-shop" {
  metadata {
    name = "sock-shop"
  }
}

resource "helm_release" "sock-shop-helm-chart" {
  depends_on = [kubernetes_namespace.sock-shop]
  name       = "sock-shop-helm-chart"
  chart      = "sock-shop-helm/helm-chart/Chart.yaml"
  namespace  = "sock-shop" 
  timeout    = "500"
}