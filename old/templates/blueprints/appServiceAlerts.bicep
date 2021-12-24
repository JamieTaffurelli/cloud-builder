@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string

@description('The names of the App Services to monitor')
param appServiceNames array

@description('Region of the App Services')
param region string = resourceGroup().location

@description('Location of Log Anaytics Workspace to query')
param logAnalyticsWorkspaceLocation string = resourceGroup().location

@description('The Resource Group of the Log Anaytics Workspace to query')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Anaytics Workspace to query')
param logAnalyticsName string

@description('Severity of the Alert')
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

@description('How often to evalute Metric Alerts (ISO 8601)')
param evaluationFrequency string = 'PT5M'

@description('Period of time to monitor for Metric Alerts (ISO 8601)')
param windowSize string = 'PT5M'

@description('How often to run Scheduled Query Rules')
param frequencyInMinutes int = 5

@description('Time period in which to run Scheduled Query Rules')
param timeWindowInMinutes int = 5

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

@description('Resource IDs of Action Groups to invoke')
param actionGroupIds array

@description('Percentage of HTTP response codes of 400 or greater before alerting')
@minValue(0)
@maxValue(100)
param httpFailurePercentage int = 0

@description('Tags to apply to Metric Alert')
param tags object

var metricAlertActions = {
  metricAlertActions: [for item in actionGroupIds: {
    actionGroupId: item
  }]
}
var templateBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/'
var metricAlertBaseUrl = '${templateBaseUrl}Microsoft.Insights/metricAlerts/'
var scheduledQueryRuleBaseUrl = '${templateBaseUrl}Microsoft.Insights/scheduledQueryRules/'
var appServiceHttpReturnCodeTemplateUrl = '${metricAlertBaseUrl}appServiceHttpReturnCodeMetricAlert.1.0.5.0.json${templatesSas}'
var appServiceTotalRequestTemplateUrl = '${metricAlertBaseUrl}appServiceTotalRequestMetricAlert.1.0.3.0.json${templatesSas}'
var appServiceResponseTimeTemplateUrl = '${metricAlertBaseUrl}appServiceResponseTimeMetricAlert.1.0.3.0.json${templatesSas}'
var appServiceHttpReturnCodeRuleTemplateUrl = '${scheduledQueryRuleBaseUrl}appServiceHttpReturnCodeRule.2.0.2.0.json${templatesSas}'

module appServiceNames_http_return_code_alert '?' /*TODO: replace with correct path to [variables('appServiceHttpReturnCodeTemplateUrl')]*/ = [for item in appServiceNames: {
  name: '${item}-http-return-code-alert'
  params: {
    appServiceName: item
    appServiceRegion: region
    enabled: enabled
    severity: severity
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    alertSensitivity: alertSensitivity
    numberOfEvaluationPeriods: numberOfEvaluationPeriods
    minFailingPeriodsToAlert: minFailingPeriodsToAlert
    autoMitigate: autoMitigate
    actions: metricAlertActions.metricAlertActions
    tags: tags
  }
}]

module appServiceNames_total_request_alert '?' /*TODO: replace with correct path to [variables('appServiceTotalRequestTemplateUrl')]*/ = [for item in appServiceNames: {
  name: '${item}-total-request-alert'
  params: {
    appServiceName: item
    appServiceRegion: region
    enabled: enabled
    severity: severity
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    alertSensitivity: alertSensitivity
    numberOfEvaluationPeriods: numberOfEvaluationPeriods
    minFailingPeriodsToAlert: minFailingPeriodsToAlert
    autoMitigate: autoMitigate
    actions: metricAlertActions.metricAlertActions
    tags: tags
  }
}]

module appServiceNames_response_time_alert '?' /*TODO: replace with correct path to [variables('appServiceResponseTimeTemplateUrl')]*/ = [for item in appServiceNames: {
  name: '${item}-response-time-alert'
  params: {
    appServiceName: item
    appServiceRegion: region
    enabled: enabled
    severity: severity
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    alertSensitivity: alertSensitivity
    numberOfEvaluationPeriods: numberOfEvaluationPeriods
    minFailingPeriodsToAlert: minFailingPeriodsToAlert
    autoMitigate: autoMitigate
    actions: metricAlertActions.metricAlertActions
    tags: tags
  }
}]

module appServiceNames_http_return_code_query_alert '?' /*TODO: replace with correct path to [variables('appServiceHttpReturnCodeRuleTemplateUrl')]*/ = [for item in appServiceNames: {
  name: '${item}-http-return-code-query-alert'
  params: {
    appServiceName: item
    location: logAnalyticsWorkspaceLocation
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} is returning http errors'
    }
    failurePercentage: httpFailurePercentage
    tags: tags
  }
}]