@description('Name of the Event Hub Namespace')
param eventHubNamespaceName string

@description('Location of the Event Hub Namespace')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The messaging tier for Event Hub Namespace')
@allowed([
  'Basic'
  'Standard'
])
param sku string = 'Standard'

@description('Throughput units for Event Hub Namespace')
@minValue(1)
@maxValue(20)
param capacity int = 1

@description('Enable Auto Inflation for the Event Hub Namespace')
param isAutoInflateEnabled bool = true

@description('Maximum throughput units for Event Hub Namespace when Auto Inflate is enabled')
@minValue(0)
@maxValue(20)
param maximumThroughputUnits int = 1

@description('Enable Kafka for the Event Hub Namespace')
param kafkaEnabled bool = false

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Tags to apply to Event Hub Namespace')
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource eventHubNamespaceName_resource 'Microsoft.EventHub/namespaces@2018-11-01' = {
  name: eventHubNamespaceName
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
    capacity: capacity
  }
  properties: {
    isAutoInflateEnabled: isAutoInflateEnabled
    maximumThroughputUnits: maximumThroughputUnits
    kafkaEnabled: kafkaEnabled
  }
}

resource eventHubNamespaceName_Microsoft_Insights_service 'Microsoft.EventHub/namespaces//providers/diagnosticSettings@2015-07-01' = {
  name: '${eventHubNamespaceName}/Microsoft.Insights/service'
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
        category: 'ArchiveLogs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'OperationLogs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AutoscaleLogs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'KafkaCoordinatorLogs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'EventHubVNetConnectionEvent'
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
    eventHubNamespaceName_resource
  ]
}