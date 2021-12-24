@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string
param runbooks array
param automationAccountName string
param location string = resourceGroup().location
param scheduleName string
param scheduleDescription string
param startTime string
param expiryTime string = '31/12/9999 23:59:00'
param interval int

@allowed([
  'OneTime'
  'Minute'
  'Hour'
  'Day'
  'Week'
  'Month'
])
param frequency string
param deployJobSchedule bool = false
param timeZone string = 'Europe/London'
param advancedSchedule object = {}

@description('Tags to apply to resources')
param tags object

var templateBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/'
var runbookBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/runbooks'
var runbookTemplateUrl = '${templateBaseUrl}Microsoft.Automation/automationAccounts/runbooks/runbook.1.0.0.0.json${templatesSas}'
var scheduleTemplateUrl = '${templateBaseUrl}Microsoft.Automation/automationAccounts/schedules/schedule.1.0.2.0.json${templatesSas}'
var jobScheduleTemplateUrl = '${templateBaseUrl}Microsoft.Automation/automationAccounts/jobSchedules/jobSchedule.1.1.1.0.json${templatesSas}'

module runbooks_runbookLoop_name '?' /*TODO: replace with correct path to [variables('runbookTemplateUrl')]*/ = [for item in runbooks: {
  name: item.name
  params: {
    runbookName: item.name
    automationAccountName: automationAccountName
    storageAccountContainerUrl: runbookBaseUrl
    sasToken: templatesSas
    runbookVersion: item.version
    description: item.description
    location: location
    logVerbose: (contains(item, 'logVerbose') ? item.logVerbose : json('true'))
    logProgress: (contains(item, 'logProgress') ? item.logProgress : json('true'))
    runbookType: (contains(item, 'runbookType') ? item.runbookType : json('"Script"'))
    logActivityTrace: (contains(item, 'logVerbose') ? item.logVerbose : json('0'))
    tags: (contains(item, 'tags') ? union(item.tags, tags) : tags)
  }
}]

module scheduleName_resource '?' /*TODO: replace with correct path to [variables('scheduleTemplateUrl')]*/ = {
  name: concat(scheduleName)
  params: {
    scheduleName: scheduleName
    automationAccountName: automationAccountName
    description: scheduleDescription
    startTime: startTime
    expiryTime: expiryTime
    interval: interval
    frequency: frequency
    timeZone: timeZone
    advancedSchedule: advancedSchedule
  }
}

module runbooks_runbookScheduleLoop_name_scheduleName '?' /*TODO: replace with correct path to [variables('jobScheduleTemplateUrl')]*/ = [for item in runbooks: {
  name: concat(item.name, scheduleName)
  params: {
    scheduleName: scheduleName
    runbookName: item.name
    runbookVersion: item.version
    automationAccountName: automationAccountName
    parameters: (contains(item, 'parameters') ? runbooks[copyIndex('runbookLoop')].parameters : json('{}'))
    runOn: (contains(item, 'runOn') ? runbooks[copyIndex('runbookLoop')].parameters : json('""'))
  }
  dependsOn: [
    runbooks_runbookLoop_name
    scheduleName_resource
  ]
}]