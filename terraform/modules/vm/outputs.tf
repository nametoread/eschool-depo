output "public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "connect_string" {
  value = format(
    "ssh %s@%s -i .ssh/%s",
    var.creds.admin_username,
    azurerm_public_ip.main.ip_address,
    var.name
  )
}
