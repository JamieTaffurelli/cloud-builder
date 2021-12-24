@description('The name of the firewall policy')
param firewallPolicyName string

@description('The location to deploy the Route Table to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Operation mode for threat intelligence')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param threatIntelMode string = 'Deny'

@description('Whitelist for threat intelligence')
param threatIntelWhitelist object = {}

@description('DNS settings for firewall policy')
param dnsSettings object = {}

@description('Mode for instusion detection')
@allowed([
  'Alert'
  'Off'
  'Deny'
])
param intrusionDetectionMode string = 'Deny'

@description('Configuration for intrusion detection')
param intrusionDetectionConfiguration object = {}

@description('TLS settings')
param certificateAuthority object = {}

@description('Sku of firewall policy')
@allowed([
  'Standard'
  'Premium'
])
param skuTier string = 'Standard'

@description('Tags to apply to firewall')
param tags object

var propertiesNoTls = {
  threatIntelMode: threatIntelMode
  threatIntelWhitelist: threatIntelWhitelist
  dnsSettings: dnsSettings
  intrusionDetection: {
    mode: intrusionDetectionMode
    configuration: intrusionDetectionConfiguration
  }
  sku: {
    tier: skuTier
  }
}
var tls = {
  transportSecurity: {
    certificateAuthority: certificateAuthority
  }
}
var properties = (empty(certificateAuthority) ? propertiesNoTls : union(propertiesNoTls, tls))

resource firewallPolicyName_resource 'Microsoft.Network/firewallPolicies@2020-07-01' = {
  name: firewallPolicyName
  location: location
  tags: tags
  properties: properties
}

output firewallPolicy object = reference(firewallPolicyName_resource.id, '2020-07-01', 'Full')