@description('The name of the authorization rule that you wish to create.')
param authorizationRuleName string

@description('The name of the Service Bus to create the authorization rule in.')
param serviceBusName string

@description('Rights of the rule')
param rights array

resource serviceBusName_authorizationRuleName 'Microsoft.ServiceBus/namespaces/authorizationRules@2018-01-01-preview' = {
  name: '${serviceBusName}/${authorizationRuleName}'
  properties: {
    rights: rights
  }
}

output authorizationRule object = reference(serviceBusName_authorizationRuleName.id, '2018-01-01-preview', 'Full')