@description('The name of the Network Interface that you wish to create.')
@minLength(1)
@maxLength(80)
param nicName string

@description('The location to deploy the Network Interface to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('IP configurations for the Network Interface')
param ipConfigurations array

@description('Specifies DNS servers the Network Interface should use, default is Azure Provided DNS')
param dnsServers array = []

@description('Relative DNS name for Network Interface for communication between VMs in the same Virtual Network')
param internalDnsNameLabel string = ''

@description('Fully qualified DNS name for Network Interface for communication between VMs in the same Virtual Network')
param internalFqdn string = ''

@description('DNS suffix for Network Interface, full DNS name can be obtained by concatenating VM name with DNS suffix')
param internalDomainNameSuffix string = ''

@description('Sets this Network Interface as the Primary Network Interface on a VM')
param primary bool = true

@description('Enables bypassing of host and switch whilst maintaining policies')
param enableAcceleratedNetworking bool = false

@description('Allows forwarding of traffic to other IP addresses')
param enableIpForwarding bool = false
param tags object

var ipConfigurationsProperties = {
  ipConfigurationsProperties: [for item in ipConfigurations: {
    privateIPAllocationMethod: (contains(item, 'privateIPAllocationMethod') ? item.privateIPAllocationMethod : 'Static')
    privateIPAddress: (contains(item, 'privateIPAddress') ? item.privateIPAddress : json('null'))
    subnet: {
      id: resourceId((contains(item, 'subnetSubscriptionId') ? item.subnetSubscriptionId : subscription().subscriptionId), (contains(item, 'subnetResourceGroupName') ? item.subnetResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', item.virtualNetworkName, item.subnetName)
    }
    primary: (contains(item, 'isPrimary') ? item.isPrimary : json('true'))
    privateIPAddressVersion: (contains(item, 'privateIPAddressVersion') ? item.privateIPAddressVersion : 'IPv4')
  }]
}
var publicIps = {
  publicIps: [for item in ipConfigurations: {
    publicIPAddress: {
      id: (contains(item, 'publicIpAddressName') ? resourceId((contains(item, 'publicIpAddressSubscriptionId') ? item.publicIpAddressSubscriptionId : subscription().subscriptionId), (contains(item, 'publicIpAddressResourceGroupName') ? item.publicIpAddressResourceGroupName : resourceGroup().name), 'Microsoft.Network/publicIPAddresses', item.publicIpAddressName) : '')
    }
  }]
}
var ipConfigurationsPublic = {
  ipConfigurationsPublic: [for (item, j) in ipConfigurations: {
    name: item.name
    properties: ((publicIps.publicIps[j].publicIPAddress.id == '') ? ipConfigurationsProperties.ipConfigurationsProperties[j] : union(ipConfigurationsProperties.ipConfigurationsProperties[j], publicIps.publicIps[j]))
  }]
}

resource nicName_resource 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: nicName
  location: location
  tags: tags
  properties: {
    ipConfigurations: ipConfigurationsPublic.ipConfigurationsPublic
    dnsSettings: {
      dnsServers: dnsServers
      internalDnsNameLabel: (empty(internalDnsNameLabel) ? json('null') : internalDnsNameLabel)
      internalFqdn: internalFqdn
      internalDomainNameSuffix: internalDomainNameSuffix
    }
    primary: primary
    enableAcceleratedNetworking: enableAcceleratedNetworking
    enableIPForwarding: enableIpForwarding
  }
}

output networkInterface object = reference(nicName_resource.id, '2020-06-01', 'Full')