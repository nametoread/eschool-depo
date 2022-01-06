# eSchool Depo

Terraform & Ansible scripts to create infrastructure, setup server, build app and run as service.

## Usage

0. Install **Terraform** and **Ansible**
1. Create config files
2. Run (from `terraform` directory):
   ```bash
   $ terraform init && terraform apply
   ```

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
```

#### Notes:

- For `az` object create service principal - [docs](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash#create-a-service-principal)

- Database password requirements - [docs](https://docs.microsoft.com/en-us/azure/mysql/flexible-server/quickstart-create-server-portal)
  > A new password for the server admin account. It must contain between 8 and 128 characters. It must also contain characters from three of the following categories: English uppercase letters, English lowercase letters, numbers (0 through 9), and non-alphanumeric characters (!, $, #, %, and so on). ()
- Database SKU's - [docs](https://docs.azure.cn/zh-cn/cli/mysql/flexible-server?view=azure-cli-latest#az_mysql_flexible_server_list_skus)
- If provided with Azure DNS Zone (resource group & zone name) `A` record is created to link project name subdomain to VM IP

### ansible/.ansible.yml

Generated automatically after complete and successful `terraform apply`.

## Misc

- Generated SSH pair stored in `.ssh/` folder. Private `.key` and public `.pem` keys named after `project.name` in `terraform.tfvars`
- Check `vm_public_ip:8080`
- Also, you can rebuild app (from `ansible` directory) with:
  ```bash
  $ ansible-playbook -i .inventory playbooks/2-eschool-init.yml
  ```

## License

MIT, I think?
