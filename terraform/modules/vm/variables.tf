variable "rgroup" {
  type = object({
    name     = string
    location = string
  })
}

variable "vnet" {
  type = object({
    name = string
  })
}

variable "name" {
  type = string
}

variable "cfg" {
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

variable "creds" {
  type = object({
    admin_username = string
    public_key     = string
  })
}
