output "connect_string" {
  value = format(
    "mysql -h %s -u %s -p --ssl=true",
    azurerm_mysql_flexible_server.main.fqdn,
    nonsensitive(var.creds.admin_username)
  )
}

output "fqdn" {
  value = azurerm_mysql_flexible_server.main.fqdn
}
