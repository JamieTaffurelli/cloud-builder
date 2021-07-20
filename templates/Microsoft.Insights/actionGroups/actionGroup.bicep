@description('The name of the Action Groups')
param actionGroupName string

@description('Short name of the Action Group, will appear in SMS messages')
param groupShortName string

@description('Enable or Disable the Action Group')
param enabled bool = true

@description('Email details for the Action Group')
param emailReceivers array = []

@description('SMS details for the Action Group')
param smsReceivers array = []

@description('Web hook details for the Action Group')
param webhookReceivers array = []

@description('Service Desk details for the Action Group')
param itsmReceivers array = []

@description('App push details for the Action Group')
param azureAppPushReceivers array = []

@description('Automation Account Runbook details for the Action Group')
param automationRunbookReceivers array = []

@description('Phone call details for the Action Group')
param voiceReceivers array = []

@description('Logic App details for the Action Group')
param logicAppReceivers array = []

@description('Function App details for the Action Group')
param azureFunctionReceivers array = []

@description('RBAC role details for the Action Group')
param armRoleReceivers array = []

@description('Tags to apply to Action Group')
param tags object

resource actionGroupName_resource 'Microsoft.Insights/actionGroups@2019-06-01' = {
  name: actionGroupName
  location: 'global'
  tags: tags
  properties: {
    groupShortName: groupShortName
    enabled: enabled
    emailReceivers: emailReceivers
    smsReceivers: smsReceivers
    webhookReceivers: webhookReceivers
    itsmReceivers: itsmReceivers
    azureAppPushReceivers: azureAppPushReceivers
    automationRunbookReceivers: automationRunbookReceivers
    voiceReceivers: voiceReceivers
    logicAppReceivers: logicAppReceivers
    azureFunctionReceivers: azureFunctionReceivers
    armRoleReceivers: armRoleReceivers
  }
}

output actionGroup object = reference(actionGroupName_resource.id, '2019-06-01', 'Full')