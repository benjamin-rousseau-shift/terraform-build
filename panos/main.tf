# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    panos   = {
      source  = "paloaltonetworks/panos"
      version = "1.8.3"
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
# Gather Palo Alto Public IP from Azure

data azurerm_public_ip "panos_pub_mgmt" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-${lower(var.pafw)}1-pub-ip-mgmt"
  resource_group_name = "${var.enterprise}-${var.environment}-${var.region}-${var.pafw}-RG"
}

data azurerm_public_ip "panos_pub_untrust" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-${lower(var.pafw)}1-pub-ip-untrust"
  resource_group_name = "${var.enterprise}-${var.environment}-${var.region}-${var.pafw}-RG"
}

data azurerm_network_interface "panos_pub_nginx" {
  name                = "${lower(var.enterprise)}-${lower(var.environment)}-${lower(var.region)}-${lower(var.pafw)}1-eth1"
  resource_group_name = "${var.enterprise}-${var.environment}-${var.region}-${var.pafw}-RG"
}

provider "panos" {
  hostname = data.azurerm_public_ip.panos_pub_mgmt.ip_address
  username = "windu"
  password = var.admin_panos
}