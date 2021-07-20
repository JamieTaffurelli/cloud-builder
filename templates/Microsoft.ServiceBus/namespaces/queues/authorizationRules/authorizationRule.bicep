@description('The name of the authorization rule that you wish to create.')
param authorizationRuleName string

@description('The name of the Service Bus to create the authorization rule in.')
param serviceBusName string

@description('The name of the Service Bus Queue that you wish to create the rule in.')
param queueName string

@description('Rights of the rule')
param rights array

resource serviceBusName_queueName_authorizationRuleName 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2018-01-01-preview' = {
  name: '${serviceBusName}/${queueName}/${authorizationRuleName}'
  properties: {
    rights: rights
  }
}

output authorizationRule object = reference(serviceBusName_queueName_authorizationRuleName.id, '2018-01-01-preview', 'Full')