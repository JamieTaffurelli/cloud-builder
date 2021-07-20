@description('The name of the Disk that you wish to create.')
param diskName string

@description('The location to deploy the Disk to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The underlying Storage Architecture of the Disk, only certain VM sizes will support certain skus')
@allowed([
  'Standard_LRS'
  'Premium_LRS'
  'StandardSSD_LRS'
  'UltraSSD_LRS'
])
param sku string = 'Premium_LRS'

@description('The size in GB of the disk to be created')
@minValue(32)
@maxValue(32767)
param diskSizeGB int

@description('Data centers to replicate disk to')
param zones array = []
param tags object

resource diskName_resource 'Microsoft.Compute/disks@2020-06-30' = {
  name: diskName
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: diskSizeGB
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
  }
  zones: zones
}

output dataDisk object = reference(diskName_resource.id, '2020-06-30', 'Full')