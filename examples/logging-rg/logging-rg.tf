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

resource "azurerm_resource_group" "logs" {
  name     = var.resource_group_name
  location = var.location
}

locals {
  solutions = ["AgentHealthAssessment", "AlertManagement", "Security", "AzureActivity", "ChangeTracking", "Security", "ServiceMap", "SQLAdvancedThreatProtection", "SQLVulnerabilityAssessment", "Updates", "VMInsights"]
}

data "azurerm_subnet" "network" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}

resource "azurerm_log_analytics_workspace" "logging" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.logs.location
  resource_group_name = azurerm_resource_group.logs.name
  sku                 = "PerGB2018"
  retention_in_days   = 365
  tags                = var.tags
}

resource "azurerm_log_analytics_solution" "logging" {
  for_each              = toset(local.solutions)
  solution_name         = each.value
  location              = azurerm_resource_group.logs.location
  resource_group_name   = azurerm_resource_group.logs.name
  workspace_resource_id = azurerm_log_analytics_workspace.logging.id
  workspace_name        = azurerm_log_analytics_workspace.logging.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${each.value}"
  }
}

resource "azurerm_monitor_diagnostic_setting" "log_analytics_workspace_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_log_analytics_workspace.logging.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logging.id

  log {
    category = "Audit"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_automation_account" "logging" {
  name                = var.automation_account_name
  location            = azurerm_resource_group.logs.location
  resource_group_name = azurerm_resource_group.logs.name
  sku_name            = "Basic"
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "automation_account_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_automation_account.logging.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logging.id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "JobLogs"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "JobStreams"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "DSCNodeStatus"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 365
    }
  }
}

resource "azurerm_storage_account" "logging" {
  name                      = var.storage_account_name
  location                  = azurerm_resource_group.logs.location
  resource_group_name       = azurerm_resource_group.logs.name
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

resource "azurerm_storage_account_network_rules" "logging" {
  storage_account_id         = azurerm_storage_account.logging.id
  default_action             = "Deny"
  virtual_network_subnet_ids = [data.azurerm_subnet.network.id]
  bypass                     = ["Metrics", "Logging", "AzureServices"]
}

resource "azurerm_monitor_diagnostic_setting" "storage_account_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_storage_account.logging.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logging.id

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
  target_resource_id         = "${azurerm_storage_account.logging.id}/${each.value}/default/"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logging.id

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

resource "azurerm_log_analytics_linked_service" "logging" {
  resource_group_name = azurerm_resource_group.logs.name
  workspace_id        = azurerm_log_analytics_workspace.logging.id
  read_access_id      = azurerm_automation_account.logging.id
}

resource "azurerm_network_watcher" "logging" {
  name                = var.network_watcher_name
  resource_group_name = azurerm_resource_group.logs.name
  location            = azurerm_resource_group.logs.location
}

locals {
  event_sources = [
    {
      name           = "application"
      event_log_name = "Application"
    },
    {
      name           = "system"
      event_log_name = "System"
    },
    {
      name           = "task-diagnostic"
      event_log_name = "Microsoft-Windows-TaskScheduler/Diagnostic"
    },
    {
      name           = "task-maintenance"
      event_log_name = "Microsoft-Windows-TaskScheduler/Maintenance"
    },
    {
      name           = "task-operation"
      event_log_name = "Microsoft-Windows-TaskScheduler/Operational"
    }
  ]
}

resource "azurerm_log_analytics_datasource_windows_event" "events" {
  for_each            = { for event_source in local.event_sources : event_source.name => event_source }
  name                = each.value["name"]
  resource_group_name = azurerm_resource_group.logs.name
  workspace_name      = azurerm_log_analytics_workspace.logging.name
  event_log_name      = each.value["event_log_name"]
  event_types         = ["error", "warning", "information"]
}

locals {
  perf_sources = [
    {
      name         = "apppoolwaspoolstate"
      object_name  = "APP_POOL_WAS"
      counter_name = "Current Application Pool State"
    },
    {
      name         = "apppoolwaspoolrec"
      object_name  = "APP_POOL_WAS"
      counter_name = "Total Application Pool Recycles"
    },
    {
      name         = "apppoolwasprocfail"
      object_name  = "APP_POOL_WAS"
      counter_name = "Total Worker Process Failures"
    },
    {
      name         = "logicaldiskfreespace"
      object_name  = "LogicalDisk"
      counter_name = "% Free Space"
    },
    {
      name         = "logicaldiskavgdiskread"
      object_name  = "LogicalDisk"
      counter_name = "Avg. Disk sec/Read"
    },
    {
      name         = "logicaldiskavgdiskwrite"
      object_name  = "LogicalDisk"
      counter_name = "Avg. Disk sec/Write"
    },
    {
      name         = "logicaldiskdiskqueue"
      object_name  = "LogicalDisk"
      counter_name = "Current Disk Queue Length"
    },
    {
      name         = "logicaldiskdiskread"
      object_name  = "LogicalDisk"
      counter_name = "Disk Reads/sec"
    },
    {
      name         = "logicaldiskdisktrans"
      object_name  = "LogicalDisk"
      counter_name = "Disk Transfers/sec"
    },
    {
      name         = "logicaldiskdiskwrite"
      object_name  = "LogicalDisk"
      counter_name = "Disk Writes/sec"
    },
    {
      name         = "logicaldiskfreemb"
      object_name  = "LogicalDisk"
      counter_name = "Free Megabytes"
    },
    {
      name         = "memoryusedbyte"
      object_name  = "Memory"
      counter_name = "% Committed Bytes In Use"
    },
    {
      name         = "memoryfreemb"
      object_name  = "Memory"
      counter_name = "Available MBytes"
    },
    {
      name         = "networkadapterbyterec"
      object_name  = "Network Adapter"
      counter_name = "Bytes Received/sec"
    },
    {
      name         = "networkadapterbytesent"
      object_name  = "Network Adapter"
      counter_name = "Bytes Sent/sec"
    },
    {
      name         = "networkinterfacebytetotal"
      object_name  = "Network Interface"
      counter_name = "Bytes Total/sec"
    },
    {
      name         = "sqlagentalertsactive"
      object_name  = "SQLAgent:Alerts"
      counter_name = "Activated Alerts"
    },
    {
      name         = "sqlagentalertsactivemin"
      object_name  = "SQLAgent:Alerts"
      counter_name = "Alerts Activated/minute"
    },
    {
      name         = "sqlagentjobsactive"
      object_name  = "SQLAgent:Jobs"
      counter_name = "Active Jobs"
    },
    {
      name         = "sqlagentjobsfail"
      object_name  = "SQLAgent:Jobs"
      counter_name = "Failed Jobs"
    },
    {
      name         = "sqlagentrestart"
      object_name  = "SQLAgent:Statistics"
      counter_name = "SQL Server Restarted"
    },
    {
      name         = "sqldatabasesbrthrough"
      object_name  = "SQLServer:Databases"
      counter_name = "Backup/Restore Throughput/sec"
    },
    {
      name         = "sqldatabasesfilesize"
      object_name  = "SQLServer:Databases"
      counter_name = "Data File(s) Size (KB)"
    },
    {
      name         = "sqllockswaitms"
      object_name  = "SQLServer:Locks"
      counter_name = "Average Wait Time (ms)"
    },
    {
      name         = "sqllockslockrequest"
      object_name  = "SQLServer:Locks"
      counter_name = "Lock Requests/sec"
    },
    {
      name         = "sqllockslocktimeout"
      object_name  = "SQLServer:Locks"
      counter_name = "Lock Timeouts (timeout > 0)/sec"
    },
    {
      name         = "sqllockslocktimeoutsec"
      object_name  = "SQLServer:Locks"
      counter_name = "Lock Timeouts/sec"
    },
    {
      name         = "sqllocksdeadlock"
      object_name  = "SQLServer:Locks"
      counter_name = "Number of Deadlocks/sec"
    },
    {
      name         = "sqltransfreetempkb"
      object_name  = "SQLServer:Transactions"
      counter_name = "Free Space in tempdb (KB"
    },
    {
      name         = "sqltranstransactions"
      object_name  = "SQLServer:Transactions"
      counter_name = "Transactions"
    },
    {
      name         = "systemprocqueue"
      object_name  = "System"
      counter_name = "Processor Queue Length"
    },
    {
      name         = "tcpv4connfail"
      object_name  = "TCPv4"
      counter_name = "Connection Failures"
    },
    {
      name         = "tcpv4connact"
      object_name  = "TCPv4"
      counter_name = "Connections Active"
    },
    {
      name         = "tcpv4connest"
      object_name  = "TCPv4"
      counter_name = "Connections Established"
    }
  ]
}

resource "azurerm_log_analytics_datasource_windows_performance_counter" "perf" {
  for_each            = { for perf_source in local.perf_sources : perf_source.name => perf_source }
  name                = each.value["name"]
  resource_group_name = azurerm_resource_group.logs.name
  workspace_name      = azurerm_log_analytics_workspace.logging.name
  object_name         = each.value["object_name"]
  instance_name       = "*"
  counter_name        = each.value["counter_name"]
  interval_seconds    = 60
}

resource "azurerm_resource_group_template_deployment" "vmguesthealth" {
  name                = "vm-guest-health"
  resource_group_name = azurerm_resource_group.logs.name
  template_content    = file(var.data_collection_rule_template_path)
  parameters_content = jsonencode({
    "location" = {
      value = var.location
    },
    "destinationWorkspaceResourceId" = {
      value = azurerm_log_analytics_workspace.logging.id
    },
    "tags" = {
      value = var.tags
    }
  })
  deployment_mode = "Incremental"
  depends_on      = [azurerm_log_analytics_solution.logging]
}
