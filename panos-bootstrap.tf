# Create Upload new init-cfg file to bootstrap share.

data "azurerm_storage_account" "bootstrap-storage-acct" {
  name = var.bootstrap_storage_account
  resource_group_name = var.bootstrap_resource_group
}

data "azurerm_storage_share" "bootstrap-storage-share" {
  name = var.bootstrap_storage_share
  storage_account_name = data.azurerm_storage_account.bootstrap-storage-acct.name
}