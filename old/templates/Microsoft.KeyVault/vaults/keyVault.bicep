@description('Name of the Key Vault.')
param keyVaultName string

@description('Location of the Key Vault.')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault.')
param tenantId string = subscription().tenantId

@description('Access Policies for accounts to access Key Vault objects')
param accessPolicies array

@description('Specifies whether the Key Vault is a standard vault or a premium vault.')
@allowed([
  'Standard'
  'Premium'
])
param skuName string = 'Standard'

@description('Enables VMs to use secrets and certificates in Key Vault')
param enabledForDeployment bool = false

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enabledForDiskEncryption bool = false

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = false

@description('Specifies whether its a new Key Vault or one that is being recovered')
@allowed([
  'default'
  'recover'
])
param createMode string = 'default'

@description('Specifies what traffic can bypass network ACLs.')
@allowed([
  'None'
  'AzureServices'
])
param bypass string = 'None'

@description('List of IP addresses to allow traffic from')
param ipRules array = []

@description('List of subnet IDs to allow traffic from')
param virtualNetworkRules array = []

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var tenantIdObject = {
  tenantId: tenantId
}
var accessPolicies_var = {
  accessPolicies: [for item in accessPolicies: union(item, tenantIdObject)]
}
var ipRules_var = {
  ipRules: [for j in range(0, (empty(ipRules) ? 1 : length(ipRules))): {
    value: (empty(ipRules) ? 'dummyIp' : ipRules[j])
  }]
}
var virtualNetworkRules_var = {
  virtualNetworkRules: [for j in range(0, (empty(virtualNetworkRules) ? 1 : length(virtualNetworkRules))): {
    id: (empty(virtualNetworkRules) ? 'dummyVNetRule' : virtualNetworkRules[j])
  }]
}
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource keyVaultName_resource 'Microsoft.KeyVault/vaults@2018-02-14' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    accessPolicies: accessPolicies_var.accessPolicies
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableSoftDelete: true
    createMode: createMode
    enablePurgeProtection: true
    networkAcls: {
      bypass: bypass
      defaultAction: 'Deny'
      ipRules: (empty(ipRules) ? json('[]') : ipRules_var.ipRules)
      virtualNetworkRules: (empty(virtualNetworkRules) ? json('[]') : virtualNetworkRules_var.virtualNetworkRules)
    }
  }
}

resource keyVaultName_Microsoft_Insights_service 'Microsoft.KeyVault/vaults//providers/diagnosticSettings@2015-07-01' = {
  name: '${keyVaultName}/Microsoft.Insights/service'
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
        category: 'AuditEvent'
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
    keyVaultName_resource
  ]
}

output keyVault object = reference(keyVaultName_resource.id, '2018-02-14', 'Full')