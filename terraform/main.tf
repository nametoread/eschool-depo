module "common" {
  source = "./modules/common"

  name     = var.project.name
  location = var.project.location
}

module "vault" {
  source = "./modules/vault"

  name   = var.project.name
  rgroup = module.common.rgroup

  cfg = var.vault
}

module "database" {
  source = "./modules/database"

  name   = var.project.name
  rgroup = module.common.rgroup
  vnet   = module.common.vnet

  cfg = var.mysql
  creds = {
    admin_username = var.project.admin_username
    admin_password = module.vault.database_password
  }
}

module "vm" {
  source = "./modules/vm"

  name   = var.project.name
  rgroup = module.common.rgroup
  vnet   = module.common.vnet

  cfg = var.vm
  creds = {
    admin_username = var.project.admin_username
    public_key     = module.vault.master_public_key_openssh
  }
}

module "dns" {
  source = "./modules/dns"

  rgroup = module.common.rgroup
  domain = var.dns.root_domain
  record = {
    name  = var.dns.project_subdomain
    value = module.vm.public_ip
  }
}

module "provision" {
  count  = var.generate_ansible_files ? 1 : 0
  source = "./modules/provision"

  project = {
    name   = var.project.name
    domain = module.dns.fqdn
  }

  database = {
    fqdn     = module.database.fqdn
    username = var.project.admin_username
    password = module.vault.database_password
  }

  vm = {
    username    = var.project.admin_username
    ip          = module.vm.public_ip
    public_key  = module.vault.master_public_key_pem
    private_key = module.vault.master_private_key
  }
}
