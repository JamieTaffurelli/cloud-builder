@description('The name of the Certificate')
param certName string

@description('The location to deploy the Certificate to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Host names of the certificate')
param hostNames array

@description('Password for the SSL Ceritficate')
@secure()
param password string

@description('Subscription ID of Key Vault to get Certificate from')
param keyVaultSubscriptionId string = subscription().subscriptionId

@description('Resource Group of Key Vault to get Certificate from')
param KeyVaultResourceGroupName string = resourceGroup().name

@description('Name of Key Vault to get Certificate from')
param KeyVaultName string

@description('Name of Key Vault Secret to get Certificate')
param secretName string

@description('Subscription ID of App Service Plan to link Certificate to')
param appServicePlanSubscriptionId string = subscription().subscriptionId

@description('Resource Group of App Service Plan to link Certificate to')
param appServicePlanResourceGroupName string = resourceGroup().name

@description('Name of App Service Plan to link Certificate to')
param appServicePlanName string

@description('Tags to apply to Certificate')
param tags object

resource certName_appServicePlanName 'Microsoft.Web/certificates@2019-08-01' = {
  name: '${certName}-${appServicePlanName}'
  location: location
  tags: tags
  properties: {
    hostNames: hostNames
    password: password
    keyVaultId: resourceId(keyVaultSubscriptionId, KeyVaultResourceGroupName, 'Microsoft.KeyVault/vaults', KeyVaultName)
    keyVaultSecretName: secretName
    serverFarmId: resourceId(appServicePlanSubscriptionId, appServicePlanResourceGroupName, 'Microsoft.Web/serverFarms', appServicePlanName)
  }
}