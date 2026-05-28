resource "azurerm_nat_gateway" "nat" {
  name                = "app-nat-gateway"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Standard"
}


# Public IP
resource "azurerm_public_ip" "nat-pubip" {
  name                = "nat-public-ip"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat-pub-ass" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat-pubip.id
}


# Private IP
resource "azurerm_subnet_nat_gateway_association" "nat-pri-ass" {
  nat_gateway_id = azurerm_nat_gateway.nat.id
  subnet_id      = azurerm_subnet.private.id
}