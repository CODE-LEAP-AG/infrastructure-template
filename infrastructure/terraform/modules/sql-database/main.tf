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
    mode = "SameZone"
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

resource "azurerm_postgresql_flexible_server_database" "pg_database" {
  name      = "${var.prefix}${var.env}pgdatabase"
  server_id = azurerm_postgresql_flexible_server.pg_flexlible_server.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
