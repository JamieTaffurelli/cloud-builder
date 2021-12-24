@description('The name of the Storage Account')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Management Policy rules')
param rules array

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/managementPolicies@2019-06-01' = {
  name: '${storageAccountName}/default'
  properties: {
    policy: {
      rules: rules
    }
  }
}