# Tunnel to OV-PA

# Phase 1 IKE
resource "panos_ike_gateway" "ov_pa_ike" {
  name                   = "P1-VPN-${var.environment}-${var.region}-TO-OV-PA"
  peer_ip_type           = "ip"
  peer_ip_value          = panos_address_object.ov_pa_pub.value
  version                = "ikev2"
  interface              = panos_ethernet_interface.eth1.name
  local_ip_address_type  = "ip"
  local_ip_address_value = panos_ethernet_interface.eth1.static_ips[0]
  pre_shared_key         = var.ov_pa_psk
  local_id_type          = "ipaddr"
  local_id_value         = data.azurerm_public_ip.panos_pub_untrust.ip_address
  peer_id_type           = "ipaddr"
  peer_id_value          = panos_address_object.ov_pa_pub.value
  ikev2_crypto_profile   = panos_ike_crypto_profile.default.name
  enable_nat_traversal   = true
  nat_traversal_keep_alive = 10
}

# Phase 2 IPSEC
resource "panos_ipsec_tunnel" "ov_pa_ipsec" {
  name = "P2-VPN-${var.environment}-${var.region}-TO-OV-PA"
  tunnel_interface = panos_tunnel_interface.ov_pa.name
  anti_replay = true
  ak_ike_gateway = panos_ike_gateway.ov_pa_ike.name
  ak_ipsec_crypto_profile = panos_ipsec_crypto_profile.default.name
}

# Proxy ID IPSec
resource "panos_ipsec_tunnel_proxy_id_ipv4" "ov_pa_proxy_id" {
  ipsec_tunnel = panos_ipsec_tunnel.ov_pa_ipsec.name
  name = "PROXY-ID-OV-PA"
  local = panos_address_object.local_range.value
  remote = panos_address_object.ov_pa_range.value
  protocol_any = true
}

# Proxy ID IPSec AKS
resource "panos_ipsec_tunnel_proxy_id_ipv4" "ov_pa_proxy_id_aks_web" {
  ipsec_tunnel = panos_ipsec_tunnel.ov_pa_ipsec.name
  name = "PROXY-ID-OV-PA-AKS-WEB"
  local = panos_address_object.local_range_aks_range.value
  remote = panos_address_object.ov_pa_range.value
  protocol_any = true
}

# Tunnel to ZI-CFR

# Phase 1 IKE
resource "panos_ike_gateway" "zi_cfr_ike" {
  name                   = "P1-VPN-${var.environment}-${var.region}-TO-ZI-CFR"
  peer_ip_type           = "ip"
  peer_ip_value          = panos_address_object.zi_cfr_pub.value
  version                = "ikev2"
  interface              = panos_ethernet_interface.eth1.name
  local_ip_address_type  = "ip"
  local_ip_address_value = panos_ethernet_interface.eth1.static_ips[0]
  pre_shared_key         = var.zi_cfr_psk
  local_id_type          = "ipaddr"
  local_id_value         = data.azurerm_public_ip.panos_pub_untrust.ip_address
  peer_id_type           = "ipaddr"
  peer_id_value          = panos_address_object.zi_cfr_pub.value
  ikev2_crypto_profile   = panos_ike_crypto_profile.default.name
  enable_nat_traversal   = true
  nat_traversal_keep_alive = 10
}

# Phase 2 IPSEC
resource "panos_ipsec_tunnel" "zi_cfr_ipsec" {
  name = "P2-VPN-${var.environment}-${var.region}-TO-ZI-CFR"
  tunnel_interface = panos_tunnel_interface.zi_cfr.name
  anti_replay = true
  ak_ike_gateway = panos_ike_gateway.zi_cfr_ike.name
  ak_ipsec_crypto_profile = panos_ipsec_crypto_profile.default.name
}

# Proxy ID IPSec
resource "panos_ipsec_tunnel_proxy_id_ipv4" "zi_cfr_proxy_id" {
  ipsec_tunnel = panos_ipsec_tunnel.zi_cfr_ipsec.name
  name = "PROXY-ID-ZI-CFR"
  local = panos_address_object.local_range.value
  remote = panos_address_object.zi_cfr_range.value
  protocol_any = true
}

# Proxy ID IPSec
resource "panos_ipsec_tunnel_proxy_id_ipv4" "zi_cfr_proxy_id_aks_web" {
  ipsec_tunnel = panos_ipsec_tunnel.zi_cfr_ipsec.name
  name = "PROXY-ID-ZI-CFR-AKS-WEB"
  local = panos_address_object.local_range_aks_range.value
  remote = panos_address_object.zi_cfr_range.value
  protocol_any = true
}