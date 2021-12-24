@description('Name of the Virtual Network Peering')
param peeringName string

@description('Name of the Virtual Network')
param virtualNetworkName string

@description('Allow traffic to connect to remote Virtual Network')
param allowVirtualNetworkAccess bool = false

@description('Allow traffic to be forwarded to other Virtual Networks')
param allowForwardedTraffic bool = false

@description('Allow the remote Virtual Network to use this Virtual Networks Virtual Gateway')
param allowGatewayTransit bool = false

@description('Allow this Virtual Network to use the remote Virtual Networks Virtual Gateway')
param useRemoteGateways bool = false

@description('Subscription ID of the Virtual Network to peer to')
param remoteVirtualNetworkSubscriptionId string = subscription().subscriptionId

@description('Resource Group name of the Virtual Network to peer to')
param remoteVirtualNetworkResourceGroupName string = resourceGroup().name

@description('Name of the Virtual Network to peer to')
param remoteVirtualNetworkName string

resource remoteVirtualNetwork 'Microsoft.Network/virtualNetworks@2020-07-01' existing = {
  name: remoteVirtualNetworkName
  scope: resourceGroup(remoteVirtualNetworkSubscriptionId, remoteVirtualNetworkResourceGroupName)
}

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2019-04-01' = {
  name: '${virtualNetworkName}/${peeringName}'
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVirtualNetwork.id
    }
  }
}

output virtualNetworkPeering object = peering
