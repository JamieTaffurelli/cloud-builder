@description('The name of the Log Analytics Workspace that you wish to create.')
param logAnalyticsName string

@description('Location of the Log Analytics Workspace')
param location string = resourceGroup().location

@description('The sku of the Log Analytics Workspace that you wish to create.')
@allowed([
  'Free'
  'Standard'
  'Premium'
  'PerNode'
  'PerGB2018'
  'Standalone'
  'CapacityReservation'
])
param sku string = 'PerGB2018'

@description('The amount of capacity to reserve in GB, intervals of 100')
param capacityReservationLevel int = 0

@description('The amount of time to retain logs for, if sku is unlimited then this value will be ignored and unlimited retention will be set.')
@minValue(30)
@maxValue(730)
param retentionInDays int = 400

@description('Limit the daily amount of data written to Log Analytics')
param dailyQuotaGB string = ''

@description('The network access type for accessing Log Analytics ingestion')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('The network access type for accessing Log Analytics query')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'
param tags object

var skuName = {
  name: sku
}
var capacityReservation = {
  capacityReservationLevel: capacityReservationLevel
}
var sku_var = ((sku == 'CapacityReservation') ? union(skuName, capacityReservation) : skuName)
var retentionInDays_var = ((sku == 'Unlimited') ? -1 : retentionInDays)
var workspaceCapping = {
  dailyQuotaGB: dailyQuotaGB
}
var solutions = [
  'ADAssessment'
  'ADReplication'
  'AgentHealthAssessment'
  'AntiMalware'
  'ApplicationInsights'
  'AzureDataFactoryAnalytics'
  'AzureNetworking'
  'AzureNSGAnalytics'
  'AzureSecurityOfThings'
  'AzureSQLAnalytics'
  'AzureWebAppsAnalytics'
  'Backup'
  'CapacityPerformance'
  'ChangeTracking'
  'ContainerInsights'
  'Containers'
  'DHCPActivity'
  'DnsAnalytics'
  'InternalWindowsEvent'
  'KeyVault'
  'KeyVaultAnalytics'
  'LogicAppB2B'
  'LogicAppsManagement'
  'NetworkMonitoring'
  'SCOMAssessment'
  'Security'
  'SecurityCenterFree'
  'SecurityCenterNetworkTraffic'
  'SecurityInsights'
  'ServiceFabric'
  'ServiceMap'
  'SiteRecovery'
  'SQLAdvancedThreatProtection'
  'SQLAssessment'
  'SQLVulnerabilityAssessment'
  'SurfaceHub'
  'Updates'
  'VMInsights'
  'WaaSUpdateInsights'
  'WindowsDefenderATPStable'
  'WindowsEventForwarding'
  'WindowsFirewall'
]

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: location
  tags: tags
  properties: {
    sku: sku_var
    retentionInDays: retentionInDays_var
    workspaceCapping: ((dailyQuotaGB == '') ? json('{}') : workspaceCapping)
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource logAnalyticsSolutions'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for item in solutions: {
  name: '${item}(${logAnalyticsName})'
  location: location
  tags: tags
  plan: {
    name: '${item}(${logAnalyticsName})'
    publisher: 'Microsoft'
    product: 'OMSGallery/${item}'
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalytics.id
  }
}]

resource logAnalyticsDiag 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: 'service'
  scope: logAnalytics
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
        category: 'Audit'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
    ]
    workspaceId: logAnalytics.id
  }
}

output logAnalytics object = logAnalytics
