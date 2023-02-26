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
  # This is set to true usually when the Private Endpoint is used.
  public_network_access_enabled = var.public_network_access_enabled
  sku_name                      = var.sku_name
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

#---------------------------------------------------------
# Provisioning with Private Endpoint
#---------------------------------------------------------
resource "azurerm_private_endpoint" "this" {
  count               = var.private_endpoint_config.subnet_id == null ? 0 : 1
  name                = "${var.name}-pe"
  location            = azurerm_key_vault.this.location
  resource_group_name = azurerm_key_vault.this.resource_group_name
  subnet_id           = var.private_endpoint_config.subnet_id
  private_service_connection {
    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
    # Reference page for subresource_names
    # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview
  }
  private_dns_zone_group {
    # Reference page
    # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns
    name                 = "${var.name}-psc" # Private Service Connection Name
    private_dns_zone_ids = [var.private_endpoint_config.private_dns_zone_id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  count                 = var.private_endpoint_config.private_dns_zone_name != null && var.private_endpoint_config.virtual_network_id != null ? 1 : 0
  name                  = "${var.name}-sub2dns"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_endpoint_config.private_dns_zone_name
  virtual_network_id    = var.private_endpoint_config.virtual_network_id
}


