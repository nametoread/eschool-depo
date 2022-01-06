# General block

## Create resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.project.name}-resources"
  location = var.project.location
}

## Create virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.project.name}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Database block

## Create subnet for database
resource "azurerm_subnet" "database" {
  name                 = "${var.project.name}-database"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]

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

## Create private DNS zone
resource "azurerm_private_dns_zone" "main" {
  name                = "${var.project.name}-db.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.main.name
}

## Link DNS zone to virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  name                  = "mysql-link"
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = azurerm_virtual_network.main.id
  resource_group_name   = azurerm_resource_group.main.name
}

resource "random_pet" "db_suffix" {
  length = 2
}

## Create MySQL server
resource "azurerm_mysql_flexible_server" "main" {
  name                   = random_pet.db_suffix.id
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  delegated_subnet_id    = azurerm_subnet.database.id
  private_dns_zone_id    = azurerm_private_dns_zone.main.id
  administrator_login    = var.mysql.admin_login
  administrator_password = var.mysql.admin_pass
  sku_name               = var.mysql.sku_name
  version                = var.mysql.version

  depends_on = [azurerm_private_dns_zone_virtual_network_link.main]
}

# VM block

## Create subnet for virtual machine
resource "azurerm_subnet" "internal" {
  name                 = "${var.project.name}-internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

## Create VM public IP
resource "azurerm_public_ip" "main" {
  name                = "${var.project.name}-main-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

## Create network security group
resource "azurerm_network_security_group" "main" {
  name                = "${var.project.name}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP8080"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

## Create network interface
resource "azurerm_network_interface" "main" {
  name                = "${var.project.name}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

## Connect NSG to NIC
resource "azurerm_network_interface_security_group_association" "main" {
  network_security_group_id = azurerm_network_security_group.main.id
  network_interface_id      = azurerm_network_interface.main.id
}

##  Link VM public IP and domain 

resource "azurerm_dns_a_record" "main" {
  count = var.dns.zone_name != null && var.dns.rg_name != null ? 1 : 0
  name                = var.project.name
  zone_name           = var.dns.zone_name
  resource_group_name = var.dns.rg_name
  ttl                 = 30
  records             = ["${azurerm_public_ip.main.ip_address}"]
}

## Create SSH key pair
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "local_pem" {
  # filename             = pathexpand("~/.ssh/${var.project.name}.pem")
  filename             = "../.ssh/${var.project.name}.pem"
  directory_permission = "0700"
  file_permission      = "0644"
  content              = tls_private_key.main.public_key_pem
}

resource "local_file" "local_key" {
  # filename             = pathexpand("~/.ssh/${var.project.name}.key")
  filename             = "../.ssh/${var.project.name}.key"
  directory_permission = "0700"
  file_permission      = "0600"
  sensitive_content    = tls_private_key.main.private_key_pem
}

## Create VM
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.project.name}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_B2s"

  os_disk {
    name                 = "${var.project.name}-os-disk"
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  source_image_reference {
    publisher = "SUSE"               # "Debian"
    offer     = "opensuse-leap-15-3" # "debian-11"
    sku       = "gen2"               # "11-gen2"
    version   = "latest"
  }

  computer_name                   = "${var.project.name}-vm"
  admin_username                  = var.project.admin
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.project.admin
    public_key = tls_private_key.main.public_key_openssh
  }
}

# Ansible block

## Create inventory
resource "local_file" "ans_inventory" {
  filename = "../ansible/.inventory"
  content  = "${azurerm_public_ip.main.ip_address} ansible_ssh_private_key_file=../.ssh/${var.project.name}.key"
}

locals {
  ans_creds = sensitive(
    yamlencode({
      login : "${var.project.admin}",
      db_ip : "${azurerm_mysql_flexible_server.main.name}.${azurerm_private_dns_zone.main.name}",
      db_user : "${var.mysql.admin_login}",
      db_pass : "${var.mysql.admin_pass}",
      app_ip : "${azurerm_public_ip.main.ip_address}",
    })
  )
}

## Store sensitive variables
resource "local_file" "ans_variables" {
  filename          = "../ansible/.ansible.yml"
  sensitive_content = join("\n", ["---", "${local.ans_creds}"])
}

## Run plays
resource "null_resource" "ans_provision" {
  triggers = {
    vm_id = "${azurerm_linux_virtual_machine.main.virtual_machine_id}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/.inventory ../ansible/main.yml"
  }

  depends_on = [
    local_file.ans_inventory, local_file.ans_variables
  ]
}
