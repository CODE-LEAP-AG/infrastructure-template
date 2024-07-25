module "rg" {
  source   = "../modules/resource-group"
  prefix   = var.prefix
  location = var.location
  env      = var.env
}

module "network" {
  depends_on = [module.rg]
  source     = "../modules/network"
  prefix     = var.prefix
  location   = var.location
  env        = var.env
  rg_name    = module.rg.rg.name
}

module "appgw" {
  depends_on      = [module.network]
  source          = "../modules/application-gateway"
  rg_name         = module.rg.rg.name
  env             = var.env
  location        = var.location
  prefix          = var.prefix
  appgw_subnet_id = module.network.appgw_subnet.id
}

module "container_registry" {
  depends_on = [module.rg]
  source     = "../modules/container-registry"
  prefix     = var.prefix
  env        = var.env
  location   = var.location
  rg_name    = module.rg.rg.name
}

module "aks" {
  depends_on          = [module.appgw]
  source              = "../modules/aks-cluster"
  prefix              = var.prefix
  location            = var.location
  rg_name             = module.rg.rg.name
  env                 = var.env
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
  depends_on   = [module.aks, module.container_registry]
  source       = "../modules/managed-identity"
  prefix       = var.prefix
  env          = var.env
  location     = var.location
  cluster_name = module.aks.aks.name
  rg_id        = module.rg.rg.id
  vnet_id      = module.network.vnet.id
  acr_id       = module.container_registry.acr.id
  rg_name      = module.rg.rg.name
  aks_identity_principal_id = module.aks.aks_identity.principal_id
}
