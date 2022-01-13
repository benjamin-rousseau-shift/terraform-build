# NAT Rules
resource "panos_nat_rule_group" "default" {
  rule {
    name = "NAT INTERNET ACCESS"
    tags = [panos_administrative_tag.internet.name]
    original_packet {
      source_zones          = [
        panos_zone.dbcp.name, panos_zone.internal.name, panos_zone.mgt.name, panos_zone.storage.name, panos_zone.web.name
      ]
      destination_zone      = panos_zone.untrust.name
      destination_interface = panos_ethernet_interface.eth1.name
      source_addresses = [panos_address_object.local_range.name,panos_address_group.local_all_aks.name]
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
    tags = [panos_administrative_tag.aks_web.name]
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
    tags = [panos_administrative_tag.aks_web.name]
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
    tags = [panos_administrative_tag.vpn-s2s.name,panos_administrative_tag.panorama.name]
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
    tags = [panos_administrative_tag.vpn-s2s.name]
    name                  = "PERMIT DNS TO DOMAIN CONTROLLER LOCAL"
    source_zones          = [panos_zone.internal.name,panos_zone.web.name,panos_zone.dbcp.name]
    source_addresses      = [panos_address_object.local_mgmt.name,panos_address_group.local_all_aks.name]
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
    tags = [panos_administrative_tag.internet.name]
    name                  = "PERMIT LOCAL MGMT TO INTERNET"
    source_zones          = [panos_zone.internal.name]
    source_addresses      = [panos_address_object.local_mgmt.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.untrust.name]
    destination_addresses = ["any"]
    applications          = ["ssl","pan-db-cloud","paloalto-updates"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.internet.name]
    name                  = "PERMIT AKS RANGE TO AZURE"
    source_zones          = [panos_zone.web.name,panos_zone.dbcp.name]
    source_addresses      = [panos_address_group.local_all_aks.name]
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
    tags = [panos_administrative_tag.vault.name]
    name                  = "PERMIT AKS RANGE TO HASH-VA"
    source_zones          = [panos_zone.web.name,panos_zone.dbcp.name]
    source_addresses      = [panos_address_group.local_all_aks.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.vpn_s2s.name]
    destination_addresses = [panos_address_group.local_vault.name]
    applications          = ["ssl"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.vpn-s2s.name]
    name                  = "PERMIT VPN-S2S LOCAL"
    source_zones          = [panos_zone.untrust.name]
    source_addresses      = [panos_address_group.tunnel.name, panos_address_object.local_pub_ip.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.untrust.name]
    destination_addresses = [panos_address_group.tunnel.name, panos_address_object.local_pub_ip.name]
    applications          = ["ipsec"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.internet.name,panos_administrative_tag.aks_web.name]
    name                  = "PERMIT INTERNET TO NGINX POC"
    source_zones          = [panos_zone.untrust.name]
    source_addresses      = ["any"]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.web.name]
    destination_addresses = [panos_address_object.local_nginx_poc_pub.name]
    applications          = ["web-browsing","ssl"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.vpn-s2s.name,panos_administrative_tag.aks.name]
    name                  = "PERMIT VPN-CLIENT USER ACCESS TO AKS"
    source_zones          = [panos_zone.vpn_s2s.name]
    source_addresses      = [panos_address_group.local_vpn_client.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.web.name]
    destination_addresses = [panos_address_group.local_all_aks.name]
    applications          = ["web-browsing","ssl"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.aks.name,panos_administrative_tag.preprod.name]
    name                  = "PERMIT AKS-PREPROD CROSS CLUSTER FLOW"
    source_zones          = [panos_zone.web.name,panos_zone.dbcp.name]
    source_addresses      = [panos_address_group.local_aks_web_preprod.name,panos_address_group.local_aks_dbcp_prod.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.web.name,panos_zone.dbcp.name]
    destination_addresses = [panos_address_group.local_aks_web_preprod.name,panos_address_group.local_aks_dbcp_prod.name]
    applications          = ["any"]
    services              = ["any"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.rets_dbcp.name,panos_administrative_tag.vpn-s2s.name]
    name                  = "PERMIT RETS-DBCP TO DOMAIN CONTROLLER"
    source_zones          = [panos_zone.dbcp.name]
    source_addresses      = [panos_address_group.local_rets_dbcp.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.vpn_s2s.name]
    destination_addresses = [panos_address_object.domain_controller.name]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.rets_dbcp.name,panos_administrative_tag.vpn-s2s.name]
    name                  = "PERMIT ADM TO RETS-DBCP"
    source_zones          = [panos_zone.vpn_s2s.name]
    source_addresses      = [panos_address_group.local_vpn_client.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.dbcp.name]
    destination_addresses = [panos_address_group.local_rets_dbcp.name]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.rets_dbcp.name,panos_administrative_tag.pdq.name]
    name                  = "PERMIT PDQ TO RETS-DBCP"
    source_zones          = [panos_zone.vpn_s2s.name]
    source_addresses      = [panos_address_group.local_pdq.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.dbcp.name]
    destination_addresses = [panos_address_group.local_rets_dbcp.name]
    applications          = ["any"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.rets_dbcp.name,panos_administrative_tag.vpn-s2s.name]
    name                  = "PERMIT DBA-MGMT1 TO RETS-DBCP"
    source_zones          = [panos_zone.vpn_s2s.name]
    source_addresses      = [panos_address_object.dba-mgmt.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.dbcp.name]
    destination_addresses = [panos_address_group.local_rets_dbcp.name]
    applications          = ["mssql-db","mssql-mon"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.rets_dbcp.name,panos_administrative_tag.vault.name]
    name                  = "PERMIT HASH-VA RETS-DBCP"
    source_zones          = [panos_zone.vpn_s2s.name]
    source_addresses      = [panos_address_group.local_vault.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.dbcp.name]
    destination_addresses = [panos_address_group.local_rets_dbcp.name]
    applications          = ["mssql-db","mssql-mon"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.rets_dbcp.name,panos_administrative_tag.pdq.name]
    name                  = "PERMIT RETS-DBCP TO PDQ"
    source_zones          = [panos_zone.dbcp.name]
    source_addresses      = [panos_address_group.local_rets_dbcp.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.vpn_s2s.name]
    destination_addresses = [panos_address_group.local_pdq.name]
    applications          = ["ms-ds-smb"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }

  rule {
    tags = [panos_administrative_tag.rets_dbcp.name,panos_administrative_tag.vpn-s2s.name]
    name                  = "PERMIT RETS-DBCP TO FS1"
    source_zones          = [panos_zone.dbcp.name]
    source_addresses      = [panos_address_group.local_rets_dbcp.name]
    source_users          = ["any"]
    hip_profiles          = ["any"]
    destination_zones     = [panos_zone.vpn_s2s.name]
    destination_addresses = [panos_address_object.fs1.name]
    applications          = ["ms-ds-smb"]
    services              = ["application-default"]
    categories            = ["any"]
    action                = "allow"
  }
}