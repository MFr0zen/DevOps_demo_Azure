resource "azurerm_app_configuration" "main" {
  name                = "devopsappconfig1986"
  resource_group_name = azurerm_resource_group.main.name
  location            = local.location
  sku                 = "free"
}

resource "azurerm_app_configuration_key" "image_tag" {
  configuration_store_id = azurerm_app_configuration.main.id

  key   = "latest-image-tag"
  value = "1.0.0"
}