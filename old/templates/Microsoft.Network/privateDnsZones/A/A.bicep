@description('The name of the A record that you wish to create.')
param recordName string

@description('The name of the private dns zone')
param privateDnsZoneName string

@description('Properties of the A record')
param properties object

resource privateDnsZoneName_recordName 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${privateDnsZoneName}/${recordName}'
  properties: properties
}

output aRecord object = reference(privateDnsZoneName_recordName.id, '2020-06-01', 'Full')