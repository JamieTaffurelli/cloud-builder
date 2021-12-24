@description('Set the location for all resources, same location as the resource group')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Enter the type of connections to be created')
param connectorType string

@description('Name of Azure Blob Storage API Connection')
param connectorName string

@description('Display Name of the Azure Blob Storage API Connection')
param connectorDisplayName string

@description('Name of Azure Blob Storage API Connection')
@secure()
param parameterValues object

@description('Set the tag associated to the Resources')
param tags object

resource connectorName_resource 'Microsoft.Web/connections@2016-06-01' = {
  location: location
  name: connectorName
  tags: tags
  properties: {
    displayName: connectorDisplayName
    api: {
      id: '${subscription().id}/providers/Microsoft.Web/locations/${location}/managedApis/${connectorType}'
    }
    parameterValues: parameterValues
  }
}

output connector object = reference(connectorName_resource.id, '2016-06-01', 'Full')