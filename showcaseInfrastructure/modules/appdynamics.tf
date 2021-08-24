resource "kubernetes_namespace" "appdynamics" {
  metadata {
    name = "appdynamics"
  }
}

resource "helm_release" "appdynamics-helm-chart" {
  depends_on = [kubernetes_namespace.appdynamics]
  name       = "appdynamics-helm-chart"
  repository = "https://ciscodevnet.github.io/appdynamics-charts"
  chart      = "appdynamics-charts/cluster-agent"
  namespace  = "appdynamics" 
  timeout    = "500"
}

set {
    name  = "controllerInfo.account"
    value = var.appdynamics_account
}

set {
    name  = "controllerInfo.username"
    value = var.appdynamics_username
}

set {
    name  = "controllerInfo.password"
    value = var.appdynamics_password
        }
    
set {
    name  = "controllerInfo.accessKey"
    value = var.appdynamics_accessKey
}