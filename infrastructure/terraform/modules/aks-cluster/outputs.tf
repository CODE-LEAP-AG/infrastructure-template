output "aks" {
  value = {
    name = azurerm_kubernetes_cluster.aks.name
    id   = azurerm_kubernetes_cluster.aks.id
  }
}

output "userpool" {
  value = {
    name = azurerm_kubernetes_cluster_node_pool.usernodepool.name
    id   = azurerm_kubernetes_cluster_node_pool.usernodepool.id
  }
}

output "aks_identity" {
  value = {
    name         = azurerm_user_assigned_identity.aks_identity.name
    principal_id = azurerm_user_assigned_identity.aks_identity.principal_id
  }
}

output "userpool_identity" {
  value = {
    name         = azurerm_user_assigned_identity.userpool_identity.name
    principal_id = azurerm_user_assigned_identity.userpool_identity.principal_id
  }
}
