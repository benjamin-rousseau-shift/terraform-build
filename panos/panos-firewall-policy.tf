# NAT Rules
resource "panos_nat_rule_group" "default" {
  rule {
    name = "NAT INTERNET ACCESS"
    original_packet {
      source_zones          = [
        panos_zone.dbcp.name, panos_zone.internal.name, panos_zone.mgt.name, panos_zone.storage.name, panos_zone.web.name
      ]
      destination_zone      = panos_zone.untrust.name
      destination_interface = panos_ethernet_interface.eth1.name
      source_addresses = [panos_address_object.local_range.name,panos_address_object.local_range_aks.name]
      destination_addresses = ["any"]
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = panos_ethernet_interface.eth1.name
            ip_address = "${var.IPAddressPrefix}.1.254/24"
          }
        }
      }
      destination {}
    }
  }

  rule {
    name = "NAT TO NGINX"
    original_packet {
      source_zones          = [panos_zone.untrust.name]
      destination_zone      = panos_zone.untrust.name
      destination_interface = panos_ethernet_interface.eth1.name
      source_addresses = ["any"]
      destination_addresses = [data.azurerm_network_interface.panos_pub_nginx.private_ip_addresses[1]]
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          translated_address {
            translated_addresses = [panos_address_object.local_nginx.name]
          }
        }
      }
      destination {
        static_translation {
          address = "20.40.141.174"
          port = "443"
        }
      }
    }
  }
}

# SEC Rules
resource "panos_security_policy_group" "default" {
  rule {
    name                  = "PERMIT ACCESS TO PANORAMA LOCAL"
    source_zones          = [panos_zone.internal.name, panos_zone.vpn_s2s.name]
    source_addresses      = [var.panorama, panos_address_object.local_mgmt.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.internal.name, panos_zone.vpn_s2s.name]
    destination_addresses = [var.panorama, panos_address_object.local_mgmt.name]
    applications          = ["paloalto-updates", "paloalto-userid-agent", "panorama", "ssl"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "PERMIT DNS TO DOMAIN CONTROLLER LOCAL"
    source_zones          = [panos_zone.internal.name,panos_zone.web.name]
    source_addresses      = [panos_address_object.local_mgmt.name,"${var.AKSIPAddressPrefix}.0.0/18"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.vpn_s2s.name]
    destination_addresses = [var.domain_controller]
    applications          = ["dns"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "PERMIT AKS RANGE TO AZURE"
    source_zones          = [panos_zone.web.name]
    source_addresses      = [panos_address_object.local_range_aks.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.untrust.name]
    destination_addresses = ["any"]
    applications          = ["any"]
    services              = ["service-https","tcp_9000"]
    categories            = ["any"]
    action                = "allow"
  }

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

  rule {
    name                  = "PERMIT INTERNET TO NGINX"
    source_zones          = [panos_zone.untrust.name]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.web.name]
    destination_addresses = [data.azurerm_network_interface.panos_pub_nginx.private_ip_addresses[1]]
    applications          = ["ssl"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
}