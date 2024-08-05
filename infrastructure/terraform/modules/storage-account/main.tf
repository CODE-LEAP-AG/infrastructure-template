resource "azurerm_storage_account" "storage_account" {
  resource_group_name      = var.rg_name
  name                     = "${var.prefix}sa2307"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"
}

resource "azurerm_storage_share" "debezium_conf" {
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = var.quota_debezium_conf
  name                 = var.fs_name_debezium_conf
}

resource "azurerm_storage_share" "debezium_data" {
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = var.quota_debezium_data
  name                 = var.fs_name_debezium_data
}