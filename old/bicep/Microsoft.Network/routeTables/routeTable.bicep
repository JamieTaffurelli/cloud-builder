@description('The name of the Route Table')
param routeTableName string

@description('The location to deploy the Route Table to')
param location string = resourceGroup().location

@description('Routes to apply to the route table')
param routes array

@description('Disable routes advertised from Virtual Network Gateway via BGP, this can affect ExpressRoute connectivity')
param disableBgpRoutePropagation bool = false

@description('Tags to apply to Route Table')
param tags object

resource routeTable 'Microsoft.Network/routeTables@2020-07-01' = {
  name: routeTableName
  location: location
  tags: tags
  properties: {
    routes: routes
    disableBgpRoutePropagation: disableBgpRoutePropagation
  }
}

output routeTable object = routeTable
