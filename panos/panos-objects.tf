#Tags
resource "panos_administrative_tag" "tag_vpn_clients" {
  name = "VPN-CLIENT"
  vsys = "vsys2"
  color = "color5"
  comment = ""
}

# Address Objects
resource "panos_address_object" "ov_pa_pub" {
  name        = "LOCAL_${var.enterprise}-OV-PA-PUB-IP_54.36.29.130"
  value       = "54.36.29.130"
  description = "It's the Pub IP of OV_PA used for VPN-S2S"
}

resource "panos_address_object" "domain_controller" {
  name        = "LOCAL_DANDORAN_10.2.3.1"
  value       = "10.2.3.1"
  description = "It's a Domain Controller located in OV_PA"
}

resource "panos_address_object" "panorama" {
  name        = "LOCAL_PANORAMA_10.2.2.1"
  value       = "10.2.2.1"
  description = "It's the Panorama Address"
}

resource "panos_address_object" "local_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-IP-RANGE_${var.IPAddressPrefix}.0.0"
  value       = "${var.IPAddressPrefix}.0.0/16"
  description = ""
}

resource "panos_address_object" "ov_pa_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-IP-RANGE_10.2.0.0"
  value       = "10.2.0.0/16"
  description = ""
}

resource "panos_address_object" "ov_pa_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-PARIS-IP-RANGE_10.2.4.0"
  value       = "10.2.4.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
}

resource "panos_address_object" "az_eus_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-US-IP-RANGE_10.32.6.0"
  value       = "10.32.6.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
}

resource "panos_address_object" "az_sg_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-SG-IP-RANGE_10.28.6.0"
  value       = "10.28.6.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
}

resource "panos_address_object" "az_wjp_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-SG-IP-RANGE_10.39.6.0"
  value       = "10.39.6.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
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
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-NGINX-LB-PUB-IP_${data.azurerm_network_interface.panos_pub_nginx.private_ip_address}"
  value       = data.azurerm_network_interface.panos_pub_nginx.private_ip_address
  description = ""
}

resource "panos_address_object" "local_aks_web_nginx" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-NGINX-LB-PRIV-IP_${var.AKSIPAddressPrefix}.1.81"
  value       = "${var.AKSIPAddressPrefix}.1.81"
  description = ""
}

# Address Groups
resource "panos_address_group" "local_vpn_client" {
  name = "LOCAL_ALL-VPN-CLIENT"
  dynamic_match = "'VPN-CLIENT'"
  description = "All VPN Client IP Ranges"
}