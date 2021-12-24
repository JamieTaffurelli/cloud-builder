@description('The name of the Metric Alert to deploy')
param metricAlertName string

@description('The description of the Metric Alert')
param description string

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

@description('Resource IDs that the Metric Alert is scoped to')
param scopes array

@description('How often to evalute Metric (ISO 8601)')
param evaluationFrequency string

@description('Period of time to monitor (ISO 8601)')
param windowSize string

@description('Resource type of the target resource(s)')
param targetResourceType string

@description('Region of the target resource(s)')
param targetResourceRegion string = resourceGroup().location

@description('Type of Alert criteria')
@allowed([
  'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
])
param type string

@description('Metric Criteria objects')
param allOf array

@description('Auto resolve alert')
param autoMitigate bool = true

@description('Action to take on Metric Alert (Action Group or Webhook)')
param actions array

@description('Tags to apply to Metric Alert')
param tags object

resource metricAlertName_resource 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertName
  location: 'global'
  tags: tags
  properties: {
    description: description
    severity: severity
    enabled: enabled
    scopes: scopes
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: targetResourceType
    targetResourceRegion: targetResourceRegion
    criteria: {
      'odata.type': type
      allOf: allOf
    }
    autoMitigate: autoMitigate
    actions: actions
  }
}

output metricAlert object = reference(metricAlertName_resource.id, '2018-03-01', 'Full')