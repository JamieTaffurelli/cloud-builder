@description('The Subscription ID of the Azure Resource you wish to schedule for.')
param resourceSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Azure Resource you wish to schedule for.')
param resourceGroupName string = resourceGroup().name

@description('The tyep of the Azure Resource you wish to schedule for.')
param resourceType string = 'Microsoft.Compute/virtualMachines'

@description('The name of the Azure Resource you wish to schedule for.')
param resourceName string

@description('The location to deploy the schedule to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Enable or disable the shutdown schedule')
@allowed([
  'Enabled'
  'Disabled'
])
param status string = 'Enabled'

@description('Time of day to run job')
param timeOfDay string = '1900'

@description('Timezone of job schedule')
param timeZoneId string = 'GMT Standard Time'

@description('Notification settings for job execution')
param notificationSettings object = {}
param tags object

var scheduleName_var = 'shutdown-computevm-${resourceName}'

resource scheduleName 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: scheduleName_var
  location: location
  tags: tags
  properties: {
    status: status
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: timeOfDay
    }
    timeZoneId: timeZoneId
    notificationSettings: notificationSettings
    targetResourceId: resourceId(resourceSubscriptionId, resourceGroupName, resourceType, resourceName)
  }
}

output schedule object = reference(scheduleName.id, '2018-09-15', 'Full')