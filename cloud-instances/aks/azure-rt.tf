resource "azurerm_route_table" "routeTable" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.aks-rg.name
  disable_bgp_route_propagation = false

  route {
    name           = "DEFAULT-ROUTE"
    address_prefix = "${var.AKSAddressPrefix}.0.0/18"
    next_hop_type  = "vnetlocal"
  }

}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = azurerm_subnet.aks-web-subnet.id
  route_table_id = azurerm_route_table.routeTable.id
}