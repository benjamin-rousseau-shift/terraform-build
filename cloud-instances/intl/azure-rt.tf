
# Create INTL Route Table
resource "azurerm_route_table" "route-client-intl" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-INTL-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup-client.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-intl]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.5.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.5.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.248.0/24"
    next_hop_type  = "VnetLocal"

  }

}


resource "azurerm_subnet_route_table_association" "route_table_association_intl" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-intl.id
  route_table_id = azurerm_route_table.route-client-intl.id
  depends_on = [azurerm_route_table.route-client-intl]
}

