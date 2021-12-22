# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-SUB"
  address_space       = ["${var.IPAddressPrefix}.0.0/16"]
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  dns_servers         = ["10.2.3.1","1.1.1.1"]

  tags = {
    TYPE     = "VNET"
    PROJECT  = var.project
    LOCATION = "${var.environment}-${var.region}"
  }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnetmgmt" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-MGMT"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.0.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetuntrust" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-UNTRUST"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.1.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetweb" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-WEB"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.2.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetstorage" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-STORAGE"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.3.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetdbcp" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-DBCP"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.4.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetinternalsrv" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-INTERNAL-SRV"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.5.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetmgt" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-MGT"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.7.0/24"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-nsg-allow-all"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "AllowAll"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}