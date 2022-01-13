output "database_connect" {
  value = module.database.connect_string
}

output "vm_connect" {
  value = module.vm.connect_string
}

output "web_connect" {
  value = module.dns.connect_string
}
