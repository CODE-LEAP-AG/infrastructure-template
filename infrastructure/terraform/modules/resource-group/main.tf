resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}${var.env}rg"
  location = var.location
}
