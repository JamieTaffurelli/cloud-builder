@description('The name of the Workbook')
param workbookName string

@description('The location to deploy the workbook')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Kind of workbook')
@allowed([
  'Shared'
  'User'
])
param kind string = 'Shared'

@description('Display name of the workbook')
param displayName string

@description('JSON configuration of workbook')
param serializedData string

@description('Workbook version')
param version string

@description('Workbook category')
param category string = 'workbook'

@description('Workbook tags')
param workbookTags array = []

@description('Resource ID of data source')
param sourceId string

@description('Tags to apply to workbook')
param tags object

resource workbookName_id 'Microsoft.Insights/workbooks@2020-10-20' = {
  name: guid(workbookName, resourceGroup().id)
  kind: kind
  location: location
  tags: tags
  properties: {
    displayName: displayName
    serializedData: serializedData
    version: version
    category: category
    tags: workbookTags
    sourceId: sourceId
  }
}

output workbook object = reference(workbookName_id.id, '2020-10-20', 'Full')