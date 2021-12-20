# Create Client public IPs
resource "azurerm_public_ip" "myterraformpublicip-client" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-${lower(var.client)}-PROD1"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup-client.name
  allocation_method   = "Static"

}