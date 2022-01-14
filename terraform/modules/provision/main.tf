resource "local_file" "ssh_public_key" {
  filename             = "${path.cwd}/../.ssh/${var.project.name}.pem"
  directory_permission = "0700"
  file_permission      = "0644"
  content              = var.vm.public_key
}

resource "local_file" "ssh_private_key" {
  filename             = "${path.cwd}/../.ssh/${var.project.name}.key"
  directory_permission = "0700"
  file_permission      = "0600"
  sensitive_content    = var.vm.private_key
}

resource "local_file" "ansible_inventory" {
  filename = "${path.cwd}/../ansible/.inventory"
  content  = templatefile("${path.module}/inventory.tftpl", { name = var.project.name, ip = var.vm.ip })
}

locals {
  entries = sensitive(
    yamlencode({
      "project_name" : "${var.project.name}",
      "project_domain" : "${var.project.domain}",
      "vm_login" : "${var.vm.username}",
      "vm_ip" : "${var.vm.ip}",
      "db_url" : "jdbc:mysql://${var.database.fqdn}:3306/${var.project.name}?useSSL=true&useUnicode=true&characterEncoding=utf8&createDatabaseIfNotExist=true&autoReconnect=true",
      "db_user" : "${var.database.username}",
      "db_pass" : "${var.database.password}",
    })
  )
}

resource "local_file" "ansible_creds" {
  filename          = "${path.cwd}/../ansible/variables/.creds.yml"
  sensitive_content = join("\n", ["---", "# Auto-generated. Edit with caution.", local.entries])
}
