### SPI 

resource "azuread_application" "aksApp" {
  display_name               = "tc-showcase-aks-${var.environment}"
}

resource "azuread_service_principal" "aksSpi" {
  application_id = azuread_application.aksApp.application_id
}

resource "random_string" "aksSpiPasswordGen" {
  length  = 128
  upper   = true
  lower   = true
  number  = true
  special = true
}

resource "azuread_application_password" "aksSpiSecret" {
  application_object_id = azuread_application.aksApp.id
  value                 = random_string.aksSpiPasswordGen.result
  description           = "tc-showcase-aks-${var.environment}"
  end_date_relative     = "8760h"
}

### ACR PULL

resource "azurerm_role_assignment" "allowAksToPullFromAcr" {
  scope                            = data.azurerm_container_registry.containerregistry.id
  role_definition_name             = "AcrPull"
  principal_id                     = azuread_service_principal.aksSpi.object_id
  skip_service_principal_aad_check = true
}

### NETWORK
resource "azurerm_subnet" "aksSubnet" {
  name                 = "tc-showcase-${var.environment}-aks"
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.vpc_adress_space
}

resource "azurerm_role_assignment" "allowAksSpiToContributeAksSubnet" {
  scope                = azurerm_subnet.aksSubnet.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "k8s-${azurerm_resource_group.resourceGroup.name}"
    location            = azurerm_resource_group.resourceGroup.location
    resource_group_name = azurerm_resource_group.resourceGroup.name
    dns_prefix          = "k8s-${azurerm_resource_group.resourceGroup.name}"
    kubernetes_version  = "1.19.11"


    default_node_pool {
        name       = "default"
        node_count = 2
        vm_size    = "Standard_D2_v2"
        vnet_subnet_id  = azurerm_subnet.aksSubnet.id
    }

    addon_profile {
        oms_agent {
            enabled = false
        }
    }

    service_principal {
        client_id     = azuread_application.aksApp.application_id
        client_secret = random_string.aksSpiPasswordGen.result
    }
}

# PROVIDER
provider "kubernetes" {
#    load_config_file       = false
    host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
#    load_config_file       = false
    host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
  }
}

# NAMESPACES
resource "kubernetes_namespace" "Namespace" {
  for_each = toset(local.stages)  
  metadata {
    name = each.key
  }
}

resource "kubernetes_namespace" "nginxNamespace" {
  metadata {
    name = "nginx-ingress"
  }
}

# INGRESS
resource "azurerm_public_ip" "kubernetes_cluster_ingress_ip" {
  name                         = "tc-showcase-${var.environment}-ingress-ip"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  location                     = azurerm_resource_group.resourceGroup.location
  allocation_method            = "Static"
  sku                          = "Standard"
  domain_name_label            = "tc-showcase-${var.environment}"
}

resource "azurerm_key_vault_secret" "ingress-ip" {
  name         = "ingress-ip"
  value        = azurerm_public_ip.kubernetes_cluster_ingress_ip.ip_address
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "ingress-fqdn" {
  name         = "ingress-fqdn"
  value        = azurerm_public_ip.kubernetes_cluster_ingress_ip.fqdn
  key_vault_id = azurerm_key_vault.vault.id
}

resource "azurerm_role_assignment" "allowAksSpiToContributeIngressIp" {
  scope                = azurerm_public_ip.kubernetes_cluster_ingress_ip.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aksSpi.object_id
}


 resource "helm_release" "nginxIngressController" {
   name       = "ingress"
   repository = "https://helm.nginx.com/stable" 
   chart      = "nginx-ingress"
   wait       = false
   namespace  = "nginx-ingress"

   set {
     name  = "controller.service.loadBalancerIP"
     value = azurerm_public_ip.kubernetes_cluster_ingress_ip.ip_address
   }

   set {
     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
     value = azurerm_resource_group.resourceGroup.name
   }

   # it is not possible to use namespace-name in helm-release in order to build TF-execution-tree
   # kubernetes_namespace does not offer it as attribute
   # but the namespace must be created before creating helm release
   depends_on = [kubernetes_namespace.nginxNamespace]
}
