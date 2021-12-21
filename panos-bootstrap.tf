# Create Storage Account, File Share and Directories
resource "azurerm_storage_account" "bootstrap-storage-acct" {

  name                     = "${lower(var.enterprise)}0${lower(var.environment)}0${lower(var.region)}0bootstrap"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.azurelocation
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



resource "azurerm_storage_share" "bootstrap-storage-share" {
  name                 = "bootstrap"
  storage_account_name = azurerm_storage_account.bootstrap-storage-acct.name
  quota                = 50
}

resource "azurerm_storage_share_directory" "nonconfig" {
  for_each = toset([
    "content",
    "software",
    "plugins",
    "license"
  ])

  name                 = each.key
  share_name           = azurerm_storage_share.bootstrap-storage-share.name
  storage_account_name = azurerm_storage_account.bootstrap-storage-acct.name
}

resource "azurerm_storage_share_directory" "config" {
  name                 = "config"
  share_name           = azurerm_storage_share.bootstrap-storage-share.name
  storage_account_name = azurerm_storage_account.bootstrap-storage-acct.name
}

resource "azurerm_storage_share_file" "this" {
  for_each = var.files

  name             = regex("[^/]*$", each.value)
  path             = replace(each.value, "/[/]*[^/]*$/", "")
  storage_share_id = azurerm_storage_share.bootstrap-storage-share.id
  source           = replace(each.key, "/CalculateMe[X]${random_id.this[each.key].id}/", "CalculateMeX${random_id.this[each.key].id}")
  # Live above is equivalent to:   `source = each.key`  but it re-creates the file every time the content changes.
  # The replace() is not actually doing anything, except tricking Terraform to destroy a resource.
  # There is a field content_md5 designed specifically for that. But I see a bug in the provider (last seen in 2.76):
  # When content_md5 changes the re-uploading seemingly succeeds, result being however a totally empty file (size zero).
  # Workaround: use random_id above to cause the full destroy/create of a file.
  depends_on = [azurerm_storage_share_directory.config, azurerm_storage_share_directory.nonconfig]
}

resource "random_id" "this" {
  for_each = var.files

  keepers = {
    # Re-randomize on every content/md5 change. It forcibly recreates all users of this random_id.
    md5 = try(var.files_md5[each.key], md5(file(each.key)))
  }
  byte_length = 8
}