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

resource "azurerm_network_security_group" "network" {
  name                = "testingnsg123"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}


resource "azurerm_monitor_diagnostic_setting" "network_security_group_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_network_security_group.network.id
  log_analytics_workspace_id = var.log_analytics_workspace_resource_id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_network_watcher_flow_log" "network" {
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.network_watcher_resource_group_name
  network_security_group_id = azurerm_network_security_group.network.id
  storage_account_id        = var.storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 365
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.log_analytics_workspace_location
    workspace_resource_id = var.log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }
  tags = var.tags
}
