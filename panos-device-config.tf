resource "panos_general_settings" "example" {
  hostname = "${var.enterprise}-${var.environment}-${var.region}-${var.project}1"
  dns_primary = "10.2.3.1"
  ntp_primary = "10.2.3.1"
  ntp_primary_auth_type = "none"
}

