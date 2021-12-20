# Create Application & Service Principal
data "azuread_client_config" "current" {}

resource "azuread_application" "adapp-client" {
  display_name = "${var.enterprise}-${var.environment}-${var.region}-${var.client}-ADAPP"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "adapp-client-sp" {
  application_id               = azuread_application.adapp-client.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}