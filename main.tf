# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-${var.project}-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = var.project
    LOCATION = "${var.environment}-${var.region}"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-SUB"
  address_space       = ["${var.IPAddressPrefix}.0.0/16"]
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  tags = {
    TYPE     = "VNET"
    PROJECT  = var.project
    LOCATION = "${var.environment}-${var.region}"
  }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnetmgmt" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-MGMT"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.0.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetuntrust" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-UNTRUST"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.1.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetweb" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-WEB"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.2.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetstorage" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-STORAGE"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.3.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetdbcp" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-DBCP"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.4.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetinternalsrv" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-INTERNAL-SRV"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.5.0/24"]
}

resource "azurerm_subnet" "myterraformsubnetmgt" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-ZONE-MGT"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.7.0/24"]
}

resource "azurerm_subnet" "myterraformsubnet-rets-web" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-RETS-WEB"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.0/27"]
}

resource "azurerm_subnet" "myterraformsubnet-rets-storage" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-RETS-STORAGE"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.32/27"]
}

resource "azurerm_subnet" "myterraformsubnet-rets-dbcp" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-RETS-DBCP"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.64/26"]
}

resource "azurerm_subnet" "myterraformsubnet-rets-mgt" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-RETS-MGT"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.224/27"]
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

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-nsg-allow-all"
  location            = var.azurelocation
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "AllowAll"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}

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

# Create Web Route Table
resource "azurerm_route_table" "route-rets-web" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-RETS-WEB-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-rets-web]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.2.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.2.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.2.0/27"
    next_hop_type  = "VnetLocal"

  }

}

# Create Storage Route Table
resource "azurerm_route_table" "route-rets-storage" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-RETS-STORAGE-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-rets-storage]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.3.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.3.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.8.32/27"
    next_hop_type  = "VnetLocal"

  }

}

# Create DBCP Route Table
resource "azurerm_route_table" "route-rets-dbcp" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-RETS-DBCP-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-rets-dbcp]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.4.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.4.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.8.64/26"
    next_hop_type  = "VnetLocal"

  }

}

# Create MGT Route Table
resource "azurerm_route_table" "route-rets-mgt" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-RETS-MGT-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-rets-mgt]

  route {
    name                   = "DEFAULT-ROUTE"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.7.254"
  }

  route {
    name                   = "ROUTE-TO-${var.IPAddressPrefix}.0.0-16"
    address_prefix         = "${var.IPAddressPrefix}.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.IPAddressPrefix}.7.254"
  }

  route {
    name           = "ROUTE-TO-LOCAL-SUBNET"
    address_prefix = "${var.IPAddressPrefix}.8.224/27"
    next_hop_type  = "VnetLocal"

  }

}

# Association route tables
resource "azurerm_subnet_route_table_association" "route_table_association_web" {
  subnet_id      = azurerm_subnet.myterraformsubnet-rets-web.id
  route_table_id = azurerm_route_table.route-rets-web.id
  depends_on = [azurerm_route_table.route-rets-web]
}
resource "azurerm_subnet_route_table_association" "route_table_association_storage" {
  subnet_id      = azurerm_subnet.myterraformsubnet-rets-storage.id
  route_table_id = azurerm_route_table.route-rets-storage.id
  depends_on = [azurerm_route_table.route-rets-storage]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dbcp" {
  subnet_id      = azurerm_subnet.myterraformsubnet-rets-dbcp.id
  route_table_id = azurerm_route_table.route-rets-dbcp.id
  depends_on = [azurerm_route_table.route-rets-dbcp]
}

resource "azurerm_subnet_route_table_association" "route_table_association_mgt" {
  subnet_id      = azurerm_subnet.myterraformsubnet-rets-mgt.id
  route_table_id = azurerm_route_table.route-rets-mgt.id
  depends_on = [azurerm_route_table.route-rets-mgt]
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