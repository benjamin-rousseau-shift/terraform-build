resource "panos_general_settings" "default" {
  hostname = "${var.enterprise}-${var.environment}-${var.region}-${var.project}1"
  dns_primary = var.domain_controller
  ntp_primary_address = var.domain_controller
  ntp_primary_auth_type = "none"
  timezone = "Europe/Paris"
}

