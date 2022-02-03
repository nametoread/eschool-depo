locals {
  fqdn = substr(
    azurerm_dns_a_record.main.fqdn,
    0,
    length(azurerm_dns_a_record.main.fqdn) - 1
  )
}

output "connect_string" {
  value = format(
    "https://%s/",
    local.fqdn
  )
}

output "fqdn" {
  value = local.fqdn
}

output "nameservers" {
  value = flatten(azurerm_dns_zone.main.name_servers)
}
