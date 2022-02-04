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

resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group_name
}

data "azurerm_storage_account" "logs" {
  name                = var.storage_account_name
  resource_group_name = var.storage_account_resource_group_name
}

resource "azurerm_network_security_group" "network" {
  name                = var.network_security_group_name
  resource_group_name = azurerm_resource_group.network.name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "network_security_group_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_network_security_group.network.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

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
  storage_account_id        = data.azurerm_storage_account.logs.id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = 365
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = data.azurerm_log_analytics_workspace.logs.workspace_id
    workspace_region      = data.azurerm_log_analytics_workspace.logs.location
    workspace_resource_id = data.azurerm_log_analytics_workspace.logs.id
    interval_in_minutes   = 10
  }
  tags = var.tags
}

resource "azurerm_network_security_rule" "network" {
  name                        = "in-rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = azurerm_network_security_group.network.name
}

resource "azurerm_virtual_network" "network" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  address_space       = var.virtual_network_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "sql" {
  name                 = "sql"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_subnet_network_security_group_association" "sql" {
  subnet_id                 = azurerm_subnet.sql.id
  network_security_group_id = azurerm_network_security_group.network.id
}

resource "azurerm_monitor_diagnostic_setting" "virtual_network_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_virtual_network.network.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logs.id

  log {
    category = "VMProtectionAlerts"
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
