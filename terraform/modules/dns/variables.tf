variable "rgroup" {
  type = object({
    name = string
  })
}

variable "domain" {
  type = string
}

variable "record" {
  type = object({
    name  = string
    value = string
  })
}
