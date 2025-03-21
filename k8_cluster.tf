
/*resource "azurerm_resource_group" "myaksrg" {
  name = "aks_rg"
  location = "westus2"
}*/

data "azurerm_resource_group" "dotnetapp" {
  name = "dotnetapp"
}

output "id" {
  value = data.azurerm_resource_group.dotnetapp.id
}

resource "azurerm_kubernetes_cluster" "dotnetcluster" {
  name = "dotnetappAKS"
  location = "westus2"
  resource_group_name = data.azurerm_resource_group.dotnetapp.name
  dns_prefix = "dotnetapp"

  default_node_pool {
    name = "aksnodepool"
    node_count = 1
    vm_size = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.dotnetcluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.dotnetcluster.kube_config_raw

  sensitive = true
}
