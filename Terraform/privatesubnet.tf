resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
}