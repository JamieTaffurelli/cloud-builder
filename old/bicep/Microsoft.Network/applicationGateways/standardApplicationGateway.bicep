@description('The name of the Application Gateway that you wish to create.')
@minLength(1)
@maxLength(80)
param appGatewayName string

@description('The location to deploy the Application Gateway to')
param location string = resourceGroup().location

@description('The number of instances of the Application Gateway')
@minValue(0)
@maxValue(125)
param capacity int = 2

@description('Subnets for the App Gateway, e.g {\'name\':\'ipconfig\', \'subnetResourceGroup\':\'rg\', \'virtualNetwork\':\'vnet\', \'subnetName\':\'subnet\' }')
param gatewayIpConfigurations array

@description('Authentication certificates for the App Gateway')
@secure()
param authenticationCertificates object = {
  array: []
}

@description('Trusted root certificates for the App Gateway, format is {\'name\':\'\', \'properties\': {\'data\':\'\', keyVaultName:\'\', \'keyVaultSecretName\':\'\'}')
@secure()
param trustedRootCertificates object = {
  array: []
}

@description('SSL certificates for the App Gateway, format is {\'name\':\'\', \'properties\': {\'data\':\'\', \'password\':\'\', keyVaultName:\'\', \'keyVaultSecretName\':\'\'}')
@secure()
param sslCertificates object = {
  array: []
}

@description('Frontend IP addresses for the App Gateway')
@minLength(1)
@maxLength(2)
param frontendIPConfigurations array

@description('Frontend ports for the App Gateway')
@minLength(1)
@maxLength(100)
param frontendPorts array

@description('Health probes for the App Gateway')
param probes array = []

@description('Backend addresses for the App Gateway')
@minLength(1)
@maxLength(100)
param backendAddressPools array

@description('Backend HTTP settings for the App Gateway')
@minLength(1)
@maxLength(100)
param backendHttpSettingsCollection array

@description('HTTP listeners for the App Gateway')
@minLength(1)
@maxLength(100)
param httpListeners array

@description('Health probes for the App Gateway')
param urlPathMaps array = []

@description('Health probes for the App Gateway')
param requestRoutingRules array = []

@description('Health probes for the App Gateway')
param rewriteRuleSets array = []

@description('Health probes for the App Gateway')
param redirectConfigurations array = []

@description('Enable autoscaling for Application Gateway (only supported for V2), properties are \'minCapacity\', \'maxCapacity\'')
param autoScaleConfiguration object = {}

@description('Custom Error Pages on Application Gateway for HttpStatus403 or HttpStatus502, properties are \'statusCode\', \'customErrorPageUrl\'')
param customErrorConfigurations array = []

@description('Specify zone redundancy for the App Gateway, only supported with V2')
param zones array = []

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

param tags object

var connectionDraining = {
  enabled: true
  drainTimeoutInSec: 300
}
var backendHttpSettingsCollectionWithoutHostName = [for item in backendHttpSettingsCollection: {
  name: item.name
  properties: {
    port: item.properties.port
    protocol: item.properties.protocol
    cookieBasedAffinity: (contains(item.properties, 'cookieBasedAffinity') ? item.properties.cookieBasedAffinity : 'Disabled')
    requestTimeout: (contains(item.properties, 'requestTimeout') ? item.properties.requestTimeout : 30)
    probe: (((!contains(item.properties, 'probe')) || empty(item.properties.probe)) ? {} : json('{ "id": "${resourceId('Microsoft.Network/applicationGateways/probes', appGatewayName, item.properties.probe.name)}" }'))
    authenticationCertificates: (((!contains(item.properties, 'authenticationCertificates')) || empty(item.properties.authenticationCertificates)) ? [] : item.properties.authenticationCertificates)
    trustedRootCertificates: (((!contains(item.properties, 'trustedRootCertificates')) || empty(item.properties.trustedRootCertificates)) ? [] : item.properties.trustedRootCertificates)
    connectionDraining: (((!contains(item.properties, 'connectionDraining')) || empty(item.properties.connectionDraining)) ? connectionDraining : item.properties.connectionDraining)
    pickHostNameFromBackendAddress: ((!contains(item.properties, 'pickHostNameFromBackendAddress')) ? json('false') : item.properties.pickHostNameFromBackendAddress)
    affinityCookieName: (((!contains(item.properties, 'affinityCookieName')) || empty(item.properties.affinityCookieName)) ? null : item.properties.affinityCookieName)
    path: (((!contains(item.properties, 'path')) || empty(item.properties.path)) ? null : item.properties.path)
  }
}]
var backendHttpSettingsCollection_var = [for (item, j) in backendHttpSettingsCollection: {
  name: item.name
  properties: (contains(item.properties, 'hostName') ? union(backendHttpSettingsCollectionWithoutHostName[j].properties, json('{"hostname": "${item.properties.hostname}"}')) : backendHttpSettingsCollectionWithoutHostName[j].properties)
}]
var frontendIPConfigurations_var = [for item in frontendIPConfigurations: {
  name: item.name
  //properties: (contains(item, 'publicIPAddressName') ? json('{ "publicIPAddress": {"id": "${resourceId((contains(item, 'publicIPAddressSubscriptionId') ? item.publicIPAddressSubscriptionId : subscription().subscriptionId), (contains(item, 'publicIPAddressResourceGroupName') ? item.publicIPAddressResourceGroupName : resourceGroup().name), 'Microsoft.Network/publicIPAddresses', item.publicIPAddressName)}"}}') : json('{${(contains(item, 'privateIPAllocationMethod') ? '"privateIPAllocationMethod": "${item.privateIPAllocationMethod}",' : '')}${(contains(item, 'privateIPAddress') ? '"privateIPAddress": "${item.privateIPAddress}",' : '')}"subnet": {"id": "${resourceId((contains(item, 'subnetSubscriptionId') ? item.subnetSubscriptionId : subscription().subscriptionId), (contains(item, 'subnetResourceGroupName') ? item.subnetResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', item.virtualNetworkName, item.subnetName)}"}}'))
  privateIPAllocationMethod: contains(item, 'privateIPAddress') ? 'Static' : 'Dynamic'
  privateIPAddress: contains(item, 'privateIPAddress') ? item.privateIPAddress : json('null')
  privateLinkConfiguration: {
    id: contains(item, 'privateLinkName') ? resourceId(contains(item, 'privateLinkSubscriptionId') ? item.privateLinkSubscriptionId : subscription().subscriptionId, contains(item, 'privateLinkResourceGroupName') ? item.privateLinkResourceGroupName : resourceGroup().name, 'Microsoft.Network/privateEndpoints', item.privateLinkAddressName) : null
  }
  publicIPAddress: {
    id:  contains(item, 'publicIPAddressName') ? resourceId(contains(item, 'publicIPAddressSubscriptionId') ? item.publicIPAddressSubscriptionId : subscription().subscriptionId, contains(item, 'publicIPAddressResourceGroupName') ? item.publicIPAddressResourceGroupName : resourceGroup().name, 'Microsoft.Network/publicIPAddresses', item.publicIPAddressName) : null
  }
  subnet: {
    id: 'string'
  }
}]
var  gatewayIpConfigurations_var = [for item in gatewayIpConfigurations: {
  name: item.name
  properties: {
    subnet: {
      id: resourceId((contains(item, 'subnetSubscriptionId') ? item.subnetSubscriptionId : subscription().subscriptionId), (contains(item, 'subnetResourceGroupName') ? item.subnetResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', item.virtualNetworkName, item.subnetName)
    }
  }
}]
var httpListeners_var = [for item in httpListeners: {
  name: item.name
  properties: {
    frontendIPConfiguration: {
      id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, item.properties.frontendIPConfiguration.name)
    }
    frontendPort: {
      id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, item.properties.frontendPort.name)
    }
    protocol: item.properties.protocol
    hostNames: item.properties.hostNames
    sslCertificate: ((!contains(item.properties, 'sslCertificate')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/sslCertificates', appGatewayName, item.properties.sslCertificate.name)}" }'))
    requireServerNameIndication: ((item.properties.protocol == 'https') ? true : null)
    customErrorConfigurations: ((!contains(item.properties, 'customErrorConfigurations')) ? [] : item.properties.customErrorConfigurations)
  }
}]
var requestRoutingRules_var = [for item in requestRoutingRules: {
  name: item.name
  properties: {
    httpListener: {
      id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, item.properties.httpListener.name)
    }
    backendAddressPool: {
      id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, item.properties.backendAddressPool.name)
    }
    backendHttpSettings: {
      id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, item.properties.backendHttpSettings.name)
    }
    urlPathMap: ((!contains(item.properties, 'urlPathMap')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/urlPathMaps', appGatewayName, item.properties.urlPathMap.name)}" }'))
    rewriteRuleSet: ((!contains(item.properties, 'rewriteRuleSet')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', appGatewayName, item.properties.rewriteRuleSet.name)}" }'))
    redirectConfiguration: ((!contains(item.properties, 'redirectConfiguration')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/redirectConfigurations', appGatewayName, item.properties.redirectConfiguration.name)}" }'))
  }
}]
var sslCertificatesArray = sslCertificates.array
var sslCertificates_var = [for j in range(0, length(sslCertificatesArray)): {
  name: sslCertificatesArray[j].name
  properties: (json('{${(contains(sslCertificatesArray[j].properties, 'data') ? '"data": "${sslCertificatesArray[j].properties.data}"' : '')}${(contains(sslCertificatesArray[j].properties, 'keyVaultName') ? '"keyVaultSecretId": "${resourceId((contains(sslCertificatesArray[j].properties, 'keyVaultSubscriptionId') ? sslCertificatesArray[j].properties.keyVaultSubscriptionId : subscription().subscriptionId), (contains(sslCertificatesArray[j].properties, 'keyVaultResourceGroupName') ? sslCertificatesArray[j].properties.keyVaultResourceGroupName : resourceGroup().name), 'Microsoft.KeyVault/vaults/secrets', sslCertificatesArray[j].properties.keyVaultName, sslCertificatesArray[j].properties.secretName)}"' : '')}${(contains(sslCertificatesArray[j].properties, 'password') ? ',"password": "${sslCertificatesArray[j].properties.password}"' : '')}}'))
}]
var trustedRootCertificatesArray = trustedRootCertificates.array
var trustedRootCertificates_var = [for j in range(0, length(trustedRootCertificatesArray)): {
  name: trustedRootCertificatesArray[j].name
  properties: (json('{${(contains(trustedRootCertificatesArray[j].properties, 'data') ? '"data": "${trustedRootCertificatesArray[j].properties.data}"' : '')}${(contains(trustedRootCertificatesArray[j].properties, 'keyVaultName') ? '"keyVaultSecretId": "${resourceId((contains(trustedRootCertificatesArray[j].properties, 'keyVaultSubscriptionId') ? trustedRootCertificatesArray[j].properties.keyVaultSubscriptionId : subscription().subscriptionId), (contains(trustedRootCertificatesArray[j].properties, 'keyVaultResourceGroupName') ? trustedRootCertificatesArray[j].properties.keyVaultResourceGroupName : resourceGroup().name), 'Microsoft.KeyVault/vaults/secrets', trustedRootCertificatesArray[j].properties.keyVaultName, trustedRootCertificatesArray[j].properties.keyVaultSecretName)}"' : '')}}'))
}]
var urlPathMaps_var = [for j in range(0, length(urlPathMaps)): {
  name: (urlPathMaps[j].name)
  properties: {
    defaultBackendAddressPool: (!contains(urlPathMaps[j].properties, 'defaultBackendAddressPool')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, urlPathMaps[j].properties.defaultBackendAddressPool.name)}" }')
    defaultBackendHttpSettings: (!contains(urlPathMaps[j].properties, 'defaultBackendHttpSettings')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, urlPathMaps[j].properties.defaultBackendHttpSettings.name)}" }')
    defaultRewriteRuleSet: (!contains(urlPathMaps[j].properties, 'defaultRewriteRuleSet')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', appGatewayName, urlPathMaps[j].properties.defaultRewriteRuleSet.name)}" }')
    defaultRedirectConfiguration: (!contains(urlPathMaps[j].properties, 'defaultRedirectConfiguration')) ? null : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/redirectConfigurations', appGatewayName, urlPathMaps[j].properties.defaultRedirectConfiguration.name)}" }')
    pathRules: ((!contains(urlPathMaps[j].properties, 'pathRules')) ? [] : urlPathMaps[j].properties.pathRules)
  }
}]
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource appGateway 'Microsoft.Network/applicationGateways@2019-04-01' = {
  name: appGatewayName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    authenticationCertificates: authenticationCertificates.array
    autoscaleConfiguration: (empty(autoScaleConfiguration) ? null : autoScaleConfiguration)
    backendAddressPools: backendAddressPools
    backendHttpSettingsCollection: backendHttpSettingsCollection_var
    customErrorConfigurations: customErrorConfigurations
    enableFips: true
    enableHttp2: true
    frontendIPConfigurations: frontendIPConfigurations_var
    frontendPorts: frontendPorts
    gatewayIPConfigurations: gatewayIpConfigurations_var
    httpListeners: httpListeners_var
    privateLinkConfigurations: [
      {
        id: 'string'
        name: 'string'
        properties: {
          ipConfigurations: [
            {
              id: 'string'
              name: 'string'
              properties: {
                primary: bool
                privateIPAddress: 'string'
                privateIPAllocationMethod: 'string'
                subnet: {
                  id: 'string'
                }
              }
            }
          ]
        }
      }
    ]
    probes: probes
    redirectConfigurations: redirectConfigurations
    requestRoutingRules: requestRoutingRules_var
    rewriteRuleSets: rewriteRuleSets
    sku: {
      name: 'Standard_v2'
      capacity: capacity
    }
    sslCertificates: (empty(sslCertificates_var) ? [] : sslCertificates_var)
    sslPolicy: {
      policyType: 'Predefined'
      policyName: 'AppGwSslPolicy20170401S'
    }
    trustedClientCertificates: [
      {
        id: 'string'
        name: 'string'
        properties: {
          data: 'string'
        }
      }
    ]
    trustedRootCertificates: (empty(trustedRootCertificatesArray) ? [] : trustedRootCertificates_var)
    urlPathMaps: (empty(urlPathMaps) ? [] : urlPathMaps_var)    
  }
  zones: zones
}

resource appGatewayDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  properties: {
    metrics: [
      {
        category: 'AllMetrics'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
    ]
    logs: [
      {
        category: 'ApplicationGatewayAccessLog'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'ApplicationGatewayPerformanceLog'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'ApplicationGatewayFirewallLog'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
    ]
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    appGateway
  ]
}

output applicationGateway object = appGateway
