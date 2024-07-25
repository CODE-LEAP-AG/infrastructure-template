resource "azurerm_public_ip" "public_ip" {
  sku                 = "Standard"
  resource_group_name = var.rg_name
  name                = "${var.prefix}${var.env}appgwip"
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_application_gateway" "appgw" {
  resource_group_name = var.rg_name
  name                = "${var.prefix}${var.env}appgw"
  location            = var.location

  backend_address_pool {
    name = "backendpool"
  }

  backend_http_settings {
    request_timeout       = 20
    protocol              = "Http"
    port                  = 80
    name                  = "backendhttpssettings"
    cookie_based_affinity = "Disabled"
  }

  depends_on = [
    azurerm_public_ip.public_ip,
  ]

  frontend_ip_configuration {
    public_ip_address_id = azurerm_public_ip.public_ip.id
    name                 = "frontendipconfiguration"
  }

  frontend_port {
    port = 80
    name = "frontendport"
  }

  gateway_ip_configuration {
    subnet_id = var.appgw_subnet_id
    name      = "gatewayipconfiguration"
  }

  http_listener {
    protocol                       = "Http"
    name                           = "httplistener"
    frontend_port_name             = "frontendport"
    frontend_ip_configuration_name = "frontendipconfiguration"
  }

  lifecycle {
    ignore_changes = [
      backend_address_pool, backend_http_settings, http_listener, request_routing_rule, probe,
    ]
  }

  request_routing_rule {
    rule_type                  = "Basic"
    priority                   = 1
    name                       = "requestroutingrule"
    http_listener_name         = "httplistener"
    backend_http_settings_name = "backendhttpssettings"
    backend_address_pool_name  = "backendpool"
  }

  sku {
    tier     = "Standard_v2"
    name     = "Standard_v2"
    capacity = 2
  }
}