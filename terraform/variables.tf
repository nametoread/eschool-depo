variable "azure" {
  type = object({
    features = object({
      key_vault = object({
        recover_soft_deleted_key_vaults = bool
        purge_soft_delete_on_destroy    = bool
      })
    })
  })
}

variable "project" {
  type = object({
    name           = string
    location       = string
    admin_username = string
  })
}

variable "vault" {
  type = object({
    sku_name                        = string
    enabled_for_deployment          = bool
    enabled_for_disk_encryption     = bool
    enabled_for_template_deployment = bool
    soft_delete_retention_days      = number
    purge_protection_enabled        = bool
    access_policies = object({
      god = object({
        certificate_permissions = list(string)
        key_permissions         = list(string)
        secret_permissions      = list(string)
        storage_permissions     = list(string)
      })
    })
  })
}

variable "mysql" {
  type = object({
    version  = string
    sku_name = string
  })
}

variable "vm" {
  type = object({
    size         = string
    storage_type = string

    image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    rules = map(object({
      name             = string
      priority         = number
      destination_port = string
    }))
  })
}

variable "dns" {
  type = object({
    zone_name   = string
    rgroup_name = string
  })
}

variable "generate_ansible_files" {
  type    = bool
  default = false
}
