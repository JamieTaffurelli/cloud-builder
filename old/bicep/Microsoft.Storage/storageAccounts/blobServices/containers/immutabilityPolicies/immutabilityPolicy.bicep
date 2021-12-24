@description('The name of the Storage Account Container')
@minLength(3)
@maxLength(63)
param containerName string

@description('The name of the Storage Account')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('The number of days to keep a blob immutable')
@minValue(1)
@maxValue(146000)
param immutabilityPeriodSinceCreationInDays int = 146000

resource storageAccountName_default_containerName_default 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2019-04-01' = {
  name: '${storageAccountName}/default/${containerName}/default'
  properties: {
    immutabilityPeriodSinceCreationInDays: immutabilityPeriodSinceCreationInDays
  }
}