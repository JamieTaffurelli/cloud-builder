targetScope = 'subscription'

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
param policyAssigmentDescription string

@description('The metadata of the Policy Assignment')
param metadata object

@description('The enforcement mode of the Policy Assignment')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string = 'Default'

@description('The messages that describe why a resource is non-compliant with the policy')
param nonComplianceMessages array = []

@description('Specify to scope Policy Assignment to Resource Group')
param resourceGroupName string = ''

var resourceType = ((policyDefinitionType == 'Initiative') ? 'policySetDefinitions/' : 'policyDefinitions/')

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' existing = {
  name: resourceGroupName
  scope: subscription()
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policyAssignmentName
  properties: {
    displayName: displayName
    policyDefinitionId: '${subscription().id}/providers/Microsoft.Authorization/${resourceType}${policyDefinitionName}'
    scope: (empty(resourceGroupName) ? subscription().id : resourceGroup.id)
    notScopes: notScopes
    parameters: parameters
    description: policyAssigmentDescription
    metadata: metadata
    enforcementMode: enforcementMode
    nonComplianceMessages: nonComplianceMessages
  }
}
