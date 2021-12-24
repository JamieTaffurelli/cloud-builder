@description('The name of the Storage Account')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('The location to deploy the Storage Account to')
param location string = resourceGroup().location

@description('Sku name to determine geo-replication and storage architecture (HDD or SSD) of Storage Account')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Custom user domain to assign to Storage Account, uses CNAME source')
param customDomainName string = ''

@description('Bypass network ACLs for Storage Account traffic')
@allowed([
  'None'
  'Logging'
  'Metrics'
  'AzureServices'
  'Logging, Metrics'
  'Logging, AzureServices'
  'Metrics, AzureServices'
  'Logging, Metrics, AzureServices'
])
param bypass string = 'None'

@description('Allow or Deny traffic from subnets, allowed properties are: subnetId (resource ID of subnet) and action (Allow or Deny, defaults to defaultAction)')
param resourceAccessRules array = []

@description('Allow or Deny traffic from subnets, allowed properties are: subnetId (resource ID of subnet) and action (Allow or Deny, defaults to defaultAction)')
param virtualNetworkRules array = []

@description('Allow or Deny traffic from an IP or CIDR range, allowed properties are: value (must be IPv4) and action (Allow or Deny, defaults to defaultAction)')
param ipRules array = []

@description('Information about the network routing choice opted by the user for data transfer')
param routingPreference object = {}

@description('Allow or disallow public access to all blobs or containers in the storage account')
param allowBlobPublicAccess bool = true

@description('Cross Origin Resource Sharing rules')
param corsRules array = []

@description('Number of days to retain deleted blobs')
@minValue(1)
@maxValue(365)
param retentionDays int = 365

@description('Enable auto snapshot of blobs')
param automaticSnapshotEnabled bool = true

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

param tags object

var defaultAction = 'Allow'
var virtualNetworkRules_var = [for j in range(0, length(virtualNetworkRules)): {
  id: resourceId((contains(virtualNetworkRules[j], 'virtualNetworkSubscriptionId') ? virtualNetworkRules[j].virtualNetworkSubscriptionId : subscription().subscriptionId), (contains(virtualNetworkRules[j], 'virtualNetworkResourceGroupName') ? virtualNetworkRules[j].virtualNetworkResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkRules[j].virtualNetworkName, virtualNetworkRules[j].subnetName)
  action: (contains(virtualNetworkRules[j], 'action') ? virtualNetworkRules[j].action : defaultAction)
}]
var ipRules_var = [for j in range(0, length(ipRules)): {
  value: ipRules[j].value
  action: contains(ipRules[j], 'action') ? ipRules[j].action : defaultAction
}]
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365
var diagSetting = {
  metrics: [
    {
      category: 'Transaction'
      enabled: diagnosticsEnabled
      retentionPolicy: {
        enabled: diagnosticsEnabled
        days: diagnosticsRetentionInDays
      }
    }
  ]
  logs: [
    {
      category: 'StorageRead'
      enabled: diagnosticsEnabled
      retentionPolicy: {
        enabled: diagnosticsEnabled
        days: diagnosticsRetentionInDays
      }
    }
    {
      category: 'StorageWrite'
      enabled: diagnosticsEnabled
      retentionPolicy: {
        enabled: diagnosticsEnabled
        days: diagnosticsRetentionInDays
      }
    }
    {
      category: 'StorageDelete'
      enabled: diagnosticsEnabled
      retentionPolicy: {
        enabled: diagnosticsEnabled
        days: diagnosticsRetentionInDays
      }
    }
  ]
  workspaceId: logAnalyticsWorkspace.id
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName)
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  kind: 'StorageV2'
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    customDomain: {
      name: customDomainName
    }
    encryption: {
      services: {
        file: {
          enabled: true
        }
        blob: {
          enabled: true
        }
        table: {
          enabled: true
        }
        queue: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    networkAcls: {
      bypass: bypass
      resourceAccessRules: resourceAccessRules
      virtualNetworkRules: virtualNetworkRules_var
      ipRules: ipRules_var
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    routingPreference: routingPreference
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: 'TLS1_2'
  }
}

resource storageAccountAdvancedProtection 'Microsoft.Security/advancedThreatProtectionSettings@2019-01-01' = {
  name: 'current'
  scope: storageAccount
  properties: {
    isEnabled: true
  }
}

resource storageAccountDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: storageAccount
  properties: {
    metrics: [
      {
        category: 'Transaction'
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

resource storageAccountBlobService 'Microsoft.Storage/storageAccounts/blobServices@2021-02-01' existing = {
  name: '${storageAccount.name}/default'
}

resource storageAccountTableService 'Microsoft.Storage/storageAccounts/tableServices@2021-02-01' existing = {
  name: '${storageAccount.name}/default'
}

resource storageAccountFileService 'Microsoft.Storage/storageAccounts/fileServices@2021-02-01' existing = {
  name: '${storageAccount.name}/default'
}

resource storageAccountQueueService 'Microsoft.Storage/storageAccounts/queueServices@2021-02-01' existing = {
  name: '${storageAccount.name}/default'
}

resource storageAccountBlobDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview'  = {
  name: 'service'
  scope: storageAccountBlobService
  properties: diagSetting
}

resource storageAccountTableDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: storageAccountTableService
  properties: diagSetting
}

resource storageAccountFileDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: storageAccountFileService
  properties: diagSetting
}

resource storageAccountQueueDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: storageAccountQueueService
  properties: diagSetting
}

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2019-04-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    cors: {
      corsRules: corsRules
    }
    deleteRetentionPolicy: {
      enabled: true
      days: retentionDays
    }
    automaticSnapshotPolicyEnabled: automaticSnapshotEnabled
  }
}
