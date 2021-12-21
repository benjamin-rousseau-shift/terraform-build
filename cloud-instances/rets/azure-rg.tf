# Create a resource group for CLIENT
resource "azurerm_resource_group" "myterraformgroup-client" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = var.client
    LOCATION = "${var.environment}-${var.region}"
  }
}