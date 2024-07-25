provider "azurerm" {
  features {}
  use_oidc = true
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.108.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "demsytestrg"
    storage_account_name  = "demsytest2507"
    container_name        = "core"
    key                   = "terraform.tfstate"
  }
}