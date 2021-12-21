# Create Web Route Table
resource "azurerm_route_table" "route-client-web" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-WEB-RT"
  location                      = var.azurelocation
  resource_group_name           = data.azurerm_resource_group.pafw_rg.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-web]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.2.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.2.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.2.0/27"
    next_hop_type  = "VnetLocal"

  }

}

# Create Storage Route Table
resource "azurerm_route_table" "route-client-storage" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-STORAGE-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup-client.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-storage]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.3.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.3.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.8.32/27"
    next_hop_type  = "VnetLocal"

  }

}

# Create DBCP Route Table
resource "azurerm_route_table" "route-client-dbcp" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-DBCP-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup-client.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-dbcp]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.4.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.4.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.8.64/26"
    next_hop_type  = "VnetLocal"

  }

}

# Create MGT Route Table
resource "azurerm_route_table" "route-client-mgt" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-MGT-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup-client.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-mgt]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.7.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.7.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.8.224/27"
    next_hop_type  = "VnetLocal"

  }

}

# Association route tables
resource "azurerm_subnet_route_table_association" "route_table_association_web" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-web.id
  route_table_id = azurerm_route_table.route-client-web.id
  depends_on = [azurerm_route_table.route-client-web]
}
resource "azurerm_subnet_route_table_association" "route_table_association_storage" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-storage.id
  route_table_id = azurerm_route_table.route-client-storage.id
  depends_on = [azurerm_route_table.route-client-storage]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dbcp" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-dbcp.id
  route_table_id = azurerm_route_table.route-client-dbcp.id
  depends_on = [azurerm_route_table.route-client-dbcp]
}

resource "azurerm_subnet_route_table_association" "route_table_association_mgt" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-mgt.id
  route_table_id = azurerm_route_table.route-client-mgt.id
  depends_on = [azurerm_route_table.route-client-mgt]
}