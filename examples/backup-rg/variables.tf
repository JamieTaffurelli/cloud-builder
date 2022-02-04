variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the Recovery Services Vault"
}

variable "location" {
  type        = string
  description = "Location of the Recovery Services Vault"
}

variable "recovery_services_vault_name" {
  type        = string
  description = "Name of the Recovery Services Vault"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "sql_backup_policy_template_path" {
  type        = string
  description = "Path to backup policy template"
}

variable "tags" {
  type        = map(string)
  description = "Tags of the Recovery Services Vault"
}
