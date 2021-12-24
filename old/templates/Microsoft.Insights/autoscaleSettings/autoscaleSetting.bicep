@description('The name of the Autoscale Setting')
param autoscaleSettingName string

@description('The location to deploy the Autoscale Setting to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('List of rule profiles')
param profiles array

@description('Send email Alert to Subscription Administrator on Scale operation')
param sendToSubscriptionAdministrator bool = false

@description('Send email Alert to Subscription Co-Administrators on Scale operation')
param sendToSubscriptionCoAdministrators bool = false

@description('Send email Alert to custom email addresses on Scale operation')
param customEmails array = []

@description('Take action via webhook on Scale operation')
param webHooks array = []

@description('Enable or Disable the Autoscale Setting')
param enabled bool = true

@description('Resource ID to apply Autoscale Setting to')
param targetResourceId string

@description('Tags to apply to Action Group')
param tags object

resource autoscaleSettingName_resource 'Microsoft.Insights/autoscaleSettings@2014-04-01' = {
  name: autoscaleSettingName
  location: location
  tags: tags
  properties: {
    profiles: profiles
    notifications: [
      {
        operation: 'Scale'
        email: {
          sendToSubscriptionAdministrator: sendToSubscriptionAdministrator
          sendToSubscriptionCoAdministrators: sendToSubscriptionCoAdministrators
          customEmails: customEmails
        }
        webhooks: webHooks
      }
    ]
    enabled: enabled
    name: autoscaleSettingName
    targetResourceUri: targetResourceId
  }
}

output autoscaleSetting object = reference(autoscaleSettingName_resource.id, '2014-04-01', 'Full')