@description('Name of the Virtual Network')
@minLength(2)
@maxLength(64)
param virtualNetworkName string

@description('Location of the Virtual Network')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The CIDR ranges allocated to the Virtual Network')
param addressPrefixes array

@description('The DNS Servers to apply to Virtual Network. Default value [] will use Azure provided DNS')
param dnsServers array = []

@description('The subnets to provision in the Virtual Network')
param subnets array

@description('The CIDR range of the gateway subnet, leave empty to exclude gateway subnet deployment')
param gatewaySubnetPrefix string = ''

@description('The CIDR range of the Azure Firewall, leave empty to exclude Azure Firewall subnet deployment')
param azureFirewallSubnetPrefix string = ''

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Tags to apply to Virtual Network')
param tags object

var subnets_var = {
  subnets: [for item in subnets: {
    name: item.name
    properties: {
      addressPrefix: item.addressPrefix
      networkSecurityGroup: (contains(item, 'networkSecurityGroupName') ? json('{"id": "${resourceId((contains(item, 'networkSecurityGroupSubscriptionId') ? item.networkSecurityGroupSubscriptionId : subscription().subscriptionId), (contains(item, 'networkSecurityGroupResourceGroupName') ? item.networkSecurityGroupResourceGroupName : resourceGroup().name), 'Microsoft.Network/networkSecurityGroups', item.networkSecurityGroupName)}"}') : json('null'))
      routeTable: (contains(item, 'routeTableName') ? json('{"id": "${resourceId((contains(item, 'routeTableNameSubscriptionId') ? item.routeTableNameSubscriptionId : subscription().subscriptionId), (contains(item, 'routeTableNameResourceGroupName') ? item.routeTableNameResourceGroupName : resourceGroup().name), 'Microsoft.Network/routeTables', item.routeTableName)}"}') : json('null'))
      serviceEndpoints: (contains(item, 'serviceEndpoints') ? item.serviceEndpoints : json('null'))
    }
  }]
}
var gatewaySubnet = [
  {
    name: 'GatewaySubnet'
    properties: {
      addressPrefix: gatewaySubnetPrefix
    }
  }
]
var azureFirewallSubnet = [
  {
    name: 'AzureFirewallSubnet'
    properties: {
      addressPrefix: azureFirewallSubnetPrefix
    }
  }
]
var gatewaySubnetUnion = (empty(gatewaySubnetPrefix) ? subnets_var.subnets : union(subnets_var.subnets, gatewaySubnet))
var firewallSubnetUnion = (empty(azureFirewallSubnetPrefix) ? gatewaySubnetUnion : union(gatewaySubnetUnion, azureFirewallSubnet))
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2018-11-01' = {
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
    subnets: firewallSubnetUnion
    enableVmProtection: true
    enableDdosProtection: false
  }
}

resource virtualNetworkName_Microsoft_Insights_service 'Microsoft.Network/virtualNetworks//providers/diagnosticSettings@2015-07-01' = {
  name: '${virtualNetworkName}/Microsoft.Insights/service'
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
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    virtualNetworkName_resource
  ]
}

output virtualNetwork object = reference(virtualNetworkName_resource.id, '2018-11-01', 'Full')