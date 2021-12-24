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

resource eventHubNamespaceName_eventHubName 'Microsoft.EventHub/namespaces/eventHubs@2017-04-01' = {
  name: '${eventHubNamespaceName}/${eventHubName}'
  properties: {
    messageRetentionInDays: messageRetentionInDays
    partitionCount: partitionCount
  }
}