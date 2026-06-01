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

# open port 8000 on vm for loadbalancer health check
resource "azurerm_network_security_rule" "allow_lb_to_app" {
  name      = "allow-lb-to-app"
  priority  = 110
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "8000"

  source_address_prefix      = "AzureLoadBalancer"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.pri-nsg.name
}

# open port 8000 on vm for loadbalancer for internet requests
resource "azurerm_network_security_rule" "allow_internet_to_app" {
  name      = "allow-internet-to-app"
  priority  = 111
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "8000"

  source_address_prefix      = "Internet"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.pri-nsg.name
}