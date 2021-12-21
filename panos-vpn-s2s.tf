# Tunnel to OV-PA

# Phase 1 IKE
resource "panos_ike_gateway" "ov_pa_ike" {
  name                   = "P1-VPN-${var.environment}-${var.region}-TO-OV-PA"
  peer_ip_type           = "ip"
  peer_ip_value          = var.ov_pa_pub
  version                = "ikev2"
  interface              = "ethernet1/1"
  local_ip_address_type  = "ip"
  local_ip_address_value = azurerm_public_ip.myterraformpublicipuntrust.ip_address
  pre_shared_key         = var.ov_pa_psk
  local_id_type          = "ipaddr"
  local_id_value         = azurerm_public_ip.myterraformpublicipuntrust.ip_address
  peer_id_type           = "ipaddr"
  peer_id_value          = var.ov_pa_pub
  ikev2_crypto_profile   = panos_ike_crypto_profile.default.name
  enable_nat_traversal   = true
}

# Phase 2 IPSEC
resource "panos_ipsec_tunnel" "ov_pa_ipsec" {
  name = "P2-VPN-${var.environment}-${var.region}-TO-OV-PA"
  tunnel_interface = panos_tunnel_interface.ov_pa.name
  anti_replay = true
  ak_ike_gateway = panos_ike_gateway.ov_pa_ike.name
  ak_ipsec_crypto_profile = panos_ipsec_crypto_profile.default.name
  tunnel_monitor_proxy_id = panos_ipsec_tunnel_proxy_id_ipv4.ov_pa_proxy_id.name
}

# Proxy ID IPSec
resource "panos_ipsec_tunnel_proxy_id_ipv4" "ov_pa_proxy_id" {
  ipsec_tunnel = panos_ipsec_tunnel.ov_pa_ipsec.name
  name = "PROXY-ID-OV-PA"
  local = "${var.IPAddressPrefix}.0.0/16"
  remote = "10.2.0.0/16"
  protocol_any = true
}