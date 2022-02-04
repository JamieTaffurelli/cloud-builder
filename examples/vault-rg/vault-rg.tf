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

resource "azurerm_resource_group" "vault" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "encryption" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.vault.location
  resource_group_name         = azurerm_resource_group.vault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  enable_rbac_authorization   = false
  sku_name                    = "standard"
  tags                        = var.tags
}

resource "azurerm_key_vault_access_policy" "me" {
  key_vault_id = azurerm_key_vault.encryption.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  key_permissions = [
    "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
  ]
  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
  certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
}

resource "azurerm_key_vault_access_policy" "backup" {
  key_vault_id = azurerm_key_vault.encryption.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "6a71e386-f79a-44a4-8bfb-6f42e2ae92e5"
  key_permissions = [
    "Get", "List", "Backup"
  ]
  secret_permissions = [
    "Backup", "Get", "List"
  ]
}

resource "azurerm_monitor_diagnostic_setting" "key_vault_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_key_vault.encryption.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_key_vault_secret" "aws_backup" {
  name         = var.aws_access_key
  value        = var.aws_secret_key
  key_vault_id = azurerm_key_vault.encryption.id
}
