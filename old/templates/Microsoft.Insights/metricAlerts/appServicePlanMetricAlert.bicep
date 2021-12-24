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

@description('The Subscription ID of the App Service Plan to monitor')
param appServicePlanSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the App Service Plan to monitor')
param appServicePlanResourceGroupName string = resourceGroup().name

@description('The name of the App Service Plan to monitor')
param appServicePlanName string

@description('How often to evalute Metric (ISO 8601)')
param evaluationFrequency string = 'PT5M'

@description('Period of time to monitor (ISO 8601)')
param windowSize string = 'PT5M'

@description('Region of the App Service Plan')
param appServicePlanRegion string = resourceGroup().location

@description('Threshold for CPU Percentage alert')
param cpuThreshold string = '70'

@description('Threshold for Memory Percentage alert')
param memoryThreshold string = '70'

@description('Auto resolve alert')
param autoMitigate bool = true

@description('Action to take on Metric Alert (Action Group or Webhook)')
param actions array

@description('Tags to apply to Metric Alert')
param tags object

var cpuMetricAlertName_var = '${appServicePlanName}-static-cpu-alert'
var memoryMetricAlertName_var = '${appServicePlanName}-static-memory-alert'

resource cpuMetricAlertName 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: cpuMetricAlertName_var
  location: 'global'
  tags: tags
  properties: {
    description: 'Dynamic threshold alert for average CPU usage on${appServicePlanName}'
    severity: severity
    enabled: enabled
    scopes: [
      resourceId(appServicePlanSubscriptionId, appServicePlanResourceGroupName, 'Microsoft.Web/serverFarms', appServicePlanName)
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: 'Microsoft.Web/serverFarms'
    targetResourceRegion: appServicePlanRegion
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'CPU criterion'
          metricName: 'CpuPercentage'
          dimensions: []
          operator: 'GreaterThan'
          threshold: cpuThreshold
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: autoMitigate
    actions: actions
  }
}

resource memoryMetricAlertName 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: memoryMetricAlertName_var
  location: 'global'
  tags: tags
  properties: {
    description: 'Dynamic threshold alert for average Memory usage on${appServicePlanName}'
    severity: severity
    enabled: enabled
    scopes: [
      resourceId(appServicePlanSubscriptionId, appServicePlanResourceGroupName, 'Microsoft.Web/serverFarms', appServicePlanName)
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: 'Microsoft.Web/serverFarms'
    targetResourceRegion: appServicePlanRegion
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'Memory criterion'
          metricName: 'MemoryPercentage'
          dimensions: []
          operator: 'GreaterThan'
          threshold: memoryThreshold
          timeAggregation: 'Average'
        }
      ]
    }
    autoMitigate: autoMitigate
    actions: actions
  }
}

output cpuMetricAlert object = reference(cpuMetricAlertName.id, '2018-03-01', 'Full')
output memoryMetricAlert object = reference(memoryMetricAlertName.id, '2018-03-01', 'Full')