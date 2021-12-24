@description('Name of the job to apply to the runbook')
param scheduleName string

@description('Name of the runbook to run the job')
param runbookName string

@description('Version of the runbook to run the job')
param runbookVersion string

@description('Name of the Automation Account to run the job')
param automationAccountName string

@description('Parameters to pass to the runbook')
@secure()
param parameters object = {}

@description('Group name where job will be executed')
param runOn string = ''

resource automationAccountName_runbookName_runbookVersion_scheduleName 'Microsoft.Automation/automationAccounts/jobSchedules@2015-10-31' = {
  name: '${automationAccountName}/${guid('${runbookName}-${runbookVersion}-${scheduleName}')}'
  properties: {
    schedule: {
      name: scheduleName
    }
    runbook: {
      name: runbookName
    }
    parameters: parameters
    runOn: runOn
  }
}

output jobSchedule object = reference(automationAccountName_runbookName_runbookVersion_scheduleName.id, '2015-10-31', 'Full')