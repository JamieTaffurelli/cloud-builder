@description('The name of the Storage Account')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Cross Origin Resource Sharing rules')
param corsRules array = []

@description('Number of days to retain deleted blobs')
@minValue(1)
@maxValue(365)
param retentionDays int = 365

@description('Enable auto snapshot of blobs')
param automaticSnapshotEnabled bool = true

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2019-04-01' = {
  name: '${storageAccountName}/default'
  properties: {
    cors: {
      corsRules: corsRules
    }
    deleteRetentionPolicy: {
      enabled: true
      days: retentionDays
    }
    automaticSnapshotPolicyEnabled: automaticSnapshotEnabled
  }
}