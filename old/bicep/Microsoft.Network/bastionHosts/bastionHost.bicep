@description('Name of the Bastion Host')
@minLength(2)
@maxLength(64)
param bastionHostName string

@description('Location of the Bastion Host')
param location string = resourceGroup().location

@description('IP allocations of the Bastion Host')
param ipConfigurations array

@description('DNS name of the Bastion Host, defaults to resource name')
param dnsName string = ''

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

param tags object

var ipConfigurations_var = [for item in ipConfigurations: {
  name: item.name
  properties: {
    privateIPAllocationMethod: contains(item, 'privateIPAddress') ? 'Static' : 'Dynamic'
    privateIPAddress: contains(item, 'privateIPAddress') ? item.privateIPAddress : json('null')
    subnet: {
      id: resourceId((contains(item, 'subnetSubscriptionId') ? item.subnetSubscriptionId : subscription().subscriptionId), (contains(item, 'subnetResourceGroupName') ? item.subnetResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', item.virtualNetworkName, 'AzureBastionSubnet')
    }
    publicIPAddress: {
      id: resourceId((contains(item, 'publicIPSubscriptionId') ? item.publicIPSubscriptionId : subscription().subscriptionId), (contains(item, 'publicIPResourceGroupName') ? item.publicIPResourceGroupName : resourceGroup().name), 'Microsoft.Network/publicIPAddresses', item.publicIPName)
    }
  }
}]
var dnsName_var = (empty(dnsName) ? bastionHostName : dnsName)
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName)
}

resource bastionHost 'Microsoft.Network/bastionHosts@2020-07-01' = {
  name: bastionHostName
  location: location
  tags: tags
  properties: {
    ipConfigurations: ipConfigurations_var
    dnsName: dnsName_var
  }
}

resource bastionHostDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: bastionHost
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
        category: 'BastionAuditLogs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
    ]
    workspaceId: logAnalyticsWorkspace.id
  }
}

output virtualNetwork object = bastionHost
