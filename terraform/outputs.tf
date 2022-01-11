output "mysql_connect" {
  value = "mysql -h ${azurerm_mysql_flexible_server.main.name}.${azurerm_private_dns_zone.main.name} -u ${var.mysql.admin_login} -p --ssl=true"
}

output "ssh_connect" {
  value = "ssh -i ./ssh/${var.project.name}.key ${var.project.admin}@${azurerm_public_ip.main.ip_address}"
}

output "browser_connect" {
  value = format(
    "https://%s/",
    var.dns.zone_name != null && var.dns.rg_name != null ? "${var.project.name}.${var.dns.zone_name}" : "${azurerm_public_ip.main.ip_address}"
  )
}
