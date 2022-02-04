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

data "azurerm_resource_group" "backup" {
  name = var.recovery_services_vault_resource_group_name
}

data "azurerm_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = var.virtual_machine_resource_group_name
}

data "azurerm_recovery_services_vault" "backup" {
  name                = var.recovery_services_vault_name
  resource_group_name = var.recovery_services_vault_resource_group_name
}

data "azurerm_backup_policy_vm" "vm" {
  name                = var.backup_policy_name
  recovery_vault_name = var.recovery_services_vault_name
  resource_group_name = var.recovery_services_vault_resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "aws_backup_rg_reader" {
  scope                = data.azurerm_resource_group.backup.id
  role_definition_name = "Reader"
  principal_id         = lookup(data.azurerm_virtual_machine.vm.identity[0], "principal_id")
}

resource "azurerm_role_assignment" "aws_backup_vault_operator" {
  scope                = data.azurerm_recovery_services_vault.backup.id
  role_definition_name = "Backup Operator"
  principal_id         = lookup(data.azurerm_virtual_machine.vm.identity[0], "principal_id")
}

resource "azurerm_role_assignment" "aws_virtual_machine_contributor" {
  scope                = data.azurerm_virtual_machine.vm.id
  role_definition_name = "Contributor"
  principal_id         = lookup(data.azurerm_virtual_machine.vm.identity[0], "principal_id")
}

resource "azurerm_key_vault_access_policy" "vm" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = lookup(data.azurerm_virtual_machine.vm.identity[0], "principal_id")
  secret_permissions = [
    "Get", "List"
  ]
}

resource "azurerm_backup_protected_vm" "vm" {
  resource_group_name = var.recovery_services_vault_resource_group_name
  recovery_vault_name = var.recovery_services_vault_name
  source_vm_id        = data.azurerm_virtual_machine.vm.id
  backup_policy_id    = data.azurerm_backup_policy_vm.vm.id
}

resource "azurerm_resource_group_template_deployment" "registerbackupsqlvm" {
  name                = "register-sql-${var.virtual_machine_name}"
  resource_group_name = var.recovery_services_vault_resource_group_name
  template_content    = file("..\\..\\..\\azure\\terraform\\arm-templates\\registerSqlVMBackup.json")
  parameters_content = jsonencode({
    "recoveryServicesVaultName" = {
      value = var.recovery_services_vault_name
    },
    "vmResourceGroupName" = {
      value = var.virtual_machine_resource_group_name
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
}

resource "azurerm_resource_group_template_deployment" "autobackupsqlvm" {
  name                = "auto-backup-sql-${var.virtual_machine_name}"
  resource_group_name = var.recovery_services_vault_resource_group_name
  template_content    = file("..\\..\\..\\azure\\terraform\\arm-templates\\registerSqlVMDatabaseAutoBackup.json")
  parameters_content = jsonencode({
    "recoveryServicesVaultName" = {
      value = var.recovery_services_vault_name
    },
    "backupPolicyName" = {
      value = var.sql_backup_policy_name
    },
    "vmResourceGroupName" = {
      value = var.virtual_machine_resource_group_name
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
