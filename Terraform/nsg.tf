resource "azurerm_network_security_group" "pri-nsg" {
  name                = "private-nsg"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_security_group" "pub-nsg" {
  name                = "public-nsg"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
}