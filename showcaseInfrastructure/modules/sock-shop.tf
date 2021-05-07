resource "kubernetes_namespace" "sock-shop" {
  metadata {
    name = "sock-shop"
  }
}

resource "helm_release" "sock-shop-helm-chart" {
  depends_on = [kubernetes_namespace.sock-shop]
  name       = "sock-shop-helm-chart"
  chart      = "./sock-shop-helm/helm-chart"
  namespace  = "sock-shop" 
  timeout    = "500"
}