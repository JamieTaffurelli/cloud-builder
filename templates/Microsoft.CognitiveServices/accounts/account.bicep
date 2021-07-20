@description('Name of the Cognitive Service Account.')
param accountName string

@description('Location of the Cognitive Service Account.')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Cognitive Services API type')
param kind string

@description('Optional subdomain for token authentication')
param customSubDomainName string = ''

@description('Allowed IP addresses to connect')
param ipRules array = []

@description('Allowed virtual networks to connect')
param virtualNetworkRules array = []

@description('Private Endpoints for Cognitive Services Account')
param privateEndpointConnections array = []

@description('Enable or disabled public internet access')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Special API properties')
@secure()
param apiProperties object = {}

@description('Sku to use')
param skuName string

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365
var networkProperties = {
  networkAcls: {
    defaultAction: 'Deny'
    ipRules: ipRules
    virtualNetworkRules: virtualNetworkRules
  }
}
var miscProperties = {
  customSubDomainName: customSubDomainName
  privateEndpointConnections: privateEndpointConnections
  publicNetworkAccess: publicNetworkAccess
  apiProperties: apiProperties
}
var properties = ((empty(ipRules) && empty(ipRules)) ? miscProperties : union(miscProperties, networkProperties))

resource accountName_resource 'Microsoft.CognitiveServices/accounts@2017-04-18' = {
  name: accountName
  location: location
  tags: tags
  kind: kind
  properties: properties
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource accountName_Microsoft_Insights_service 'Microsoft.CognitiveServices/accounts//providers/diagnosticSettings@2015-07-01' = {
  name: '${accountName}/Microsoft.Insights/service'
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
        category: 'Audit'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'RequestResponse'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'Trace'
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
    accountName_resource
  ]
}

output account object = reference(accountName_resource.id, '2017-04-18', 'Full')