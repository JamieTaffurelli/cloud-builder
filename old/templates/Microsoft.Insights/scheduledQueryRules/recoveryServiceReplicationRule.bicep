@description('The name of the Recovery Services Vault to pull data from')
param vaultName string

@description('The location to deploy the Scheduled Query Rule to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

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

@description('Number of results (greater than) before alert is triggered')
param threshold string = '0'

@description('Tags to apply to Scheduled Query Rule')
param tags object

var queryName_var = '${vaultName}-replication-alert'
var query = 'AzureDiagnostics | where Category == "AzureSiteRecoveryReplicatedItems" and (replicationHealth_s == "Critical" or replicationHealth_s == "Warning") and Resource == "${toUpper(vaultName)}"'

resource queryName 'Microsoft.Insights/scheduledQueryRules@2018-04-16' = {
  name: queryName_var
  location: location
  tags: tags
  properties: {
    description: 'Query for Recovery Services Vault ${vaultName} replication health status'
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
        threshold: threshold
      }
    }
  }
}

output scheduledQueryRule object = reference(queryName.id, '2018-04-16', 'Full')