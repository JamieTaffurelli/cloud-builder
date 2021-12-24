@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string

@description('The name of the Recovery Services Vault that you wish to create.')
param vaultName string

@description('The location to deploy the Recovery Services Vault to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The location of alert rules. Must be the same as the Log Analytics location')
param alertRuleLocation string = resourceGroup().location

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Enable Recovery Services Vault alert blueprint')
param enableAlerts bool = true

@description('Severity of Recovery Services Vault alert blueprint')
@allowed([
  0
  1
  2
  3
  4
])
param alertSeverity int = 0

@description('Frequency to run alert queries')
param alertEvaluationFrequencyInMinutes int = 5

@description('Time window to run alert queries')
param windowSizeInMinutes int = 5

@description('Resource IDs of Action Groups to invoke on alert')
param actionGroupIds array
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365
var backupPolicyTemplateVersion = '1.0.0.0'
var backupPolicyTemplateUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/Microsoft.RecoveryServices/vaults/backupPolicies/backupPolicy.${backupPolicyTemplateVersion}.json${templatesSas}'
var recoveryServicesBlueprintAlertTemplateVersion = '1.0.5.0'
var recoveryServicesBlueprintAlertTemplateUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/blueprints/recoveryServicesVaultAlerts.${recoveryServicesBlueprintAlertTemplateVersion}.json${templatesSas}'
var scheduleRunTimes = [
  '21/09/2016 05:30:00'
]

resource vaultName_resource 'Microsoft.RecoveryServices/vaults@2018-01-10' = {
  name: vaultName
  location: location
  tags: tags
  properties: {}
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
}

resource vaultName_Microsoft_Insights_service 'Microsoft.RecoveryServices/vaults//providers/diagnosticSettings@2015-07-01' = {
  name: '${vaultName}/Microsoft.Insights/service'
  properties: {
    metrics: []
    logs: [
      {
        category: 'AzureBackupReport'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'CoreAzureBackup'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AddonAzureBackupJobs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AddonAzureBackupAlerts'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AddonAzureBackupPolicy'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AddonAzureBackupStorage'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AddonAzureBackupProtectedInstance'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureSiteRecoveryJobs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureSiteRecoveryEvents'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureSiteRecoveryReplicatedItems'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureSiteRecoveryReplicationStats'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureSiteRecoveryRecoveryPoints'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureSiteRecoveryReplicationDataUploadRate'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureSiteRecoveryProtectedDiskDataChurn'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
    ]
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    vaultName_resource
  ]
}

module vaultName_iaas_backup '?' /*TODO: replace with correct path to [variables('backupPolicyTemplateUrl')]*/ = {
  name: '${vaultName}-iaas-backup'
  params: {
    backupPolicyName: 'iaas-backup'
    vaultName: vaultName
    properties: {
      backupManagementType: 'AzureIaasVM'
      instantRpRetentionRangeInDays: 5
      schedulePolicy: {
        scheduleRunFrequency: 'Daily'
        scheduleRunDays: null
        scheduleRunTimes: scheduleRunTimes
        schedulePolicyType: 'SimpleSchedulePolicy'
      }
      retentionPolicy: {
        dailySchedule: {
          retentionTimes: scheduleRunTimes
          retentionDuration: {
            count: 7
            durationType: 'Days'
          }
        }
        weeklySchedule: {
          daysOfTheWeek: [
            'Sunday'
            'Wednesday'
          ]
          retentionTimes: scheduleRunTimes
          retentionDuration: {
            count: 4
            durationType: 'Weeks'
          }
        }
        monthlySchedule: {
          retentionScheduleFormatType: 'Daily'
          retentionScheduleDaily: {
            daysOfTheMonth: [
              {
                date: 1
                isLast: false
              }
            ]
          }
          retentionScheduleWeekly: null
          retentionTimes: scheduleRunTimes
          retentionDuration: {
            count: 12
            durationType: 'Months'
          }
        }
        yearlySchedule: {
          retentionScheduleFormatType: 'Daily'
          monthsOfYear: [
            'January'
            'May'
            'September'
          ]
          retentionScheduleDaily: {
            daysOfTheMonth: [
              {
                date: 1
                isLast: false
              }
            ]
          }
          retentionScheduleWeekly: null
          retentionTimes: scheduleRunTimes
          retentionDuration: {
            count: 10
            durationType: 'Years'
          }
        }
        retentionPolicyType: 'LongTermRetentionPolicy'
      }
      timeZone: 'GMT Standard Time'
    }
    tags: tags
  }
  dependsOn: [
    vaultName_resource
  ]
}

module vaultName_recovery_service_alerts '?' /*TODO: replace with correct path to [variables('recoveryServicesBlueprintAlertTemplateUrl')]*/ = {
  name: '${vaultName}-recovery-service-alerts'
  params: {
    templateStorageAccountName: templateStorageAccountName
    templatesSas: templatesSas
    vaultNames: [
      vaultName
    ]
    logAnalyticsWorkspaceLocation: alertRuleLocation
    enabled: enableAlerts
    severity: alertSeverity
    frequencyInMinutes: alertEvaluationFrequencyInMinutes
    timeWindowInMinutes: windowSizeInMinutes
    actionGroupIds: actionGroupIds
    logAnalyticsName: logAnalyticsName
    tags: tags
  }
  dependsOn: [
    vaultName_resource
  ]
}

output vault object = reference(vaultName_resource.id, '2018-01-10', 'Full')