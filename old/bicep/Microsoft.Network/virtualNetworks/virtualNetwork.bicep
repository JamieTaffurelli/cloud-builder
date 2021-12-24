@description('Name of the Virtual Network')
@minLength(2)
@maxLength(64)
param virtualNetworkName string

@description('Location of the Virtual Network')
param location string = resourceGroup().location

@description('The CIDR ranges allocated to the Virtual Network')
param addressPrefixes array

@description('The DNS Servers to apply to Virtual Network. Default value [] will use Azure provided DNS')
param dnsServers array = []

@description('The subnets to provision in the Virtual Network')
param subnets array

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

param tags object

var subnets_var = [for item in subnets: {
  name: item.name
  properties: {
    addressPrefix: item.addressPrefix
    networkSecurityGroup: (contains(item, 'networkSecurityGroupName') ? json('{"id": "${resourceId((contains(item, 'networkSecurityGroupSubscriptionId') ? item.networkSecurityGroupSubscriptionId : subscription().subscriptionId), (contains(item, 'networkSecurityGroupResourceGroupName') ? item.networkSecurityGroupResourceGroupName : resourceGroup().name), 'Microsoft.Network/networkSecurityGroups', item.networkSecurityGroupName)}"}') : null)
    routeTable: (contains(item, 'routeTableName') ? json('{"id": "${resourceId((contains(item, 'routeTableNameSubscriptionId') ? item.routeTableNameSubscriptionId : subscription().subscriptionId), (contains(item, 'routeTableNameResourceGroupName') ? item.routeTableNameResourceGroupName : resourceGroup().name), 'Microsoft.Network/routeTables', item.routeTableName)}"}') : null)
    serviceEndpoints: (contains(item, 'serviceEndpoints') ? item.serviceEndpoints : null)
    privateEndpointNetworkPolicies: (contains(item, 'privateEndpointNetworkPolicies') ? item.privateEndpointNetworkPolicies : 'Disabled')
    privateLinkServiceNetworkPolicies: (contains(item, 'privateLinkServiceNetworkPolicies') ? item.privateLinkServiceNetworkPolicies : 'Disabled')
  }
}]
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName)
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    dhcpOptions: {
      dnsServers: dnsServers
    }
    subnets: subnets_var
    enableVmProtection: true
    enableDdosProtection: false
  }
}

resource virtualNetworkDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: virtualNetwork
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
        category: 'VMProtectionAlerts'
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

output virtualNetwork object = virtualNetwork
