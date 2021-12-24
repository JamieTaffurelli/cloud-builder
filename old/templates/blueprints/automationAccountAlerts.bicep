@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string

@description('The names of the Runbooks to monitor')
param runbookNames array

@description('The name of the Automation Account to monitor')
param automationAccountName string

@description('Location of Log Analytics Workspace to query')
param logAnalyticsWorkspaceLocation string = resourceGroup().location

@description('The Resource Group of the Log Analytics Workspace to query')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to query')
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

@description('How often to run Scheduled Query Rules')
param frequencyInMinutes int = 5

@description('Time period in which to run Scheduled Query Rules')
param timeWindowInMinutes int = 5

@description('Resource IDs of Action Groups to invoke')
param actionGroupIds array

@description('Tags to apply to Metric Alert')
param tags object

var templateBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/'
var scheduledQueryRuleBaseUrl = '${templateBaseUrl}Microsoft.Insights/scheduledQueryRules/'
var recoveryServiceFailoverRuleTemplateUrl = '${scheduledQueryRuleBaseUrl}runbookFailureRule.1.0.1.0.json${templatesSas}'

module runbookNames_failure_alert_triggered '?' /*TODO: replace with correct path to [variables('recoveryServiceFailoverRuleTemplateUrl')]*/ = [for item in runbookNames: {
  name: '${item}-failure-alert-triggered'
  params: {
    automationAccountName: automationAccountName
    runbookName: item
    location: logAnalyticsWorkspaceLocation
    enabled: string(enabled)
    dataSourceResourceGroupName: logAnalyticsResourceGroupName
    dataSourceName: logAnalyticsName
    frequencyInMinutes: frequencyInMinutes
    timeWindowInMinutes: timeWindowInMinutes
    severity: severity
    aznsAction: {
      actionGroup: actionGroupIds
      emailSubject: '${item} failure alerts are being triggered in Log Analytics'
    }
    tags: tags
  }
}]