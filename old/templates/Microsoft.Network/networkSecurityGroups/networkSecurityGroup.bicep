@description('The name of the Network Security Group that you wish to create.')
@minLength(1)
@maxLength(80)
param nsgName string

@description('The location to deploy the Network Security Group to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Rules to apply to the nsg')
param securityRules array = []

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource nsgName_resource 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: securityRules
  }
}

resource nsgName_Microsoft_Insights_service 'Microsoft.Network/networkSecurityGroups//providers/diagnosticSettings@2015-07-01' = {
  name: '${nsgName}/Microsoft.Insights/service'
  properties: {
    metrics: []
    logs: [
      {
        category: 'NetworkSecurityGroupEvent'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'NetworkSecurityGroupRuleCounter'
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
    nsgName_resource
  ]
}

output networkSecurityGroup object = reference(nsgName_resource.id, '2020-06-01', 'Full')