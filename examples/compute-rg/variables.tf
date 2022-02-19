variable "resource_group_name" {
  type        = string
  description = "Resource Group name of the virtual machine"
}

variable "location" {
  type        = string
  description = "Location of the virtual machine"
}

variable "virtual_machine_name" {
  type        = string
  description = "Name of the Virtual Machine"
}

variable "public_ip_name" {
  type        = string
  description = "Name of the public IP"
}

variable "network_interface_name" {
  type        = string
  description = "Name of the network interface"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}

variable "private_ip_address" {
  type        = string
  description = "Private IP address of the network interface"
}

variable "size" {
  type        = string
  description = "Size of the virtual machine"
}

variable "zone" {
  type        = number
  description = "Availability zone of the virtual machine"
}

variable "disk_size_gb" {
  type        = number
  default     = 127
  description = "Size of the os"
}

variable "sql_log_disk_name" {
  type        = string
  description = "Name of the Recovery Services Vault"
}

variable "sql_log_disk_lun" {
  type        = number
  validation {
      condition = var.sql_log_disk_lun >= 2
      error_message = "Lun must be greater or equal to 2."
  }
  description = "Name of the Recovery Services Vault"
}

variable "sql_log_disk_size_gb" {
  type        = number
  description = "Size of the os"
}

variable "sql_data_disk_name" {
  type        = string
  description = "Name of the Recovery Services Vault"
}

variable "sql_data_disk_lun" {
  type        = number
  validation {
      condition = var.sql_data_disk_lun >= 2
      error_message = "Lun must be greater or equal to 2."
  }
  description = "Name of the Recovery Services Vault"
}

variable "sql_data_disk_size_gb" {
  type        = number
  description = "Size of the os"
}

variable "data_collection_rule_association_template_path" {
  type        = string
  description = "Path to data collection rule association template"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of Log Analytics Workspace to send diagnostics"
}

variable "log_analytics_workspace_resource_group_name" {
  type        = string
  description = "Resource Group of Log Analytics Workspace to send diagnostics"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of virtual network to deploy virtual machine to"
}

variable "virtual_network_resource_group_name" {
  type        = string
  description = "Resource Group name of virtual network to deploy virtual machine to"
}

variable "key_vault_name" {
  type        = string
  description = "Name of key vault for disk encryption"
}

variable "key_vault_resource_group_name" {
  type        = string
  description = "Resource Group name of key vault for disk encryption"
}

variable "storage_account_name" {
  type        = string
  description = "Name of Storage Account to send diagnostics"
}

variable "storage_account_resource_group_name" {
  type        = string
  description = "Resource Group of Storage Account to send diagnostics"
}

variable "shared_image_name" {
  type        = string
  description = "Name of the image to use for the virtual machine"
}

variable "shared_image_gallery_name" {
  type        = string
  description = "name of image gallery to pull image from"
}

variable "shared_image_gallery_resource_group_name" {
  type        = string
  description = "Resource Group of image gallery to pull image from"
}

variable "data_collection_rule_name" {
  type        = string
  default     = "Microsoft-VMInsights-Health"
  description = "Name of data collection rule to associate with"
}

variable "data_collection_rule_resource_group_name" {
  type        = string
  description = "Resource Group of the data collection rule to associate with"
}

variable "tags" {
  type        = map(string)
  description = "Tags of the Virtual Machine"
}
