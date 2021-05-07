resource "kubernetes_namespace" "sock-shop" {
  metadata {
    name = "sock-shop"
  }
}

resource "null_resource" "debugger" {
  provisioner "local-exec" {
    command = "ls -la"
  }
}


resource "helm_release" "sock-shop-helm-chart" {
  depends_on = [kubernetes_namespace.sock-shop]
  name       = "sock-shop-helm-chart"
  chart      = "${path.root}/../sock-shop-helm/helm-chart"
  namespace  = "sock-shop" 
  timeout    = "500"
}