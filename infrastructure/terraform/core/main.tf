module "rg" {
  source   = "../modules/resource-group"
  prefix   = var.prefix
  location = var.location
}

module "network" {
  depends_on = [module.rg]
  source     = "../modules/network"
  prefix     = var.prefix
  location   = var.location
  rg_name    = module.rg.rg.name
}

module "appgw" {
  depends_on      = [module.network]
  source          = "../modules/application-gateway"
  rg_name         = module.rg.rg.name
  location        = var.location
  prefix          = var.prefix
  appgw_subnet_id = module.network.appgw_subnet.id
}

module "container_registry" {
  depends_on = [module.rg]
  source     = "../modules/container-registry"
  prefix     = var.prefix
  location   = var.location
  rg_name    = module.rg.rg.name
}

module "aks" {
  depends_on          = [module.appgw]
  source              = "../modules/aks-cluster"
  prefix              = var.prefix
  location            = var.location
  rg_name             = module.rg.rg.name
  vm_size             = "Standard_D2s_v3"
  syspool_node_count  = "1"
  syspool_min_count   = "1"
  syspool_max_count   = "1"
  userpool_node_count = "1"
  userpool_min_count  = "1"
  userpool_max_count  = "1"
  vnet_id             = module.network.vnet.id
  aks_subnet_id       = module.network.aks_subnet.id
  appgw_id            = module.appgw.appgw.id
}

module "managed_identity" {
  depends_on                = [module.aks, module.container_registry]
  source                    = "../modules/managed-identity"
  prefix                    = var.prefix
  location                  = var.location
  cluster_name              = module.aks.aks.name
  rg_id                     = module.rg.rg.id
  vnet_id                   = module.network.vnet.id
  acr_id                    = module.container_registry.acr.id
  rg_name                   = module.rg.rg.name
  aks_identity_principal_id = module.aks.aks_identity.principal_id
}

module "storage_account" {
  depends_on            = [module.rg]
  source                = "../modules/storage-account"
  prefix                = var.prefix
  location              = var.location
  rg_name               = module.rg.rg.name
  fs_name_debezium_conf = "conf"
  fs_name_debezium_data = "data"
  quota_debezium_conf   = 1
  quota_debezium_data   = 50
}

# module "sql_database" {
#   depends_on             = [module.rg]
#   source                 = "../modules/sql-database"
#   prefix                 = var.prefix
#   location               = var.location
#   rg_name                = module.rg.rg.name
#   administrator_login    = var.administrator_login
#   administrator_password = var.administrator_password
# }
