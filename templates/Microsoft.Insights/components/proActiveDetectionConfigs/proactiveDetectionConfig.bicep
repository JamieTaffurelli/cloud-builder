@description('The name of the Proactive Rule to deploy')
@allowed([
  'slowpageloadtime'
  'slowserverresponsetime'
  'longdependencyduration'
  'degradationinserverresponsetime'
  'degradationindependencyduration'
  'extension_traceseveritydetector'
  'extension_exceptionchangeextension'
  'extension_memoryleakextension'
  'extension_securityextensionspackage'
  'extension_billingdatavolumedailyspikeextension'
])
param ruleDefinitionName string

@description('The name of the Application Insights to attach the Proactive Detection Config to')
param appInsightsName string

@description('The location to deploy the Proactive Detection Config to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Enable or Disable the Proactive Detection Config')
param enabled bool = true

@description('Send all alerts to subscription owners (not recommended)')
param sendEmailsToSubscriptionOwners bool = false

@description('Send alerts to additional email addresses')
param customEmails array = []

resource appInsightsName_ruleDefinitionName 'Microsoft.Insights/components/proactiveDetectionConfigs@2018-05-01-preview' = {
  name: '${appInsightsName}/${ruleDefinitionName}'
  location: location
  properties: {
    Enabled: enabled
    SendEmailsToSubscriptionOwners: sendEmailsToSubscriptionOwners
    CustomEmails: customEmails
    RuleDefinitions: {
      Name: ruleDefinitionName
    }
  }
}

output proactiveDetectionConfig object = reference(appInsightsName_ruleDefinitionName.id, '2018-05-01-preview', 'Full')