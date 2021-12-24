@description('Name of the Event Hub')
param eventHubName string

@description('Name of the Event Hub Namespace')
param eventHubNamespaceName string

@description('Number of days to retain messages')
@minValue(1)
@maxValue(7)
param messageRetentionInDays int = 1

@description('Number of partitions, recommended value greater or equal to the number of throughput units')
@minValue(2)
@maxValue(32)
param partitionCount int

@description('Frequency to capture to storage')
@minValue(60)
@maxValue(900)
param intervalInSeconds int = 300

@description('Size window before capture to storage')
@minValue(10485760)
@maxValue(524288000)
param sizeLimitInBytes int = 30000000

@description('Capture to Data Lake or Storage Account')
@allowed([
  'DataLake'
  'StorageAccount'
])
param captureResourceType string = 'DataLake'

@description('The Subscription ID of the capture resource')
param captureResourceSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the capture resource')
param captureResourceResourceGroupName string = resourceGroup().name

@description('The name of the capture resource')
param captureResourceName string

@description('The location to capture to, folder path for data lake and container name for storage account')
param captureLocation string

@description('Naming convention for archive')
param captureNameFormat string = '{Namespace}/{EventHub}/{Year}{Month}{Day}/{Hour}/{Minute}/{Second}_{PartitionId}_N'

@description('Dont write to storage for empty archives')
param skipEmptyArchives bool = true

var captureDestinationType = ((captureResourceType == 'DataLake') ? 'EventHubArchive.AzureDataLake' : 'EventHubArchive.AzureBlockBlob')
var dataLakeDestinationProperties = {
  dataLakeSubscriptionId: captureResourceSubscriptionId
  dataLakeAccountName: captureResourceName
  dataLakeFolderPath: captureLocation
  archiveNameFormat: captureNameFormat
}
var storageAccountDestinationProperties = {
  storageAccountResourceId: resourceId(captureResourceSubscriptionId, captureResourceResourceGroupName, 'Microsoft.Storage/storageAccounts', captureResourceName)
  blobContainer: captureLocation
  archiveNameFormat: captureNameFormat
}
var captureProperties = ((captureResourceType == 'DataLake') ? dataLakeDestinationProperties : storageAccountDestinationProperties)

resource eventHubNamespaceName_eventHubName 'Microsoft.EventHub/namespaces/eventHubs@2017-04-01' = {
  name: '${eventHubNamespaceName}/${eventHubName}'
  properties: {
    messageRetentionInDays: messageRetentionInDays
    partitionCount: partitionCount
    captureDescription: {
      enabled: true
      encoding: 'Avro'
      intervalInSeconds: intervalInSeconds
      sizeLimitInBytes: sizeLimitInBytes
      destination: {
        name: captureDestinationType
        properties: captureProperties
      }
      skipEmptyArchives: skipEmptyArchives
    }
  }
}