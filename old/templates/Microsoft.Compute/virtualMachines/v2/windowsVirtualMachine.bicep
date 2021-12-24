@description('The name of the Virtual Machine that you wish to create.')
@minLength(1)
@maxLength(15)
param vmName string

@description('The location to deploy the Virtual Machine to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Specify if VM image deployed requires purchase plan, usually only required for third party images.')
param purchasePlanRequired bool = false

@description('The size of the Virtual Machine')
param vmSize string

@description('The publisher of the Virtual Machine OS disk image')
param imagePublisher string = 'MicrosoftWindowsServer'

@description('The offer of the Virtual Machine OS disk image')
param imageOffer string = 'WindowsServer'

@description('The publisher of the Virtual Machine OS disk image')
param imageSku string = '2016-Datacenter'

@description('The name of the Virtual Machine OS Managed Disk')
param osDiskName string

@description('The caching option of the Virtual Machine OS disk (None, ReadOnly, ReadWrite), defaults to None for Standard storage, ReadOnly for Premium storage')
@allowed([
  ''
  'None'
  'ReadOnly'
  'ReadWrite'
])
param osDiskCaching string = ''

@description('Specifies how the OS disk should be created')
@allowed([
  'FromImage'
  'Empty'
  'Attach'
])
param osDiskCreateOption string = 'FromImage'

@description('Specifies whether writeAccelerator should be enabled or disabled on the disk.')
param writeAcceleratorEnabled bool = false

@description('Size of the OS, maximum size of 2048')
@minValue(127)
@maxValue(2048)
param osDiskSizeInGB int = 127

@description('The underlying Storage Architecture of the Virtual Machine OS disk, only certain VM sizes will support certain Storage Account Types')
@allowed([
  'Standard_LRS'
  'Premium_LRS'
  'StandardSSD_LRS'
  'UltraSSD_LRS'
])
param osDiskStorageAccountType string = 'Premium_LRS'

@description('Specify Data Disks to attach to the Virtual Machine.')
param dataDisks array = []

@description('Local admin user for the VM')
param adminUsername string

@description('Local admin password for the VM')
@secure()
param adminPassword string

@description('Enable Automatic OS updates for the Virtual Machine')
param enableAutomaticUpdates bool = false

@description('Specify Network Interfaces to attach to the Virtual Machine.')
param networkInterfaces array

@description('Storage Account Blob Endpoint to store diagnostic information from the Virtual Machine.')
param diagnosticsStorageAccountName string

@description('Resource ID of the Availabilty Set to deploy Virtual Machine to')
param availabilitySetId string = ''

@description('Deploy to redunant zones')
param zones array = []

@metadata({
  descriptions: 'URL of blob container templates are located'
})
param templateContainerUrl string

@metadata({
  descriptions: 'URL of blob container templates are located'
})
@secure()
param templateSas string

@metadata({
  descriptions: 'Version of Background Info extension'
})
param bgVersion string = '2.1'

@metadata({
  descriptions: 'Version of Dependency Agent extension'
})
param dependencyAgentVersion string = '9.9'

@metadata({
  descriptions: 'Version of Disk Encryption extension'
})
param diskEncryptionVersion string = '2.2'

@metadata({
  descriptions: 'Will force disk encryption to reinstall with default value, pass in static value to override this'
})
param diskEncryptionUpdateTag string = newGuid()

@description('The Subscription ID of the key vault to generate BitLocker encryption key')
param diskEncryptionKeyVaultSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the key vault to generate BitLocker encryption key')
param diskEncryptionKeyVaultResourceGroupName string = resourceGroup().name

@description('The name of the key vault to generate BitLocker encryption key')
param diskEncryptionKeyVaultName string

@description('The Subscription ID of the key vault to apply key encryption key to BitLocker key')
param kekKeyVaultSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the key vault to apply key encryption key to BitLocker key')
param kekKeyVaultResourceGroupName string = resourceGroup().name

@description('The name of the key vault to apply key encryption key to BitLocker key')
param kekKeyVaultName string

@description('The name of the key to apply key encryption key to BitLocker key')
param kekName string

@description('The name of the key vault to generate key encryption key')
param kekVersion string

@description('The encryption algorithm of the kek, RSA-OEAP recommended')
param keyEncryptionAlgorithm string = 'RSA-OAEP'
param tags object

var purchasePlan = {
  name: imageSku
  publisher: imagePublisher
  product: imageOffer
}
var osDiskCaching_var = (empty(osDiskCaching) ? (((osDiskStorageAccountType == 'Premium_LRS') || (osDiskStorageAccountType == 'UltraSSD_LRS')) ? 'ReadWrite' : 'None') : osDiskCaching)
var dataDisks_var = {
  dataDisks: [for j in range(0, (empty(dataDisks) ? 1 : length(dataDisks))): {
    lun: (empty(dataDisks) ? 1 : dataDisks[j].lun)
    caching: ((empty(dataDisks) || (!contains(dataDisks[j], 'caching'))) ? 'ReadOnly' : dataDisks[j].caching)
    writeAcceleratorEnabled: ((empty(dataDisks) || (!contains(dataDisks[j], 'writeAcceleratorEnabled'))) ? json('false') : dataDisks[j].writeAcceleratorEnabled)
    managedDisk: {
      id: (empty(dataDisks) ? 1 : resourceId((contains(dataDisks[j], 'diskSubscriptionId') ? dataDisks[j].diskSubscriptionId : subscription().subscriptionId), (contains(dataDisks[j], 'diskResourceGroupName') ? dataDisks[j].diskResourceGroupName : resourceGroup().name), 'Microsoft.Compute/disks', dataDisks[j].diskName))
    }
    createOption: ((empty(dataDisks) || (!contains(dataDisks[j], 'createOption'))) ? 'Attach' : dataDisks[j].createOption)
  }]
}
var networkInterfaces_var = {
  networkInterfaces: [for item in networkInterfaces: {
    id: resourceId((contains(item, 'networkInterfaceSubscriptionId') ? item.networkInterfaceSubscriptionId : subscription().subscriptionId), (contains(item, 'networkInterfaceResourceGroupName') ? item.networkInterfaceResourceGroupName : resourceGroup().name), 'Microsoft.Network/networkInterfaces', item.networkInterfaceName)
    properties: {
      primary: item.isPrimary
    }
  }]
}
var availabilitySet = {
  id: availabilitySetId
}
var vmExtensionTemplateVersion = '1.1.0.0'
var vmExtensionsTemplateUrl = '${templateContainerUrl}Microsoft.Compute/virtualMachines/extensions/virtualMachineExtension.${vmExtensionTemplateVersion}.json${templateSas}'

resource vmName_resource 'Microsoft.Compute/virtualMachines@2019-03-01' = {
  name: vmName
  location: location
  tags: tags
  plan: ((purchasePlanRequired == json('true')) ? purchasePlan : json('null'))
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: imagePublisher
        offer: imageOffer
        sku: imageSku
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: osDiskName
        caching: osDiskCaching_var
        writeAcceleratorEnabled: writeAcceleratorEnabled
        createOption: osDiskCreateOption
        diskSizeGB: osDiskSizeInGB
        managedDisk: {
          storageAccountType: osDiskStorageAccountType
        }
      }
      dataDisks: (empty(dataDisks) ? json('[]') : dataDisks_var.dataDisks)
    }
    additionalCapabilities: {
      ultraSSDEnabled: ((osDiskStorageAccountType == 'UltraSSD_LRS') ? json('true') : json('false'))
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: enableAutomaticUpdates
      }
    }
    networkProfile: {
      networkInterfaces: networkInterfaces_var.networkInterfaces
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: 'https://${diagnosticsStorageAccountName}.blob.core.windows.net/'
      }
    }
    availabilitySet: ((availabilitySetId == '') ? json('null') : availabilitySet)
  }
  identity: {
    type: 'SystemAssigned'
  }
  zones: zones
}

module vmName_BGInfo '?' /*TODO: replace with correct path to [variables('vmExtensionsTemplateUrl')]*/ = {
  name: '${vmName}-BGInfo'
  params: {
    vmExtensionName: 'BGInfo'
    vmName: vmName
    typeHandlerVersion: bgVersion
    publisher: 'Microsoft.Compute'
    type: 'BGInfo'
    tags: tags
  }
  dependsOn: [
    vmName_resource
  ]
}

module vmName_DependencyAgentWindows '?' /*TODO: replace with correct path to [variables('vmExtensionsTemplateUrl')]*/ = {
  name: '${vmName}-DependencyAgentWindows'
  params: {
    vmExtensionName: 'DependencyAgentWindows'
    vmName: vmName
    typeHandlerVersion: dependencyAgentVersion
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: 'DependencyAgentWindows'
    tags: tags
  }
  dependsOn: [
    vmName_resource
  ]
}

module vmName_AzureDiskEncryption '?' /*TODO: replace with correct path to [variables('vmExtensionsTemplateUrl')]*/ = {
  name: '${vmName}-AzureDiskEncryption'
  params: {
    vmExtensionName: 'AzureDiskEncryption'
    vmName: vmName
    typeHandlerVersion: diskEncryptionVersion
    publisher: 'Microsoft.Azure.Security'
    type: 'AzureDiskEncryption'
    forceUpdateTag: diskEncryptionUpdateTag
    settings: {
      EncryptionOperation: 'EnableEncryption'
      KeyEncryptionAlgorithm: keyEncryptionAlgorithm
      KeyVaultURL: 'https://${diskEncryptionKeyVaultName}.vault.azure.net/'
      KeyVaultResourceId: resourceId(diskEncryptionKeyVaultSubscriptionId, diskEncryptionKeyVaultResourceGroupName, 'Microsoft.KeyVault/vaults', diskEncryptionKeyVaultName)
      KeyEncryptionKeyURL: 'https://${kekKeyVaultName}.vault.azure.net/keys/${kekName}/${kekVersion}'
      KekVaultResourceId: resourceId(kekKeyVaultSubscriptionId, kekKeyVaultResourceGroupName, 'Microsoft.KeyVault/vaults', kekKeyVaultName)
      ResizeOSDisk: false
    }
    tags: tags
  }
  dependsOn: [
    vmName_resource
  ]
}