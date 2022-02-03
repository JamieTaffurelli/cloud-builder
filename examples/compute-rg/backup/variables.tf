variable "location" {
  type        = string
  description = "Location of the backup item deployment"
}

variable "virtual_machine_resource_group_name" {
  type        = string
  description = "Resource Group of the Virtual Machine to backup"
}

variable "virtual_machine_name" {
  type        = string
  description = "Name of the Virtual Machine to backup"
}

variable "recovery_services_vault_resource_group_name" {
  type        = string
  description = "Resource Group of Recovery Services Vault to send backups to"
}

variable "recovery_services_vault_name" {
  type        = string
  description = "Name of Recovery Services Vault to send backups to"
}

variable "backup_policy_name" {
  type        = string
  default     = "VMBackupPolicy"
  description = "Name of VM backup policy to assign"
}

variable "key_vault_resource_group_name" {
  type        = string
  description = "Resource Group of Key Vault to apply access policy for Managed Identity"
}

variable "key_vault_name" {
  type        = string
  description = "Name of Key Vault to apply access policy for Managed Identity"
}

variable "sql_backup_policy_name" {
  type        = string
  default     = "HourlyLogBackup"
  description = "Name of the SQL backup policy"
}

variable "tags" {
  type        = map(string)
  description = "Tags of the Virtual Machine"
}
