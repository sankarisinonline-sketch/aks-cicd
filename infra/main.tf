terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = "rg-aks-demo"
  location = "East US"
}

# AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-demo-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aksdemo"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Output kubeconfig
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}
