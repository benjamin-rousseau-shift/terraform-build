# Create a resource group for PAFW
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-${var.project}-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = var.project
    LOCATION = "${var.environment}-${var.region}"
  }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "${lower(var.enterprise)}0${lower(var.environment)}0${lower(var.region)}0bootdiag"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.azurelocation
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    TYPE             = "STORAGE-ACCOUNT"
    LOCATION         = "${var.environment}-${var.region}"
    PROJECT          = "BOOTDIAG"
    STORAGE-TYPE     = "HDD"
    REPLICATION-TYPE = "LRS"
  }
}

# Create storage account for Palo ALto
resource "azurerm_storage_account" "mystorageaccount-pafw" {
  name                     = "${lower(var.enterprise)}0${lower(var.environment)}0${lower(var.region)}0${lower(var.project)}0hdd0sa"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.azurelocation
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    TYPE             = "STORAGE-ACCOUNT"
    LOCATION         = "${var.environment}-${var.region}"
    PROJECT          = var.project
    STORAGE-TYPE     = "HDD"
    REPLICATION-TYPE = "LRS"
  }
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicipmgmt" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-${lower(var.project)}1-pub-ip-mgmt"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

}

resource "azurerm_public_ip" "myterraformpublicipuntrust" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-${lower(var.project)}1-pub-ip-untrust"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

}