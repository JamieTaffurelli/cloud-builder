@description('The name of the Public IP that you wish to create.')
@minLength(1)
@maxLength(80)
param publicIPName string

@description('The location to deploy the Public IP to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The SKU of the Public IP')
@allowed([
  'Basic'
  'Standard'
])
param sku string = 'Standard'

@description('Method of IP allocation when requested (static or dynamic)')
@allowed([
  'static'
  'dynamic'
])
param publicIpAllocationMethod string = 'static'

@description('Specifies IPv4 or IPv6 IP address')
@allowed([
  'IPv4'
  'IPv6'
])
param publicIPAddressVersion string = 'IPv4'

@description('Unique DNS Name')
param domainNameLabel string

@description('Domain name label, fqdn and reverse fqdn')
param dnsSettings object = {}

@description('List of tags for Public IP address')
param ipTags array = []

@description('Specify if allocation is static')
param ipAddress string = ''

@description('Idle timeout for inbound originated flow')
@minValue(4)
@maxValue(30)
param idleTimeoutInMinutes int = 4

@description('Specify Availability Zones')
param zones array = []

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var domainNameLabel_var = {
  domainNameLabel: domainNameLabel
}
var dnsSettings_var = union(domainNameLabel_var, dnsSettings)
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource publicIPName_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPName
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
    publicIPAddressVersion: publicIPAddressVersion
    dnsSettings: dnsSettings_var
    ipTags: ipTags
    ipAddress: ipAddress
    idleTimeoutInMinutes: idleTimeoutInMinutes
  }
  zones: zones
}

resource publicIPName_Microsoft_Insights_service 'Microsoft.Network/publicIPAddresses//providers/diagnosticSettings@2015-07-01' = {
  name: '${publicIPName}/Microsoft.Insights/service'
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
        category: 'DDoSProtectionNotifications'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'DDoSMitigationFlowLogs'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'DDoSMitigationReports'
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
    publicIPName_resource
  ]
}

output publicIP object = reference(publicIPName_resource.id, '2020-11-01', 'Full')