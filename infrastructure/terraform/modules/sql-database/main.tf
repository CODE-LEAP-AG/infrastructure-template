resource "azurerm_postgresql_flexible_server" "pg_flexlible_server" {
  name                = "${var.prefix}${var.env}pgflexibleserver"
  location            = var.location
  resource_group_name = var.rg_name

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sku_name     = "Standard_B1ms" # Minimal cost SKU
  storage_mb   = 32768           # Minimum storage size
  storage_tier = "Standard"      # Standard storage tier
  version      = "12"

  high_availability {
    mode = "Disabled"
  }

  lifecycle {
    ignore_changes = [
      storage_profile,
      administrator_login,
      administrator_password
    ]
  }
}

resource "azurerm_postgresql_database" "pg_database" {
  depends_on = [azurerm_postgresql_flexible_server.pg_flexlible_server]
  name = "${var.prefix}${var.env}pgdatabase"
  resource_group_name = var.rg_name
  server_name = azurerm_postgresql_flexible_server.pg_flexlible_server.name
  charset = "UTF8"
  collation = "English_United States.1252"
}