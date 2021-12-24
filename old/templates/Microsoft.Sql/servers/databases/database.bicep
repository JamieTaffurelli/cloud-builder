@description('The name of the database that you wish to create.')
param databaseName string

@description('The name of the SQL Server linked to the database.')
param sqlServerName string

@description('The location to deploy the SQL Server to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The sku of the Database')
param sku object

@description('The collation of the database')
@allowed([
  'DATABASE_DEFAULT'
  'SQL_Latin1_General_CP1_CI_AS'
])
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('The maximum size of the of the database')
param maxSizeBytes int = 34359738368

@description('The Subscription ID of the associated elastic pool')
param elasticPoolSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the associated elastic pool')
param elasticPoolResourceGroupName string = resourceGroup().name

@description('The name of the associated elastic pool')
param elasticPoolName string = ''

@description('The collation of the metadata catalog')
@allowed([
  'DATABASE_DEFAULT'
  'SQL_Latin1_General_CP1_CI_AS'
])
param catalogCollation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Spread database across different datacenter zones')
param zoneRedundant bool = true

@description('The License Type for the database')
@allowed([
  'LicenseIncluded'
  'BasePrice'
])
param licenseType string = 'LicenseIncluded'

@description('Time in minutes after which database is automatically paused')
param autoPauseDelay int = -1

@description('Minimum number of instances if not paused')
param minCapacity string = '2'

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var elasticPoolId = (empty(elasticPoolName) ? '' : resourceId(elasticPoolSubscriptionId, elasticPoolResourceGroupName, 'Microsoft.Sql/servers/elasticPools', sqlServerName, databaseName))
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource sqlServerName_databaseName 'Microsoft.Sql/servers/databases@2017-10-01-preview' = {
  name: '${sqlServerName}/${databaseName}'
  location: location
  tags: tags
  sku: sku
  properties: {
    createMode: 'Default'
    collation: collation
    maxSizeBytes: maxSizeBytes
    elasticPoolId: elasticPoolId
    catalogCollation: catalogCollation
    zoneRedundant: zoneRedundant
    licenseType: licenseType
    autoPauseDelay: autoPauseDelay
    minCapacity: minCapacity
  }
}

resource sqlServerName_databaseName_current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2014-04-01' = {
  parent: sqlServerName_databaseName
  name: 'current'
  properties: {
    status: 'Enabled'
  }
}

output database object = reference(sqlServerName_databaseName.id, '2017-10-01-preview', 'Full')