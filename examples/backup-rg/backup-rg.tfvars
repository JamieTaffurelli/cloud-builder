resource_group_name                         = "backup"
location                                    = "eastus"
recovery_services_vault_name                = "rsv"
log_analytics_workspace_name                = "logging-law"
log_analytics_workspace_resource_group_name = "logging"
sql_backup_policy_template_path             = "../../azure/arm-templates/sqlRecoveryServicesVaultBackupPolicy.json"
tags                                        = {}
