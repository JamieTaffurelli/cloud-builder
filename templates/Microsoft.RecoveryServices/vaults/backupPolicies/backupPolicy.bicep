@description('The name of the Recovery Services Backup Policy that you wish to create.')
param backupPolicyName string

@description('The name of the Recovery Services Vault that you wish to deploy the Backup Policy to.')
param vaultName string

@description('The location to deploy the Recovery Services Backup Policy to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The properties of the Backup Policy')
param properties object
param tags object

resource vaultName_backupPolicyName 'Microsoft.RecoveryServices/vaults/backupPolicies@2016-06-01' = {
  name: '${vaultName}/${backupPolicyName}'
  location: location
  tags: tags
  properties: properties
}

output backupPolicy object = reference(vaultName_backupPolicyName.id, '2016-06-01', 'Full')