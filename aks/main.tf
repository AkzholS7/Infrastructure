terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

data "azurerm_resource_group" "example" {  
  name = "1-976eb0da-playground-sandbox"
}

resource "azurerm_kubernetes_cluster" "example" {
    name = "my-aks"
    location = data.azurerm_resource_group.example.location
    resource_group_name = data.azurerm_resource_group.example.name
    dns_prefix = "myaks"

    default_node_pool {
      name = "default"
      node_count = 1
      vm_size = "Standard_D2_v2"
    }

    identity {
      type = "SystemAssigned"
    }

    tags = {
      environment = "Dev"
    }
  
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.example.kube_config_raw
    sensitive = true
  
}