#rg fe-rg
#pip pub-ip01
#fw  fw-01
#vnet fe-vnet

provider "azurerm" {
  version = "= 2.18"
  features {}
}

resource "azurerm_resource_group" "fe-rg" {
  name     = "fe-rg"
  location = "uksouth"
}

resource "azurerm_virtual_network" "fe-rg" {
  name                = "fe-vnet"
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
}

resource "azurerm_subnet" "fe-rg-01" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "fe-rg-02" {
  name                 = "jbox-subnet"
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "fe-rg" {
  name                = "pub-ip01"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fe-rg" {
  name                = "fw-01"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
  ip_configuration {
    name                 = "fwip-config"
    subnet_id            = azurerm_subnet.fe-rg-01.id
    public_ip_address_id = azurerm_public_ip.fe-rg.id
  }
}