@description('The name of the Service Bus Namespace that you wish to create.')
param serviceBusName string

@description('The location to deploy the Service Bus Namespace to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The sku of the the Service Bus Namespace to')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param skuName string = 'Basic'

@description('The number of messaging units for the Service Bus Namespace')
@allowed([
  1
  2
  4
])
param capacity int = 1

@description('Make Service Bus Namespace Zone Redundant')
param zoneRedundant bool = false

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource serviceBusName_resource 'Microsoft.ServiceBus/namespaces@2018-01-01-preview' = {
  name: serviceBusName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuName
    capacity: capacity
  }
  properties: {
    zoneRedundant: zoneRedundant
    identity: {
      type: 'SystemAssigned'
    }
  }
}

resource serviceBusName_Microsoft_Insights_service 'Microsoft.ServiceBus/namespaces//providers/diagnosticSettings@2015-07-01' = {
  name: '${serviceBusName}/Microsoft.Insights/service'
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
        category: 'OperationalLogs'
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
    serviceBusName_resource
  ]
}

output serviceBus object = reference(serviceBusName_resource.id, '2018-01-01-preview', 'Full')