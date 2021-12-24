@description('The name of the Service Bus Queue that you wish to create.')
param queueName string

@description('The name of the Service Bus to create the Queue in.')
param serviceBusName string

@description('Lock time for other receivers')
param lockDuration string = 'PT1M'

@description('Max size in megabytes')
param maxSizeInMegabytes int = 1024

@description('Check for duplicates')
param requiresDuplicateDetection bool = false

@description('Support sessions')
param requiresSession bool = false

@description('Time before expiration')
param defaultMessageTimeToLive string = 'P14D'

@description('Support dead lettering')
param deadLetteringOnMessageExpiration bool = false

@description('Timespan to check for duplicates')
param duplicateDetectionHistoryTimeWindow string = 'PT10M'

@description('Dead letter after this number of deliveries')
param maxDeliveryCount int = 10

@description('Enable batched operations')
param enableBatchedOperations bool = true

@description('Idle interval after which to delete')
param autoDeleteOnIdle string = ''

@description('Partition across message brokers')
param enablePartitioning bool = false

@description('Hold message in memory before writing to disk')
param enableExpress bool = false

@description('Queue/Topic to forward to')
param forwardTo string = ''

@description('Queue/Topic to forward dead lettered messages to')
param forwardDeadLetteredMessagesTo string = ''

resource serviceBusName_queueName 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
  name: '${serviceBusName}/${queueName}'
  properties: {
    lockDuration: lockDuration
    maxSizeInMegabytes: maxSizeInMegabytes
    requiresDuplicateDetection: requiresDuplicateDetection
    requiresSession: requiresSession
    defaultMessageTimeToLive: defaultMessageTimeToLive
    deadLetteringOnMessageExpiration: deadLetteringOnMessageExpiration
    duplicateDetectionHistoryTimeWindow: duplicateDetectionHistoryTimeWindow
    maxDeliveryCount: maxDeliveryCount
    enableBatchedOperations: enableBatchedOperations
    autoDeleteOnIdle: autoDeleteOnIdle
    enablePartitioning: enablePartitioning
    enableExpress: enableExpress
    forwardTo: (empty(forwardTo) ? json('null') : forwardTo)
    forwardDeadLetteredMessagesTo: (empty(forwardDeadLetteredMessagesTo) ? json('null') : forwardDeadLetteredMessagesTo)
  }
}

output serviceBusQueue object = reference(serviceBusName_queueName.id, '2017-04-01', 'Full')