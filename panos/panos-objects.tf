# Address Objects
resource "panos_address_object" "local_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-IP-RANGE_${var.IPAddressPrefix}.0.0"
  value       = "${var.IPAddressPrefix}.0.0/16"
  description = ""
}

resource "panos_address_object" "local_range_aks_web" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-IP-RANGE_${var.AKSIPAddressPrefix}.0.0"
  value       = "${var.AKSIPAddressPrefix}.0.0/18"
  description = ""
}

resource "panos_address_object" "local_mgmt" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-${var.pafw}1_${var.IPAddressPrefix}.5.254"
  value       = "${var.IPAddressPrefix}.5.254"
  description = ""
}

resource "panos_address_object" "local_nginx" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-${var.pafw}1_${data.azurerm_network_interface.panos_pub_nginx.private_ip_address}"
  value       = data.azurerm_network_interface.panos_pub_nginx.private_ip_address
  description = ""
}