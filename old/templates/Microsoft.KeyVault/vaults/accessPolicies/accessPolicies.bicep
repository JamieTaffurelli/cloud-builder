@description('Name of the Access Policy.')
param accessPoliciesName string

@description('Name of the Key Vault.')
param keyVaultName string

@description('Specifies permissions on keys, secrets and certificates, properties are tenantId, objectId, permissions.keys, permissions.secrets, permissions.certificates, permissions.storage')
param accessPolicies array

var accessPolicies_var = {
  accessPolicies: [for j in range(0, ((length(accessPolicies) == 0) ? 1 : length(accessPolicies))): {
    tenantId: (contains(accessPolicies[j], 'tenantId') ? accessPolicies[j].tenantId : subscription().tenantId)
    objectId: accessPolicies[j].objectId
    permissions: {
      keys: (contains(accessPolicies[j].permissions, 'keys') ? accessPolicies[j].permissions.keys : json('[]'))
      secrets: (contains(accessPolicies[j].permissions, 'secrets') ? accessPolicies[j].permissions.secrets : json('[]'))
      certificates: (contains(accessPolicies[j].permissions, 'certificates') ? accessPolicies[j].certificates.secrets : json('[]'))
      storage: (contains(accessPolicies[j].permissions, 'storage') ? accessPolicies[j].storage.secrets : json('[]'))
    }
  }]
}

resource keyVaultName_accessPoliciesName 'Microsoft.KeyVault/vaults/accessPolicies@2018-02-14' = {
  name: '${keyVaultName}/${accessPoliciesName}'
  properties: {
    accessPolicies: accessPolicies_var
  }
}

output accessPolicies object = reference(keyVaultName_accessPoliciesName.id, '2018-02-14', 'Full')