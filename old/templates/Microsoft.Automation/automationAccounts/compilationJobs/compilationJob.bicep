@description('Name of the Automation Account to compile the DSC in')
param compilationJobName string = newGuid()

@description('Name of the Automation Account to compile the DSC in')
param automationAccountName string

@description('Location of the Compilation Job')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Name of the Node Configuration to make compile in the Automation Account')
param configurationName string

@description('JSON escaped string for configuration data to pass into the node configuration')
param configurationData string

@description('Create new node configuration or overwrite existing')
param incrementNodeConfigurationBuild bool = false

@description('Tags to apply to Compilation Job')
param tags object

resource automationAccountName_compilationJobName 'Microsoft.Automation/automationAccounts/compilationJobs@2015-10-31' = {
  name: '${automationAccountName}/${compilationJobName}'
  location: location
  tags: tags
  properties: {
    configuration: {
      name: configurationName
    }
    parameters: {
      configurationData: configurationData
    }
    incrementNodeConfigurationBuild: incrementNodeConfigurationBuild
  }
}

output compilationJob object = reference(automationAccountName_compilationJobName.id, '2015-10-31', 'Full')