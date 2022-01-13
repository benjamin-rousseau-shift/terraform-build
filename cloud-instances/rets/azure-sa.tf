# Create storage account for Client
resource "azurerm_storage_account" "mystorageaccount-client-hdd" {
  name                     = "${lower(var.enterprise)}0${lower(var.environment)}0${lower(var.region)}0${lower(var.client)}0hdd0sa"
  resource_group_name      = azurerm_resource_group.myterraformgroup-client.name
  location                 = var.azurelocation
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    TYPE             = "STORAGE-ACCOUNT"
    LOCATION         = "${var.environment}-${var.region}"
    PROJECT          = var.client
    STORAGE-TYPE     = "HDD"
    REPLICATION-TYPE = "LRS"
  }
}

resource "azurerm_storage_container" "hdd-vhds" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.mystorageaccount-client-hdd.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "mystorageaccount-client-ssd" {
  name                     = "${lower(var.enterprise)}0${lower(var.environment)}0${lower(var.region)}0${lower(var.client)}0ssd0sa"
  resource_group_name      = azurerm_resource_group.myterraformgroup-client.name
  location                 = var.azurelocation
  account_tier             = "Premium"
  account_replication_type = "LRS"

  tags = {
    TYPE             = "STORAGE-ACCOUNT"
    LOCATION         = "${var.environment}-${var.region}"
    PROJECT          = var.client
    STORAGE-TYPE     = "SSD"
    REPLICATION-TYPE = "LRS"
  }
}

resource "azurerm_storage_container" "ssd-vhds" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.mystorageaccount-client-ssd.name
  container_access_type = "private"
}