@description('The name of the Machine Learning Workspace')
param workspaceName string

@description('The location to deploy the Machine Learning Workspace to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Description of the Machine Learning Workspace')
param description string

@description('Friendly name of the Machine Learning Workspace')
param friendlyName string

@description('Subscription of the Key Vault for Machine Learning Workspace to consume secrets from')
param keyVaultSubscriptionId string = subscription().subscriptionId

@description('Resource Group of the Key Vault for Machine Learning Workspace to consume secrets from')
param keyVaultResourceGroupName string = resourceGroup().name

@description('Name of the Key Vault for Machine Learning Workspace to consume secrets from')
param keyVaultName string

@description('Subscription of the App Insights for Machine Learning Workspace to send telemetry data to')
param appInsightsSubscriptionId string = subscription().subscriptionId

@description('Resource Group of the App Insights for Machine Learning Workspace to send telemetry data to')
param appInsightsResourceGroupName string = resourceGroup().name

@description('Name of the App Insights for Machine Learning Workspace to send telemetry data to')
param appInsightsName string

@description('Subscription of the ACR for Machine Learning Workspace to consume container images from')
param containerRegistrySubscriptionId string = subscription().subscriptionId

@description('Resource Group of the ACR for Machine Learning Workspace consume container images from')
param containerRegistryResourceGroupName string = resourceGroup().name

@description('Name of the ACR for Machine Learning Workspace to consume container images from')
param containerRegistryName string

@description('Subscription of the Storage Account for Machine Learning Workspace to consume data from')
param storageAccountSubscriptionId string = subscription().subscriptionId

@description('Resource Group of the Storage Account for Machine Learning Workspace consume data from')
param storageAccountResourceGroupName string = resourceGroup().name

@description('Name of the Storage Account for Machine Learning Workspace to consume data from')
param storageAccountName string

@description('Enable encryption with a customer managed key')
@allowed([
  'Enabled'
  'Disabled'
])
param customerEncryption string = 'Disabled'

@description('Subscription of the Key Vault for Machine Learning Workspace to use for encryption, ignored if customerEncryption is disabled')
param encryptionKeyVaultSubscriptionId string = subscription().subscriptionId

@description('Resource Group of the Key Vault for Machine Learning Workspace to use for encryption, ignored if customerEncryption is disabled')
param encryptionKeyVaultResourceGroupName string = resourceGroup().name

@description('Name of the Key Vault for Machine Learning Workspace to use for encryption, ignored if customerEncryption is disabled')
param encryptionKeyVaultName string = ''

@description('Name of the Key for Machine Learning Workspace to use for encryption, ignored if customerEncryption is disabled')
param encryptionKeyName string = ''

@description('Version of the Key for Machine Learning Workspace to use for encryption, ignored if customerEncryption is disabled')
param encryptionKeyVersion string = ''

@description('Designate as a high business impact workspace to encrypt certain diagnostic data')
param hbiWorkspace bool = false

@description('The compute name for image build')
param imageBuildCompute string = ''

@description('Allow public access when workspace is behind a vnet')
param allowPublicAccessWhenBehindVnet bool = false

@description('Private Link resources this workspaces consume')
param sharedPrivateLinkResources array = []

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Tags to apply to the Machine Learning Workspace')
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource workspaceName_resource 'Microsoft.MachineLearningServices/workspaces@2020-08-01' = {
  name: workspaceName
  location: location
  tags: tags
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    description: description
    friendlyName: friendlyName
    keyVault: resourceId(keyVaultSubscriptionId, keyVaultResourceGroupName, 'Microsoft.KeyVault/vaults', keyVaultName)
    appInsights: resourceId(appInsightsSubscriptionId, appInsightsResourceGroupName, 'Microsoft.Insights/components', appInsightsName)
    containerRegistry: resourceId(containerRegistrySubscriptionId, containerRegistryResourceGroupName, 'Microsoft.ContainerRegistry/registries', containerRegistryName)
    storageAccount: resourceId(storageAccountSubscriptionId, storageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', storageAccountName)
    encryption: {
      status: customerEncryption
      keyVaultProperties: {
        keyVaultArmId: resourceId(encryptionKeyVaultSubscriptionId, encryptionKeyVaultResourceGroupName, 'Microsoft.KeyVault/vaults', encryptionKeyVaultName)
        keyIdentifier: 'https://${encryptionKeyVaultName}.vault.azure.net/keys/${encryptionKeyName}/${encryptionKeyVersion}'
      }
    }
    hbiWorkspace: hbiWorkspace
    imageBuildCompute: imageBuildCompute
    allowPublicAccessWhenBehindVnet: allowPublicAccessWhenBehindVnet
    sharedPrivateLinkResources: sharedPrivateLinkResources
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource workspaceName_Microsoft_Insights_service 'Microsoft.MachineLearningServices/workspaces//providers/diagnosticSettings@2015-07-01' = {
  name: '${workspaceName}/Microsoft.Insights/service'
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
        category: 'AmlComputeClusterEvent'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AmlComputeClusterNodeEvent'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'AmlComputeJobEvent'
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
    'Microsoft.Web/Sites/${workspaceName}'
  ]
}

output workspace object = reference(workspaceName_resource.id, '2020-08-01', 'Full')