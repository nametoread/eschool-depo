output "vm_public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "db_private_ip" {
  value = "${azurerm_mysql_flexible_server.main.name}.${azurerm_private_dns_zone.main.name}"
}
