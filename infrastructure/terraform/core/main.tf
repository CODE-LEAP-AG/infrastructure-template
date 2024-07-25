module "rg" {
  source   = "../modules/resource-group"
  prefix   = var.PREFIX
  location = var.LOCATION
  env      = var.ENV
}

module "network" {
  depends_on = [module.rg]
  source     = "../modules/network"
  prefix     = var.PREFIX
  location   = var.LOCATION
  env        = var.ENV
  rg_name    = module.rg.rg.name
}

module "appgw" {
  depends_on      = [module.network]
  source          = "../modules/application-gateway"
  rg_name         = module.rg.rg.name
  env             = var.ENV
  location        = var.LOCATION
  prefix          = var.PREFIX
  appgw_subnet_id = module.network.appgw_subnet.id
}

module "aks" {
  depends_on          = [module.appgw]
  source              = "../modules/aks-cluster"
  prefix              = var.PREFIX
  location            = var.LOCATION
  rg_name             = module.rg.rg.name
  env                 = var.ENV
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
  depends_on   = [module.aks]
  source       = "../modules/managed-identity"
  prefix       = var.PREFIX
  env          = var.ENV
  location     = var.LOCATION
  cluster_name = module.aks.aks.name
  rg_id        = module.rg.rg.id
}

