@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string

@description('The names of the Recovery Services Vaults to monitor')
param vaultNames array

@description('Location of Log Analytics Workspace to query')
param logAnalyticsWorkspaceLocation string = resourceGroup().location

@description('The Resource Group of the Log Analytics Workspace to query')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to query')
param logAnalyticsName string

@description('Severity of the Alert')
@allowed([
  0
  1
  2
  3
  4
])
param severity int

@description('Enable or Disable the Metric Alert')
param enabled bool = true

@description('How often to run Scheduled Query Rules')
param frequencyInMinutes int = 5

@description('Time period in which to run Scheduled Query Rules')
param timeWindowInMinutes int = 5

@description('Resource IDs of Action Groups to invoke')
param actionGroupIds array

@description('Tags to apply to Metric Alert')
param tags object

var templateBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/'
var scheduledQueryRuleBaseUrl = '${templateBaseUrl}Microsoft.Insights/scheduledQueryRules/'
var recoveryServiceAlertTriggeredRuleTemplateUrl = '${scheduledQueryRuleBaseUrl}recoveryServiceAlertTriggeredRule.1.0.1.0.json${templatesSas}'
var recoveryServiceBackupFailedRuleTemplateUrl = '${scheduledQueryRuleBaseUrl}recoveryServiceBackupFailedRule.1.0.2.0.json${templatesSas}'
var recoveryServiceFailoverRuleTemplateUrl = '${scheduledQueryRuleBaseUrl}recoveryServiceFailoverRule.1.0.3.0.json${templatesSas}'
var recoveryServiceRecoveryJobFailedRuleTemplateUrl = '${scheduledQueryRuleBaseUrl}recoveryServiceRecoveryJobFailedRule.1.0.2.0.json${templatesSas}'
var recoveryServiceReplicationRuleTemplateUrl = '${scheduledQueryRuleBaseUrl}recoveryServiceReplicationRule.1.0.2.0.json${templatesSas}'

module vaultNames_recovery_service_alert_triggered '?' /*TODO: replace with correct path to [variables('recoveryServiceAlertTriggeredRuleTemplateUrl')]*/ = [for item in vaultNames: {
  name: '${item}-recovery-service-alert-triggered'
  params: {
    vaultName: item
    location: logAnalyticsWorkspaceLocation
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} backup alerts are being triggered in Log Analytics'
    }
    tags: tags
  }
}]

module vaultNames_recovery_service_backup_failed_alert '?' /*TODO: replace with correct path to [variables('recoveryServiceBackupFailedRuleTemplateUrl')]*/ = [for item in vaultNames: {
  name: '${item}-recovery-service-backup-failed-alert'
  params: {
    vaultName: item
    location: logAnalyticsWorkspaceLocation
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} backup jobs are failing'
    }
    tags: tags
  }
}]

module vaultNames_recovery_service_failover_alert '?' /*TODO: replace with correct path to [variables('recoveryServiceFailoverRuleTemplateUrl')]*/ = [for item in vaultNames: {
  name: '${item}-recovery-service-failover-alert'
  params: {
    vaultName: item
    location: logAnalyticsWorkspaceLocation
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} failover health is not normal'
    }
    tags: tags
  }
}]

module vaultNames_recovery_service_job_alert '?' /*TODO: replace with correct path to [variables('recoveryServiceRecoveryJobFailedRuleTemplateUrl')]*/ = [for item in vaultNames: {
  name: '${item}-recovery-service-job-alert'
  params: {
    vaultName: item
    location: logAnalyticsWorkspaceLocation
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} recovery jobs are failing'
    }
    tags: tags
  }
}]

module vaultNames_recovery_service_replication_alert '?' /*TODO: replace with correct path to [variables('recoveryServiceReplicationRuleTemplateUrl')]*/ = [for item in vaultNames: {
  name: '${item}-recovery-service-replication-alert'
  params: {
    vaultName: item
    location: logAnalyticsWorkspaceLocation
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} replication health is not normal'
    }
    tags: tags
  }
}]