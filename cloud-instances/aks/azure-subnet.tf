# Gathering Data from Datacenter
data "azurerm_resource_group" "pafw_rg" {
  name = "${var.enterprise}-${var.environment}-${var.region}-${var.pafw}-RG"
}

data "azurerm_virtual_network" "pafw_vnet" {
  name = "${var.enterprise}-${var.environment}-${var.region}-SUB"
  resource_group_name = data.azurerm_resource_group.pafw_rg.name
}

# AKS Vnet

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-AKS-SUB"
  address_space       = ["${var.AKSAddressPrefix}.0.0/16"]
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.aks-rg.name

  tags = {
    TYPE     = "VNET"
    PROJECT  = "AKS"
    LOCATION = "${var.environment}-${var.region}"
  }
}


#AKS Subnets
resource "azurerm_subnet" "aks-web-subnet" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-AKS-WEB"
  resource_group_name  = azurerm_resource_group.aks-rg.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.AKSAddressPrefix}.0.0/18"]
}

#
#resource "azurerm_subnet" "aks-worker-subnet" {
#  name                 = "${var.enterprise}-${var.environment}-${var.region}-AKS-WORKER"
#  resource_group_name  = data.azurerm_resource_group.pafw_rg.name
#  virtual_network_name = data.azurerm_virtual_network.pafw_vnet.name
#  address_prefixes     = ["${var.AKSAddressPrefix}.64.0/18"]
#}
