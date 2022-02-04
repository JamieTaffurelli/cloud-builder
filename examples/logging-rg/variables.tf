variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group to create"
}

variable "location" {
  type        = string
  description = "Location to deploy resources"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to deploy"
}

variable "automation_account_name" {
  type        = string
  description = "Name of the automation account to link to workspace"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the Storage Account to deploy"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet to allow storage access to"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Virtual Network with subnet to allow storage access to"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Resource Group of the Virtual Network with subnet to allow storage access to"
}

variable "network_watcher_name" {
  type        = string
  description = "Name of the Network Watcher to deploy"
}

variable "data_collection_rule_template_path" {
  type        = string
  description = "Path to data collection rule arm template"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}