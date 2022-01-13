output "connect_string" {
  value = "https://${var.name}.${var.zone_name}/"
}

output "fqdn" {
  value = "${var.name}.${var.zone_name}"
}
