variable "rgroup" {
  type = object({
    name     = string
    location = string
  })
}

variable "name" {
  type = string
}

variable "cfg" {
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
