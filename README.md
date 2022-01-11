# eSchool Depo

eSchool project 1-click install.

## Usage

### Installation

0. Install **Terraform** and **Ansible**
1. Create config files (see below)
2. Run `$ make magic`

_Notes:_

- Usually whole process takes around 15 minutes to complete.

### Additional commands

- `$ make deploy` - create infrastructure
- `$ make wipe` - delete infrastructure
- `$ make provision` - make provision (full)
- `$ make configure` - configure remote environment (only)
- `$ make update` - create/update app (only)

## Features

- Configurable end-to-end automation
- Custom domain (via **Azure DNS**)
- SSL generation (via **certbot**)
- Lightweight (redirection from :80 and :443 via **iptables**)
- Secure (maybe?)

## Config files (examples)

### terraform/terraform.tfvars

```
az = {
  subscription_id = "<FILL_ME>"
  tenant_id       = "<FILL_ME>"
  client_id       = "<FILL_ME>"
  client_secret   = "<FILL_ME>"
}

mysql = {
  admin_login = "<FILL_ME>"
  admin_pass  = "<FILL_ME>"        # see notes
  version     = "8.0.21"           # latest tested
  sku_name    = "B_Standard_B1ms"
}

project = {
  name     = "eschool"
  location = "East US"
  admin    = "azure"
}

dns = {
  rg_name   = "<FILL_ME>"
  zone_name = "<FILL_ME>"
}

ssl = {
  email = "<FILL_ME>"
  pass  = "<FILL_ME>"
}
```

_Notes:_

- For `az` object create service principal - [docs](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#create-a-service-principal)

- Database password requirements - [docs](https://docs.microsoft.com/en-us/azure/mysql/flexible-server/quickstart-create-server-portal)
  > A new password for the server admin account. It must contain between 8 and 128 characters. It must also contain characters from three of the following categories: English uppercase letters, English lowercase letters, numbers (0 through 9), and non-alphanumeric characters (!, $, #, %, and so on). ()
- Database SKU's - [docs](https://docs.azure.cn/zh-cn/cli/mysql/flexible-server?view=azure-cli-latest#az_mysql_flexible_server_list_skus)
- If provided with Azure DNS Zone (resource group & zone name) `A` record is created to link project name subdomain to VM IP

### ansible/.ansible.yml

Generated automatically after complete and successful infrastructure deployment.

## Misc

- Generated SSH pair stored in `.ssh/` folder. Private `.key` and public `.pem` keys named after `project.name` in `terraform.tfvars`
- See output of terraform for Web / MySQL / SSH connection strings

## License

MIT, I think?
