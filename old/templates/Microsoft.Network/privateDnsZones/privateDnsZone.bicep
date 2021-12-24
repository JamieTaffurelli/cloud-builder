@description('The name of the Private DNS Zone that you wish to create.')
param privateDnsZoneName string
param tags object

resource privateDnsZoneName_resource 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  tags: tags
  properties: {}
}

output privateDnsZone object = reference(privateDnsZoneName_resource.id, '2020-06-01', 'Full')