// RESOURCE-GROUP MC_: MANAGED BY AKS
data "azurerm_resource_group" "MC_demsyprodrg_demsyprodaks_germanywestcentral" {
  name = "MC_${var.prefix}rg_${var.cluster_name}_${var.location}"
}

// IDENTITY FOR APPGW: MANAGED BY RESOURCE-GROUP MC_
data "azurerm_user_assigned_identity" "ingressapplicationgateway" {
  resource_group_name = data.azurerm_resource_group.MC_demsyprodrg_demsyprodaks_germanywestcentral.name
  name                = "ingressapplicationgateway-${var.prefix}aks"
}
resource "azurerm_role_assignment" "ingressapplicationgateway_contributor_rg" {
  scope                = var.rg_id
  role_definition_name = "Contributor"
  // grant identity "ingressapplicationgateway" contributor access to RG
  principal_id         = data.azurerm_user_assigned_identity.ingressapplicationgateway.principal_id
  depends_on           = [data.azurerm_user_assigned_identity.ingressapplicationgateway]
}

// GRANT ROLE "NETWORK CONTRIBUTOR" TO AKS IDENTITY
resource "azurerm_role_assignment" "aks_network_contributor" {
  skip_service_principal_aad_check = true
  scope                            = var.vnet_id
  role_definition_name             = "Network Contributor"
  principal_id                     = var.aks_identity_principal_id
}

// GRANT ACR PUSH-PULL TO AKS IDENTITY
resource "azurerm_role_assignment" "aks_push_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = var.aks_identity_principal_id
}

// IDENTITY FOR AGENT POOL: MANAGED BY RESOURCE-GROUP MC_
data "azurerm_user_assigned_identity" "agentpool" {
  resource_group_name = data.azurerm_resource_group.MC_demsyprodrg_demsyprodaks_germanywestcentral.name
  name                = "${var.prefix}aks-agentpool"
}
resource "azurerm_role_assignment" "agentpool_push_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  // grant identity "agentpool" push access to ACR
  principal_id         = data.azurerm_user_assigned_identity.agentpool.principal_id
}
