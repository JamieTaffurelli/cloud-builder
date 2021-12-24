@description('The name of the Policy Assignment you wish to create')
param policyAssignmentName string

@description('The display name of the Policy Assignment you wish to create')
param displayName string

@description('The name of the Policy Definition or Initiative you wish to assign to the Policy Assignment')
param policyDefinitionName string

@description('The name of the Policy Definition or Initiative you wish to assign to the Policy Assignment')
@allowed([
  'Initiative'
  'Standard'
])
param policyDefinitionType string = 'Initiative'

@description('The scopes to exclude from the Policy Assignment')
param notScopes array = []

@description('The parameters for the Policy Rule of the Policy Assignment')
param parameters object

@description('The description of the Policy Assignment')
param description string

@description('The metadata of the Policy Assignment')
param metadata object

@description('The enforcement mode of the Policy Assignment')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@description('The sku name of the Policy Assignment')
@allowed([
  'A0'
  'A1'
])
param skuName string = 'A1'

@description('The sku  of the Policy Assignment')
@allowed([
  'Free'
  'Standard'
])
param skuTier string = 'Standard'

@description('Specify to scope Policy Assignment to Resource Group')
param resourceGroupName string = ''

var resourceType = ((policyDefinitionType == 'Initiative') ? 'policySetDefinitions/' : 'policyDefinitions/')

resource policyAssignmentName_resource 'Microsoft.Authorization/policyAssignments@2019-06-01' = {
  name: policyAssignmentName
  properties: {
    displayName: displayName
    policyDefinitionId: '${subscription().id}/providers/Microsoft.Authorization/${resourceType}${policyDefinitionName}'
    scope: (empty(resourceGroupName) ? subscription().id : '${subscription().id}/resourceGroups/${resourceGroupName}')
    notScopes: notScopes
    parameters: parameters
    description: description
    metadata: metadata
    enforcementMode: enforcementMode
  }
  sku: {
    name: skuName
    tier: skuTier
  }
}