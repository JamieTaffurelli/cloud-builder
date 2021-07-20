@description('The name of the Flow Log that you wish to create.')
param flowLogName string

@description('The name of the Network Watcher that you wish to monitor the Flow Log')
param networkWatcherName string

@description('The location to deploy the Network Watcher to')
@allowed([
  'northeurope'
  'westeurope'
])
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

@description('The GUID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsId string

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The location of the Log Analytics Workspace to send diagnostics to')
@allowed([
  'northeurope'
  'westeurope'
])
param logAnalyticsLocation string = resourceGroup().location

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('The name of the Log Analytics Workspace to send diagnostics to')
@allowed([
  10
  60
])
param trafficAnalyticsInterval int = 10
param tags object

resource networkWatcherName_flowLogName 'Microsoft.Network/networkWatchers/flowLogs@2020-06-01' = {
  name: '${networkWatcherName}/${flowLogName}'
  location: location
  tags: tags
  properties: {
    targetResourceId: resourceId(nsgSubscriptionId, nsgResourceGroupName, 'Microsoft.Network/networkSecurityGroups', nsgName)
    storageId: resourceId(storageAccountSubscriptionId, storageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', storageAccountName)
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
        workspaceId: logAnalyticsId
        workspaceRegion: logAnalyticsLocation
        workspaceResourceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
        trafficAnalyticsInterval: trafficAnalyticsInterval
      }
    }
  }
}

output flowLog object = reference(networkWatcherName_flowLogName.id, '2020-06-01', 'Full')