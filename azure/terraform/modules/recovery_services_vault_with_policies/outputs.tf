output "recovery_services_vault_id" {
  value       = azurerm_recovery_services_vault.backup.id
  description = "Resource ID of the Log Analytics Workspace"
}
