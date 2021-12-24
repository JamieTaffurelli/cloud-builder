@description('The name of the Log Analytics Workspace that you wish to create.')
param logAnalyticsName string

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
  'WireData2'
]

resource logAnalyticsName_resource 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: 'westeurope'
  tags: tags
  properties: {
    sku: sku_var
    retentionInDays: retentionInDays_var
    workspaceCapping: ((dailyQuotaGB == '') ? json('{}') : workspaceCapping)
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}

resource solutions_logAnalyticsName 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [for item in solutions: {
  name: '${item}(${logAnalyticsName})'
  location: 'westeurope'
  tags: tags
  plan: {
    name: '${item}(${logAnalyticsName})'
    publisher: 'Microsoft'
    product: 'OMSGallery/${item}'
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalyticsName_resource.id
  }
  dependsOn: [
    logAnalyticsName
  ]
}]

output logAnalytics object = reference(logAnalyticsName_resource.id, '2020-08-01', 'Full')