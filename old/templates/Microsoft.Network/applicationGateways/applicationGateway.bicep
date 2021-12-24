@description('The name of the Application Gateway that you wish to create.')
@minLength(1)
@maxLength(80)
param appGatewayName string

@description('The location to deploy the Application Gateway to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The sku of the Application Gateway')
@allowed([
  'WAF_Medium'
  'WAF_Large'
  'WAF_v2'
  'Standard_Small'
  'Standard_Medium'
  'Standard_Large'
  'Standard_v2'
])
param skuName string = 'WAF_Medium'

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

@description('Monitor or block WAF violating traffic')
@allowed([
  'Detection'
  'Prevention'
])
param firewallMode string = 'Prevention'

@description('Set of disabled WAF rules')
param disabledRuleGroups array = []

@description('Maximum size allowed for request body in KB')
@minValue(1)
@maxValue(128)
param maxRequestBodySizeInKb int = 128

@description('Maximum size allowed for uploaded files in MB, max value for standard sku is 100MB and large sku is 500 MB')
@minValue(1)
@maxValue(500)
param fileUploadLimitInMb int = 100

@description('Exclude request attributes from WAF, properties are \'matchVariable\', \'selectorMatchOperator\', \'selector\'')
param exclusions array = []

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

var gatewayIpConfigurations_var = {
  gatewayIpConfigurations: [for item in gatewayIpConfigurations: {
    name: item.name
    properties: {
      subnet: {
        id: resourceId((contains(item, 'subnetSubscriptionId') ? item.subnetSubscriptionId : subscription().subscriptionId), (contains(item, 'subnetResourceGroupName') ? item.subnetResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', item.virtualNetworkName, item.subnetName)
      }
    }
  }]
}
var trustedRootCertificatesArray = trustedRootCertificates.array
var trustedRootCertificates_var = {
  trustedRootCertificates: [for j in range(0, (empty(trustedRootCertificatesArray) ? 1 : length(trustedRootCertificatesArray))): {
    name: (empty(trustedRootCertificatesArray) ? 'dummyName' : trustedRootCertificatesArray[j].name)
    properties: (empty(trustedRootCertificatesArray) ? json('{}') : json('{${(contains(trustedRootCertificatesArray[j].properties, 'data') ? '"data": "${trustedRootCertificatesArray[j].properties.data}"' : '')}${(contains(trustedRootCertificatesArray[j].properties, 'keyVaultName') ? '"keyVaultSecretId": "${resourceId((contains(trustedRootCertificatesArray[j].properties, 'keyVaultSubscriptionId') ? trustedRootCertificatesArray[j].properties.keyVaultSubscriptionId : subscription().subscriptionId), (contains(trustedRootCertificatesArray[j].properties, 'keyVaultResourceGroupName') ? trustedRootCertificatesArray[j].properties.keyVaultResourceGroupName : resourceGroup().name), 'Microsoft.KeyVault/vaults/secrets', trustedRootCertificatesArray[j].properties.keyVaultName, trustedRootCertificatesArray[j].properties.keyVaultSecretName)}"' : '')}}'))
  }]
}
var sslCertificatesArray = sslCertificates.array
var sslCertificates_var = {
  sslCertificates: [for j in range(0, (empty(sslCertificatesArray) ? 1 : length(sslCertificatesArray))): {
    name: (empty(sslCertificatesArray) ? 'dummyName' : sslCertificatesArray[j].name)
    properties: (empty(sslCertificatesArray) ? json('{}') : json('{${(contains(sslCertificatesArray[j].properties, 'data') ? '"data": "${sslCertificatesArray[j].properties.data}"' : '')}${(contains(sslCertificatesArray[j].properties, 'keyVaultName') ? '"keyVaultSecretId": "${resourceId((contains(sslCertificatesArray[j].properties, 'keyVaultSubscriptionId') ? sslCertificatesArray[j].properties.keyVaultSubscriptionId : subscription().subscriptionId), (contains(sslCertificatesArray[j].properties, 'keyVaultResourceGroupName') ? sslCertificatesArray[j].properties.keyVaultResourceGroupName : resourceGroup().name), 'Microsoft.KeyVault/vaults/secrets', sslCertificatesArray[j].properties.keyVaultName, sslCertificatesArray[j].properties.secretName)}"' : '')}${(contains(sslCertificatesArray[j].properties, 'password') ? ',"password": "${sslCertificatesArray[j].properties.password}"' : '')}}'))
  }]
}
var frontendIPConfigurations_var = {
  frontendIPConfigurations: [for item in frontendIPConfigurations: {
    name: item.name
    properties: (contains(item, 'publicIPAddressName') ? json('{ "publicIPAddress": {"id": "${resourceId((contains(item, 'publicIPAddressSubscriptionId') ? item.publicIPAddressSubscriptionId : subscription().subscriptionId), (contains(item, 'publicIPAddressResourceGroupName') ? item.publicIPAddressResourceGroupName : resourceGroup().name), 'Microsoft.Network/publicIPAddresses', item.publicIPAddressName)}"}}') : json('{${(contains(item, 'privateIPAllocationMethod') ? '"privateIPAllocationMethod": "${item.privateIPAllocationMethod}",' : '')}${(contains(item, 'privateIPAddress') ? '"privateIPAddress": "${item.privateIPAddress}",' : '')}"subnet": {"id": "${resourceId((contains(item, 'subnetSubscriptionId') ? item.subnetSubscriptionId : subscription().subscriptionId), (contains(item, 'subnetResourceGroupName') ? item.subnetResourceGroupName : resourceGroup().name), 'Microsoft.Network/virtualNetworks/subnets', item.virtualNetworkName, item.subnetName)}"}}'))
  }]
}
var connectionDraining = {
  enabled: true
  drainTimeoutInSec: 300
}
var backendHttpSettingsCollectionWithoutHostName = {
  backendHttpSettingsCollectionWithoutHostName: [for item in backendHttpSettingsCollection: {
    name: item.name
    properties: {
      port: item.properties.port
      protocol: item.properties.protocol
      cookieBasedAffinity: (contains(item.properties, 'cookieBasedAffinity') ? item.properties.cookieBasedAffinity : 'Disabled')
      requestTimeout: (contains(item.properties, 'requestTimeout') ? item.properties.requestTimeout : 30)
      probe: (((!contains(item.properties, 'probe')) || empty(item.properties.probe)) ? json('{}') : json('{ "id": "${resourceId('Microsoft.Network/applicationGateways/probes', appGatewayName, item.properties.probe.name)}" }'))
      authenticationCertificates: (((!contains(item.properties, 'authenticationCertificates')) || empty(item.properties.authenticationCertificates)) ? json('[]') : item.properties.authenticationCertificates)
      trustedRootCertificates: (((!contains(item.properties, 'trustedRootCertificates')) || empty(item.properties.trustedRootCertificates)) ? json('[]') : item.properties.trustedRootCertificates)
      connectionDraining: (((!contains(item.properties, 'connectionDraining')) || empty(item.properties.connectionDraining)) ? connectionDraining : item.properties.connectionDraining)
      pickHostNameFromBackendAddress: ((!contains(item.properties, 'pickHostNameFromBackendAddress')) ? json('false') : item.properties.pickHostNameFromBackendAddress)
      affinityCookieName: (((!contains(item.properties, 'affinityCookieName')) || empty(item.properties.affinityCookieName)) ? json('null') : item.properties.affinityCookieName)
      path: (((!contains(item.properties, 'path')) || empty(item.properties.path)) ? json('null') : item.properties.path)
    }
  }]
}
var backendHttpSettingsCollection_var = {
  backendHttpSettingsCollection: [for (item, j) in backendHttpSettingsCollection: {
    name: item.name
    properties: (contains(item.properties, 'hostName') ? union(backendHttpSettingsCollectionWithoutHostName[j].properties, json('{"hostname": "${item.properties.hostname}"}')) : backendHttpSettingsCollectionWithoutHostName.backendHttpSettingsCollectionWithoutHostName[j].properties)
  }]
}
var httpListeners_var = {
  httpListeners: [for item in httpListeners: {
    name: item.name
    properties: {
      frontendIPConfiguration: {
        id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, item.properties.frontendIPConfiguration.name)
      }
      frontendPort: {
        id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, item.properties.frontendPort.name)
      }
      protocol: item.properties.protocol
      hostName: item.properties.hostName
      sslCertificate: ((!contains(item.properties, 'sslCertificate')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/sslCertificates', appGatewayName, item.properties.sslCertificate.name)}" }'))
      requireServerNameIndication: ((item.properties.protocol == 'https') ? json('true') : json('null'))
      customErrorConfigurations: ((!contains(item.properties, 'customErrorConfigurations')) ? json('[]') : item.properties.customErrorConfigurations)
    }
  }]
}
var urlPathMaps_var = {
  urlPathMaps: [for j in range(0, (empty(urlPathMaps) ? 1 : length(urlPathMaps))): {
    name: (empty(urlPathMaps) ? 'dummyName' : urlPathMaps[j].name)
    properties: {
      defaultBackendAddressPool: (empty(urlPathMaps) ? 'dummyBackendAddressPool' : ((!contains(urlPathMaps[j].properties, 'defaultBackendAddressPool')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, urlPathMaps[j].properties.defaultBackendAddressPool.name)}" }')))
      defaultBackendHttpSettings: (empty(urlPathMaps) ? 'dummyBackendHttpSettings' : ((!contains(urlPathMaps[j].properties, 'defaultBackendHttpSettings')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, urlPathMaps[j].properties.defaultBackendHttpSettings.name)}" }')))
      defaultRewriteRuleSet: (empty(urlPathMaps) ? 'dummyRewriteRuleSet' : ((!contains(urlPathMaps[j].properties, 'defaultRewriteRuleSet')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', appGatewayName, urlPathMaps[j].properties.defaultRewriteRuleSet.name)}" }')))
      defaultRedirectConfiguration: (empty(urlPathMaps) ? 'dummyRedirectConfiguration' : ((!contains(urlPathMaps[j].properties, 'defaultRedirectConfiguration')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/redirectConfigurations', appGatewayName, urlPathMaps[j].properties.defaultRedirectConfiguration.name)}" }')))
      pathRules: (empty(urlPathMaps) ? 'dummyRedirectConfiguration' : ((!contains(urlPathMaps[j].properties, 'pathRules')) ? json('[]') : urlPathMaps[j].properties.pathRules))
    }
  }]
}
var requestRoutingRules_var = {
  requestRoutingRules: [for item in requestRoutingRules: {
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
      urlPathMap: ((!contains(item.properties, 'urlPathMap')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/urlPathMaps', appGatewayName, item.properties.urlPathMap.name)}" }'))
      rewriteRuleSet: ((!contains(item.properties, 'rewriteRuleSet')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/rewriteRuleSets', appGatewayName, item.properties.rewriteRuleSet.name)}" }'))
      redirectConfiguration: ((!contains(item.properties, 'redirectConfiguration')) ? json('null') : json('{"id": "${resourceId('Microsoft.Network/applicationGateways/redirectConfigurations', appGatewayName, item.properties.redirectConfiguration.name)}" }'))
    }
  }]
}
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource appGatewayName_resource 'Microsoft.Network/applicationGateways@2019-04-01' = {
  name: appGatewayName
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
      capacity: capacity
    }
    sslPolicy: {
      policyType: 'Predefined'
      policyName: 'AppGwSslPolicy20170401S'
    }
    gatewayIPConfigurations: gatewayIpConfigurations_var.gatewayIpConfigurations
    authenticationCertificates: authenticationCertificates.array
    trustedRootCertificates: (empty(trustedRootCertificatesArray) ? json('[]') : trustedRootCertificates_var.trustedRootCertificates)
    sslCertificates: (empty(sslCertificates_var) ? json('[]') : sslCertificates_var.sslCertificates)
    frontendIPConfigurations: frontendIPConfigurations_var.frontendIPConfigurations
    frontendPorts: frontendPorts
    probes: probes
    backendAddressPools: backendAddressPools
    backendHttpSettingsCollection: backendHttpSettingsCollection_var.backendHttpSettingsCollection
    httpListeners: httpListeners_var.httpListeners
    urlPathMaps: (empty(urlPathMaps) ? json('[]') : urlPathMaps_var.urlPathMaps)
    requestRoutingRules: requestRoutingRules_var.requestRoutingRules
    rewriteRuleSets: rewriteRuleSets
    redirectConfigurations: redirectConfigurations
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: firewallMode
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
      disabledRuleGroups: disabledRuleGroups
      requestBodyCheck: true
      maxRequestBodySizeInKb: maxRequestBodySizeInKb
      fileUploadLimitInMb: fileUploadLimitInMb
      exclusions: exclusions
    }
    enableHttp2: true
    autoscaleConfiguration: (empty(autoScaleConfiguration) ? json('null') : autoScaleConfiguration)
    customErrorConfigurations: customErrorConfigurations
  }
  zones: zones
}

resource appGatewayName_Microsoft_Insights_service 'Microsoft.Network/applicationGateways//providers/diagnosticSettings@2015-07-01' = {
  name: '${appGatewayName}/Microsoft.Insights/service'
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
    appGatewayName_resource
  ]
}

output applicationGateway object = reference(appGatewayName_resource.id, '2019-04-01', 'Full')