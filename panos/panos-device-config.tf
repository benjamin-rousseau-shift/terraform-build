resource "panos_general_settings" "default" {
  hostname = "${var.enterprise}-${var.environment}-${var.region}-${var.project}1"
  dns_primary = "10.2.3.1"
  ntp_primary_address = "10.2.3.1"
}

