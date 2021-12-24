@description('The name of the Network Interface that you wish to create.')
@minLength(1)
@maxLength(80)
param nicName string

@description('The location to deploy the Network Interface to')
param location string = resourceGroup().location

@description('IP configurations for the Network Interface')
param ipConfigurations array

@description('Specifies DNS servers the Network Interface should use, default is Azure Provided DNS')
param dnsServers array = []

@description('Relative DNS name for Network Interface for communication between VMs in the same Virtual Network')
param internalDnsNameLabel string = ''

@description('Enables bypassing of host and switch whilst maintaining policies')
param enableAcceleratedNetworking bool = false

@description('Allows forwarding of traffic to other IP addresses')
param enableIpForwarding bool = false

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

param tags object

var ipConfigurationsProperties = [for item in ipConfigurations: {
  privateIPAllocationMethod: contains(item, 'privateIPAddress') ? 'Static' : 'Dynamic'
  privateIPAddress: contains(item, 'privateIPAddress') ? item.privateIPAddress : json('null')
  subnet: {
    id: resourceId((contains(item, 'subnetSubscriptionId') ? item.subnetSubscriptionId : subscription().subscriptionId), (contains(item, 'subnetResourceGroupName') ? item.subnetResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', item.virtualNetworkName, item.subnetName)
  }
  primary: (contains(item, 'isPrimary') ? item.isPrimary : json('true'))
  privateIPAddressVersion: (contains(item, 'privateIPAddressVersion') ? item.privateIPAddressVersion : 'IPv4')
}]
var publicIps = [for item in ipConfigurations: {
  publicIPAddress: {
    id: (contains(item, 'publicIpAddressName') ? resourceId((contains(item, 'publicIpAddressSubscriptionId') ? item.publicIpAddressSubscriptionId : subscription().subscriptionId), (contains(item, 'publicIpAddressResourceGroupName') ? item.publicIpAddressResourceGroupName : resourceGroup().name), 'Microsoft.Network/publicIPAddresses', item.publicIpAddressName) : '')
  }
}]
var ipConfigurationsPublic = [for (item, j) in ipConfigurations: {
  name: item.name
  properties: ((publicIps[j].publicIPAddress.id == '') ? ipConfigurationsProperties[j] : union(ipConfigurationsProperties[j], publicIps[j]))
}]
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName)
}

resource nic 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: ipConfigurationsPublic
    dnsSettings: {
      dnsServers: dnsServers
      internalDnsNameLabel: (empty(internalDnsNameLabel) ? json('null') : internalDnsNameLabel)

    }
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableIPForwarding: enableIpForwarding
  }
}

resource nicDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: nic
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
    workspaceId: logAnalyticsWorkspace.id
  }
}

output networkInterface object = nic
