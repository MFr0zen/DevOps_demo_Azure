resource "azurerm_network_interface" "ni" {
  name                = "app-ni"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}
