terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.25.0"
    }
  }

  backend "azurerm" {
    subscription_id      = "80ea84e8-afce-4851-928a-9e2219724c69"
    resource_group_name  = "1-a50ef9d0-playground-sandbox"
    storage_account_name = "aksholstorageaccount7"
    container_name       = "state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "80ea84e8-afce-4851-928a-9e2219724c69"
  features {}
  skip_provider_registration = true
}

data "azurerm_resource_group" "rg" {
  name = "1-a50ef9d0-playground-sandbox"
}