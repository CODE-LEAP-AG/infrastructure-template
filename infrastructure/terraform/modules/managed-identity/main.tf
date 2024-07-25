// AUTOMATICALLY CREATED BY AKS
data "azurerm_resource_group" "MC_demsyprodrg_demsyprodaks_germanywestcentral" {
  name = "MC_${var.prefix}${var.env}rg_${var.cluster_name}_${var.location}"
}

// AUTOMATICALLY CREATED BY AKS
data "azurerm_user_assigned_identity" "ma_ingressapplicationgateway" {
  resource_group_name = data.azurerm_resource_group.MC_demsyprodrg_demsyprodaks_germanywestcentral.name
  name                = "ingressapplicationgateway-${var.prefix}${var.env}aks"
}

// LET INGRESS GATEWAY MANAGE THE AKS RESOURCE GROUP
resource "azurerm_role_assignment" "ra_ingressapplicationgateway_contributor" {
  scope                = var.rg_id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ma_ingressapplicationgateway.principal_id
}

// LET AKS CLUSTER HAVE PUSH ACCESS TO CONTAINER REGISTRY
resource "azurerm_role_assignment" "ra_aks_acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = var.aks_principal_id
}