@description('The name of the Storage Account Container')
@minLength(3)
@maxLength(63)
param containerName string

@description('The name of the Storage Account')
@minLength(3)
@maxLength(24)
param storageAccountName string

resource storageAccountName_default_containerName 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-04-01' = {
  name: '${storageAccountName}/default/${containerName}'
  properties: {
    publicAccess: 'None'
  }
}