# Create a resource group for AKS
resource "azurerm_resource_group" "aks-rg" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-AKS-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = "AKS"
    LOCATION = "${var.environment}-${var.region}"
  }
}

# Create a resource group for AKS Nodes
resource "azurerm_resource_group" "aks-nodes-web-rg" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-NODES-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = "AKS"
    LOCATION = "${var.environment}-${var.region}"
  }
}

resource "azurerm_resource_group" "aks-nodes-worker-rg" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-AKS-WORKER-NODES-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = "AKS"
    LOCATION = "${var.environment}-${var.region}"
  }
}