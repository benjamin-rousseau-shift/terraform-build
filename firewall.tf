# Create network interface
resource "azurerm_network_interface" "myterraformniceth0" {
  name                = "${var.FirewallVmName}-eth0"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnetmgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.0.254"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicipmgmt.id
  }

}

resource "azurerm_network_interface" "myterraformniceth1" {
  name                = "${var.FirewallVmName}-eth1"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnetuntrust.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.1.254"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicipuntrust.id
  }

}

resource "azurerm_network_interface" "myterraformniceth2" {
  name                = "${var.FirewallVmName}-eth2"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnetweb.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.2.254"
  }

}

resource "azurerm_network_interface" "myterraformniceth3" {
  name                = "${var.FirewallVmName}-eth3"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnetstorage.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.3.254"
  }

}
resource "azurerm_network_interface" "myterraformniceth4" {
  name                = "${var.FirewallVmName}-eth4"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnetdbcp.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.4.254"
  }

}

resource "azurerm_network_interface" "myterraformniceth5" {
  name                = "${var.FirewallVmName}-eth5"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnetinternalsrv.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.5.254"
  }

}

resource "azurerm_network_interface" "myterraformniceth6" {
  name                = "${var.FirewallVmName}-eth6"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.myterraformsubnetmgt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.IPAddressPrefix}.7.254"
  }

}
# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sec_association_mgmt" {
  network_interface_id      = azurerm_network_interface.myterraformniceth0.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

resource "azurerm_network_interface_security_group_association" "sec_association_untrust" {
  network_interface_id      = azurerm_network_interface.myterraformniceth1.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicipmgmt" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-pafw-pub-ip-mgmt"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

}

resource "azurerm_public_ip" "myterraformpublicipuntrust" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-pafw-pub-ip-untrust"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"

}

# Accept Terms for the PAN OS Image
resource "azurerm_marketplace_agreement" "panosimage" {
  publisher ="paloaltonetworks"
  offer     = "vmseries1"
  plan       = "bundle2"
}

# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
  name = var.FirewallVmName

  location              = var.azurelocation
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  vm_size                  = "Standard_D4_v2"
  depends_on = [azurerm_marketplace_agreement.panosimage]

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries1"
    # Using a pay as you go license set sku to "bundle2"
    # To use a purchased license change sku to "byol"
    sku       = "bundle2"
    version   = "9.1.0"
  }

  plan {
    # Using a pay as you go license set sku to "bundle2"
    # To use a purchased license change sku to "byol"
    name      = "bundle2"
    publisher = "paloaltonetworks"
    product   = "vmseries1"
  }

  storage_os_disk {
    name          = "${var.FirewallVmName}-OSDisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    vhd_uri       = "${azurerm_storage_account.mystorageaccount-pafw.primary_blob_endpoint}vhds/${var.FirewallVmName}-OSDisk.vhd"
  }

  os_profile {
    computer_name  = var.FirewallVmName
    admin_username = "windu"
    admin_password = var.admin_password
    custom_data = join(
    ",",
    [
      "storage-account=shift0central0bootstrap",
      "access-key=TMlnjVOeVENKWXNMm2GfHHJEJk1I0LBc0GJed7DDChLdFTzX7apuUM128T1EM+aZ+MX+F+Q+/xO+Wjyk7t/YGg==",
      "file-share=bootstrap",
      "share-directory=None"
    ],
    )
  }

  # The ordering of interaces assignewd here controls the PAN OS device mapping
  # 1st = mgmt0, 2nd = Ethernet1/1, 3rd = Ethernet 1/2
  primary_network_interface_id = azurerm_network_interface.myterraformniceth0.id
  network_interface_ids = [
    azurerm_network_interface.myterraformniceth0.id, azurerm_network_interface.myterraformniceth1.id,
    azurerm_network_interface.myterraformniceth2.id, azurerm_network_interface.myterraformniceth3.id,
    azurerm_network_interface.myterraformniceth4.id, azurerm_network_interface.myterraformniceth5.id,
    azurerm_network_interface.myterraformniceth6.id
  ]

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled = true
    storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    TYPE = "FIREWALL"
    PROJECT = var.project
    LOCATION = "${var.environment}-${var.region}"
    ENVIRONMENT = "INTERNAL-PROD"
  }
}

output "FirewallMgmtIP" {
  value = "https://${azurerm_public_ip.myterraformpublicipmgmt.ip_address}"
}