@description('Name of the configuration to make availiable in the Automation Account')
param configurationName string

@description('Location of the Automation Account')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Name of the Automation Account to consume the configuration')
param automationAccountName string

@description('Enable verbose logging')
param logVerbose bool = true

@description('Enable log progress')
param logProgress bool = true

@description('Storage Account URL to \'folder\' to get the configuration from')
param storageAccountContainerUrl string

@description('SAS token to authenticate against configuration Storage Account')
@secure()
param sasToken string

@description('Version of the configuration to make availiable in the Automation Account')
param configurationVersion string

@description('Description of the configuration to make availiable in the Automation Account')
param description string

var configurationName_var = concat(configurationName, configurationVersion)

resource automationAccountName_configurationName 'Microsoft.Automation/automationAccounts/configurations@2015-10-31' = {
  name: '${automationAccountName}/${configurationName_var}'
  location: location
  properties: {
    logVerbose: logVerbose
    logProgress: logProgress
    source: {
      type: 'uri'
      value: '${storageAccountContainerUrl}/${configurationName}${configurationVersion}.ps1${sasToken}'
    }
    description: description
  }
}

output configuration object = reference(automationAccountName_configurationName.id, '2015-10-31', 'Full')