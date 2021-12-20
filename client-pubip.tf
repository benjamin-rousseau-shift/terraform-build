# Create Client public IPs
resource "azurerm_public_ip" "myterraformpublicip-client" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-PROD1"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup-client.name
  allocation_method   = "Static"

}