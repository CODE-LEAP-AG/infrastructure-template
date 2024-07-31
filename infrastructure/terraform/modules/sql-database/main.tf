resource "azurerm_postgresql_server" "postgresql_server" {
  name                         = "${var.prefix}${var.env}pgserver"
  location                     = var.location
  resource_group_name          = var.rg_name
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  sku_name                     = "B_Gen5_1"
  storage_mb                   = 5120
  auto_grow_enabled            = true
  version                      = "11"
  ssl_enforcement_enabled      = true
  lifecycle {
    ignore_changes = [
      administrator_login,
      administrator_login_password,
      storage_mb
    ]
  }
}

resource "azurerm_postgresql_database" "postgresql_database" {
  name = "${var.prefix}${var.env}pgdb"
  resource_group_name = var.rg_name
  server_name = azurerm_postgresql_server.postgresql_server.name
  charset = "UTF8"
  collation = "English_United States.1252"
}