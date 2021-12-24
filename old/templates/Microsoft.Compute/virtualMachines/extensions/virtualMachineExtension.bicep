@description('The name of the Virtual Machine Extension resource that you wish to create.')
param vmExtensionName string

@description('The name of the Virtual Machine to apply the extension to.')
param vmName string

@description('The location to deploy the Virtual Machine Extension to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The version Virtual Machine Extension that you wish to create.')
param typeHandlerVersion string

@description('The publisher of the Virtual Machine Extension that you wish to create.')
param publisher string

@description('The type of the Virtual Machine Extension that you wish to create')
param type string

@description('If this value is different compared to')
param forceUpdateTag string = 'v1.0'

@description('Unencrypted settings for the extension')
param settings object = {}

@description('Encrypted settings for the extension')
@secure()
param protectedSettings object = {}
param tags object

resource vmName_vmExtensionName 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: '${vmName}/${vmExtensionName}'
  location: location
  tags: tags
  properties: {
    publisher: publisher
    type: type
    typeHandlerVersion: typeHandlerVersion
    autoUpgradeMinorVersion: true
    forceUpdateTag: forceUpdateTag
    settings: settings
    protectedSettings: protectedSettings
  }
}

output virtualMachineExtension object = reference(vmName_vmExtensionName.id, '2019-03-01', 'Full')