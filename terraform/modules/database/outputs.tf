output "connect_string" {
  value = format(
    "mysql -h %s.%s -u %s -p --ssl=true",
    azurerm_mysql_flexible_server.main.name,
    azurerm_private_dns_zone.main.name,
    nonsensitive(var.creds.admin_username)
  )
}

output "fqdn" {
  value = "${azurerm_mysql_flexible_server.main.name}.${azurerm_private_dns_zone.main.name}"
}
