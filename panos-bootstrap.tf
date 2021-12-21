# Create Upload new init-cfg file to bootstrap share.

data "azurerm_storage_account" "bootstrap-storage-acct" {
  name = var.bootstrap_storage_account
  resource_group_name = var.bootstrap_resource_group
}

data "azurerm_storage_share" "bootstrap-storage-share" {
  name = var.bootstrap_storage_share
  storage_account_name = data.azurerm_storage_account.bootstrap-storage-acct.name
}

data "azurerm_storage_share_directory" "config" {
  name                 = "config"
  share_name           = data.azurerm_storage_share.bootstrap-storage-share.name
  storage_account_name = data.azurerm_storage_account.bootstrap-storage-acct.name
}

resource "azurerm_storage_share_file" "this" {
  for_each = var.files

  name             = regex("[^/]*$", each.value)
  path             = replace(each.value, "/[/]*[^/]*$/", "")
  storage_share_id = data.azurerm_storage_share.bootstrap-storage-share.id
  source           = replace(each.key, "/CalculateMe[X]${random_id.this[each.key].id}/", "CalculateMeX${random_id.this[each.key].id}")
  # Live above is equivalent to:   `source = each.key`  but it re-creates the file every time the content changes.
  # The replace() is not actually doing anything, except tricking Terraform to destroy a resource.
  # There is a field content_md5 designed specifically for that. But I see a bug in the provider (last seen in 2.76):
  # When content_md5 changes the re-uploading seemingly succeeds, result being however a totally empty file (size zero).
  # Workaround: use random_id above to cause the full destroy/create of a file.
  depends_on = [data.azurerm_storage_share_directory.config]
}

resource "random_id" "this" {
  for_each = var.files

  keepers = {
    # Re-randomize on every content/md5 change. It forcibly recreates all users of this random_id.
    md5 = try(var.files_md5[each.key], md5(file(each.key)))
  }
  byte_length = 8
}