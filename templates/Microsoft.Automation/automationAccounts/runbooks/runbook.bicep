@description('Name of the runbook to make availiable in the Automation Account')
param runbookName string

@description('Name of the Automation Account to consume the runbook')
param automationAccountName string

@description('Location of the runbook')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Enable verbose logging')
param logVerbose bool = true

@description('Enable progress logging')
param logProgress bool = true

@description('Enable progress logging')
@allowed([
  'Script'
  'Graph'
  'PowerShellWorkflow'
  'PowerShell'
  'GraphPowerShellWorkflow'
  'GraphPowerShell'
])
param runbookType string = 'PowerShell'

@description('Storage Account URL to \'folder\' to get the runbook from')
param storageAccountContainerUrl string

@description('SAS token to authenticate against configuration Storage Account')
@secure()
param sasToken string

@description('Version of the runbook to make availiable in the Automation Account')
param runbookVersion string

@description('Description of the runbook to make availiable in the Automation Account')
param description string

@description('Description of the runbook to make availiable in the Automation Account')
@allowed([
  0
  1
  2
])
param logActivityTrace int = 0

@description('Tags to apply to runbook')
param tags object

resource automationAccountName_runbookName 'Microsoft.Automation/automationAccounts/runbooks@2018-06-30' = {
  name: '${automationAccountName}/${runbookName}'
  location: location
  tags: tags
  properties: {
    logVerbose: logVerbose
    logProgress: logProgress
    runbookType: runbookType
    publishContentLink: {
      uri: '${storageAccountContainerUrl}/${runbookName}.${runbookVersion}.ps1${sasToken}'
      version: runbookVersion
    }
    description: description
    logActivityTrace: logActivityTrace
  }
}

output runbook object = reference(automationAccountName_runbookName.id, '2018-06-30', 'Full')