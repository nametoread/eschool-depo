resource "azurerm_dns_zone" "main" {
  resource_group_name = var.rgroup.name
  name                = var.domain
}

resource "azurerm_dns_a_record" "main" {
  resource_group_name = var.rgroup.name
  zone_name           = azurerm_dns_zone.main.name

  name    = var.record.name
  records = [var.record.value]
  ttl     = 30
}
