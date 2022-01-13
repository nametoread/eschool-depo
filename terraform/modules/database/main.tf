resource "azurerm_subnet" "main" {
  resource_group_name  = var.rgroup.name
  virtual_network_name = var.vnet.name

  name             = "${var.name}-database"
  address_prefixes = ["10.0.2.0/24"]

  service_endpoints = ["Microsoft.Storage"]
  delegation {
    name = "dfs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "main" {
  resource_group_name = var.rgroup.name
  name                = "${var.name}.mysql.database.azure.com"
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  resource_group_name = var.rgroup.name
  virtual_network_id  = var.vnet.id

  name                  = "mysql-link"
  private_dns_zone_name = azurerm_private_dns_zone.main.name
}

resource "random_pet" "name" {
  length = 3
}

resource "azurerm_mysql_flexible_server" "main" {
  resource_group_name = var.rgroup.name
  location            = var.rgroup.location

  name                = random_pet.name.id
  delegated_subnet_id = azurerm_subnet.main.id
  private_dns_zone_id = azurerm_private_dns_zone.main.id
  sku_name            = var.cfg.sku_name
  version             = var.cfg.version

  administrator_login    = var.creds.admin_username
  administrator_password = var.creds.admin_password

  depends_on = [azurerm_private_dns_zone_virtual_network_link.main]
}
