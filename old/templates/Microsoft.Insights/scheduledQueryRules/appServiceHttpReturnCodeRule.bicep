@description('The name of the App Gateway to pull data from')
param appServiceName string

@description('The location to deploy the Scheduled Query Rule to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Percentage of failed requests to requests before alerting')
@minValue(0)
@maxValue(100)
param failurePercentage int = 0

@description('Enable or Disable the Metric Alert')
param enabled string = 'true'

@description('The Subscription ID of the data source to query')
param dataSourceSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the data source to query')
param dataSourceResourceGroupName string = resourceGroup().name

@description('The name of the data source to query')
param dataSourceName string

@description('How often to run the query')
param frequencyInMinutes int = 5

@description('Time period in which to query data')
param timeWindowInMinutes int = 5

@description('Severity of the Scheduled Query Rule')
@allowed([
  0
  1
  2
  3
  4
])
param severity int

@description('Action object: actionGroup, emailSubject, customWebhookPayload')
param aznsAction object

@description('Tags to apply to Scheduled Query Rule')
param tags object

var queryName_var = '${appServiceName}-http-return-code-rule'
var query = 'let appServiceRequests = AppServiceHTTPLogs | where _ResourceId contains "${toUpper(appServiceName)}"; let requestCount = AppServiceHTTPLogs | summarize appRequestCount = count() | extend output = "output"; AppServiceHTTPLogs | where ScStatus >= 400 | summarize failedRequestCount = count() | extend output = "output" | join requestCount on output | project failurePercent = (100 * todouble(failedRequestCount) / todouble(appRequestCount)) | where failurePercent > ${failurePercentage}'

resource queryName 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: queryName_var
  location: location
  tags: tags
  properties: {
    description: 'Query for App Service ${appServiceName} return codes greater than or equal to 400'
    enabled: enabled
    source: {
      query: query
      dataSourceId: resourceId(dataSourceSubscriptionId, dataSourceResourceGroupName, 'Microsoft.OperationalInsights/workspaces', dataSourceName)
      queryType: 'ResultCount'
    }
    schedule: {
      frequencyInMinutes: frequencyInMinutes
      timeWindowInMinutes: timeWindowInMinutes
    }
    action: {
      'odata.type': 'Microsoft.WindowsAzure.Management.Monitoring.Alerts.Models.Microsoft.AppInsights.Nexus.DataContracts.Resources.ScheduledQueryRules.AlertingAction'
      severity: severity
      aznsAction: aznsAction
      trigger: {
        thresholdOperator: 'GreaterThan'
        threshold: '0'
      }
    }
  }
}

output scheduledQueryRule object = reference(queryName.id, '2018-04-16', 'Full')