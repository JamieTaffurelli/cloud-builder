@description('Name of the Secret.')
param secretName string

@description('Name of the Key Vault.')
param keyVaultName string

@description('Value of the Secret.')
@secure()
param secretValue string

@description('Enable Secret')
param enabled bool = true

@description('Not before date in UTC.')
param NotBeforeDate string = ''

@description('Expiry date in UTC.')
param ExpiryDate string = ''

resource keyVaultName_secretName 'Microsoft.KeyVault/vaults/secrets@2018-02-14' = {
  name: '${keyVaultName}/${secretName}'
  properties: {
    value: secretValue
    attributes: {
      enabled: enabled
      nbf: (empty(NotBeforeDate) ? json('null') : NotBeforeDate)
      exp: (empty(ExpiryDate) ? json('null') : ExpiryDate)
    }
  }
}

output secretUri string = reference(keyVaultName_secretName.id, '2018-02-14', 'Full').properties.secretUriWithVersion