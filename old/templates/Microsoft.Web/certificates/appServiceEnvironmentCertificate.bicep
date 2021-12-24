@description('The name of the Certificate')
param certName string

@description('The location to deploy the Certificate to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Base-64 string encoded pfx file containing SSL certificate')
@secure()
param pfxString string

@description('Password for the SSL Ceritficate')
@secure()
param password string

@description('Subscription ID of App Service Environment to link Certificate to')
param appServiceEnvironmentSubscriptionId string = subscription().subscriptionId

@description('Resource Group of App Service Environment to link Certificate to')
param appServiceEnvironmentResourceGroupName string = resourceGroup().name

@description('Name of App Service Environment to link Certificate to')
param appServiceEnvironmentName string

@description('Tags to apply to Certificate')
param tags object

resource certName_appServiceEnvironmentName_InternalLoadBalancingASE 'Microsoft.Web/certificates@2015-08-01' = {
  name: '${certName}_${appServiceEnvironmentName}_InternalLoadBalancingASE'
  location: location
  tags: tags
  properties: {
    pfxBlob: pfxString
    password: password
    hostingEnvironmentProfile: {
      id: resourceId(appServiceEnvironmentSubscriptionId, appServiceEnvironmentResourceGroupName, 'Microsoft.Web/hostingEnvironments', appServiceEnvironmentName)
    }
  }
}