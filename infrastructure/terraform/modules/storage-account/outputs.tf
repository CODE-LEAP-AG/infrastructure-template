output "storage_account" {
  value = {
    name = azurerm_storage_account.storage_account.name
    id   = azurerm_storage_account.storage_account.id
  }
}
