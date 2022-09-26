# Subnets
resource "azurerm_subnet" "myterraformsubnet-client-intl" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-INTL"
  resource_group_name  = data.azurerm_resource_group.pafw_rg.name
  virtual_network_name = data.azurerm_virtual_network.pafw_vnet.name
  address_prefixes     = ["${var.IPAddressPrefix}.248.0/24"]
}