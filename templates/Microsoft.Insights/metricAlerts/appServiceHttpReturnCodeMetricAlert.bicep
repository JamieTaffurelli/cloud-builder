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

@description('The Subscription ID of the App Service to monitor')
param appServiceSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the App Service to monitor')
param appServiceResourceGroupName string = resourceGroup().name

@description('The name of the App Service to monitor')
param appServiceName string

@description('How often to evalute Metric (ISO 8601)')
param evaluationFrequency string = 'PT5M'

@description('Period of time to monitor (ISO 8601)')
param windowSize string = 'PT5M'

@description('Region of the App Service')
param appServiceRegion string = resourceGroup().location

@description('Sensitivity of alert for dynamic threshold')
@allowed([
  'High'
  'Medium'
  'Low'
])
param alertSensitivity string = 'High'

@description('Number of time periods for algorithm to analyse')
param numberOfEvaluationPeriods string = '4'

@description('Number of periods to fail threshold before alert is triggered')
param minFailingPeriodsToAlert string = '3'

@description('Auto resolve alert')
param autoMitigate bool = true

@description('Action to take on Metric Alert (Action Group or Webhook)')
param actions array

@description('Tags to apply to Metric Alert')
param tags object

var appService4xxAlertName_var = '${appServiceName}-http-4xx-alert'
var appService5xxAlertName_var = '${appServiceName}-http-5xx-alert'

resource appService4xxAlertName 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: appService4xxAlertName_var
  location: 'global'
  tags: tags
  properties: {
    description: 'Dynamic threshold alert for HTTP 4xx return codes on${appServiceName}'
    severity: severity
    enabled: enabled
    scopes: [
      resourceId(appServiceSubscriptionId, appServiceResourceGroupName, 'Microsoft.Web/sites', appServiceName)
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: 'Microsoft.Web/sites'
    targetResourceRegion: appServiceRegion
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'DynamicThresholdCriterion'
          name: '4xx criterion'
          metricName: 'Http4xx'
          dimensions: []
          operator: 'GreaterThan'
          alertSensitivity: alertSensitivity
          failingPeriods: {
            numberOfEvaluationPeriods: numberOfEvaluationPeriods
            minFailingPeriodsToAlert: minFailingPeriodsToAlert
          }
          timeAggregation: 'Total'
        }
      ]
    }
    autoMitigate: autoMitigate
    actions: actions
  }
}

resource appService5xxAlertName 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: appService5xxAlertName_var
  location: 'global'
  tags: tags
  properties: {
    description: 'Dynamic threshold alert for HTTP 5xx return codes on${appServiceName}'
    severity: severity
    enabled: enabled
    scopes: [
      resourceId(appServiceSubscriptionId, appServiceResourceGroupName, 'Microsoft.Web/sites', appServiceName)
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: 'Microsoft.Web/sites'
    targetResourceRegion: appServiceRegion
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'DynamicThresholdCriterion'
          name: '5xx criterion'
          metricName: 'Http5xx'
          dimensions: []
          operator: 'GreaterThan'
          alertSensitivity: alertSensitivity
          failingPeriods: {
            numberOfEvaluationPeriods: numberOfEvaluationPeriods
            minFailingPeriodsToAlert: minFailingPeriodsToAlert
          }
          timeAggregation: 'Total'
        }
      ]
    }
    autoMitigate: autoMitigate
    actions: actions
  }
}

output _4xxMetricAlert object = reference(appService4xxAlertName.id, '2018-03-01', 'Full')
output _5xxMetricAlert object = reference(appService5xxAlertName.id, '2018-03-01', 'Full')