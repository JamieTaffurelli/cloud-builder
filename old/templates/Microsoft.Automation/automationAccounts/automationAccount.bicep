@description('Name of the Automation Account')
param automationAccountName string

@description('Location of the Automation Account')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Tags to apply to Automation Account')
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource automationAccountName_resource 'Microsoft.Automation/automationAccounts@2015-10-31' = {
  name: automationAccountName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

resource automationAccountName_Microsoft_Insights_service 'Microsoft.Automation/automationAccounts//providers/diagnosticSettings@2015-07-01' = {
  name: '${automationAccountName}/Microsoft.Insights/service'
  properties: {
    metrics: [
      {
        category: 'AllMetrics'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
    ]
    logs: [
      {
        category: 'JobLogs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'JobStreams'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'DscNodeStatus'
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
    automationAccountName_resource
  ]
}

output automationAccount object = reference(automationAccountName_resource.id, '2015-10-31', 'Full')