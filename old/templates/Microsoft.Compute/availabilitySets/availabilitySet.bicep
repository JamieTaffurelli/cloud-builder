@description('The name of the Availability Set that you wish to create.')
param availabilitySetName string

@description('The location to deploy the Availability Set to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The amount of Update Domains in the Availability Set')
param platformUpdateDomainCount int = 5

@description('The amount of Fault Domains in the Availability Set')
param platformFaultDomainCount int = 2

@description('Sku of the Availability Set')
@allowed([
  'Aligned'
  'Classic'
])
param skuName string = 'Aligned'
param tags object

resource availabilitySetName_resource 'Microsoft.Compute/availabilitySets@2019-03-01' = {
  name: availabilitySetName
  location: location
  tags: tags
  properties: {
    platformUpdateDomainCount: platformUpdateDomainCount
    platformFaultDomainCount: platformFaultDomainCount
  }
  sku: {
    name: skuName
  }
}

output availabilitySet object = reference(availabilitySetName_resource.id, '2019-03-01', 'Full')