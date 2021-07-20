@description('The name of the App Service')
param appName string

@description('The location to deploy the App Service to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Kind of App Service Plan')
@allowed([
  'app'
  'functionapp'
  'app,linux'
])
param kind string = 'app'

@description('Define SSL bindings for the App Service')
param hostNameSslStates array = []

@description('Subscription ID of App Service Plan to link App Service to')
param appServicePlanSubscriptionId string = subscription().subscriptionId

@description('Resource Group of App Service Plan to link App Service to')
param appServicePlanResourceGroupName string = resourceGroup().name

@description('Name of App Service Plan to link Application Service to')
param appServicePlanName string

@description('Version of .NET framework for runtime')
param netFrameworkVersion string = 'v4.7'

@description('Version of PHP framework for runtime')
param phpVersion string = ''

@description('Version of Python framework for runtime')
param pythonVersion string = ''

@description('Version of Node framework for runtime')
param nodeVersion string = ''

@description('Application settings (key-value pairs { appSettings: [ { key: value } ] })')
@secure()
param appSettings object = {}

@description('Linked Storage Accounts')
param azureStorageAccounts object = {}

@description('Connection string for app config')
param connectionStrings array = []

@description('Handler mappings for the app')
param handlerMappings array = []

@description('Run app in 32 bit mode')
param use32BitWorkerProcess bool = false

@description('Version of Java for runtime')
param javaVersion string = ''

@description('What to run Java in, e.g tomcat')
param javaContainer string = ''

@description('Version of Java container for runtime')
param javaContainerVersion string = ''

@description('Directories for hosting more than one app')
param virtualApplications array = [
  {
    virtualPath: '/'
    physicalPath: 'site\\wwwroot'
    preloadEnabled: true
    virtualDirectories: null
  }
]

@description('Load Balancing rules for multiple app instances and slots')
@allowed([
  'WeightedRoundRobin'
  'LeastRequests'
  'LeastResponseTime'
  'WeightedTotalTraffic'
  'RequestHash'
])
param loadBalancing string = 'LeastRequests'

@description('Enable app authentication')
param siteAuthEnabled bool = true

@description('Durably store platform security tokens in auth flows')
param tokenStoreEnabled bool = false

@description('External redirect urls for logging in or out')
param allowedExternalRedirectUrls array = []

@description('Default provider fo authentication')
@allowed([
  'AzureActiveDirectory'
  'Facebook'
  'Google'
  'MicrosoftAccount'
  'Twitter'
])
param defaultProvider string = 'AzureActiveDirectory'

@description('Number of hours after token expiration that token refresh API can be called')
param tokenRefreshExtensionHours int = 72

@description('Client ID of application')
param clientId string = ''

@description('Tenant ID of Azure tenant')
param tenantId string = subscription().tenantId

@description('Allowed IDs when validating JWTs issued by AAD')
param allowedAudiences array = []

@description('Additional params to send to OpenID (key-value pairs)')
param additionalLoginParams array = []

@description('OpenID Connect client ID of Google App')
param googleClientId string = ''

@description('OpenID Connect client secret of Google App')
param googleClientSecret string = ''

@description('OpenID Connect client ID of Facebook App')
param facebookAppId string = ''

@description('OpenID Connect client secret of Facebook App')
param facebookAppSecret string = ''

@description('The OAuth 1.0a consumer key of the Twitter application used for sign-in')
param twitterConsumerKey string = ''

@description('The OAuth 1.0a consumer secret of the Twitter application used for sign-in')
param twitterConsumerSecret string = ''

@description('The OAuth 2.0 client ID that was created for the app used for authentication')
param microsoftAccountClientId string = ''

@description('The OAuth 2.0 client secret that was created for the app used for authentication')
param microsoftAccountClientSecret string = ''

@description('Cross Origin Resource Sharing Settings')
param cors object = {}

@description('Enable local MySQL')
param localMySQLEnabled bool = false

@description('Network ACLs for main app')
param ipSecurityRestrictions array = []

@description('Network ACLs for associated scm app')
param scmIpSecurityRestrictions array = []

@description('Enable session cookies to route client requests in the same session to the smae instance')
param clientAffinityEnabled bool = true

@description('The degree of severity for diagnostic logs.')
@allowed([
  'Verbose'
  'Information'
  'Warning'
  'Error'
])
param diagnosticsLogsLevel string = 'Verbose'

@description('The name of the Storage Account to send diagnostic logs to')
param diagnosticsStorageAccountName string

@description('The name of the Storage Account Container to send diagnostic logs to')
param diagnosticsContainerName string

@description('The SAS token for authentication to the Storage Account')
@secure()
param diagnosticsStorageAccountSasToken string

@description('Enable client certificate authentication')
param clientCertEnabled bool = true

@description('Comma separated list of paths to exclude for client authentication')
param clientCertExclusionPaths string = ''

@description('Disable public hostnames, only accessible by APIM if disabled')
param hostNamesDisabled bool = false

@description('App Service will only accept https requests if true')
param httpsOnly bool = true

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string

@description('Tags to apply to App Service Environment')
param tags object

var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365
var webAppLogs = [
  {
    category: 'AppServiceHTTPLogs'
    enabled: diagnosticsEnabled
    retentionPolicy: {
      enabled: diagnosticsEnabled
      days: diagnosticsRetentionInDays
    }
  }
  {
    category: 'AppServiceConsoleLogs'
    enabled: diagnosticsEnabled
    retentionPolicy: {
      enabled: diagnosticsEnabled
      days: diagnosticsRetentionInDays
    }
  }
  {
    category: 'AppServiceAppLogs'
    enabled: diagnosticsEnabled
    retentionPolicy: {
      enabled: diagnosticsEnabled
      days: diagnosticsRetentionInDays
    }
  }
  {
    category: 'AppServiceFileAuditLogs'
    enabled: diagnosticsEnabled
    retentionPolicy: {
      enabled: diagnosticsEnabled
      days: diagnosticsRetentionInDays
    }
  }
  {
    category: 'AppServiceAuditLogs'
    enabled: diagnosticsEnabled
    retentionPolicy: {
      enabled: diagnosticsEnabled
      days: diagnosticsRetentionInDays
    }
  }
]
var functionAppLogs = [
  {
    category: 'FunctionAppLogs'
    enabled: diagnosticsEnabled
    retentionPolicy: {
      enabled: diagnosticsEnabled
      days: diagnosticsRetentionInDays
    }
  }
]
var logs = ((kind == 'functionapp') ? functionAppLogs : webAppLogs)

resource appName_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: appName
  kind: kind
  location: location
  tags: tags
  properties: {
    enabled: true
    hostNameSslStates: hostNameSslStates
    serverFarmId: resourceId(appServicePlanSubscriptionId, appServicePlanResourceGroupName, 'Microsoft.Web/serverFarms', appServicePlanName)
    siteConfig: {
      netFrameworkVersion: netFrameworkVersion
      phpVersion: phpVersion
      pythonVersion: pythonVersion
      nodeVersion: nodeVersion
      requestTracingEnabled: true
      requestTracingExpirationTime: '31/12/9999 23:59:00'
      remoteDebuggingEnabled: false
      httpLoggingEnabled: true
      logsDirectorySizeLimit: 128
      detailedErrorLoggingEnabled: true
      appSettings: (empty(appSettings) ? json('[]') : appSettings.appSettings)
      azureStorageAccounts: azureStorageAccounts
      connectionStrings: connectionStrings
      handlerMappings: handlerMappings
      scmType: 'VSTSRM'
      use32BitWorkerProcess: use32BitWorkerProcess
      webSocketsEnabled: false
      alwaysOn: true
      javaVersion: javaVersion
      javaContainer: javaContainer
      javaContainerVersion: javaContainerVersion
      managedPipelineMode: 'Integrated'
      virtualApplications: virtualApplications
      loadBalancing: loadBalancing
      autoHealEnabled: false
      siteAuthSettings: {
        enabled: siteAuthEnabled
        unauthenticatedClientAction: 'RedirectToLoginPage'
        tokenStoreEnabled: tokenStoreEnabled
        allowedExternalRedirectUrls: allowedExternalRedirectUrls
        defaultProvider: defaultProvider
        tokenRefreshExtensionHours: tokenRefreshExtensionHours
        clientId: clientId
        issuer: 'https://sts.windows.net/${tenantId}/'
        validateIssuer: true
        allowedAudiences: allowedAudiences
        additionalLoginParams: additionalLoginParams
        googleClientId: googleClientId
        googleClientSecret: googleClientSecret
        facebookAppId: facebookAppId
        facebookAppSecret: facebookAppSecret
        twitterConsumerKey: twitterConsumerKey
        twitterConsumerSecret: twitterConsumerSecret
        microsoftAccountClientId: microsoftAccountClientId
        microsoftAccountClientSecret: microsoftAccountClientSecret
      }
      cors: cors
      localMySqlEnabled: localMySQLEnabled
      ipSecurityRestrictions: ipSecurityRestrictions
      scmIpSecurityRestrictions: scmIpSecurityRestrictions
      scmIpSecurityRestrictionsUseMain: false
      http20Enabled: true
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      applicationLogs: {
        azureBlobStorage: {
          level: diagnosticsLogsLevel
          sasUrl: 'https://${diagnosticsStorageAccountName}.blob.core.windows.net/${diagnosticsContainerName}${diagnosticsStorageAccountSasToken}'
          retentionInDays: 365
        }
      }
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: clientAffinityEnabled
    clientCertEnabled: clientCertEnabled
    clientCertExclusionPaths: clientCertExclusionPaths
    hostNamesDisabled: hostNamesDisabled
    httpsOnly: httpsOnly
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource appName_Microsoft_Insights_service 'Microsoft.Web/sites//providers/diagnosticSettings@2015-07-01' = {
  name: '${appName}/Microsoft.Insights/service'
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
    logs: logs
    workspaceId: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
  }
  dependsOn: [
    appName_resource
  ]
}

output app object = reference(appName_resource.id, '2018-11-01', 'Full')