#Tags
resource "panos_administrative_tag" "tag_vpn_clients" {
  name = "VPN-CLIENT"
  vsys = "vsys1"
  color = "color5"
  comment = ""
}

resource "panos_administrative_tag" "internet" {
  name = "INTERNET"
  vsys = "vsys1"
  color = "color6"
  comment = ""
}

resource "panos_administrative_tag" "vpn-s2s" {
  name = "VPN-S2S"
  vsys = "vsys1"
  color = "color31"
  comment = ""
}

resource "panos_administrative_tag" "aks_web" {
  name = "AKS-WEB"
  vsys = "vsys1"
  color = "color27"
  comment = ""
}

resource "panos_administrative_tag" "aks_dbcp" {
  name = "AKS-DBCP"
  vsys = "vsys1"
  color = "color28"
  comment = ""
}

resource "panos_administrative_tag" "rets_dbcp" {
  name = "RETS-DBCP"
  vsys = "vsys1"
  color = "color29"
  comment = ""
}

resource "panos_administrative_tag" "prod" {
  name = "PROD"
  vsys = "vsys1"
  color = "color11"
  comment = ""
}
resource "panos_administrative_tag" "preprod" {
  name = "PREPROD"
  vsys = "vsys1"
  color = "color12"
  comment = ""
}

resource "panos_administrative_tag" "aks" {
  name = "AKS"
  vsys = "vsys1"
  color = "color25"
  comment = ""
}

resource "panos_administrative_tag" "panorama" {
  name = "PANORAMA"
  vsys = "vsys1"
  color = "color15"
  comment = ""
}

resource "panos_administrative_tag" "vault" {
  name = "VAULT"
  vsys = "vsys1"
  color = "color20"
  comment = ""
}

resource "panos_administrative_tag" "tunnel_pub_ips" {
  name = "TUNNEL"
  vsys = "vsys1"
  color = "color21"
  comment = ""
}

resource "panos_administrative_tag" "pdq" {
  name = "PDQ"
  vsys = "vsys1"
  color = "color22"
  comment = ""
}

# Address Objects
resource "panos_address_object" "vault" {
  name        = "LOCAL_${var.enterprise}-ZI-HASH-VA1_10.57.31.12"
  value       = "10.57.31.12"
  description = "It's the IP of the Hashicorp Vault"
  tags = [panos_administrative_tag.vault.name]
}

resource "panos_address_object" "ov_pa_pub" {
  name        = "LOCAL_${var.enterprise}-OV-PA-PUB-IP_54.36.29.130"
  value       = "54.36.29.130"
  description = "It's the Pub IP of OV-PA used for VPN-S2S"
  tags = [panos_administrative_tag.tunnel_pub_ips.name]
}

resource "panos_address_object" "zi_cfr_pub" {
  name        = "LOCAL_${var.enterprise}-ZI-CFR-PUB-IP_40.89.155.125"
  value       = "40.89.155.125"
  description = "It's the Pub IP of ZI-CFR used for VPN-S2S"
  tags = [panos_administrative_tag.tunnel_pub_ips.name]
}

resource "panos_address_object" "domain_controller" {
  name        = "LOCAL_DANDORAN_10.2.3.1"
  value       = "10.2.3.1"
  description = "It's a Domain Controller located in OV-PA"
}

resource "panos_address_object" "fs1" {
  name        = "LOCAL_SH-OV-SHFT-FS1_10.2.3.10"
  value       = "10.2.3.10"
  description = "It's a file server in OV-PA"
}

resource "panos_address_object" "pdq" {
  name        = "LOCAL_SH-OV-SHFT-PDQ1"
  value       = "10.2.3.180"
  description = "It's PDQ bruh."
  tags = [panos_administrative_tag.pdq.name]
}

resource "panos_address_object" "panorama" {
  name        = "LOCAL_PANORAMA_10.2.2.1"
  value       = "10.2.2.1"
  description = "It's the Panorama Address"
}

resource "panos_address_object" "dba-mgmt" {
  name        = "LOCAL_SH-OV-DBA-MGMT1_10.2.251.1"
  value       = "10.2.251.1"
  description = "It's DBA Management Server"
}

resource "panos_address_object" "rets-db1" {
  name        = "LOCAL_SH-AZ-RETS-DB1_${var.IPAddressPrefix}.8.68"
  value       = "${var.IPAddressPrefix}.8.68"
  description = "It's a Database for Test named RETS-DB1"
  tags = [panos_administrative_tag.rets_dbcp.name]
}

resource "panos_address_object" "local_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-IP-RANGE_${var.IPAddressPrefix}.0.0-16"
  value       = "${var.IPAddressPrefix}.0.0/16"
  description = ""
}

resource "panos_address_object" "local_pub_ip" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-${var.pafw}1-PUB-IP_${var.IPAddressPrefix}.1.254"
  value       = "${var.IPAddressPrefix}.1.254"
  description = ""
}

resource "panos_address_object" "ov_pa_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-IP-RANGE_10.2.0.0-16"
  value       = "10.2.0.0/16"
  description = ""
}

resource "panos_address_object" "zi_cfr_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-IP-RANGE_10.57.0.0-16"
  value       = "10.57.0.0/16"
  description = ""
}

resource "panos_address_object" "ov_pa_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-PARIS-IP-RANGE_10.2.4.0-24"
  value       = "10.2.4.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
}

resource "panos_address_object" "az_eus_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-US-IP-RANGE_10.32.6.0-24"
  value       = "10.32.6.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
}

resource "panos_address_object" "az_sg_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-SG-IP-RANGE_10.28.6.0-24"
  value       = "10.28.6.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
}

resource "panos_address_object" "az_wjp_vpn_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-CLIENT-VPN-WJP-IP-RANGE_10.39.6.0-24"
  value       = "10.39.6.0/24"
  description = ""
  tags = [panos_administrative_tag.tag_vpn_clients.name]
}

resource "panos_address_object" "local_range_aks_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-IP-RANGE_${var.AKSIPAddressPrefix}.0.0-16"
  value       = "${var.AKSIPAddressPrefix}.0.0/16"
  description = ""
}

resource "panos_address_object" "local_range_aks_web_preprod" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-PREPROD-IP-RANGE_${var.AKSIPAddressPrefix}.0.0-20"
  value       = "${var.AKSIPAddressPrefix}.0.0/20"
  description = ""
  tags = [panos_administrative_tag.aks.name,panos_administrative_tag.aks_web.name,panos_administrative_tag.preprod.name]
}

resource "panos_address_object" "local_range_aks_dbcp_preprod" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-DBCP-PREPROD-IP-RANGE_${var.AKSIPAddressPrefix}.16.0-20"
  value       = "${var.AKSIPAddressPrefix}.16.0/20"
  description = ""
  tags = [panos_administrative_tag.aks.name,panos_administrative_tag.aks_dbcp.name,panos_administrative_tag.preprod.name]
}

resource "panos_address_object" "local_range_aks_web_prod" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-PROD-IP-RANGE_${var.AKSIPAddressPrefix}.32.0-20"
  value       = "${var.AKSIPAddressPrefix}.32.0/20"
  description = ""
  tags = [panos_administrative_tag.aks.name,panos_administrative_tag.aks_web.name,panos_administrative_tag.prod.name]
}

resource "panos_address_object" "local_range_aks_dbcp_prod" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-DBCP-PROD-IP-RANGE_${var.AKSIPAddressPrefix}.64.0-20"
  value       = "${var.AKSIPAddressPrefix}.64.0/20"
  description = ""
  tags = [panos_administrative_tag.aks.name,panos_administrative_tag.aks_dbcp.name,panos_administrative_tag.prod.name]
}

resource "panos_address_object" "local_nginx_poc_pub" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-POC-PUB-IP_${data.azurerm_network_interface.panos_pub_nginx.private_ip_addresses[1]}"
  value       = "${data.azurerm_network_interface.panos_pub_nginx.private_ip_addresses[1]}"
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
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-NGINX-LB-PRIV-IP_${var.AKSIPAddressPrefix}.2.1"
  value       = "${var.AKSIPAddressPrefix}.2.1"
  description = ""
}

# Address Groups
resource "panos_address_group" "local_vpn_client" {
  name = "LOCAL_GRP-ALL-VPN-CLIENT"
  dynamic_match = "'VPN-CLIENT'"
  description = "All VPN Client IP Ranges"
}

resource "panos_address_group" "local_vault" {
  name = "LOCAL_GRP-HASH-VA"
  dynamic_match = "'VAULT'"
  description = "All Hashicorp Vault Group"
}

resource "panos_address_group" "local_all_aks" {
  name = "LOCAL_GRP-ALL-AKS"
  dynamic_match = "'AKS'"
  description = "All AKS Of this Datacenter"
}

resource "panos_address_group" "tunnel" {
  name = "LOCAL_GRP-ALL-TUNNEL-PUB-IP"
  dynamic_match = "'TUNNEL'"
  description = "All Public IP of Different datacenter for tunnel vpn-s2s"
}

resource "panos_address_group" "local_aks_web_preprod" {
  name = "LOCAL_GRP-AKS-WEB-PREPROD"
  dynamic_match = "'AKS-WEB' and 'PREPROD'"
  description = "All AKS WEB PREPROD"
}

resource "panos_address_group" "local_aks_dbcp_preprod" {
  name = "LOCAL_GRP-AKS-DBCP-PREPROD"
  dynamic_match = "'AKS-DBCP' and 'PREPROD'"
  description = "All AKS DBCP PREPROD"
}

resource "panos_address_group" "local_aks_web_prod" {
  name = "LOCAL_GRP-AKS-WEB-PROD"
  dynamic_match = "'AKS-WEB' and 'PROD'"
  description = "All AKS WEB PROD"
}

resource "panos_address_group" "local_aks_dbcp_prod" {
  name = "LOCAL_GRP-AKS-DBCP-PROD"
  dynamic_match = "'AKS-DBCP' and 'PROD'"
  description = "All AKS DBCP PROD"
}

resource "panos_address_group" "local_rets_dbcp" {
  name = "LOCAL_GRP-RETS-DBCP"
  dynamic_match = "'RETS-DBCP'"
  description = "All RETS DBCP Machines"
}

resource "panos_address_group" "local_pdq" {
  name = "LOCAL_GRP-ALL-PDQ"
  dynamic_match = "'PDQ'"
  description = "All PDQ Servers"
}