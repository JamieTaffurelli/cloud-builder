@description('The name of the Route Table to apply the Route to')
param routeTableName string

@description('The name of the Route')
param routeName string

@description('CIDR block in which to apply the route')
param addressPrefix string

@description('Next hop to forward the packets to')
@allowed([
  'VirtualNetworkGateway'
  'VnetLocal'
  'Internet'
  'VirtualAppliance'
  'None'
])
param nextHopType string

@description('IP address to send the packets to, only valid for a next hop type of VirtualAppliance')
param nextHopIpAddress string = ''

resource routeTableName_routeName 'Microsoft.Network/routeTables/routes@2019-04-01' = {
  name: '${routeTableName}/${routeName}'
  properties: {
    addressPrefix: addressPrefix
    nextHopType: nextHopType
    nextHopIpAddress: (empty(nextHopIpAddress) ? json('null') : nextHopIpAddress)
  }
}

output route object = reference(routeTableName_routeName.id, '2019-04-01', 'Full')