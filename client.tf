# Create a resource group for CLIENT
resource "azurerm_resource_group" "myterraformgroup-client" {
  name     = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-RG"
  location = var.azurelocation

  tags = {
    TYPE     = "RESOURCE-GROUP"
    PROJECT  = var.project
    LOCATION = "${var.environment}-${var.region}"
  }
}

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

# Create Application & Service Principal
data "azuread_client_config" "current" {}

resource "azuread_application" "adapp-client" {
  display_name = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-ADAPP"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "adapp-client-sp" {
  application_id               = azuread_application.adapp-client.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

# Create Key Vault for Client
resource "azurerm_key_vault" "mykeyvault-client" {
  name                        = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-KV"
  location                    = var.azurelocation
  resource_group_name         = azurerm_resource_group.myterraformgroup-client
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


#Client Subnets
resource "azurerm_subnet" "myterraformsubnet-client-web" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-WEB"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.0/27"]
}

resource "azurerm_subnet" "myterraformsubnet-client-storage" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-STORAGE"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.32/27"]
}

resource "azurerm_subnet" "myterraformsubnet-client-dbcp" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-DBCP"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.64/26"]
}

resource "azurerm_subnet" "myterraformsubnet-client-mgt" {
  name                 = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-MGT"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["${var.IPAddressPrefix}.8.224/27"]
}

# Create Web Route Table
resource "azurerm_route_table" "route-client-web" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-WEB-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-web]

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
resource "azurerm_route_table" "route-client-storage" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-STORAGE-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup-client.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-storage]

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
resource "azurerm_route_table" "route-client-dbcp" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-DBCP-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup-client.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-dbcp]

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
resource "azurerm_route_table" "route-client-mgt" {
  name                          = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-MGT-RT"
  location                      = var.azurelocation
  resource_group_name           = azurerm_resource_group.myterraformgroup-client.name
  disable_bgp_route_propagation = false
  depends_on = [azurerm_subnet.myterraformsubnet-client-mgt]

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
  subnet_id      = azurerm_subnet.myterraformsubnet-client-web.id
  route_table_id = azurerm_route_table.route-client-web.id
  depends_on = [azurerm_route_table.route-client-web]
}
resource "azurerm_subnet_route_table_association" "route_table_association_storage" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-storage.id
  route_table_id = azurerm_route_table.route-client-storage.id
  depends_on = [azurerm_route_table.route-client-storage]
}

resource "azurerm_subnet_route_table_association" "route_table_association_dbcp" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-dbcp.id
  route_table_id = azurerm_route_table.route-client-dbcp.id
  depends_on = [azurerm_route_table.route-client-dbcp]
}

resource "azurerm_subnet_route_table_association" "route_table_association_mgt" {
  subnet_id      = azurerm_subnet.myterraformsubnet-client-mgt.id
  route_table_id = azurerm_route_table.route-client-mgt.id
  depends_on = [azurerm_route_table.route-client-mgt]
}
