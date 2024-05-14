terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.25.0"
    }
  }

  backend "azurerm" {
    subscription_id      = "5dd0931b-07e1-4ca2-b4c1-93436ecec38b"
    resource_group_name  = "akzhols-rg-tfstate"
    storage_account_name = "akzholstorageaccount77"
    container_name       = "state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "5dd0931b-07e1-4ca2-b4c1-93436ecec38b"
  features {}
  skip_provider_registration = true
}

data "azurerm_resource_group" "rg" {
  name = "akzhols-rg-tfstate"
}