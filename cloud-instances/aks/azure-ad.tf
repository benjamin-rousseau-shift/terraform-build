# Create Application & Service Principal
data "azuread_client_config" "current" {}

resource "azuread_application" "adapp-client" {
  display_name = "${var.enterprise}-${var.environment}-${var.region}-AKS-ADAPP"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "adapp-client-sp" {
  application_id               = azuread_application.adapp-client.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "random_string" "password" {
  length  = 32
  special = true
}

# Create Service Principal password
resource "azuread_service_principal_password" "app" {
  end_date             = "2299-12-30T23:00:00Z"                        # Forever
  service_principal_id = "${azuread_service_principal.adapp-client-sp.id}"
  value                = "${random_string.password.result}"
}