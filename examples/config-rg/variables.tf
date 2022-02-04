variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the Storage Account"
}

variable "location" {
  type        = string
  description = "Location of the Resource Group"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "storage_account_name" {
  type        = string
  description = "Name of Storage Account to create"
}

variable "storage_account_resource_group_name" {
  type        = string
  description = "Resource Group of Storage Account to create"
}

variable "container_name" {
  type        = string
  description = "Storage container to name"
}

variable "tags" {
  type        = map(string)
  description = "Tags of the Virtual Machine"
}
