output "vnet" {
  value = {
    name          = azurerm_virtual_network.vnet.name
    id            = azurerm_virtual_network.vnet.id
    address_space = azurerm_virtual_network.vnet.address_space
  }
}

output "aks_subnet" {
  value = {
    name           = azurerm_subnet.aks_subnet.name
    id             = azurerm_subnet.aks_subnet.id
    rg_name        = azurerm_subnet.aks_subnet.resource_group_name
    address_prefix = azurerm_subnet.aks_subnet.address_prefixes
  }
}

output "appgw_subnet" {
  value = {
    name           = azurerm_subnet.appgw_subnet.name
    id             = azurerm_subnet.appgw_subnet.id
    rg_name        = azurerm_subnet.appgw_subnet.resource_group_name
    address_prefix = azurerm_subnet.appgw_subnet.address_prefixes
  }
}
