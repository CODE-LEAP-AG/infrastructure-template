resource "azurerm_postgresql_flexible_server" "pg_flexlible_server" {
  name                = "${var.prefix}${var.env}pgflexibleserver"
  location            = var.location
  resource_group_name = var.rg_name

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  sku_name     = "GP_Standard_D4s_v3"
  storage_mb   = 32768
  storage_tier = "P4"
  version      = "12"

  high_availability {
    mode                      = "SameZone"
  }

  lifecycle {
    ignore_changes = [
      storage_mb,
      administrator_login,
      administrator_password,
      zone,
      high_availability[0].standby_availability_zone
    ]
  }
}

resource "azurerm_postgresql_database" "pg_database" {
  depends_on          = [azurerm_postgresql_flexible_server.pg_flexlible_server]
  name                = "${var.prefix}${var.env}pgdatabase"
  resource_group_name = var.rg_name
  server_name         = azurerm_postgresql_flexible_server.pg_flexlible_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
