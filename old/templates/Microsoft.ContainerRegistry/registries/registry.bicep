@description('The name of the Container Registry you wish to create')
param registryName string

@description('The location to deploy the Container Registry to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The sku of the Container Registry')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Basic'

@description('Enable admin user on the container registry')
param adminUserEnabled bool = false

@description('Allow or Deny traffic from subnets, allowed properties are: subnetId (resource ID of subnet) and action (Allow or Deny, defaults to defaultAction). Premium SKU must be enabled')
param virtualNetworkRules array = []

@description('Allow or Deny traffic from an IP or CIDR range, allowed properties are: value (must be IPv4) and action (Allow or Deny, defaults to defaultAction). Premium SKU must be enabled')
param ipRules array = []

@description('Enable or Disable container quarantine. Premium SKU must be enabled. Premium SKU must be enabled')
@allowed([
  'Enabled'
  'Disabled'
])
param quarantinePolicy string = 'Disabled'

@description('Enable or Disable purging of untagged manifest. Premium SKU must be enabled')
@allowed([
  'Enabled'
  'Disabled'
])
param trustPolicy string = 'Disabled'

@description('number of days before deleting untagged manifests. Premium SKU must be enabled')
@minValue(0)
@maxValue(365)
param retentionDays int = 0

@description('Enable or Disable the retention policy. Premium SKU must be enabled')
@allowed([
  'Enabled'
  'Disabled'
])
param retentionPolicy string = 'Disabled'

@description('Enable FQDN of container registry. Premium SKU must be enabled')
param dataEndpointEnabled bool = false

@description('Enable or Disable public access to Container Registry. Premium SKU must be enabled')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Tags to apply to Container Registry')
param tags object

var defaultAction = 'Allow'
var virtualNetworkRules_var = {
  virtualNetworkRules: [for j in range(0, (empty(virtualNetworkRules) ? 1 : length(virtualNetworkRules))): {
    id: (empty(virtualNetworkRules) ? 'dummyId' : resourceId((contains(virtualNetworkRules[j], 'virtualNetworkSubscriptionId') ? virtualNetworkRules[j].virtualNetworkSubscriptionId : subscription().subscriptionId), (contains(virtualNetworkRules[j], 'virtualNetworkResourceGroupName') ? virtualNetworkRules[j].virtualNetworkResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkRules[j].virtualNetworkName, virtualNetworkRules[j].subnetName))
    action: (empty(virtualNetworkRules) ? 'dummyAction' : (contains(virtualNetworkRules[j], 'action') ? virtualNetworkRules[j].action : defaultAction))
  }]
}
var ipRules_var = {
  ipRules: [for j in range(0, (empty(ipRules) ? 1 : length(ipRules))): {
    value: (empty(ipRules) ? 'dummyId' : ipRules[j].value)
    action: (empty(ipRules) ? 'dummyAction' : (contains(ipRules[j], 'action') ? ipRules[j].action : defaultAction))
  }]
}
var premiumNetworkRuleSet = {
  defaultAction: defaultAction
  virtualNetworkRules: virtualNetworkRules_var
  ipRules: ipRules_var
}
var networkRuleSet = ((sku == 'Premium') ? premiumNetworkRuleSet : json('{}'))
var premiumPolicies = {
  quarantinePolicy: {
    status: quarantinePolicy
  }
  trustPolicy: {
    type: 'Notary'
    status: trustPolicy
  }
  retentionPolicy: {
    days: retentionDays
    status: retentionPolicy
  }
}
var policies = ((sku == 'Premium') ? premiumPolicies : json('{}'))
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource registryName_resource 'Microsoft.ContainerRegistry/registries@2019-12-01-preview' = {
  name: registryName
  location: location
  tags: tags
  sku: {
    name: sku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    networkRuleSet: networkRuleSet
    policies: policies
    dataEndpointEnabled: dataEndpointEnabled
    publicNetworkAccess: publicNetworkAccess
  }
}

resource registryName_Microsoft_Insights_service 'Microsoft.ContainerRegistry/registries//providers/diagnosticSettings@2015-07-01' = {
  name: '${registryName}/Microsoft.Insights/service'
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
        category: 'ContainerRegistryLoginEvents'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'ContainerRegistryRepositoryEvents'
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
    registryName_resource
  ]
}

output registry object = reference(registryName_resource.id, '2019-12-01-preview', 'Full')