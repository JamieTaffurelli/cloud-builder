@description('The name of the Public Certificate')
param certificateName string

@description('The name of the App Service Slot')
param slotName string

@description('The name of the App Service')
param appName string

@description('The location to deploy the Public Certificate to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Base-64 .cer certificate')
@secure()
param blobString string

@description('The Certificate Store to install the Certificate to')
@allowed([
  'CurrentUserMy'
  'LocalMachineMy'
  'Unknown'
])
param publicCertificateLocation string = 'CurrentUserMy'

resource appName_slotName_certificateName 'Microsoft.Web/sites/slots/publicCertificates@2016-03-01' = {
  name: '${appName}/${slotName}/${certificateName}'
  location: location
  properties: {
    blob: blobString
    publicCertificateLocation: publicCertificateLocation
  }
}

output cert object = reference(appName_slotName_certificateName.id, '2016-03-01', 'Full')