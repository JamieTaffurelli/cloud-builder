@description('The name of the Private DNS Zone that you wish to create.')
param privateDnsZoneName string
param tags object

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  tags: tags
  properties: {}
}

output privateDnsZone object = privateDnsZone
