@description('The name of the firewall policy rule collection group')
param ruleCollectionGroupName string

@description('The name of the firewall policy')
param firewallPolicyName string

@description('Priority of the rule collection group')
param priority int

@description('Rule collections for the group')
param ruleCollections array = []

resource firewallPolicyName_ruleCollectionGroupName 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-07-01' = {
  name: '${firewallPolicyName}/${ruleCollectionGroupName}'
  properties: {
    priority: priority
    ruleCollections: ruleCollections
  }
}

output ruleCollectionGroup object = reference(firewallPolicyName_ruleCollectionGroupName.id, '2020-07-01', 'Full')