@description('The name of the firewall')
param firewallName string

@description('The location to deploy the Route Table to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Application rules for the firewall')
param applicationRuleCollections array = []

@description('NAT rules for the firewall')
param natRuleCollections array = []

@description('Applications rules for the firewall')
param networkRuleCollections array = []

@description('IP configurations rules for the firewall')
param ipConfigurations array

@description('Operation mode for threat intelligence')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param threatIntelMode string = 'Deny'

@description('The Subscription ID of the firewall policy Workspace to send diagnostics to')
param firewallPolicySubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the firewall policy')
param firewallPolicyResourceGroupName string = resourceGroup().name

@description('The name of the firewall policy')
param firewallPolicyName string

@description('Sku of firewall')
@allowed([
  'Standard'
  'Premium'
])
param skuTier string = 'Standard'

@description('Zone redundancy settings')
param zones array = []

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Tags to apply to firewall')
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource firewallName_resource 'Microsoft.Network/azureFirewalls@2020-07-01' = {
  name: firewallName
  location: location
  tags: tags
  properties: {
    applicationRuleCollections: applicationRuleCollections
    natRuleCollections: natRuleCollections
    networkRuleCollections: networkRuleCollections
    ipConfigurations: ipConfigurations
    threatIntelMode: threatIntelMode
    firewallPolicy: {
      id: resourceId(firewallPolicySubscriptionId, firewallPolicyResourceGroupName, 'Microsoft.Network/firewallPolicies', firewallPolicyName)
    }
    sku: {
      name: 'AZFW_VNet'
      tier: skuTier
    }
  }
  zones: zones
}

resource firewallName_Microsoft_Insights_service 'Microsoft.Network/azureFirewalls//providers/diagnosticSettings@2015-07-01' = {
  name: '${firewallName}/Microsoft.Insights/service'
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
        category: 'AzureFirewallApplicationRule'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureFirewallNetworkRule'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AzureFirewallDNSProxy'
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
    firewallName_resource
  ]
}

output firewall object = reference(firewallName_resource.id, '2020-07-01', 'Full')