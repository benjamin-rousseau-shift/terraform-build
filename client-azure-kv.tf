# Create Key Vault for Client
resource "azurerm_key_vault" "mykeyvault-client" {
  name                        = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-KV"
  location                    = var.azurelocation
  resource_group_name         = azurerm_resource_group.myterraformgroup-client.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  depends_on = [azuread_service_principal.adapp-client-sp]

  sku_name = "standard"

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.backup_management_id

    key_permissions = [
      "Get","List","Backup"
    ]

    secret_permissions = [
      "Get","List","Backup"
    ]
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = azuread_service_principal.adapp-client-sp.id

    key_permissions = [
      "Get","UnwrapKey","WrapKey"
    ]

  }
}