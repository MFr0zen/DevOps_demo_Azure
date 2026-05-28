resource "azuread_service_principal" "github" {
  client_id = azuread_application.github.client_id
}