output "id" {
  value = azurerm_key_vault.this.id
}

output "uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "name" {
  value = azurerm_key_vault.this.name
}

output "vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "network_interface_id" {
  value = var.private_endpoint_config.subnet_id == null ? null : azurerm_private_endpoint[0].this.network_interface.0.id
}