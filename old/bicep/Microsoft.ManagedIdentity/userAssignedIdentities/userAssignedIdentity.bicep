@description('The name of the User Assigned Identity that you wish to create.')
@minLength(1)
@maxLength(80)
param userAssignedIdentityName string

@description('The location to deploy the User Assigned Identity to')
param location string = resourceGroup().location

param tags object

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: userAssignedIdentityName
  location: location
  tags: tags
}

output userAssignedIdentity object = userAssignedIdentity
