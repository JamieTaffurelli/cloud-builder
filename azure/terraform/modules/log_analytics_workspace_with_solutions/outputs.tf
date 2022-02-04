output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.logging.id
  description = "Resource ID of the Log Analytics Workspace"
}

output "log_analytics_workspace_primary_shared_key" {
  value       = azurerm_log_analytics_workspace.logging.primary_shared_key
  description = "The Primary shared key for the Log Analytics Workspace"
  sensitive   = true
}

output "log_analytics_workspace_secondary_shared_key" {
  value       = azurerm_log_analytics_workspace.logging.secondary_shared_key
  description = "The Secondary shared key for the Log Analytics Workspace"
  sensitive   = true
}

output "log_analytics_workspace_customer_id" {
  value       = azurerm_log_analytics_workspace.logging.workspace_id
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace"
}

output "automation_account_id" {
  value       = azurerm_automation_account.logging.id
  description = "Resource ID of the Automation Account"
}

output "storage_account_id" {
  value       = azurerm_storage_account.logging.id
  description = "Resource ID of the Storage Account"
}

output "storage_account_primary_blob_endpoint" {
  value       = azurerm_storage_account.logging.primary_blob_endpoint
  description = "Primary URL for blob endpoint"
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.logging.primary_access_key
  description = "Primary Storage Account key"
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  value       = azurerm_storage_account.logging.secondary_access_key
  description = "Secondary Storage Account key"
  sensitive   = true
}

output "data_collection_rule_id" {
  value       = jsondecode(azurerm_resource_group_template_deployment.vmguesthealth.output_content).id.value
  description = "Resource ID of data collection rule"
}

output "network_watcher_id" {
  value       = azurerm_network_watcher.logging.id
  description = "Network Watcher resource ID"
}
