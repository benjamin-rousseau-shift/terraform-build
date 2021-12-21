# Address Objects
resource "panos_address_object" "local_range" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-IP-RANGE_${var.IPAddressPrefix}.0.0"
  value       = "${var.IPAddressPrefix}.0.0/16"
  description = ""
}

resource "panos_address_object" "local_mgmt" {
  name        = "LOCAL_${var.enterprise}-${var.environment}-${var.region}-${var.project}1_${var.IPAddressPrefix}.5.254"
  value       = "${var.IPAddressPrefix}.0.254"
  description = ""
}

# Zone Protection Profile
resource "panos_dos_protection_profile" "default" {
  name        = "Zone Protection Profile"
  description = ""
}