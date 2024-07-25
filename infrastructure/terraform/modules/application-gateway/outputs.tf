output "appgw" {
  value = {
    name = azurerm_application_gateway.appgw.name
    id   = azurerm_application_gateway.appgw.id
  }
}
