@description('The name of the Flow Log that you wish to create.')
param flowLogName string

@description('The name of the Network Watcher that you wish to monitor the Flow Log')
param networkWatcherName string

@description('The location to deploy the Network Watcher to')
param location string = resourceGroup().location

@description('The Subscription ID of the NSG to to monitor')
param nsgSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the NSG to to monitor')
param nsgResourceGroupName string = resourceGroup().name

@description('The name of the NSG to to monitor')
param nsgName string

@description('The Subscription ID of the Storage Account to send logs to')
param storageAccountSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Storage Account to send logs to')
param storageAccountResourceGroupName string = resourceGroup().name

@description('The name of the Storage Account to send logs to')
param storageAccountName string

@description('Enable the Flow Log')
param enabled bool = true

@description('The number of days to retain logs')
@minValue(1)
@maxValue(90)
param retentionInDays int = 90

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('The name of the Log Analytics Workspace to send diagnostics to')
@allowed([
  10
  60
])
param trafficAnalyticsInterval int = 10

param tags object

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-07-01' existing = {
  name: nsgName
  scope: resourceGroup(nsgSubscriptionId, nsgResourceGroupName)
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
  scope: resourceGroup(storageAccountSubscriptionId, storageAccountResourceGroupName)
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName)
}

resource networkWatcher 'Microsoft.Network/networkWatchers@2020-06-01' existing = {
  name: networkWatcherName
}

resource flowLog 'Microsoft.Network/networkWatchers/flowLogs@2020-06-01' = {
  name: '${networkWatcher.name}/${flowLogName}'
  location: location
  tags: tags
  properties: {
    targetResourceId: nsg.id
    storageId: storageAccount.id
    enabled: enabled
    retentionPolicy: {
      days: retentionInDays
      enabled: true
    }
    format: {
      type: 'JSON'
      version: 2
    }
    flowAnalyticsConfiguration: {
      networkWatcherFlowAnalyticsConfiguration: {
        enabled: true
        workspaceId: logAnalytics.properties.customerId
        workspaceRegion: logAnalytics.location
        workspaceResourceId: logAnalytics.id
        trafficAnalyticsInterval: trafficAnalyticsInterval
      }
    }
  }
}

output flowLog object = flowLog
