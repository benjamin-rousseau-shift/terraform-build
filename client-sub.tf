#Client Subnets
resource "azurerm_subnet" "myterraformsubnet-client-web" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-WEB"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.0/27"]
}

resource "azurerm_subnet" "myterraformsubnet-client-storage" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-STORAGE"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.32/27"]
}

resource "azurerm_subnet" "myterraformsubnet-client-dbcp" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-DBCP"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.64/26"]
}

resource "azurerm_subnet" "myterraformsubnet-client-mgt" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-MGT"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.224/27"]
}