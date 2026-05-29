#Github gets permission to push images to acr
resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.github.object_id
}

resource "azurerm_role_assignment" "github_appconfig_writer" {
  scope                = azurerm_app_configuration.main.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = azuread_service_principal.github.object_id
}

resource "azurerm_role_assignment" "github_aap_config_contribute" {
  scope                = azurerm_app_configuration.main.id
  role_definition_name = "App Configuration Contributor"
  principal_id         = azuread_service_principal.github.object_id
}

# ----------------------------------------------------------------------

# VM gets permission to read the latest image tag from app-configuration
resource "azurerm_role_assignment" "appconfig_reader" {
  scope                = azurerm_app_configuration.main.id
  role_definition_name = "App Configuration Data Reader"
  principal_id         = azurerm_linux_virtual_machine.app.identity[0].principal_id
}

resource "azurerm_role_assignment" "appconfig_contribute" {
  scope                = azurerm_app_configuration.main.id
  role_definition_name = "App Configuration Contributor"
  principal_id         = azurerm_linux_virtual_machine.app.identity[0].principal_id
}

# VM gets permission to pull images from acr
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.app.identity[0].principal_id
}
