@description('The name of the Network Security Group that you wish to create.')
@minLength(1)
@maxLength(80)
param nsgName string

@description('The location to deploy the Network Security Group to')
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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName)
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: securityRules
  }
}

resource nsgDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: nsg
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
    workspaceId: logAnalyticsWorkspace.id
  }
}

output networkSecurityGroup object = nsg
