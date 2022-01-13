terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.91"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = var.azure.features.key_vault.recover_soft_deleted_key_vaults
      purge_soft_delete_on_destroy    = var.azure.features.key_vault.purge_soft_delete_on_destroy
    }
  }
}
