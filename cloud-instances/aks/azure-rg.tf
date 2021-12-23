# Create a resource group for AKS
resource "azurerm_resource_group" "aks-rg" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-AKS-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = "AKS"
    LOCATION = "${var.environment}-${var.region}"
    VERSION = "${local.version}"
  }
}