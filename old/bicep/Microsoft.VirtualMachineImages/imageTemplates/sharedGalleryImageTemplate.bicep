@description('The name of the Image Template that you wish to create.')
param imageTemplateName string

@description('The location to deploy the Image Template to')
param location string = resourceGroup().location

@description('The Subscription ID of the user assigned identity to use for gallery and storage actions')
param userAssignedIdentitySubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the user assigned identity to use for gallery and storage actions')
param userAssignedIdentityResourceGroupName string = resourceGroup().name

@description('The name of the shared user assigned identity to use for gallery and storage actions')
param userAssignedIdentityName string

@description('The timeout of image builds')
param buildTimeoutInMinutes int = 240

@description('The size of the VM to build')
param vmSize string = 'Standard_A1_v2'

@description('The Subscription ID of the subnet to build the image in')
param subnetSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the subnet to build the image in')
param subnetResourceGroupName string = resourceGroup().name

@description('The name of the virtual network to build the image in')
param virtualNetworkName string

@description('The name of the subnet to build the image in')
param subnetName string

@description('The source of the vm image')
param source object = {
  type: 'PlatformImage'
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2019-Datacenter'
  version: 'latest'
}

@description('The customization steps to apply to the image')
param customize array = []

@description('The Subscription ID of the shared image gallery to distribute the image to')
param sharedImageGallerySubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the shared image gallery to distribute the image to')
param sharedImageGalleryResourceGroupName string = resourceGroup().name

@description('The name of the shared image gallery to distribute the image to')
param sharedImageGalleryName string

@description('The name of the image to update')
param sharedImageName string

@description('The version of the image to apply, default is automatic versioning')
param sharedImageVersion string = ''

@description('The unique name for identifying the distribution')
param runOutputName string

@description('Tags for the image')
param artifactTags object

@description('Replication regions for images, must include location of the gallery')
param replicationRegions array = [
  resourceGroup().location
]

@description('Exclude version from being used as latest in the shared image gallery')
param excludeFromLatest bool = false

@description('Exclude version from being used as latest in the shared image gallery')
@allowed([
  'Standard_ZRS'
  'Standard_LRS'
])
param storageAccountType string = 'Standard_ZRS'

param tags object

var userAssignedIdentityID = resourceId(userAssignedIdentitySubscriptionId, userAssignedIdentityResourceGroupName, 'Microsoft.ManagedIdentity/userAssignedIdentities', userAssignedIdentityName)
var sharedImageIdNoVersion = resourceId(sharedImageGallerySubscriptionId, sharedImageGalleryResourceGroupName, 'Microsoft.Compute/galleries/images', sharedImageGalleryName, sharedImageName)
var sharedImageIdVersion = resourceId(sharedImageGallerySubscriptionId, sharedImageGalleryResourceGroupName, 'Microsoft.Compute/galleries/images/versions', sharedImageGalleryName, sharedImageName, sharedImageVersion)
var sharedImageId = empty(sharedImageVersion) ? sharedImageIdNoVersion : sharedImageIdVersion

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2020-07-01' existing = {
  name: '${virtualNetworkName}/${subnetName}'
  scope: resourceGroup(subnetSubscriptionId, subnetResourceGroupName)
}

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2020-02-14' = {
  name: imageTemplateName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityID}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: buildTimeoutInMinutes
    vmProfile: {
      vmSize: vmSize
      osDiskSizeGB: 0
      vnetConfig: {
        subnetId: subnet.id
      }
    }
    source: source
    customize: customize
    distribute: [
        {
        type: 'SharedImage'
        galleryImageId: sharedImageId
        runOutputName: runOutputName
        artifactTags: artifactTags
        replicationRegions: replicationRegions
        excludeFromLatest: excludeFromLatest
        storageAccountType: storageAccountType
      }
    ]
  }
}

output imageTemplate object = imageTemplate

