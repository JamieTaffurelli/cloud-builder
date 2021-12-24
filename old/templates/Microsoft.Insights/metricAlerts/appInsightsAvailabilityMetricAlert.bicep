@description('The name of the Metric Alert to deploy')
param metricAlertName string

@description('The description of the Metric Alert')
param description string

@description('Severity of the Metric Alert')
@allowed([
  0
  1
  2
  3
  4
])
param severity int

@description('Enable or Disable the Metric Alert')
param enabled bool = true

@description('The Subscription ID of the Web Test to query')
param webTestSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Web Test to query')
param webTestResourceGroupName string = resourceGroup().name

@description('The name of the Web Test to query')
param webTestName string

@description('The Subscription ID of the App Insights to query')
param appInsightsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the App Insights to query')
param appInsightsResourceGroupName string = resourceGroup().name

@description('The name of the App Insights to query')
param appInsightsName string

@description('How often to evalute Metric (ISO 8601)')
param evaluationFrequency string

@description('Period of time to monitor (ISO 8601)')
param windowSize string

@description('Number of failed locations before alert is triggered')
param failedLocationCount int

@description('Auto resolve alert')
param autoMitigate bool = true

@description('Action to take on Metric Alert (Action Group or Webhook)')
param actions array

@description('Tags to apply to Metric Alert')
param tags object

resource metricAlertName_resource 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertName
  location: 'global'
  tags: tags
  properties: {
    description: description
    severity: severity
    enabled: enabled
    scopes: [
      resourceId(webTestSubscriptionId, webTestResourceGroupName, 'Microsoft.Insights/webTests', webTestName)
      resourceId(appInsightsSubscriptionId, appInsightsResourceGroupName, 'Microsoft.Insights/components', appInsightsName)
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
      webTestId: resourceId(webTestSubscriptionId, webTestResourceGroupName, 'Microsoft.Insights/webTests', webTestName)
      componentId: resourceId(appInsightsSubscriptionId, appInsightsResourceGroupName, 'Microsoft.Insights/components', appInsightsName)
      failedLocationCount: failedLocationCount
    }
    autoMitigate: autoMitigate
    actions: actions
  }
}

output metricAlert object = reference(metricAlertName_resource.id, '2018-03-01', 'Full')