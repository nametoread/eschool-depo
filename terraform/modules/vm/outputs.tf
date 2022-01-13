output "public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "connect_string" {
  value = "ssh ${var.creds.admin_username}@${azurerm_public_ip.main.ip_address}"
}
