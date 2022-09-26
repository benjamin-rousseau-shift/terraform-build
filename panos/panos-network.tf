# Ethernet Interfaces
resource "panos_ethernet_interface" "eth1" {
  name       = "ethernet1/1"
  vsys       = "vsys1"
  mode       = "layer3"
  static_ips = ["${var.IPAddressPrefix}.1.254/24"]
  comment    = "UNTRUST Interface"
}
resource "panos_ethernet_interface" "eth2" {
  name               = "ethernet1/2"
  vsys               = "vsys1"
  mode               = "layer3"
  static_ips         = ["${var.IPAddressPrefix}.2.254/24"]
  comment            = "WEB Interface"
  management_profile = panos_management_profile.ping.name
}
resource "panos_ethernet_interface" "eth3" {
  name               = "ethernet1/3"
  vsys               = "vsys1"
  mode               = "layer3"
  static_ips         = ["${var.IPAddressPrefix}.3.254/24"]
  comment            = "STORAGE Interface"
  management_profile = panos_management_profile.ping.name
}
resource "panos_ethernet_interface" "eth4" {
  name               = "ethernet1/4"
  vsys               = "vsys1"
  mode               = "layer3"
  static_ips         = ["${var.IPAddressPrefix}.4.254/24"]
  comment            = "DBCP Interface"
  management_profile = panos_management_profile.ping.name
}
resource "panos_ethernet_interface" "eth5" {
  name               = "ethernet1/5"
  vsys               = "vsys1"
  mode               = "layer3"
  static_ips         = ["${var.IPAddressPrefix}.5.254/24"]
  comment            = "INTERNAL-SRV Interface"
  management_profile = panos_management_profile.default.name
}
resource "panos_ethernet_interface" "eth6" {
  name               = "ethernet1/6"
  vsys               = "vsys1"
  mode               = "layer3"
  static_ips         = ["${var.IPAddressPrefix}.7.254/24"]
  comment            = "MGT Interface"
  management_profile = panos_management_profile.ping.name
}

# IKE Crypto Profile
resource "panos_ike_crypto_profile" "default" {
  name                    = "AES-128-SHA256-G2-86400"
  dh_groups               = ["group2"]
  authentications         = ["sha256"]
  encryptions             = ["aes-128-cbc"]
  lifetime_value          = 24
  authentication_multiple = 0
}

#IPSec Crypto Profile
resource "panos_ipsec_crypto_profile" "default" {
  name            = "AES-128-SHA256-G2-LT-28800"
  authentications = ["sha256"]
  encryptions     = ["aes-128-cbc"]
  dh_group        = "group2"
  lifetime_type   = "hours"
  lifetime_value  = 8
  protocol        = "esp"
}

# Virtual Router
resource "panos_virtual_router" "default" {
  name        = "default"
  static_dist = 10
  interfaces  = [
    panos_ethernet_interface.eth1.name,
    panos_ethernet_interface.eth2.name,
    panos_ethernet_interface.eth3.name,
    panos_ethernet_interface.eth4.name,
    panos_ethernet_interface.eth5.name,
    panos_ethernet_interface.eth6.name,
    panos_tunnel_interface.ov_pa.name,
    panos_tunnel_interface.zi_cfr.name
  ]
}

#Management Interface
resource "panos_management_profile" "default" {
  name           = "Remote Management"
  ping           = true
  https          = true
  ssh            = true
  snmp           = true
  userid_service = true
  permitted_ips  = [
    panos_address_object.panorama.value, "10.2.4.0/24", "10.28.6.0/24", "10.2.3.105/32", "10.2.3.180/32", "10.57.26.5/32", "10.57.26.6/32",
    "10.2.184.5/32", "10.57.5.30/32"
  ]
}
resource "panos_management_profile" "ping" {
  name          = "Allow Ping"
  ping          = true
  permitted_ips = [
    "10.57.5.30/32"
  ]
}

# Static Route
resource "panos_static_route_ipv4" "default" {
  name           = "DEFAULT-ROUTE"
  virtual_router = panos_virtual_router.default.name
  destination    = "0.0.0.0/0"
  type           = "ip-address"
  next_hop       = "${var.IPAddressPrefix}.1.1"
}



resource "panos_static_route_ipv4" "ov_pa" {
  name           = "ROUTE-TO-OV-PA"
  virtual_router = panos_virtual_router.default.name
  destination    = panos_address_object.ov_pa_range.value
  interface      = panos_tunnel_interface.ov_pa.name
  type           = ""
}

resource "panos_static_route_ipv4" "zi_cfr" {
  name           = "ROUTE-TO-ZI-CFR"
  virtual_router = panos_virtual_router.default.name
  destination    = panos_address_object.zi_cfr_range.value
  interface      = panos_tunnel_interface.zi_cfr.name
  type           = ""
  depends_on = [panos_tunnel_interface.zi_cfr]
}


resource "panos_static_route_ipv4" "aks_web_preprod" {
  name           = "ROUTE-TO-AKS-WEB-PREPROD"
  virtual_router = panos_virtual_router.default.name
  destination    = panos_address_object.local_range_aks_web_preprod.value
  interface      = panos_ethernet_interface.eth2.name
  type           = "ip-address"
  next_hop       = "${var.IPAddressPrefix}.2.1"
}

resource "panos_static_route_ipv4" "aks_dbcp_preprod" {
  name           = "ROUTE-TO-AKS-DBCP-PREPROD"
  virtual_router = panos_virtual_router.default.name
  destination    = panos_address_object.local_range_aks_dbcp_preprod.value
  interface      = panos_ethernet_interface.eth4.name
  type           = "ip-address"
  next_hop       = "${var.IPAddressPrefix}.4.1"
}

resource "panos_static_route_ipv4" "aks_web_prod" {
  name           = "ROUTE-TO-AKS-WEB-PROD"
  virtual_router = panos_virtual_router.default.name
  destination    = panos_address_object.local_range_aks_web_prod.value
  interface      = panos_ethernet_interface.eth2.name
  type           = "ip-address"
  next_hop       = "${var.IPAddressPrefix}.2.1"
}

resource "panos_static_route_ipv4" "aks_dbcp_prod" {
  name           = "ROUTE-TO-AKS-DBCP-PROD"
  virtual_router = panos_virtual_router.default.name
  destination    = panos_address_object.local_range_aks_dbcp_prod.value
  interface      = panos_ethernet_interface.eth4.name
  type           = "ip-address"
  next_hop       = "${var.IPAddressPrefix}.4.1"
}

resource "panos_static_route_ipv4" "intl" {
  name           = "ROUTE-TO-INTL"
  virtual_router = panos_virtual_router.default.name
  destination    = "10.99.248.0/24"
  interface      = panos_ethernet_interface.eth5.name
  type           = "ip-address"
  next_hop       = "${var.IPAddressPrefix}.5.1"
}

resource "panos_static_route_ipv4" "rets_dbcp" {
  name           = "ROUTE-TO-RETS-DBCP"
  virtual_router = panos_virtual_router.default.name
  destination    = "10.99.8.64/26"
  interface      = panos_ethernet_interface.eth4.name
  type           = "ip-address"
  next_hop       = "${var.IPAddressPrefix}.4.1"
}

# Tunnel Interface
resource "panos_tunnel_interface" "ov_pa" {
  name    = "tunnel.1"
  comment = "TUNNEL OV-PA"
}

resource "panos_tunnel_interface" "zi_cfr" {
  name    = "tunnel.2"
  comment = "TUNNEL ZI-CFR"
}


# Zones
resource "panos_zone" "dbcp" {
  name           = "ZONE-DBCP-SRV"
  mode           = "layer3"
  interfaces     = [
    panos_ethernet_interface.eth4.name
  ]
  enable_user_id = true
}
resource "panos_zone" "internal" {
  name           = "ZONE-INTERNAL-SRV"
  mode           = "layer3"
  interfaces     = [
    panos_ethernet_interface.eth5.name
  ]
  enable_user_id = true
}
resource "panos_zone" "mgmt" {
  name           = "ZONE-MGMT"
  mode           = "layer3"
  interfaces     = []
  enable_user_id = true
}
resource "panos_zone" "mgt" {
  name           = "ZONE-MGT"
  mode           = "layer3"
  interfaces     = [
    panos_ethernet_interface.eth6.name
  ]
  enable_user_id = true
}
resource "panos_zone" "security" {
  name           = "ZONE-SECURITY-SRV"
  mode           = "layer3"
  interfaces     = []
  enable_user_id = true
}
resource "panos_zone" "storage" {
  name           = "ZONE-STORAGE-SRV"
  mode           = "layer3"
  interfaces     = [
    panos_ethernet_interface.eth3.name
  ]
  enable_user_id = true
}
resource "panos_zone" "untrust" {
  name           = "ZONE-UNTRUST"
  mode           = "layer3"
  interfaces     = [
    panos_ethernet_interface.eth1.name
  ]
  enable_user_id = false
  #zone_profile   = panos_dos_protection_profile.default.name
}

resource "panos_zone" "vpn_s2s" {
  name           = "ZONE-VPN-S2S"
  mode           = "layer3"
  interfaces     = [
    panos_tunnel_interface.ov_pa.name,
    panos_tunnel_interface.zi_cfr.name
  ]
  enable_user_id = true
}

resource "panos_zone" "web" {
  name           = "ZONE-WEB-SRV"
  mode           = "layer3"
  interfaces     = [
    panos_ethernet_interface.eth2.name
  ]
  enable_user_id = true
}

