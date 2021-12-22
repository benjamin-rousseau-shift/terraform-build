# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    panos = {
      source = "paloaltonetworks/panos"
      version = "1.8.3"
    }
  }
}

provider "panos" {
  hostname = var.panos_pub_mgmt
  username = "windu"
  password = var.admin_panos
}