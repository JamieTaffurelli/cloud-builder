@description('Name of the schedule to create')
param scheduleName string

@description('Name of the Automation Account to host the schedule')
param automationAccountName string

@description('Description of the schedule')
param description string

@description('Start time of schedule')
param startTime string

@description('Expiry time of schedule')
param expiryTime string = '31/12/9999 23:59:00'

@description('Interval of the schedule')
param interval int = 1

@description('Frequency of the schedule')
@allowed([
  'OneTime'
  'Minute'
  'Hour'
  'Day'
  'Week'
  'Month'
])
param frequency string

@description('Timezone of the schedule')
param timeZone string = 'Europe/London'

@description('Advanced schedule for days of the week or month')
param advancedSchedule object = {}

resource automationAccountName_scheduleName 'Microsoft.Automation/automationAccounts/schedules@2015-10-31' = {
  name: '${automationAccountName}/${scheduleName}'
  properties: {
    description: description
    startTime: startTime
    expiryTime: expiryTime
    interval: interval
    frequency: frequency
    timeZone: timeZone
    advancedSchedule: advancedSchedule
  }
}

output schedule object = reference(automationAccountName_scheduleName.id, '2015-10-31', 'Full')