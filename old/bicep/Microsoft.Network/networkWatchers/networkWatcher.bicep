@description('The name of the Network Watcher that you wish to create.')
param networkWatcherName string

@description('The location to deploy the Network Watcher to')
param location string = resourceGroup().location

param tags object

resource networkWatcher 'Microsoft.Network/networkWatchers@2020-06-01' = {
  name: networkWatcherName
  location: location
  tags: tags
  properties: {}
}

output networkWatcher object = networkWatcher
