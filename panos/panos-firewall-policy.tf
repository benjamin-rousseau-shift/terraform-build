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
      source_addresses = [panos_address_object.local_range.name,panos_address_object.local_range_aks_web.name]
      destination_addresses = ["any"]
    }
    translated_packet {
      source {
        dynamic_ip_and_port {
          interface_address {
            interface = panos_ethernet_interface.eth1.name
            ip_address = panos_ethernet_interface.eth1.static_ips[0]
          }
        }
      }
      destination {}
    }
  }

  rule {
    name = "NAT TO NGINX HTTP"
    original_packet {
      source_zones          = [panos_zone.untrust.name]
      destination_zone      = panos_zone.untrust.name
      destination_interface = panos_ethernet_interface.eth1.name
      source_addresses = ["any"]
      destination_addresses = [data.azurerm_network_interface.panos_pub_nginx.private_ip_addresses[1]]
      service = "service-http"
    }
    translated_packet {
      source {
      }
      destination {
        static_translation {
          address = panos_address_object.local_aks_web_nginx.value
          port = "80"
        }
      }
    }
  }

  rule {
    name = "NAT TO NGINX HTTPS"
    original_packet {
      source_zones          = [panos_zone.untrust.name]
      destination_zone      = panos_zone.untrust.name
      destination_interface = panos_ethernet_interface.eth1.name
      source_addresses = ["any"]
      destination_addresses = [data.azurerm_network_interface.panos_pub_nginx.private_ip_addresses[1]]
      service = "service-https"
    }
    translated_packet {
      source {
      }
      destination {
        static_translation {
          address = panos_address_object.local_aks_web_nginx.value
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
    source_addresses      = [panos_address_object.panorama.name, panos_address_object.local_mgmt.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.internal.name, panos_zone.vpn_s2s.name]
    destination_addresses = [panos_address_object.panorama.name, panos_address_object.local_mgmt.name]
    applications          = ["paloalto-updates", "paloalto-userid-agent", "panorama", "ssl"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "PERMIT DNS TO DOMAIN CONTROLLER LOCAL"
    source_zones          = [panos_zone.internal.name,panos_zone.web.name]
    source_addresses      = [panos_address_object.local_mgmt.name,panos_address_object.local_range_aks_web.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.vpn_s2s.name]
    destination_addresses = [panos_address_object.domain_controller.name]
    applications          = ["dns"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "PERMIT AKS RANGE TO AZURE"
    source_zones          = [panos_zone.web.name]
    source_addresses      = [panos_address_object.local_range_aks_web.name]
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
    source_addresses      = [panos_address_object.ov_pa_pub.name, panos_address_object.local_pub_ip.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.untrust.name]
    destination_addresses = [panos_address_object.ov_pa_pub.name, panos_address_object.local_pub_ip.name]
    applications          = ["ipsec"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "PERMIT INTERNET TO NGINX POC"
    source_zones          = [panos_zone.untrust.name]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.web.name]
    destination_addresses = [panos_address_object.local_nginx_poc_pub.name]
    applications          = ["web-browsing"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    name                  = "PERMIT VPN-CLIENT USER ACCESS TO NGINX"
    source_zones          = [panos_zone.vpn_s2s.name]
    source_addresses      = [panos_address_group.local_vpn_client.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.web.name]
    destination_addresses = [panos_address_object.local_range_aks_web.name]
    applications          = ["web-browsing","ssl"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
}