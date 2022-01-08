terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.90"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    var.network_interface_id
  ]
  zone = var.zone

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_account_uri
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = var.disk_size_gb
  }

  source_image_id = var.source_image_id
  tags            = var.tags
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_key" "kv" {
  name         = var.key_vault_kek_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_virtual_machine_extension" "ade" {
  name                       = "AzureDiskEncryption"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = "2.2"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "EncryptionOperation": "EnableEncryption",
      "KeyEncryptionAlgorithm": "RSA-OAEP",
      "KeyVaultURL": "${data.azurerm_key_vault.kv.vault_uri}",
      "KeyEncryptionKeyURL": "${data.azurerm_key_vault.kv.vault_uri}keys/${var.key_vault_kek_name}/${var.key_vault_kek_version}",
      "KeyVaultResourceId": "${data.azurerm_key_vault.kv.id}",
      "KekVaultResourceId": "${data.azurerm_key_vault.kv.id}",
      "VolumeType": "All"
    }
SETTINGS
  tags     = var.tags
}

resource "azurerm_virtual_machine_extension" "logs" {
  name                       = "MicrosoftMonitoringAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "workspaceId": "${var.log_analytics_workspace_customer_id}"
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${var.log_analytics_workspace_customer_key}"
    }
PROTECTED_SETTINGS
  tags     = var.tags
}

resource "azurerm_virtual_machine_extension" "dep" {
  name                       = "DependencyAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentWindows"
  type_handler_version       = "9.10"
  auto_upgrade_minor_version = true
  tags     = var.tags
  depends_on = [azurerm_virtual_machine_extension.logs]
}

resource "azurerm_virtual_machine_extension" "av" {
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "AntimalwareEnabled": "true",
      "RealtimeProtectionEnabled": "true",
      "ScheduledScanSettings": {
        "isEnabled": "true",
        "scanType": "Quick",
        "day": "7",
        "time": "120"
      }
    }
SETTINGS
  tags     = var.tags
}

resource "azurerm_virtual_machine_extension" "nwa" {
  name                       = "NetworkWatcherAgentWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  tags                       = var.tags
}

resource "azurerm_virtual_machine_extension" "gh" {
  name                       = "GuestHealthWindowsAgent"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor.VirtualMachines.GuestHealth"
  type                       = "GuestHealthWindowsAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags     = var.tags
}
resource "azurerm_virtual_machine_extension" "bg" {
  name                       = "BGInfo"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "BGInfo"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true
  tags     = var.tags
}

resource "azurerm_mssql_virtual_machine" "vm" {
  virtual_machine_id    = azurerm_windows_virtual_machine.vm.id
  sql_license_type      = "PAYG"
  r_services_enabled    = false
  sql_connectivity_port = 1433
  sql_connectivity_type = "PRIVATE"
  sql_connectivity_update_password = var.sql_password
  sql_connectivity_update_username = var.sql_username
}

variable "sql_username" {
  type        = string
  description = "SQL sysadmin username"
}

variable "sql_password" {
  type        = string
  sensitive   = true
  description = "SQL sysadmin password"
}

data "azurerm_backup_policy_vm" "vm" {
  name                = var.backup_policy_name
  recovery_vault_name = var.recovery_services_vault_name
  resource_group_name = var.recovery_services_vault_resource_group_name
}

resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = var.recovery_services_vault_resource_group_name
  recovery_vault_name = var.recovery_services_vault_name
  source_vm_id        = azurerm_windows_virtual_machine.vm.id
  backup_policy_id    = data.azurerm_backup_policy_vm.vm.id
}

resource "azurerm_resource_group_template_deployment" "registerbackupsqlvm" {
  name                = "register-sql-${var.virtual_machine_name}"
  resource_group_name = var.recovery_services_vault_resource_group_name
  template_content    = file("..\\azure\\terraform\\arm-templates\\registerSqlVMBackup.json")
  parameters_content = jsonencode({
    "recoveryServicesVaultName" = {
      value = var.recovery_services_vault_name
    },
    "vmResourceGroupName" = {
      value = var.resource_group_name
    },
    "vmName" = {
      value = var.virtual_machine_name
    },
    "location" = {
      value = var.location
    },
    "tags" = {
      value = var.tags
    }
  })
  deployment_mode = "Incremental"
  depends_on      = [azurerm_mssql_virtual_machine.vm]
}

resource "azurerm_resource_group_template_deployment" "autobackupsqlvm" {
  name                = "auto-backup-sql-${var.virtual_machine_name}"
  resource_group_name = var.recovery_services_vault_resource_group_name
  template_content    = file("..\\azure\\terraform\\arm-templates\\registerSqlVMDatabaseAutoBackup.json")
  parameters_content = jsonencode({
    "recoveryServicesVaultName" = {
      value = var.recovery_services_vault_name
    },
    "backupPolicyName" = {
      value = var.sql_backup_policy_name
    },
    "vmResourceGroupName" = {
      value = var.resource_group_name
    },
    "vmName" = {
      value = var.virtual_machine_name
    },
    "location" = {
      value = var.location
    },
    "tags" = {
      value = var.tags
    }
  })
  deployment_mode = "Incremental"
  depends_on      = [azurerm_resource_group_template_deployment.registerbackupsqlvm]
}

resource "azurerm_monitor_diagnostic_setting" "virtual_machine_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_windows_virtual_machine.vm.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

