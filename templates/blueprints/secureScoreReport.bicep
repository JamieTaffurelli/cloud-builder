@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string

@description('Name of Log Analytics Connector')
param logAnalyticsConnectorName string

@description('Display Name of the Log Analytics Connector')
param logAnalyticsConnectorDisplayName string
param logicAppName string
param logicAppVersion string

@description('Sku of the Logic App')
@allowed([
  'Free'
  'Basic'
  'Standard'
])
param sku string = 'Standard'

@description('Allowed outbound IP address for workflow')
param workflowOutGoingIpAddresses array = []

@description('Access endpoint IP addresses for workflow')
param workflowAccessEndpointsIpAddresses array = []

@description('Allowed outbound IP address for connector')
param connectorOutGoingIpAddresses array = []

@description('Access endpoint IP addresses for connector')
param connectorAccessEndpointsIpAddresses array = []

@description('Allowed trigger caller IP addresses')
param triggerCallerIpAddresses array = []

@description('Authentication polices for trigger')
param triggerAuthenticationPolicies object = {}

@description('Allowed contents caller IP addresses')
param contentsCallerIpAddresses array = []

@description('Authentication polices for contents')
param contentsAuthenticationPolicies object = {}

@description('Allowed action caller IP addresses')
param actionCallerIpAddresses array = []

@description('Authentication polices for action')
param actionAuthenticationPolicies object = {}

@description('Allowed workflow caller IP addresses')
param workflowCallerIpAddresses array = []

@description('Authentication polices for workflow')
param workflowAuthenticationPolicies object = {}

@description('The name of the Workbook')
param workbookName string

@description('Kind of workbook')
@allowed([
  'Shared'
  'User'
])
param kind string = 'Shared'

@description('Display name of the workbook')
param workbookDisplayName string

@description('JSON configuration of workbook')
param serializedData string = ''

@description('Workbook version')
param workbookVersion string

@description('Workbook tags')
param workbookTags array = []

@description('The Subscription ID of the Log Analytics Workspace')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace')
param logAnalyticsName string

@description('Tags to apply to resources')
param tags object

var templateBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/'
var connectorTemplateUrl = '${templateBaseUrl}Microsoft.Web/connections/connector.1.1.0.0.json${templatesSas}'
var logicAppTemplateUrl = '${templateBaseUrl}Microsoft.Logic/workflows/secureScore.1.0.1.0.json${templatesSas}'
var workbookTemplateUrl = '${templateBaseUrl}Microsoft.Insights/workbooks/workbook.1.0.3.0.json${templatesSas}'
var defaultSerializedData = '{"version":"Notebook/1.0","items":[{"type":1,"content":{"json":"# Secure Score History"},"name":"text - 7"},{"type":9,"content":{"version":"KqlParameterItem/1.0","parameters":[{"id":"0ad3d0b6-a044-4cac-86f3-9b9ea9744ed2","version":"KqlParameterItem/1.0","name":"TimeRange","type":4,"isRequired":true,"value":{"durationMs":2419200000},"typeSettings":{"selectableValues":[{"durationMs":300000},{"durationMs":900000},{"durationMs":1800000},{"durationMs":3600000},{"durationMs":14400000},{"durationMs":43200000},{"durationMs":86400000},{"durationMs":172800000},{"durationMs":259200000},{"durationMs":604800000},{"durationMs":1209600000},{"durationMs":2419200000},{"durationMs":2592000000},{"durationMs":5184000000},{"durationMs":7776000000}]},"resourceType":"microsoft.insights/components"},{"id":"86d256dd-a537-4a55-908e-6e80d87c1157","version":"KqlParameterItem/1.0","name":"Subscription","type":6,"multiSelect":true,"quote":"\'","delimiter":",","value":[],"typeSettings":{"additionalResourceOptions":["value::all"],"includeAll":true},"resourceType":"microsoft.insights/components"}],"style":"pills","queryType":0,"resourceType":"microsoft.insights/components"},"name":"parameters - 0"},{"type":1,"content":{"json":"## Secure Score - All Subs"},"name":"text - 4"},{"type":3,"content":{"version":"KqlItem/1.0","query":"SecureScore_CL| extend SubscriptionId = strcat(split(id_s, \'/\')[2])| summarize arg_max(TimeGenerated, SubscriptionId, *) by bin(TimeGenerated, 1d), SubscriptionId| project TimeGenerated, properties_score_current_d","size":0,"aggregation":3,"timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","crossComponentResources":["/subscriptions/${logAnalyticsSubscriptionId}/resourceGroups/${logAnalyticsResourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/${logAnalyticsName}"],"visualization":"areachart","chartSettings":{"seriesLabelSettings":[{"seriesName":"properties_score_current_d","label":"Current Score"}]}},"name":"Current Score - All Subscriptions"},{"type":1,"content":{"json":"## Secure Score by Sub"},"name":"text - 5"},{"type":3,"content":{"version":"KqlItem/1.0","query":"SecureScore_CL| extend SubscriptionId = strcat(split(id_s, \'/\')[2])| where \\"{Subscription:lable}\\" == \\"All\\" or SubscriptionId in ({Subscription:subid})| summarize arg_max(TimeGenerated, SubscriptionId, *) by bin(TimeGenerated, 1d), SubscriptionId| project TimeGenerated, SubscriptionId, properties_score_current_d","size":0,"aggregation":5,"timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","crossComponentResources":["/subscriptions/${logAnalyticsSubscriptionId}/resourceGroups/${logAnalyticsResourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/${logAnalyticsName}"],"visualization":"linechart"},"name":"Secure Score by Subscription"},{"type":1,"content":{"json":"## Secure Score Controls"},"name":"text - 6"},{"type":3,"content":{"version":"KqlItem/1.0","query":"SecureScoreControls_CL| extend SubscriptionId = strcat(split(id_s, \'/\')[2])| where \\"{Subscription:lable}\\" == \\"All\\" or SubscriptionId in ({Subscription:subid})| summarize arg_max(TimeGenerated, properties_displayName_s, *) by bin(TimeGenerated, 1d), SubscriptionId, properties_displayName_s| project TimeGenerated, properties_displayName_s, SubscriptionId, properties_score_current_d","size":0,"aggregation":5,"timeContext":{"durationMs":0},"timeContextFromParameter":"TimeRange","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces","crossComponentResources":["/subscriptions/${logAnalyticsSubscriptionId}/resourceGroups/${logAnalyticsResourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/${logAnalyticsName}"],"visualization":"linechart","gridSettings":{"sortBy":[{"itemKey":"properties_displayName_s","sortOrder":1}]},"sortBy":[{"itemKey":"properties_displayName_s","sortOrder":1}]},"name":"query - 7"}],"isLocked":false}'
var serializedData_var = (empty(serializedData) ? defaultSerializedData : serializedData)

module logAnalyticsConnectorName_deploy '?' /*TODO: replace with correct path to [variables('connectorTemplateUrl')]*/ = {
  name: '${logAnalyticsConnectorName}-deploy'
  params: {
    connectorType: 'azureloganalyticsdatacollector'
    connectorName: logAnalyticsConnectorName
    connectorDisplayName: logAnalyticsConnectorDisplayName
    parameterValues: {
      username: reference(resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces/', logAnalyticsName), '2015-11-01-preview').customerId
      password: listKeys(resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces/', logAnalyticsName), '2015-11-01-preview').primarySharedKey
    }
    tags: tags
  }
}

module logicAppName_deploy '?' /*TODO: replace with correct path to [variables('logicAppTemplateUrl')]*/ = {
  name: '${logicAppName}-deploy'
  params: {
    logicAppName: logicAppName
    version: logicAppVersion
    sku: sku
    workflowOutGoingIpAddresses: workflowOutGoingIpAddresses
    workflowAccessEndpointsIpAddresses: workflowAccessEndpointsIpAddresses
    connectorOutGoingIpAddresses: connectorOutGoingIpAddresses
    connectorAccessEndpointsIpAddresses: connectorAccessEndpointsIpAddresses
    triggerCallerIpAddresses: triggerCallerIpAddresses
    triggerAuthenticationPolicies: triggerAuthenticationPolicies
    contentsCallerIpAddresses: contentsCallerIpAddresses
    contentsAuthenticationPolicies: contentsAuthenticationPolicies
    actionCallerIpAddresses: actionCallerIpAddresses
    actionAuthenticationPolicies: actionAuthenticationPolicies
    workflowCallerIpAddresses: workflowCallerIpAddresses
    workflowAuthenticationPolicies: workflowAuthenticationPolicies
    logAnalyticsConnectorId: resourceId('Microsoft.Web/connections', logAnalyticsConnectorName)
    tags: tags
  }
  dependsOn: [
    'Microsoft.Resources/deployments/${logAnalyticsConnectorName}-deploy'
  ]
}

module workbookName_deploy '?' /*TODO: replace with correct path to [variables('workbookTemplateUrl')]*/ = {
  name: '${workbookName}-deploy'
  params: {
    workbookName: workbookName
    kind: kind
    displayName: workbookDisplayName
    serializedData: serializedData_var
    version: workbookVersion
    workbookTags: workbookTags
    sourceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces/', logAnalyticsName)
    tags: tags
  }
}