# eSchool Depo

So far _the easiest_ eSchool project deployment.

## Usage

1. Install **Terraform**, **Ansible** (core + _community.general_ collection)
2. Install **Azure CLI** and log in
3. Clone this repository
4. Create config files
   - `terraform/.auto.tfvars` - deployment configuration
   - `ansible/variables/.params.yml` - provisioning configuration
5. Run `$ make magic`

## Features

- Both creation of infrastructure and provisioning (under 15 minutes)
- Comprehensive configuration
- **Terraform**-specific:
  - Modular structure
  - Generated and vault-stored secrets (_Azure Key Vault_)
  - Database as service within private DNS zone (_Azure MySLQ Flexible_)
  - Dynamic network security rules of VM
  - DNS `A record` to VM public IP link (_Azure DNS_)
  - Optional generation of inventory and variables for Ansible
- **Ansible**-specific:
  - System update and installation of required packages
  - Non-privileged user and group for application
  - SSL certificate generation through CSR (_certbot_)
  - Propper convertation `.pem` to `.p12` (_openssl_)
  - Application as service (_systemctl unit file + environment file for secrets_)
  - Port redirection (_iptables_)
  - 1-command application update, configuration and rebuild

## Notes

- For additional single task commands see `Makefile`
- In case of setting variable **generate_ansible_files** to `true` generated SSH pair is stored in `.ssh/` folder. Private and public keys named after `project.name` in `.auto.tfvars`
- Some parts of Ansible scripts (e.g. system update) are **openSUSE**-specific
- See Terraform **outputs** for Web / Database / SSH connect strings
- In latest versions private repository is used, hence deploy key added to that repo is needed
- Also, after first run it is required to point provided root domain to created nameservers

## License

MIT, I think?
