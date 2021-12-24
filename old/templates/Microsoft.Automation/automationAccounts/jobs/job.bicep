@description('Name of the job to apply to the runbook')
param jobName string

@description('Name of the Automation Account to run the job')
param runbookName string

@description('Name of the Automation Account to run the job')
param automationAccountName string

@description('Parameters to pass to the runbook')
@secure()
param parameters object = {}

@description('Group name where job will be executed')
param runOn string = ''

resource automationAccountName_jobName 'Microsoft.Automation/automationAccounts/jobs@2017-05-15-preview' = {
  name: '${automationAccountName}/${guid(jobName)}'
  properties: {
    runbook: {
      name: runbookName
    }
    parameters: parameters
    runOn: runOn
  }
}

output job object = reference(resourceId('Microsoft.Automation/automationAccounts/jobs', automationAccountName, jobName), '2017-05-15-preview', 'Full')