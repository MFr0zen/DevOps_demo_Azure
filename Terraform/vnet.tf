resource "azurerm_virtual_network" "main" {
  name                = "main-vnet"
  location            = local.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.main.name
}