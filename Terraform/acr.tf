resource "azurerm_container_registry" "acr" {
  name                = "demoappacr1986"
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location
  sku                 = "Basic"
  admin_enabled       = false
}