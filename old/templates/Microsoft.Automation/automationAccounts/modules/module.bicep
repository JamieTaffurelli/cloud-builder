@description('Name of the module to make availiable in the Automation Account')
param moduleName string

@description('Name of the Automation Account to consume the module')
param automationAccountName string

@description('Storage Account URL to \'folder\' to get the module from')
param storageAccountContainerUrl string

@description('SAS token to authenticate against module Storage Account')
@secure()
param sasToken string

@description('Version of the module to make availiable in the Automation Account')
param moduleVersion string

@description('File extension of the module to make availiable in the Automation Account')
@allowed([
  'zip'
  'nupkg'
])
param moduleFileType string = 'nupkg'

var moduleName_var = toLower(moduleName)

resource automationAccountName_moduleName 'Microsoft.Automation/automationAccounts/modules@2015-10-31' = {
  name: '${automationAccountName}/${moduleName}'
  properties: {
    contentLink: {
      uri: '${storageAccountContainerUrl}/${moduleName_var}.${moduleVersion}.${moduleFileType}${sasToken}'
    }
  }
}

output module object = reference(automationAccountName_moduleName.id, '2015-10-31', 'Full')