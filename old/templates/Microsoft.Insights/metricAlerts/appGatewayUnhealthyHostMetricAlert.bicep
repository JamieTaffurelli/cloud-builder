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

@description('Number of records to trigger alert')
param threshold string = '0'

@description('Time aggregation of data')
param timeAggregation string = 'Average'

@description('Auto resolve alert')
param autoMitigate bool = true

@description('Action to take on Metric Alert (Action Group or Webhook)')
param actions array

@description('Tags to apply to Metric Alert')
param tags object

var appGatewayUnheathyHostAlertName_var = '${appGatewayName}-static-unhealthy-host-alert'

resource appGatewayUnheathyHostAlertName 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: appGatewayUnheathyHostAlertName_var
  location: 'global'
  tags: tags
  properties: {
    description: 'Static threshold alert for unhealthy hosts on${appGatewayName}'
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
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'Unhealthy host criterion'
          metricName: 'UnhealthyHostCount'
          dimensions: []
          operator: 'GreaterThan'
          threshold: threshold
          timeAggregation: timeAggregation
        }
      ]
    }
    autoMitigate: autoMitigate
    actions: actions
  }
}

output metricAlert object = reference(appGatewayUnheathyHostAlertName.id, '2018-03-01', 'Full')