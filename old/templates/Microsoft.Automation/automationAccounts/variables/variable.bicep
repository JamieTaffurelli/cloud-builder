@description('Name of the Variable to create in the Automation Account')
param variableName string

@description('Name of the Automation Account')
param automationAccountName string

@description('Value of the Variable to create in the Automation Account')
@secure()
param value string

@description('Description of the Variable')
param description string

resource automationAccountName_variableName 'Microsoft.Automation/automationAccounts/variables@2015-10-31' = {
  name: '${automationAccountName}/${variableName}'
  properties: {
    value: value
    description: description
    isEncrypted: true
  }
}