// RESOURCE-GROUP: MANAGED BY AKS
data "azurerm_resource_group" "MC_demsyprodrg_demsyprodaks_germanywestcentral" {
  name = "MC_${var.prefix}${var.env}rg_${var.cluster_name}_${var.location}"
}

// IDENTITY FOR APPGW: MANAGED BY AKS
data "azurerm_user_assigned_identity" "ma_ingressapplicationgateway" {
  resource_group_name = data.azurerm_resource_group.MC_demsyprodrg_demsyprodaks_germanywestcentral.name
  name                = "ingressapplicationgateway-${var.prefix}${var.env}aks"
}

// GRANR ROLE "CONTRIBUTOR" TO APPGW IDENTITY
resource "azurerm_role_assignment" "ra_ingressapplicationgateway_contributor" {
  scope                = var.rg_id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.ma_ingressapplicationgateway.principal_id
}

// USER-ASSIGNED IDENTITY FOR AKS
resource "azurerm_user_assigned_identity" "aks_identity" {
  resource_group_name = var.rg_name
  name                = "${var.prefix}${var.env}aksidentity"
  location            = var.location
}
// GRANT ROLE "NETWORK CONTRIBUTOR" TO AKS IDENTITY
resource "azurerm_role_assignment" "aks-mi-network-contributor" {
  skip_service_principal_aad_check = true
  scope                            = var.vnet_id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_user_assigned_identity.aks_identity.principal_id
  depends_on                       = [azurerm_user_assigned_identity.aks_identity]
}

// LET AKS CLUSTER HAVE PUSH ACCESS TO CONTAINER REGISTRY
resource "azurerm_role_assignment" "ra_aks_acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}