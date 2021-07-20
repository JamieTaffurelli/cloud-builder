@description('Virtual machines Logical service grouping, e.g: \'BuildServers\', \'SQLServerCluster\'')
param virtualMachinesServiceName string

@description('The virtual Machines name')
param virtualMachineNames array

@description('The location to deploy the Scheduled Query Rule to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Percentage level of free Disk space before alerting')
@minValue(0)
@maxValue(100)
param freeSpacePercentage int = 10

@description('Enable or Disable the Metric Alert')
param enabled string = 'true'

@description('The Subscription ID of the data source to query')
param dataSourceSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the data source to query')
param dataSourceResourceGroupName string = 'defaultresourcegroup-weu'

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

var virtualMachineNames_var = replace(replace(string(virtualMachineNames), '[', ''), ']', '')
var queryName_var = '${virtualMachinesServiceName}-disk-lower-than-${freeSpacePercentage}-percent-rule'
var query = 'InsightsMetrics | where Name == "FreeSpacePercentage" and Val <= ${freeSpacePercentage} and Computer has_any (${virtualMachineNames_var}) | distinct Computer'

resource queryName 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: queryName_var
  location: location
  tags: tags
  properties: {
    description: 'Query for ${queryName_var}'
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