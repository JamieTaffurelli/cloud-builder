@description('Name of the Credential to create in the Automation Account')
param credentialName string

@description('Name of the Automation Account')
param automationAccountName string

@description('Username of the Credential to create in the Automation Account')
param userName string

@description('Password of the Credential to create in the Automation Account')
@secure()
param password string

@description('Description of the Credential')
param description string

resource automationAccountName_credentialName 'Microsoft.Automation/automationAccounts/credentials@2015-10-31' = {
  name: '${automationAccountName}/${credentialName}'
  properties: {
    userName: userName
    password: password
    description: description
  }
}