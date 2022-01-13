resource "azurerm_dns_a_record" "main" {
  name                = var.name
  zone_name           = var.zone_name
  resource_group_name = var.rgroup_name
  ttl                 = 30
  records             = [var.ip]
}
