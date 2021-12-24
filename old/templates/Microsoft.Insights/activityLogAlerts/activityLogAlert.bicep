@description('The name of the Activity Log Alert to deploy')
param activityLogAlertName string

@description('The description of the Activity Log Alert')
param description string

@description('Enable or Disable the Activity Log Alert')
param enabled bool = true

@description('Resource IDs that the Activity Log Alert is scoped to')
param scopes array

@description('List of Activity Log Alert conditions')
param allOf array

@description('Action to take on Activity Log Alert (Action Group or Webhook)')
param actions object

@description('Tags to apply to Activity Log Alert')
param tags object

resource activityLogAlertName_resource 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertName
  location: 'global'
  tags: tags
  properties: {
    description: description
    enabled: enabled
    scopes: scopes
    condition: {
      allOf: allOf
    }
    actions: actions
  }
}

output metricAlert object = reference(activityLogAlertName_resource.id, '2017-04-01', 'Full')