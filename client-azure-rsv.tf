# Create Recovery Service Vault
resource "azurerm_recovery_services_vault" "myvault-client" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-RSV"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup-client.name
  sku                 = "Standard"

  soft_delete_enabled = true
}

# Create Client Backup Policy
resource "azurerm_backup_policy_vm" "myvault-policy-client" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-BKP-POLICY"
  resource_group_name = azurerm_resource_group.myterraformgroup-client.name
  recovery_vault_name = azurerm_recovery_services_vault.myvault-client.name

  timezone = "Romance Standard Time"

  backup {
    frequency = "Daily"
    time      = "00:00"
  }

  retention_daily {
    count = 8
  }

}