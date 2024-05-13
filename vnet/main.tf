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

# resource "azurerm_resource_group" "example" {
#   name     = "1-976eb0da-playground-sandbox"
#   location = "South Central US"
# }

data "azurerm_resource_group" "example" {  
  name = "1-976eb0da-playground-sandbox"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name = "my-subnet"
  resource_group_name = data.azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes = ["10.0.1.0/24"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
  
}

resource "azurerm_route_table" "example" {
  name = "example-route-table"
  location = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  disable_bgp_route_propagation = false

  route {
    name = "route1"
    address_prefix = "10.0.0.0/16"
    next_hop_type = "VnetLocal"
  }

  tags = {
    environment = "Dev"
  }
  
}

resource "azurerm_subnet_route_table_association" "name" {
  subnet_id = azurerm_subnet.example.id
  route_table_id = azurerm_route_table.example.id
  
}

resource "azurerm_network_security_group" "example" {
  name = "acceptanceTestSecurityGroup1"
  location = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  security_rule {
    name = "test123"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet_network_security_group_association" "name" {
  subnet_id = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
  
}