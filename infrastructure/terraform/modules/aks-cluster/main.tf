// USER-ASSIGNED IDENTITY FOR AKS
resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.rg_name
  name                = "${var.prefix}aksidentity"
  location            = var.location
}

// AKS CLUSTER WITH AGIC (APPGW INGRESS CONTROLLER)
resource "azurerm_kubernetes_cluster" "aks" {
  resource_group_name = var.rg_name
  name                = "${var.prefix}aks"
  location            = var.location
  dns_prefix          = "${var.prefix}"

  default_node_pool {
    vnet_subnet_id      = var.aks_subnet_id
    vm_size             = var.vm_size
    node_count          = var.syspool_node_count
    name                = "systempool"
    min_count           = var.syspool_min_count
    max_count           = var.syspool_max_count
    enable_auto_scaling = true
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.aks_identity.id,
    ]
  }

  lifecycle {
    ignore_changes = [
      default_node_pool
    ]
  }

  ingress_application_gateway {
    gateway_id = var.appgw_id
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  depends_on = [azurerm_user_assigned_identity.aks_identity]
}

// AKS USER NODE POOL
resource "azurerm_kubernetes_cluster_node_pool" "usernodepool" {
  vnet_subnet_id        = var.aks_subnet_id
  vm_size               = var.vm_size
  node_count            = var.userpool_node_count
  name                  = "userpool"
  mode                  = "User"
  min_count             = var.userpool_min_count
  max_count             = var.userpool_max_count
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  enable_auto_scaling   = true

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
  depends_on = [azurerm_kubernetes_cluster.aks]
}
