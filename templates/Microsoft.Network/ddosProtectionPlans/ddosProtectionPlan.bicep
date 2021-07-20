@description('The name of the DDOS Protection Plan that you wish to create.')
param ddosProtectionPlanName string

@description('The location to deploy the DDOS Protection Plan to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location
param tags object

resource ddosProtectionPlanName_resource 'Microsoft.Network/ddosProtectionPlans@2018-11-01' = {
  name: ddosProtectionPlanName
  location: location
  tags: tags
  properties: {}
}

output ddosProtectionPlan object = reference(ddosProtectionPlanName_resource.id, '2018-11-01', 'Full')