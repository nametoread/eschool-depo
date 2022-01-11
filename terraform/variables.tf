variable "az" {
  type = object({
    subscription_id = string
    tenant_id       = string
    client_id       = string
    client_secret   = string
  })
  sensitive = true
}

variable "mysql" {
  type = object({
    admin_login = string
    admin_pass  = string
    version     = string
    sku_name    = string
  })
  sensitive = true
}

variable "project" {
  type = object({
    name     = string
    location = string
    admin    = string
  })
}

variable "dns" {
  type = object({
    rg_name   = string
    zone_name = string
  })
  default = {
    rg_name   = null
    zone_name = null
  }
}

variable "ssl" {
  type = object({
    email = string
    pass  = string
  })
  sensitive = true
}
