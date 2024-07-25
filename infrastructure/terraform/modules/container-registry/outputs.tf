output "acr" {
  value = {
    name = azurerm_container_registry.acr.name
    id   = azurerm_container_registry.acr.id
  }
}
