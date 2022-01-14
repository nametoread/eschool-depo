output "database_password" {
  value     = azurerm_key_vault_secret.database_password.value
  sensitive = true
}

output "master_private_key" {
  value     = base64decode(azurerm_key_vault_secret.secrets["master_key_private_b64"].value)
  sensitive = true
}

output "master_public_key_pem" {
  value = base64decode(azurerm_key_vault_secret.secrets["master_key_public_pem_b64"].value)
}

output "master_public_key_openssh" {
  value = base64decode(azurerm_key_vault_secret.secrets["master_key_public_openssh_b64"].value)
}
