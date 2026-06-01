# lb public ip
resource "azurerm_public_ip" "lb_pubip" {
  name                = "lb-public-ip"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# lb
resource "azurerm_lb" "lb" {
  name                = "public-lb"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.lb_pubip.id
  }
}

# lb backend pool
resource "azurerm_lb_backend_address_pool" "pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backend-pool"
}

# associate vm ni
resource "azurerm_network_interface_backend_address_pool_association" "vm_assoc" {
  network_interface_id    = azurerm_network_interface.ni.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}

resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-probe"
  port            = 8000
  protocol        = "Http"
  request_path    = "/health"
}

resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8000
  frontend_ip_configuration_name = "public-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.pool.id]
  probe_id                       = azurerm_lb_probe.http.id
}

# lb dns
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-public-ip"
  location            = local.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  domain_name_label = "my-demo-app-1986"
}