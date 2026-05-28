resource "azurerm_linux_virtual_machine" "app" {
  name                  = "app-vm"
  resource_group_name   = azurerm_resource_group.main.name
  location              = local.location
  size                  = "Standard_B2s_v2"
  admin_username        = "azvmuser"
  network_interface_ids = [azurerm_network_interface.ni.id]


  admin_ssh_key {
    username   = "azvmuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = base64encode(templatefile("${path.module}/userdata.sh", {
    acr_name    = azurerm_container_registry.acr.name
    acr_login   = azurerm_container_registry.acr.login_server
    app_port    = 8000
    config_name = azurerm_app_configuration.main.name
  }))
}
