terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.90"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.az.subscription_id
  tenant_id       = var.az.tenant_id
  client_id       = var.az.client_id
  client_secret   = var.az.client_secret
}
