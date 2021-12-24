@description('The name of the Network Watcher that you wish to create.')
param networkWatcherName string

@description('The location to deploy the Network Watcher to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location
param tags object

resource networkWatcherName_resource 'Microsoft.Network/networkWatchers@2020-06-01' = {
  name: networkWatcherName
  location: location
  tags: tags
  properties: {}
}

output networkWatcher object = reference(networkWatcherName_resource.id, '2020-06-01', 'Full')