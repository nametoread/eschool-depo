output "db_private_fqdn" {
  value = "${azurerm_mysql_flexible_server.main.name}.${azurerm_private_dns_zone.main.name}"
}

output "ssh_connect" {
  value = "ssh -i ./ssh/${var.project.name}.key ${var.project.admin}@${azurerm_public_ip.main.ip_address}"
}

output "browser_connect" {
  value = format(
    "%s:8080",
    var.dns.zone_name != null && var.dns.rg_name != null ? "${var.project.name}.${var.dns.zone_name}" : "${azurerm_public_ip.main.ip_address}"
  )
}
