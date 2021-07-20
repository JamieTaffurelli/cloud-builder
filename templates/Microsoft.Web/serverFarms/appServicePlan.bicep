@description('The name of the App Service Plan')
param appServicePlanName string

@description('The location to deploy the App Service Plan to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Kind of App Service Plan workers')
@allowed([
  'Windows'
  'Linux'
  'FunctionApp'
  'Elastic'
])
param kind string = 'Windows'

@description('Subscription ID of App Service Environment to link Application Service Plan to')
param appServiceEnvironmentSubscriptionId string = subscription().subscriptionId

@description('Resource Group of App Service Environment to link Application Service Plan to')
param appServiceEnvironmentResourceGroupName string = resourceGroup().name

@description('Name of App Service Environment to link Application Service Plan to')
param appServiceEnvironmentName string

@description('Enable independent scaling of apps in the App Service Plan')
param perSiteScaling bool = true

@description('Maximum number of workers, only valid if kind is \'Elastic\'')
param maximumElasticWorkerCount int = 5

@description('The size of the workers: 1 CPU 1.75 GB RAM, 2 CPU 3.5 GB RAM, 4 CPU 7 GB RAM')
@allowed([
  'Small'
  'Medium'
  'Large'
])
param skuSize string = 'Small'

@description('The default number of workers in the Application Service Plan')
param capacity int = 2

@description('Tags to apply to App Service Environment')
param tags object

var sku = ((skuSize == 'Small') ? 'I1' : ((skuSize == 'Medium') ? 'I2' : 'I3'))

resource appServicePlanName_resource 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: appServicePlanName
  kind: kind
  location: location
  tags: tags
  properties: {
    hostingEnvironmentProfile: {
      id: resourceId(appServiceEnvironmentSubscriptionId, appServiceEnvironmentResourceGroupName, 'Microsoft.Web/hostingEnvironments', appServiceEnvironmentName)
    }
    perSiteScaling: perSiteScaling
    maximumElasticWorkerCount: maximumElasticWorkerCount
    isSpot: false
    reserved: ((kind == 'Linux') ? json('true') : json('false'))
  }
  sku: {
    name: sku
    tier: 'Isolated'
    size: sku
    family: 'I'
    capacity: capacity
  }
}

output appServicePlan object = reference(appServicePlanName_resource.id, '2018-02-01', 'Full')