variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the Recovery Services Vault"
}

variable "location" {
  type        = string
  description = "Location of the Recovery Services Vault"
}

variable "network_security_group_name" {
  type        = string
  description = "Name of the Network Security Group to deploy"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the Virtual Network to deploy"
}

variable "virtual_network_address_space" {
  type        = list(string)
  description = "Address space of the Virtual Network to deploy"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet to deploy"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Address space of the subnet to deploy"
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
  description = "Name of Storage Account to send diagnostics"
}

variable "storage_account_resource_group_name" {
  type        = string
  description = "Resource Group of Storage Account to send diagnostics"
}

variable "network_watcher_name" {
  type        = string
  description = "Name of Network Watcher to send diagnostics"
}

variable "network_watcher_resource_group_name" {
  type        = string
  description = "Resource Group of Network Watcher to send diagnostics"
}

variable "tags" {
  type        = map(string)
  description = "Tags of the Recovery Services Vault"
}
