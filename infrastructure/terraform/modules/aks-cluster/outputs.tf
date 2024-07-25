output "aks" {
  value = {
    name = azurerm_kubernetes_cluster.aks.name
    id   = azurerm_kubernetes_cluster.aks.id
  }
}
