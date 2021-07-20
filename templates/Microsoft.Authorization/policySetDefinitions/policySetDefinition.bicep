targetScope = 'subscription'

@description('The name of the Policy Set Definition you wish to create')
param policySetDefinitionName string

@description('The type of the Policy Set Definition you wish to create')
@allowed([
  'BuiltIn'
  'Custom'
  'NotSpecified'
])
param policyType string = 'Custom'

@description('The display name of the Policy Set Definition you wish to create')
param displayName string

@description('The description of the Policy Set Definition you wish to create')
param description string

@description('The policy rules of the Policy Set Definition you wish to create')
param policyDefinitions array

@description('The metadata of the Policy Set Definition you wish to create')
param metadata object

@description('The parameters of the Policy Set Definition you wish to create')
param parameters object

resource policySetDefinitionName_resource 'Microsoft.Authorization/policySetDefinitions@2019-06-01' = {
  name: policySetDefinitionName
  properties: {
    policyType: policyType
    displayName: displayName
    description: description
    policyDefinitions: policyDefinitions
    metadata: metadata
    parameters: parameters
  }
}