@description('The name of the Backup Policy to attach to the Virtual Machine')
param backupPolicyName string = 'iaas-backup'

@description('The name of the Recovery Services Vault that you wish to store backups in')
param vaultName string

@description('The name of the Virtual Machine that you wish to set a backup for')
param vmName string

@description('The Resource Group name of the Virtual Machine that you wish to set a backup for')
param vmResourceGroupName string = resourceGroup().name

@description('The location to deploy the Recovery Services Backup Policy to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location
param tags object

var backupFabric = 'Azure'
var protectionContainer = 'iaasvmcontainer;iaasvmcontainerv2;${vmResourceGroupName};${vmName}'
var protectedItem = 'vm;iaasvmcontainerv2;${vmResourceGroupName};${vmName}'

resource vaultName_backupFabric_protectionContainer_protectedItem 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2019-05-13' = {
  name: '${vaultName}/${backupFabric}/${protectionContainer}/${protectedItem}'
  location: location
  tags: tags
  properties: {
    sourceResourceId: resourceId(vmResourceGroupName, 'Microsoft.Compute/virtualMachines', vmName)
    policyId: resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', vaultName, backupPolicyName)
    protectedItemType: 'Microsoft.Compute/virtualMachines'
  }
}

output vmProtectedItem object = reference(vaultName_backupFabric_protectionContainer_protectedItem.id, '2019-05-13', 'Full')