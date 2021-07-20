@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string

@description('The names of the App Gateways to monitor')
param appGatewayNames array

@description('Region of the App Gateways')
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
param appGatewayHttpFailurePercentage int = 0

@description('Percentage of WAF failures before alerting')
@minValue(0)
@maxValue(100)
param appGatewayWafFailurePercentage int = 0

@description('Wildcard paths to exclude from WAF Scheduled Query')
param wafPathsToExclude array = []

@description('WAF rules to exclude from WAF Scheduled Query')
param wafRulesToExclude array = []

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
var appGatewayFailedRequestTemplateUrl = '${metricAlertBaseUrl}appGatewayFailedRequestMetricAlert.1.0.3.0.json${templatesSas}'
var appGatewayTotalRequestTemplateUrl = '${metricAlertBaseUrl}appGatewayTotalRequestMetricAlert.1.0.3.0.json${templatesSas}'
var appGatewayUnhealthyHostTemplateUrl = '${metricAlertBaseUrl}appGatewayUnhealthyHostMetricAlert.1.0.1.0.json${templatesSas}'
var appGatewayHttpReturnCodeTemplateUrl = '${scheduledQueryRuleBaseUrl}appGatewayHttpReturnCodeRule.2.0.1.0.json${templatesSas}'
var appGatewayWafViolationCodeTemplateUrl = '${scheduledQueryRuleBaseUrl}appGatewayWafViolationRule.2.1.1.0.json${templatesSas}'

module appGatewayNames_failed_request_alert '?' /*TODO: replace with correct path to [variables('appGatewayFailedRequestTemplateUrl')]*/ = [for item in appGatewayNames: {
  name: '${item}-failed-request-alert'
  params: {
    appGatewayName: item
    appGatewayRegion: region
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

module appGatewayNames_total_request_alert '?' /*TODO: replace with correct path to [variables('appGatewayTotalRequestTemplateUrl')]*/ = [for item in appGatewayNames: {
  name: '${item}-total-request-alert'
  params: {
    appGatewayName: item
    appGatewayRegion: region
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

module appGatewayNames_unhealthy_host_alert '?' /*TODO: replace with correct path to [variables('appGatewayUnhealthyHostTemplateUrl')]*/ = [for item in appGatewayNames: {
  name: '${item}-unhealthy-host-alert'
  params: {
    appGatewayName: item
    appGatewayRegion: region
    enabled: enabled
    severity: severity
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    autoMitigate: autoMitigate
    actions: metricAlertActions.metricAlertActions
    tags: tags
  }
}]

module appGatewayNames_http_return_code_alert '?' /*TODO: replace with correct path to [variables('appGatewayHttpReturnCodeTemplateUrl')]*/ = [for item in appGatewayNames: {
  name: '${item}-http-return-code-alert'
  params: {
    appGatewayName: item
    location: logAnalyticsWorkspaceLocation
    failurePercentage: appGatewayHttpFailurePercentage
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
    tags: tags
  }
}]

module appGatewayNames_waf_violation_alert '?' /*TODO: replace with correct path to [variables('appGatewayWafViolationCodeTemplateUrl')]*/ = [for item in appGatewayNames: {
  name: '${item}-waf-violation-alert'
  params: {
    appGatewayName: item
    location: logAnalyticsWorkspaceLocation
    failurePercentage: appGatewayWafFailurePercentage
    pathsToExclude: wafPathsToExclude
    rulesToExclude: wafRulesToExclude
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} is showing waf violations'
    }
    tags: tags
  }
}]