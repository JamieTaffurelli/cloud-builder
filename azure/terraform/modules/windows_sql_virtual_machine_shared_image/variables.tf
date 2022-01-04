variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the Virtual Machine"
}

variable "location" {
  type        = string
  description = "Location of the Virtual Machine"
}

variable "virtual_machine_name" {
  type        = string
  description = "Name of the Virtual Machine"
}

variable "size" {
  type        = string
  description = "Size of the Virtual Machine"
}

variable "admin_username" {
  type        = string
  description = "Username of local admin account"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Password of local admin account"
}

variable "network_interface_id" {
  type        = string
  description = "Resource ID of the Network Interface"
}

variable "boot_diagnostics_storage_account_uri" {
  type        = string
  description = "Primary or Secondary endpoint for boot diagnostics"
}

variable "disk_size_gb" {
  type        = string
  description = "Size in GB of OS disk"
}

variable "source_image_id" {
  type        = string
  description = "Resource ID of the image in the Shared Image Gallery"
}

variable "zone" {
  type        = string
  description = "Availability Zone to deploy Virtual Machine to"
}

variable "key_vault_name" {
  type        = string
  description = "Name of Key Vault used for disk encryption"
}

variable "key_vault_resource_group_name" {
  type        = string
  description = "Resource Group name of Key Vault used for disk encryption"
}

variable "key_vault_kek_name" {
  type        = string
  description = "Name of the key used for disk encryption"
}

variable "key_vault_kek_version" {
  type        = string
  description = "Version of the key used for disk encryption"
}

variable "recovery_services_vault_resource_group_name" {
  type        = string
  description = "Resource Group Name of the Recovery Services Vault"
}

variable "recovery_services_vault_name" {
  type        = string
  description = "Name of the Recovery Services Vault"
}

variable "backup_policy_name" {
  type        = string
  default     = "VMBackupPolicy"
  description = "Name of the VM backup policy"
}

variable "sql_backup_policy_name" {
  type        = string
  default     = "HourlyLogBackup"
  description = "Name of the SQL database backup policy"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Resource ID of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_customer_id" {
  type        = string
  description = "Customer ID of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_customer_key" {
  type        = string
  sensitive   = true
  description = "Customer key of Log Analytics Workspace to send diagnostics"
}

variable "tags" {
  type        = map(any)
  description = "Tags of the Log Analytics Workspace"
}


