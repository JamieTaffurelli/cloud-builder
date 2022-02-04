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

data "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

resource "azurerm_resource_group" "backup" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_recovery_services_vault" "backup" {
  name                = var.recovery_services_vault_name
  location            = azurerm_resource_group.backup.location
  resource_group_name = azurerm_resource_group.backup.name
  sku                 = "Standard"
  storage_mode_type   = "GeoRedundant"
  soft_delete_enabled = true

  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "recovery_services_vault_backup_diagnostics" {
  name                           = "security-logging-backup"
  target_resource_id             = azurerm_recovery_services_vault.backup.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.logs.id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "CoreAzureBackup"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AddonAzureBackupAlerts"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AddonAzureBackupJobs"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AddonAzureBackupPolicy"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AddonAzureBackupStorage"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AddonAzureBackupProtectedInstance"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "recovery_services_vault_site_recovery_diagnostics" {
  name                       = "security-logging-site-recovery"
  target_resource_id         = azurerm_recovery_services_vault.backup.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "AzureSiteRecoveryJobs"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzureSiteRecoveryEvents"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzureSiteRecoveryReplicatedItems"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzureSiteRecoveryReplicationStats"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzureSiteRecoveryRecoveryPoints"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzureSiteRecoveryReplicationDataUploadRate"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzureSiteRecoveryProtectedDiskDataChurn"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "Health"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_backup_policy_vm" "backup" {
  name                           = "VMBackupPolicy"
  resource_group_name            = azurerm_resource_group.backup.name
  recovery_vault_name            = var.recovery_services_vault_name
  timezone                       = "UTC"
  instant_restore_retention_days = 2

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 13
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 6
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }

  retention_yearly {
    count    = 1
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
  tags = var.tags
  depends_on = [
    azurerm_recovery_services_vault.backup
  ]
}

resource "azurerm_resource_group_template_deployment" "backup" {
  name                = "sql-backup-policy"
  resource_group_name = azurerm_resource_group.backup.name
  template_content    = file(var.sql_backup_policy_template_path)
  parameters_content = jsonencode({
    "recoveryServicesVaultName" = {
      value = var.recovery_services_vault_name
    },
    "location" = {
      value = azurerm_resource_group.backup.location
    },
    "tags" = {
      value = var.tags
    }
  })
  deployment_mode = "Incremental"
  depends_on      = [azurerm_recovery_services_vault.backup]
}
