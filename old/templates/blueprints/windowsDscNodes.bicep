@description('The storage account to pull templates from')
param templateStorageAccountName string

@description('The SAS token for then storage account to pull templates from')
@secure()
param templatesSas string
param configurationName string
param configurationVersion string
param configurationDescription string
param automationAccountName string
param configurationData string
param vmNames array
param dscExtensionVersion string = '2.80'

@allowed([
  'ApplyAndAutoCorrect'
  'ApplyAndMonitor'
])
param configurationMode string = 'ApplyAndMonitor'
param rebootNodeIfNeeded bool = true
param actionAfterReboot string = 'ContinueConfiguration'
param allowModuleOverwrite bool = true

@description('Tags to apply to resources')
param tags object

var templateBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/templates/'
var dscBaseUrl = 'https://${templateStorageAccountName}.blob.core.windows.net/dsc/'
var dscConfigurationTemplateUrl = '${templateBaseUrl}Microsoft.Automation/automationAccounts/configurations/configuration.1.1.1.0.json${templatesSas}'
var compilationJobTemplateUrl = '${templateBaseUrl}Microsoft.Automation/automationAccounts/compilationJobs/compilationJob.1.2.0.0.json${templatesSas}'
var vmExtensionTemplateUrl = '${templateBaseUrl}Microsoft.Compute/virtualMachines/extensions/virtualMachineExtension.1.1.0.0.json${templatesSas}'

module configurationName_resource '?' /*TODO: replace with correct path to [variables('dscConfigurationTemplateUrl')]*/ = {
  name: configurationName
  params: {
    configurationName: configurationName
    automationAccountName: automationAccountName
    storageAccountContainerUrl: '${dscBaseUrl}configurations'
    sasToken: templatesSas
    configurationVersion: configurationVersion
    description: configurationDescription
  }
}

module configurationName_compile '?' /*TODO: replace with correct path to [variables('compilationJobTemplateUrl')]*/ = {
  name: '${configurationName}-compile'
  params: {
    configurationName: concat(configurationName, configurationVersion)
    automationAccountName: automationAccountName
    configurationData: configurationData
    tags: tags
  }
  dependsOn: [
    configurationName_resource
  ]
}

module vmNames_vmDscLoop_configurationName '?' /*TODO: replace with correct path to [variables('vmExtensionTemplateUrl')]*/ = [for item in vmNames: {
  name: concat(item, configurationName)
  params: {
    vmExtensionName: 'Microsoft.Powershell.DSC'
    vmName: item
    typeHandlerVersion: dscExtensionVersion
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    settings: {
      Properties: [
        {
          Name: 'RegistrationKey'
          Value: {
            UserName: 'PLACEHOLDER_DONOTUSE'
            Password: 'PrivateSettingsRef:registrationKeyPrivate'
          }
          TypeName: 'System.Management.Automation.PSCredential'
        }
        {
          Name: 'RegistrationUrl'
          Value: reference(resourceId('Microsoft.Automation/automationAccounts/', automationAccountName), '2015-10-31').registrationUrl
          TypeName: 'System.String'
        }
        {
          Name: 'NodeConfigurationName'
          Value: '${configurationName}${configurationVersion}.${item}'
          TypeName: 'System.String'
        }
        {
          Name: 'ConfigurationMode'
          Value: configurationMode
          TypeName: 'System.String'
        }
        {
          Name: 'RebootNodeIfNeeded'
          Value: rebootNodeIfNeeded
          TypeName: 'System.Boolean'
        }
        {
          Name: 'ActionAfterReboot'
          Value: actionAfterReboot
          TypeName: 'System.String'
        }
        {
          Name: 'AllowModuleOverwrite'
          Value: allowModuleOverwrite
          TypeName: 'System.Boolean'
        }
      ]
    }
    protectedSettings: {
      Items: {
        registrationKeyPrivate: listKeys(resourceId('Microsoft.Automation/automationAccounts/', automationAccountName), '2018-06-30').Keys[0].value
      }
    }
    tags: tags
  }
  dependsOn: [
    'Microsoft.Resources/deployments/${configurationName}-compile'
  ]
}]