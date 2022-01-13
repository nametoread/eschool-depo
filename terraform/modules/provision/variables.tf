variable "project" {
  type = object({
    name   = string
    domain = string
  })
}

variable "database" {
  type = object({
    fqdn     = string
    username = string
    password = string
  })
  sensitive = true
}

variable "vm" {
  type = object({
    username    = string
    ip          = string
    public_key  = string
    private_key = string
  })
  sensitive = true
}
