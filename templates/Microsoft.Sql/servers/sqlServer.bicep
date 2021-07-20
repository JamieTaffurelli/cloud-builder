@description('The name of the SQL Server that you wish to create.')
param sqlServerName string

@description('The location to deploy the SQL Server to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The username of the SQL admin')
param administratorLogin string = 'sqladmin'

@description('The password of the SQL admin')
@secure()
param administratorLoginPassword string

@description('Array of Firewall Rule resources, properties are: name, startIpAddress and EndIpAddressw')
param firewallRules array

@description('The state of the Security Alert Policy')
@allowed([
  'Enabled'
  'Disabled'
])
param securityAlertPolicyState string = 'Enabled'

@description('List of email addresses to send Security Alerts to')
param emailAddresses array

@description('The name of the AAD object to set as admin')
param aadLoginName string

@description('The object ID of the AAD object to set as admin')
@secure()
param aadObjectId string

@description('The Subscription ID of the Storage Account to send Threat Detection logs to')
param threatDetectionStorageAccountSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Storage Account to send Threat Detection logs to')
param threatDetectionStorageAccountResourceGroupName string = resourceGroup().name

@description('The name of the Storage Account to send Threat Detection logs to')
param threatDetectionStorageAccountName string

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource sqlServerName_resource 'Microsoft.Sql/servers@2015-05-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlServerName_master 'Microsoft.Sql/servers/databases@2017-10-01-preview' = {
  parent: sqlServerName_resource
  location: location
  name: 'master'
  properties: {}
}

resource sqlServerName_master_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2018-06-01-preview' = {
  parent: sqlServerName_master
  name: 'default'
  properties: {
    state: securityAlertPolicyState
    disabledAlerts: []
    emailAddresses: emailAddresses
    emailAccountAdmins: true
    storageEndpoint: 'https://${threatDetectionStorageAccountName}.blob.core.windows.net'
    storageAccountAccessKey: listKeys(resourceId(threatDetectionStorageAccountSubscriptionId, threatDetectionStorageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', threatDetectionStorageAccountName), providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value
    retentionDays: 365
  }
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_sqlServerName_master_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2017-03-01-preview' = {
  parent: sqlServerName_master
  name: 'default'
  properties: {
    storageContainerPath: 'https://${threatDetectionStorageAccountName}.blob.core.windows.net/${toLower(sqlServerName)}-vascans'
    storageAccountAccessKey: listKeys(resourceId(threatDetectionStorageAccountSubscriptionId, threatDetectionStorageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', threatDetectionStorageAccountName), providers('Microsoft.Storage', 'storageAccounts').apiVersions[0]).keys[0].value
    recurringScans: {
      isEnabled: true
      emailSubscriptionAdmins: true
      emails: emailAddresses
    }
  }
  dependsOn: [
    sqlServerName_master_Default
  ]
}

resource sqlServerName_master_Microsoft_Insights_service 'Microsoft.Sql/servers/databases//providers/diagnosticSettings@2015-07-01' = {
  name: '${sqlServerName}/master/Microsoft.Insights/service'
  properties: {
    metrics: [
      {
        category: 'Basic'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'InstanceAndAppAdvanced'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
    ]
    logs: [
      {
        category: 'SQLInsights'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AutomaticTuning'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'QueryStoreWaitStatistics'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'Errors'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'DatabaseWaitStatistics'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'Timeouts'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'Blocks'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'Deadlocks'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'Audit'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'SQLSecurityAuditEvents'
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
    sqlServerName_master
  ]
}

resource sqlServerName_Default 'Microsoft.Sql/servers/auditingSettings@2017-03-01-preview' = {
  parent: sqlServerName_resource
  name: 'default'
  properties: {
    state: 'Enabled'
    retentionDays: 365
    auditActionsAndGroups: [
      'SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP'
      'FAILED_DATABASE_AUTHENTICATION_GROUP'
      'BATCH_COMPLETED_GROUP'
    ]
    isAzureMonitorTargetEnabled: true
  }
}

resource sqlServerName_activeDirectory 'Microsoft.Sql/servers/administrators@2014-04-01' = {
  parent: sqlServerName_resource
  name: 'activeDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: aadLoginName
    sid: aadObjectId
    tenantId: subscription().tenantId
  }
}

resource sqlServerName_firewallRules_firewallRuleLoop_name 'Microsoft.Sql/servers/firewallRules@2014-04-01' = [for item in firewallRules: {
  location: location
  name: '${sqlServerName}/${item.name}'
  properties: {
    startIpAddress: item.startIpAddress
    endIpAddress: item.endIpAddress
  }
  dependsOn: [
    sqlServerName_resource
  ]
}]

output sqlServer object = reference(sqlServerName_resource.id, '2015-05-01-preview', 'Full')