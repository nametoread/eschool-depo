resource "azurerm_subnet" "main" {
  resource_group_name  = var.rgroup.name
  virtual_network_name = var.vnet.name

  name             = "${var.name}-internal"
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "main" {
  resource_group_name = var.rgroup.name
  location            = var.rgroup.location

  name              = "${var.name}-vm-ip"
  allocation_method = "Static"
}

resource "azurerm_network_security_group" "main" {
  resource_group_name = var.rgroup.name
  location            = var.rgroup.location

  name = "${var.name}-vm-nsg"

  # also could be done using looped azurerm_network_security_rule
  dynamic "security_rule" {
    for_each = var.cfg.rules
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value["destination_port"]
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_network_interface" "main" {
  resource_group_name = var.rgroup.name
  location            = var.rgroup.location

  name = "${var.name}-vm-nic"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_interface_security_group_association" "vm" {
  network_security_group_id = azurerm_network_security_group.main.id
  network_interface_id      = azurerm_network_interface.main.id
}

resource "azurerm_linux_virtual_machine" "main" {
  resource_group_name = var.rgroup.name
  location            = var.rgroup.location

  name                  = "${var.name}-vm"
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = var.cfg.size

  os_disk {
    name                 = "${var.name}-os-disk"
    storage_account_type = var.cfg.storage_type
    caching              = "ReadWrite"
  }

  source_image_reference {
    publisher = var.cfg.image.publisher
    offer     = var.cfg.image.offer
    sku       = var.cfg.image.sku
    version   = var.cfg.image.version
  }

  computer_name                   = "${var.name}-vm"
  admin_username                  = var.creds.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.creds.admin_username
    public_key = var.creds.public_key
  }
}
