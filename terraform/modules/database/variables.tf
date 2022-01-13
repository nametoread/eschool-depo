variable "rgroup" {
  type = object({
    name     = string
    location = string
  })
}

variable "vnet" {
  type = object({
    name = string
    id   = string
  })
}

variable "name" {
  type = string
}

variable "cfg" {
  type = object({
    version  = string
    sku_name = string
  })
}

variable "creds" {
  type = object({
    admin_username = string
    admin_password = string
  })
  sensitive = true
}