resource "panos_general_settings" "default" {
  hostname = "${var.enterprise}-${var.environment}-${var.region}-${var.pafw}1"
  dns_primary = panos_address_object.domain_controller.value
  dns_secondary = "1.1.1.1" # Sometime it's useful to have an external DNS that is not relying on internal VPN-S2S
  ntp_primary_address = panos_address_object.domain_controller.value
  ntp_primary_auth_type = "none"
  timezone = "Europe/Paris"
}

