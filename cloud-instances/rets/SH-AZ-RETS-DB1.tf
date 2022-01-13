# Create network interface
resource "azurerm_network_interface" "db1" {
  name                = "${var.enterprise}-${var.environment}-${var.client}-DB1"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup-client.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnet-client-dbcp.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.8.68"
  }

}

# Create VM
resource "azurerm_virtual_machine" "db1" {
  name                = azurerm_network_interface.db1.name
  resource_group_name = azurerm_network_interface.db1.resource_group_name
  location            = azurerm_network_interface.db1.location
  vm_size                = "Standard_B4ms"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  depends_on = [azurerm_network_interface.db1,azurerm_key_vault.mykeyvault-client]

  network_interface_ids = [
    azurerm_network_interface.db1.id,
  ]

  # OS Disk
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${azurerm_network_interface.db1.name}-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "128"
    vhd_uri = "${azurerm_storage_account.mystorageaccount-client-hdd.primary_blob_endpoint}${azurerm_storage_container.hdd-vhds.name}"
  }
  os_profile {
    computer_name  = azurerm_network_interface.db1.name
    admin_username = "windu"
    admin_password = var.admin_password
  }

  # Data Disks
  storage_data_disk {
    name = "${azurerm_network_interface.db1.name}-UIDisk"
    create_option = "Empty"
    disk_size_gb = "100"
    lun = "1"
    vhd_uri = "${azurerm_storage_account.mystorageaccount-client-hdd.primary_blob_endpoint}${azurerm_storage_container.hdd-vhds.name}"
  }

  storage_data_disk {
    name = "${azurerm_network_interface.db1.name}-TempDBDisk"
    create_option = "Empty"
    disk_size_gb = "100"
    lun = "2"
    vhd_uri = "${azurerm_storage_account.mystorageaccount-client-hdd.primary_blob_endpoint}${azurerm_storage_container.hdd-vhds.name}"
  }

  storage_data_disk {
    name = "${azurerm_network_interface.db1.name}-Detection01Disk"
    create_option = "Empty"
    disk_size_gb = "100"
    lun = "3"
    vhd_uri = "${azurerm_storage_account.mystorageaccount-client-hdd.primary_blob_endpoint}${azurerm_storage_container.hdd-vhds.name}"
  }


}

# Join Domain
resource "azurerm_virtual_machine_extension" "joindomain" {
  name = "joindomain"
  virtual_machine_id = azurerm_virtual_machine.db1.id
  publisher = "Microsoft.Compute"
  type = "JsonADDomainExtension"
  type_handler_version = "1.3"
  # What the settings mean: https://docs.microsoft.com/en-us/windows/desktop/api/lmjoin/nf-lmjoin-netjoindomain
  settings = <<SETTINGS
{
"Name": "corp.shift-technology.com",
"OUPath": "CN=Computers,DC=corp,DC=shift-technology,DC=com",
"User": "SHIFT\\terraformjoindomain",
"Restart": "true",
"Options": "3"
}
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
{
"Password": "${var.join_domain_pwd}"
}
PROTECTED_SETTINGS
  depends_on = ["azurerm_virtual_machine.db1"]
}

# Key Encryption Key (KEK)

resource "azurerm_key_vault_key" "db1" {
  name         = "${azurerm_network_interface.db1.name}-KEK"
  key_vault_id = azurerm_key_vault.mykeyvault-client.name
  key_type     = "RSA"
  key_size     = 2048
  depends_on = [azurerm_virtual_machine.db1,azurerm_key_vault.mykeyvault-client]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

# Activating Encryption

resource "azurerm_virtual_machine_extension" "encrypt" {
  name                 = "AzureDiskEncryption"
  location             = azurerm_network_interface.db1.location
  virtual_machine_id = azurerm_virtual_machine.db1.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2"
  depends_on = [azurerm_key_vault_key.db1,azurerm_virtual_machine.db1]

  settings = <<SETTINGS
{
  "EncryptionOperation": "EnableEncryption",
  "KeyVaultURL": "${azurerm_key_vault.mykeyvault-client.vault_uri}",
  "KeyVaultResourceId": "${azurerm_key_vault.mykeyvault-client.id}",
  "KeyEncryptionKeyURL": "${azurerm_key_vault.mykeyvault-client.vault_uri}/keys/${azurerm_key_vault_key.db1.name}/${azurerm_key_vault_key.db1.version}",
  "KekVaultResourceId": "${azurerm_key_vault.mykeyvault-client.id}",
  "KeyEncryptionAlgorithm": "RSA-OAEP",
  "VolumeType": "All"
}
SETTINGS
}

# Backup VM
resource "azurerm_backup_protected_vm" "db1" {
  resource_group_name = azurerm_recovery_services_vault.myvault-client.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.myvault-client.name
  source_vm_id        = azurerm_virtual_machine.db1.id
  backup_policy_id    = azurerm_backup_policy_vm.myvault-policy-client.id
}