terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.90"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.16"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "config" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "config" {
  name                      = var.storage_account_name
  location                  = azurerm_resource_group.config.location
  resource_group_name       = azurerm_resource_group.config.name
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
  shared_access_key_enabled = true

  blob_properties {

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }

  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "storage_account_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_storage_account.config.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  metric {
    category = "Transaction"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

locals {
  storageDiagnostics = ["blobServices", "fileServices", "tableServices", "queueServices"]
}

resource "azurerm_monitor_diagnostic_setting" "storage_account_child_diagnostics" {
  for_each                   = toset(local.storageDiagnostics)
  name                       = "security-logging"
  target_resource_id         = "${azurerm_storage_account.config.id}/${each.value}/default/"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "StorageRead"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "StorageDelete"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azuread_application" "github" {
  display_name = "GitHub Actions"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "github" {
  application_id               = azuread_application.github.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "github" {
  scope                = azurerm_resource_group.config.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.github.object_id
}
