output "sql_database" {
  value = {
    server_name   = azurerm_postgresql_flexible_server.pg_flexlible_server.name
    database_name = azurerm_postgresql_flexible_server_database.pg_database.name
  }
}
