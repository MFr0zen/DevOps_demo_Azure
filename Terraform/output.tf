output "client_id" {
  value = azuread_application.github.client_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "load_balancer_public_ip" {
  value = azurerm_public_ip.lb_pip.ip_address
}

output "load_balancer_fqdn" {
  value = azurerm_public_ip.lb_pip.fqdn
}