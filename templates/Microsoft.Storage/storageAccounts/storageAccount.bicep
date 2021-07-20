@description('The name of the Storage Account')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('The location to deploy the Storage Account to')
@allowed([
  'northeurope'
  'westeurope'
])
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

@description('Tags to apply to Storage Account')
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
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2019-06-01' = {
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
      virtualNetworkRules: (empty(virtualNetworkRules) ? json('[]') : virtualNetworkRules_var.virtualNetworkRules)
      ipRules: (empty(ipRules) ? json('[]') : ipRules_var.ipRules)
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    routingPreference: routingPreference
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: 'TLS1_2'
  }
}

resource storageAccountName_Microsoft_Security_current 'Microsoft.Storage/storageAccounts/providers/advancedThreatProtectionSettings@2019-01-01' = {
  name: '${storageAccountName}/Microsoft.Security/current'
  properties: {
    isEnabled: true
  }
  dependsOn: [
    storageAccountName_resource
  ]
}

resource storageAccountName_Microsoft_Insights_service 'Microsoft.Storage/storageAccounts//providers/diagnosticSettings@2015-07-01' = {
  name: '${storageAccountName}/Microsoft.Insights/service'
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
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    storageAccountName_resource
  ]
}

resource storageAccountName_default_Microsoft_Insights_service 'Microsoft.Storage/storageAccounts/blobServices/providers/diagnosticsettings@2015-07-01' = {
  name: '${storageAccountName}/default/Microsoft.Insights/service'
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
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    storageAccountName_resource
  ]
}

resource Microsoft_Storage_storageAccounts_tableServices_providers_diagnosticsettings_storageAccountName_default_Microsoft_Insights_service 'Microsoft.Storage/storageAccounts/tableServices/providers/diagnosticsettings@2015-07-01' = {
  name: '${storageAccountName}/default/Microsoft.Insights/service'
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
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    storageAccountName_resource
  ]
}

resource Microsoft_Storage_storageAccounts_fileServices_providers_diagnosticsettings_storageAccountName_default_Microsoft_Insights_service 'Microsoft.Storage/storageAccounts/fileServices/providers/diagnosticsettings@2015-07-01' = {
  name: '${storageAccountName}/default/Microsoft.Insights/service'
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
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    storageAccountName_resource
  ]
}

resource Microsoft_Storage_storageAccounts_queueServices_providers_diagnosticsettings_storageAccountName_default_Microsoft_Insights_service 'Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticsettings@2015-07-01' = {
  name: '${storageAccountName}/default/Microsoft.Insights/service'
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
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    storageAccountName_resource
  ]
}

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2019-04-01' = {
  parent: storageAccountName_resource
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