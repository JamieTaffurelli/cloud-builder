variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group to create"
}

variable "location" {
  type        = string
  description = "Location to deploy resources"
}

variable "key_vault_name" {
  type        = string
  description = "Name of Key Vault to deploy"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key for backups"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS secret key for backups"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
