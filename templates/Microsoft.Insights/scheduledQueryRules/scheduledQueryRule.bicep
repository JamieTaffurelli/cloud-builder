@description('The name of the Scheduled Query Rule to deploy')
param scheduledQueryRuleName string

@description('The location to deploy the Scheduled Query Rule to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The description of the Scheduled Query Rule')
param description string

@description('Enable or Disable the Metric Alert')
param enabled string = 'true'

@description('The query to run')
param query string

@description('List of resources referred to in query (for cross workspace queries)')
param authorizedResources array = []

@description('The Subscription ID of the data source to query')
param dataSourceSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the data source to query')
param dataSourceResourceGroupName string = resourceGroup().name

@description('The type of data source to query')
@allowed([
  'Microsoft.OperationalInsights/workspaces'
  'Microsoft.Insights/components'
])
param dataSourceType string = 'Microsoft.OperationalInsights/workspaces'

@description('The name of the data source to query')
param dataSourceName string

@description('How often to run the query')
param frequencyInMinutes int

@description('Time period in which to query data')
param timeWindowInMinutes int

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

@description('Trigger object: thresholdOperator, threshold and metric object')
param trigger object

@description('Tags to apply to Scheduled Query Rule')
param tags object

resource scheduledQueryRuleName_resource 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: scheduledQueryRuleName
  location: location
  tags: tags
  properties: {
    description: description
    enabled: enabled
    source: {
      query: query
      authorizedResources: authorizedResources
      dataSourceId: resourceId(dataSourceSubscriptionId, dataSourceResourceGroupName, dataSourceType, dataSourceName)
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
      trigger: trigger
    }
  }
}

output scheduledQueryRule object = reference(scheduledQueryRuleName_resource.id, '2018-04-16', 'Full')