@description('The name of the Image that you wish to create.')
param imageName string

@description('The name of the gallery that you wish to create the image definition in.')
param galleryName string

@description('The location to deploy the Image Template to')
param location string = resourceGroup().location

@description('description of the image')
param imageDescription string

@description('Disallow certain vm feature from using this image')
param disallowed object = {
  diskTypes: []
}

@description('The size of the VM to build')
param endOfLifeDate string = '2999-12-31'

@description('The eula for the vm image')
param eula string = ''

@description('List image features')
param features array = []

@description('offer of the image definition')
param offer string

@description('publisher of the image definition')
param publisher string

@description('sku of the image definition')
param sku string

@description('Specify whether to use e.ge sysprep or linux equivalent')
@allowed([
  'Generalized'
  'Specialized'
])
param osState string = 'Generalized'

@description('Supported OS types')
@allowed([
  'Linux'
  'Windows'
])
param osType string

@description('URI for privacy statement')
param privacyStatementUri string = ''

@description('URI for release notes')
param releaseNoteUri string = ''

param tags object

resource image 'Microsoft.Compute/galleries/images@2020-09-30' = {
  name: '${galleryName}/${imageName}'
  location: location
  tags: tags
  properties: {
    description: imageDescription
    disallowed: disallowed
    endOfLifeDate: endOfLifeDate
    eula: eula
    features: features
    identifier: {
      offer: offer
      publisher: publisher
      sku: sku
    }
    osState: osState
    osType: osType
    privacyStatementUri: privacyStatementUri
    releaseNoteUri: releaseNoteUri
  }
}

output image object = image
