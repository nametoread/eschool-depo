data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "main" {
  resource_group_name = var.rgroup.name
  location            = var.rgroup.location

  name      = "${var.name}-vault"
  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name                        = var.cfg.sku_name
  enabled_for_deployment          = var.cfg.enabled_for_deployment
  enabled_for_disk_encryption     = var.cfg.enabled_for_disk_encryption
  enabled_for_template_deployment = var.cfg.enabled_for_template_deployment
  soft_delete_retention_days      = var.cfg.soft_delete_retention_days
  purge_protection_enabled        = var.cfg.purge_protection_enabled
}

# TODO: create service principal for ci/cd & grant read access

resource "azurerm_key_vault_access_policy" "god" {
  key_vault_id = azurerm_key_vault.main.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  certificate_permissions = var.cfg.access_policies.god.certificate_permissions
  key_permissions         = var.cfg.access_policies.god.key_permissions
  secret_permissions      = var.cfg.access_policies.god.secret_permissions
  storage_permissions     = var.cfg.access_policies.god.storage_permissions
}
