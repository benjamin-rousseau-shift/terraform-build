# NAT Rules
resource "panos_nat_rule" "example" {
  name                  = "NAT INTERNET ACCESS"
  source_zones          = [
    panos_zone.dbcp.name, panos_zone.internal.name, panos_zone.mgt.name, panos_zone.storage.name, panos_zone.web.name
  ]
  destination_zone      = panos_zone.untrust.name
  to_interface          = panos_ethernet_interface.eth1.name
  source_addresses      = [panos_address_object.local_range.name]
  destination_addresses = ["any"]
  sat_type              = "dynamic-ip-and-port"
  sat_address_type      = "interface-address"
  sat_interface         = panos_ethernet_interface.eth1.name
  sat_ip_address        = "${var.IPAddressPrefix}.1.254/24"
  dat_type              = "none"
}

# SEC Rules
resource "panos_security_policy" "panorama" {
  rule {
    name                  = "PERMIT ACCESS TO PANORAMA LOCAL"
    source_zones          = [panos_zone.internal.name, panos_zone.vpn_s2s.name]
    source_addresses      = ["10.2.2.1", panos_address_object.local_mgmt.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.internal.name, panos_zone.vpn_s2s.name]
    destination_addresses = ["10.2.2.1", panos_address_object.local_mgmt.name]
    applications          = ["paloalto-updates", "paloalto-userid-agent", "panorama", "ssl"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }
}

resource "panos_security_policy" "vpn_s2s" {
  rule {
    name                  = "PERMIT VPN-S2S LOCAL"
    source_zones          = [panos_zone.untrust.name]
    source_addresses      = [var.ov_pa_pub, "${var.IPAddressPrefix}.1.254"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.untrust.name]
    destination_addresses = [var.ov_pa_pub, "${var.IPAddressPrefix}.1.254"]
    applications          = ["ipsec"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
}