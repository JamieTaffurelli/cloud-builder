@description('The guid of the role you wish to apply')
param roleDefinitionGuid string

@description('The object ID of the AAD object you wish to give the role')
param principalGuid string

@description('The principal type of the assigned principal ID')
@allowed([
  'User'
  'Group'
  'ServicePrincipal'
  'DirectoryRoleTemplate'
  'ForeignGroup'
  'Application'
  'MSI'
  'DirectoryObjectOrGroup'
  'Device'
])
param principalType string

@description('Description of role assignment')
param roleAssigmentDescription string

var name_var = guid(resourceGroup().id, roleDefinitionGuid, principalGuid)
var roleDefinitionId = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/${roleDefinitionGuid}'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = {
  name: name_var
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalGuid
    principalType: principalType
    description: roleAssigmentDescription
  }
}

output roleAssignment object = roleAssignment
