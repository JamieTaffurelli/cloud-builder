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

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of the Log Analytics Workspace for diagnostics"
}

variable "tags" {
  type        = map(any)
  description = "Tags of the Recovery Services Vault"
}


