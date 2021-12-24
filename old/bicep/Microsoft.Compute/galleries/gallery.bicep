@description('The name of the Shared Image Gallery that you wish to create.')
param galleryName string

@description('The location to deploy the Shared Image Gallery to')
param location string = resourceGroup().location

@description('The description of the Shared Image Gallery that you wish to create.')
param galleryDescription string

param tags object

resource gallery 'Microsoft.Compute/galleries@2020-09-30' = {
  name: galleryName
  location: location
  tags: tags
  properties: {
    description: galleryDescription
  }
}

output gallery object = gallery
