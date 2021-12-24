@description('The name of the Container Group you wish to create')
param containerGroupName string

@description('The location to deploy the Container Group to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The sku of the Container Group')
@allowed([
  'Standard'
  'Dedicated'
])
param sku string = 'Standard'

@description('Containers to deploy to the Container Group')
param containers array

@description('Credentials for private container registries, must have an \'array\' property')
@secure()
param imageRegistryCredentials object = {}

@description('Restart policy for all containers within the container group')
@allowed([
  'Always'
  'OnFailure'
  'Never'
])
param restartPolicy string = 'OnFailure'

@description('The operating system type required by the containers in the container group.')
@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Linux'

@description('The list of volumes that can be mounted by containers in this container group. Must have an \'array\' property')
@secure()
param volumes object = {
  array: []
}

@description('The ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsId string

@description('The workspace key for log analytics')
@secure()
param logAnalyticsWorkspaceKey string

@description('The init containers for a container group.')
param initContainers array = []

@description('Tags to apply to Container Group')
param tags object

resource containerGroupName_resource 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: containerGroupName
  location: location
  tags: tags
  properties: {
    containers: containers
    imageRegistryCredentials: imageRegistryCredentials.array
    restartPolicy: restartPolicy
    osType: osType
    volumes: volumes.array
    diagnostics: {
      logAnalytics: {
        workspaceId: logAnalyticsId
        workspaceKey: logAnalyticsWorkspaceKey
      }
    }
    sku: sku
    initContainers: initContainers
  }
}

output containerGroup object = reference(containerGroupName_resource.id, '2019-12-01', 'Full')