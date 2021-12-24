@description('The guid of the role you wish to apply')
param roleDefinitionGuid string

@description('The object ID of the AAD object you wish to give the role')
param principalGuid string

var name_var = guid(resourceGroup().id, roleDefinitionGuid, principalGuid)
var roleDefinitionId = '${subscription().id}/providers/Microsoft.Authorization/roleDefinitions/${roleDefinitionGuid}'

resource name 'Microsoft.Authorization/roleAssignments@2019-04-01-preview' = {
  name: name_var
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalGuid
  }
}

output roleAssignment object = reference(name.id, '2019-04-01-preview', 'Full')