variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the Network Security Group"
}

variable "location" {
  type        = string
  description = "Location of the Network Security Group"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the Network Security Group"
}

variable "network_watcher_resource_group_name" {
  type        = string
  description = "Resource group name of the Network Watcher"
}

variable "network_watcher_name" {
  type        = string
  description = "Name of the Network Watcher"
}

variable "storage_account_id" {
  type        = string
  description = "Resource ID of the Storage Account for flow logs"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Customer ID of the Log Analytics Workspace for Traffic Analytics"
}

variable "log_analytics_workspace_location" {
  type        = string
  description = "Location of the Log Analytics Workspace for Traffic Analytics"
}

variable "log_analytics_workspace_resource_id" {
  type        = string
  description = "Resource ID of the Log Analytics Workspace for Traffic Analytics"
}

variable "tags" {
  type        = map(any)
  description = "Tags of the Network Security Group and flows logs"
}


