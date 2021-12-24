@description('The name of the Resource Group that you wish to create.')
param resourceGroupName string

@description('The location to deploy the Resource Group to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string
param tags object

resource resourceGroupName_resource 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: location
  tags: tags
  properties: {}
}

output resourceGroup object = reference(resourceGroupName_resource.id, '2020-06-01', 'Full')