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
  name     = "logs1"
  location = "eastus"
}

module "logs" {
  source                       = "../azure/terraform/modules/log_analytics_workspace_with_solutions"
  location                     = azurerm_resource_group.logs.location
  resource_group_name          = azurerm_resource_group.logs.name
  log_analytics_workspace_name = "testinglogs123"
  automation_account_name      = "testingaa123"
  storage_account_name         = "testingsa123"
  network_watcher_name         = "testingnwa123"
  tags                         = {}
}

resource "azurerm_shared_image_gallery" "images" {
  name                = "testinggal123"
  resource_group_name = azurerm_resource_group.logs.name
  location            = azurerm_resource_group.logs.location
  description         = "Shared images and things."
  tags                = {}
}

resource "azurerm_shared_image" "images" {
  name                = "win2016-sql2017web"
  gallery_name        = azurerm_shared_image_gallery.images.name
  resource_group_name = azurerm_resource_group.logs.name
  location            = azurerm_resource_group.logs.location
  os_type             = "Windows"
  description         = "Windows server 2016 with SQL web edition"
  specialized         = false

  identifier {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2017-WS2016"
    sku       = "Web"
  }
  tags = {}
}

resource "azurerm_user_assigned_identity" "images" {
  name                = "image-builder"
  resource_group_name = azurerm_resource_group.logs.name
  location            = azurerm_resource_group.logs.location
  tags                = {}
}

resource "azurerm_role_assignment" "images" {
  scope                = azurerm_resource_group.logs.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.images.principal_id
}

/*
resource "azurerm_resource_group_template_deployment" "images" {
  name                = "win2016-sql2017web"
  resource_group_name = azurerm_resource_group.logs.name
  template_content    = file("../azure/terraform/arm-templates/imageBuilder.json")
  parameters_content = jsonencode({
    "imageTemplateName" = {
      value = "win2016-sql2017web"
    },
    "location" = {
      value = azurerm_resource_group.logs.location
    },
    "userAssignedIdentityId" = {
      value = azurerm_user_assigned_identity.images.id
    },
    "galleryImageId" = {
      value = azurerm_shared_image.images.id
    },
    "tags" = {
      value = {}
    }
  })
  deployment_mode = "Incremental"
  depends_on      = [azurerm_role_assignment.images]
}
*/

module "nsg" {
  source                              = "../azure/terraform/modules/network_security_group_with_diagnostics"
  location                            = azurerm_resource_group.logs.location
  resource_group_name                 = azurerm_resource_group.logs.name
  network_security_group_name         = "testingnsg123"
  network_watcher_resource_group_name = azurerm_resource_group.logs.name
  network_watcher_name                = "testingnwa123"
  storage_account_id                  = module.logs.storage_account_id
  log_analytics_workspace_id          = module.logs.log_analytics_workspace_customer_id
  log_analytics_workspace_location    = azurerm_resource_group.logs.location
  log_analytics_workspace_resource_id = module.logs.log_analytics_workspace_id
  tags                                = {}
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
  resource_group_name         = azurerm_resource_group.logs.name
  network_security_group_name = "testingnsg123"
  depends_on                  = [module.nsg]
}

resource "azurerm_virtual_network" "network" {
  name                = "testingvnet123"
  resource_group_name = azurerm_resource_group.logs.name
  location            = azurerm_resource_group.logs.location
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "sql"
    address_prefix = "10.0.1.0/24"
    security_group = module.nsg.network_security_group_id
  }
  tags = {}
}

resource "azurerm_monitor_diagnostic_setting" "virtual_network_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_virtual_network.network.id
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

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

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "encryption" {
  name                        = "testingkv12345"
  location                    = azurerm_resource_group.logs.location
  resource_group_name         = azurerm_resource_group.logs.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  enable_rbac_authorization   = false
  sku_name                    = "standard"
  tags                        = {}
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

resource "azurerm_monitor_diagnostic_setting" "key_vault_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_key_vault.encryption.id
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

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

resource "azurerm_key_vault_key" "encryption" {
  name         = "disk-encryption1"
  key_vault_id = azurerm_key_vault.encryption.id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  tags       = {}
  depends_on = [azurerm_key_vault_access_policy.me]
}

resource "azurerm_public_ip" "vm" {
  name                    = "testingpip123"
  resource_group_name     = azurerm_resource_group.logs.name
  location                = azurerm_resource_group.logs.location
  sku                     = "Standard"
  allocation_method       = "Static"
  sku_tier                = "Regional"
  availability_zone       = "Zone-Redundant"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
  tags                    = {}
}

resource "azurerm_monitor_diagnostic_setting" "public_ip_diagnostics" {
  name                       = "security-logging"
  target_resource_id         = azurerm_public_ip.vm.id
  log_analytics_workspace_id = module.logs.log_analytics_workspace_id

  log {
    category = "DDoSProtectionNotifications"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "DDoSMitigationFlowLogs"
    enabled  = true

    retention_policy {
      enabled = true
      days    = 365
    }
  }

  log {
    category = "DDoSMitigationReports"
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

resource "azurerm_network_interface" "vm" {
  name                          = "testingnic123"
  location                      = azurerm_resource_group.logs.location
  resource_group_name           = azurerm_resource_group.logs.name
  enable_ip_forwarding          = false
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.network.id}/subnets/sql"
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.vm.id
    primary                       = true
    private_ip_address            = "10.0.1.10"
  }
  tags = {}
}

module "recovery_services" {
  source                       = "../azure/terraform/modules/recovery_services_vault_with_policies"
  location                     = azurerm_resource_group.logs.location
  resource_group_name          = azurerm_resource_group.logs.name
  recovery_services_vault_name = "testingrsv123"
  log_analytics_workspace_id   = module.logs.log_analytics_workspace_id
  tags                         = {}
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
  depends_on = [module.recovery_services]
}

module "sql_vm" {
  source                                      = "../azure/terraform/modules/windows_sql_virtual_machine_shared_image"
  location                                    = azurerm_resource_group.logs.location
  resource_group_name                         = azurerm_resource_group.logs.name
  virtual_machine_name                        = "testingvm123"
  size                                        = "Standard_B2ms"
  admin_username                              = "servermonkey"
  admin_password                              = "asdhbasjdhbWW2)"
  network_interface_id                        = azurerm_network_interface.vm.id
  boot_diagnostics_storage_account_uri        = module.logs.storage_account_primary_blob_endpoint
  disk_size_gb                                = 127
  source_image_id                             = azurerm_shared_image.images.id
  zone                                        = 1
  key_vault_name                              = azurerm_key_vault.encryption.name
  key_vault_resource_group_name               = azurerm_resource_group.logs.name
  key_vault_kek_name                          = azurerm_key_vault_key.encryption.name
  key_vault_kek_version                       = azurerm_key_vault_key.encryption.version
  sql_username                                = "servermonkey"
  sql_password                                = "asdhbasjdhbWW2)"
  recovery_services_vault_name                = "testingrsv123"
  recovery_services_vault_resource_group_name = azurerm_resource_group.logs.name
  log_analytics_workspace_id                  = module.logs.log_analytics_workspace_id
  log_analytics_workspace_customer_id         = module.logs.log_analytics_workspace_customer_id
  log_analytics_workspace_customer_key        = module.logs.log_analytics_workspace_primary_shared_key
  data_collection_rule_id                     = module.logs.data_collection_rule_id
  tags                                        = {}
}

resource "azurerm_role_assignment" "aws_backup_rg_reader" {
  scope                = azurerm_resource_group.logs.id
  role_definition_name = "Reader"
  principal_id         = lookup(module.sql_vm.identity[0], "principal_id")
}

resource "azurerm_role_assignment" "aws_backup_vault_reader" {
  scope                = module.recovery_services.recovery_services_vault_id
  role_definition_name = "Backup Operator"
  principal_id         = lookup(module.sql_vm.identity[0], "principal_id")
}

resource "azurerm_role_assignment" "aws_virtual_machine_contributor" {
  scope                = module.sql_vm.virtual_machine_id
  role_definition_name = "Contributor"
  principal_id         = lookup(module.sql_vm.identity[0], "principal_id")
}
