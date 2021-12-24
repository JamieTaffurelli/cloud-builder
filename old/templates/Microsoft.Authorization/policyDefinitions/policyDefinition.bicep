targetScope = 'subscription'

@description('The name of the Policy Definition you wish to create')
param policyDefinitionName string

@description('The type of the Policy Definition you wish to create')
@allowed([
  'BuiltIn'
  'Custom'
  'NotSpecified'
])
param policyType string = 'Custom'

@description('The mode of the Policy Definition you wish to create')
param mode string = 'All'

@description('The display name of the Policy Definition you wish to create')
param displayName string

@description('The description of the Policy Definition you wish to create')
param description string

@description('The JSON object describing the rule of the Policy Definition you wish to create')
param policyRule object

@description('The metadata of the Policy Definition you wish to create')
param metadata object

@description('The parameters of the Policy Definition you wish to create')
param parameters object

resource policyDefinitionName_resource 'Microsoft.Authorization/policyDefinitions@2019-06-01' = {
  name: policyDefinitionName
  properties: {
    policyType: policyType
    mode: mode
    displayName: displayName
    description: description
    policyRule: policyRule
    metadata: metadata
    parameters: parameters
  }
}