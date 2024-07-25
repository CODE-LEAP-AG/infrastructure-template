data "azurerm_resource_group" "rg" {
  name = "${var.prefix}${var.env}rg"
}
module "storage_account" {
  depends_on            = [data.azurerm_resource_group.rg]
  source                = "../modules/storage-account"
  prefix                = var.prefix
  location              = var.location
  env                   = var.env
  rg_name               = data.azurerm_resource_group.rg.name
  fs_name_debezium_conf = "conf"
  fs_name_debezium_data = "data"
  quota_debezium_conf   = 1
  quota_debezium_data   = 50
}
