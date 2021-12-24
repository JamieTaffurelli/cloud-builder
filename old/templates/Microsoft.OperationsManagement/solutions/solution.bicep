@description('The name of the Solution you wish to create')
param solutionName string

@description('The publisher of the Solution')
param publisher string = 'Microsoft'

@description('The Solution Product')
param product string

@description('The Subscription ID of the Log Analytics Workspace to attach the solution to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to attach the solution to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to attach the solution to')
param logAnalyticsName string
param tags object

var name_var = '${solutionName}(${logAnalyticsName})'

resource name 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: name_var
  location: 'westeurope'
  tags: tags
  plan: {
    name: name_var
    publisher: publisher
    product: product
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
}

output solution object = reference(name.id, '2015-11-01-preview', 'Full')