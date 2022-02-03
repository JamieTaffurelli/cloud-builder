variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the Log Analytics Workspace"
}

variable "location" {
  type        = string
  description = "Location of the Log Analytics Workspace"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics Workspace"
}

variable "internet_ingestion_enabled" {
  type        = bool
  default     = true
  description = "Allow data ingestion over public internet"
}

variable "internet_query_enabled" {
  type        = bool
  default     = true
  description = "Allow data queries over public internet"
}

variable "automation_account_name" {
  type        = string
  description = "Name of the linked Automation Account"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the linked Storage Account"
}

variable "network_watcher_name" {
  type        = string
  description = "Name of the network watcher"
}

variable "data_collection_rule_template_path" {
  type        = string
  description = "Path to Data Collection Rule ARM template"
}

variable "tags" {
  type        = map(any)
  description = "Tags of the Log Analytics Workspace"
}


