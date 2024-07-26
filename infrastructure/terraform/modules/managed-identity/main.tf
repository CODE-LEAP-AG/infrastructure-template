// RESOURCE-GROUP MC_: MANAGED BY AKS
data "azurerm_resource_group" "MC_demsyprodrg_demsyprodaks_germanywestcentral" {
  name = "MC_${var.prefix}${var.env}rg_${var.cluster_name}_${var.location}"
}

// IDENTITY FOR APPGW: MANAGED BY RESOURCE-GROUP MC_
data "azurerm_user_assigned_identity" "ingressapplicationgateway" {
  resource_group_name = data.azurerm_resource_group.MC_demsyprodrg_demsyprodaks_germanywestcentral.name
  name                = "ingressapplicationgateway-${var.prefix}${var.env}aks"
}

// GRANT ROLE "CONTRIBUTOR" TO APPGW IDENTITY
resource "azurerm_role_assignment" "ingressapplicationgateway_contributor_rg" {
  scope                = var.rg_id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ingressapplicationgateway.principal_id
  depends_on = [ data.azurerm_user_assigned_identity.ingressapplicationgateway ]
}

// IDENTITY FOR AKS: ALREADY CREATED BY AKS
// GRANT ROLE "NETWORK CONTRIBUTOR" TO AKS IDENTITY
resource "azurerm_role_assignment" "aks_network_contributor" {
  skip_service_principal_aad_check = true
  scope                            = var.vnet_id
  role_definition_name             = "Network Contributor"
  principal_id                     = var.aks_identity_principal_id
}

// IDENTITY FOR AKS: ALREADY CREATED BY AKS
// GRANT PUSH-PULL ACCESS FOR AKS
resource "azurerm_role_assignment" "aks_push_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = var.aks_identity_principal_id
}
// GRANT PUSH ACCESS FOR USER POOL
resource "azurerm_role_assignment" "userpool_push_acr" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = var.userpool_identity_principal_id
}