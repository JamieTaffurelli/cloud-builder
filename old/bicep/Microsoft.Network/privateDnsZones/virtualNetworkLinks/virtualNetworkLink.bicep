@description('The name of the VNet Link that you wish to create.')
param virtualNetworkLinkName string

@description('The name of the private dns zone')
param privateDnsZoneName string

@description('The Subscription ID of the VNet to link')
param virtualNetworkSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the VNet to link')
param virtualNetworkResourceGroupName string = resourceGroup().name

@description('The name of the VNet to link')
param virtualNetworkName string

@description('Auto register VM records')
param registrationEnabled bool = true
param tags object

resource virtualNetwork 'Microsoft.OperationalInsights/workspaces@2020-08-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(virtualNetworkSubscriptionId, virtualNetworkResourceGroupName)
}

resource privateDnsZoneName_virtualNetworkLinkName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${privateDnsZoneName}/${virtualNetworkLinkName}'
  location: 'global'
  tags: tags
  properties: {
    virtualNetwork: {
      id: virtualNetwork.id
    }
    registrationEnabled: registrationEnabled
  }
}

output virtualNetworkLink object = reference(privateDnsZoneName_virtualNetworkLinkName.id, '2020-06-01', 'Full')
