resource "azurerm_key_vault" "this" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  soft_delete_retention_days      = var.stage == "prod" || var.stage == "acc" ? 60 : var.soft_delete_retention_days
  purge_protection_enabled        = var.stage == "prod" || var.stage == "acc" ? true : var.purge_protection
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  sku_name                        = "standard"
  dynamic "network_acls" {
    for_each = var.network_acls.bypass != null ? [0] : []
    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }
  tags = merge(
    var.additional_tags,
    {
      created-by = "iac-tf"
    },
  )
}

resource "azurerm_key_vault_access_policy" "this" {
  for_each     = toset(var.object_ids)
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = var.tenant_id
  object_id    = each.value

  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update", "Purge"
  ]

  key_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Recover", "Restore", "Purge"
  ]

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Restore",
  ]

  storage_permissions = [
    "Get", "List", "Set", "Delete", "Update", "Recover", "Restore",
  ]
}
