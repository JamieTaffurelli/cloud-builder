@description('The name of the Application Insights')
param appInsightsName string

@description('The location to deploy the Application Insights to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Used to customise UI')
param kind string = 'web'

@description('Type of Application being Monitored')
@allowed([
  'web'
  'other'
])
param appType string = 'web'

@description('Tags to apply to Application Insights')
param tags object

resource appInsightsName_resource 'Microsoft.Insights/components@2015-05-01' = {
  name: appInsightsName
  kind: kind
  location: location
  tags: tags
  properties: {
    Application_Type: appType
    Flow_Type: 'Bluefield'
    Request_Source: 'rest'
  }
}

output appInsights object = reference(appInsightsName_resource.id, '2015-05-01', 'Full')