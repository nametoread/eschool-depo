resource "random_password" "database" {
  length           = 12
  lower            = true
  min_lower        = 1
  upper            = true
  min_upper        = 1
  number           = true
  min_numeric      = 1
  special          = true
  min_special      = 1
  override_special = "!$#%"
}

resource "azurerm_key_vault_secret" "database_password" {
  name  = "database-password"
  value = random_password.database.result

  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.god
  ]
}

resource "tls_private_key" "master" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  secrets = {
    master_key_private_b64 = {
      name  = "master-key-private-b64"
      value = base64encode(tls_private_key.master.private_key_pem)
    }
    master_key_public_pem_b64 = {
      name  = "master-key-public-pem-b64"
      value = base64encode(tls_private_key.master.public_key_pem)
    }
    master_key_public_openssh_b64 = {
      name  = "master-key-public-openssh-b64"
      value = base64encode(tls_private_key.master.public_key_openssh)
    }
  }
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each = local.secrets

  name  = each.value.name
  value = each.value.value

  key_vault_id = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.god
  ]
}
