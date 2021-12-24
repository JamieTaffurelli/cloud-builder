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
param appGatewaySubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the App Service to monitor')
param appGatewayResourceGroupName string = resourceGroup().name

@description('The name of the App Service to monitor')
param appGatewayName string

@description('How often to evalute Metric (ISO 8601)')
param evaluationFrequency string = 'PT5M'

@description('Period of time to monitor (ISO 8601)')
param windowSize string = 'PT5M'

@description('Region of the App Service')
param appGatewayRegion string = resourceGroup().location

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

var appGatewayFailedRequestAlertName_var = '${appGatewayName}-dynamic-failed-request-alert'

resource appGatewayFailedRequestAlertName 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: appGatewayFailedRequestAlertName_var
  location: 'global'
  tags: tags
  properties: {
    description: 'Dynamic threshold alert for failed requests on${appGatewayName}'
    severity: severity
    enabled: enabled
    scopes: [
      resourceId(appGatewaySubscriptionId, appGatewayResourceGroupName, 'Microsoft.Network/applicationGateways', appGatewayName)
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: 'Microsoft.Network/applicationGateways'
    targetResourceRegion: appGatewayRegion
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'DynamicThresholdCriterion'
          name: 'Failed request criterion'
          metricName: 'FailedRequests'
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

output metricAlert object = reference(appGatewayFailedRequestAlertName.id, '2018-03-01', 'Full')