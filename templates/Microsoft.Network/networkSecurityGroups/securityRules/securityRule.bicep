? /* TODO: User defined functions are not supported and have not been decompiled */

@description('The name of the Security Rule that you wish to create.')
@minLength(1)
@maxLength(80)
param securityRuleName string

@description('The name of the Network Security Group that the rule is attached to.')
param nsgName string

@description('Description of the Security Rule.')
param description string

@description('Traffic Protocol (TCP or UDP).')
@allowed([
  'TCP'
  'UDP'
  '*'
])
param protocol string = 'TCP'

@description('Source traffic CIDR, IP or Tags')
param sourceAddressPrefixes array

@description('Destination traffic CIDR, IP or Tags')
param destinationAddressPrefixes array

@description('Destination traffic port numbers')
param sourcePortRanges array = [
  '*'
]

@description('Destination traffic port numbers')
param destinationPortRanges array

@description('Allow or deny traffic satisfying Security Rule conditions')
@allowed([
  'Allow'
  'Deny'
])
param access string

@description('Priorty of the Security Rule, the lower the value the higher the priority')
@minValue(100)
@maxValue(4096)
param priority int

@description('Specifies if Security Rule should apply to incoming or outgoing traffic')
@allowed([
  'Inbound'
  'Outbound'
])
param direction string

var defaultProperties = {
  description: description
  protocol: protocol
  access: access
  priority: priority
  direction: direction
}
var sourceAddressPrefixesString = securityRule.setStringOrArrayProperty('sourceAddressPrefix', 'sourceAddressPrefixes', sourceAddressPrefixes)
var sourceAddressPrefixes_var = json(sourceAddressPrefixesString)
var destinationAddressPrefixesString = securityRule.setStringOrArrayProperty('destinationAddressPrefix', 'destinationAddressPrefixes', destinationAddressPrefixes)
var destinationAddressPrefixes_var = json(destinationAddressPrefixesString)
var sourcePortRangesString = securityRule.setStringOrArrayProperty('sourcePortRange', 'sourcePortRanges', sourcePortRanges)
var sourcePortRanges_var = json(sourcePortRangesString)
var destinationPortRangesString = securityRule.setStringOrArrayProperty('destinationPortRange', 'destinationPortRanges', destinationPortRanges)
var destinationPortRanges_var = json(destinationPortRangesString)
var properties = union(defaultProperties, sourceAddressPrefixes_var, destinationAddressPrefixes_var, sourcePortRanges_var, destinationPortRanges_var)

resource nsgName_securityRuleName 'Microsoft.Network/networkSecurityGroups/securityRules@2018-11-01' = {
  name: '${nsgName}/${securityRuleName}'
  properties: properties
}

output securityRule object = reference(nsgName_securityRuleName.id, '2018-11-01', 'Full')