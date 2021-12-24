@description('The name of the AKS node pool to create')
param poolName string

@description('The name of the AKS cluster to attach node pool to')
param clusterName string

@description('Number of nodes to create')
param count int = 1

@description('VM size of nodes')
param vmSize string = 'Standard_B2S'

@description('Size of OS disk on nodes')
@minValue(32)
@maxValue(2048)
param osDiskSizeGB int = 32

@description('Maximum number of pods that can run on a node')
param maxPods int = 30

@description('OS to run on nodes')
@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Linux'

@description('Maximum number of nodes to auto scale to')
param maxCount int = 1

@description('Minimum number of nodes to auto scale to')
param minCount int = 1

@description('Mode of agent pool')
@allowed([
  'User'
  'System'
])
param mode string = 'User'

@description('Count or percentage of additional nodes to be added during upgrade. If empty uses AKS default')
param maxSurge string = ''

@description('Availabilty zones for nodes')
param availabilityZones array = []

@description('Enable public IP for nodes')
param enableNodePublicIP bool = false

@description('Tags on agent pool scaleset')
param tags object

@description('Agent pool node labels to be persisted across all nodes in agent pool.')
param nodeLabels object = {}

@description('Taints added to new nodes during node pool create and scale')
param nodeTaints array = []

resource clusterName_poolName 'Microsoft.ContainerService/managedClusters/agentPools@2020-11-01' = {
  name: '${clusterName}/${poolName}'
  properties: {
    count: count
    vmSize: vmSize
    osDiskSizeGB: osDiskSizeGB
    osDiskType: 'Managed'
    maxPods: maxPods
    osType: osType
    maxCount: maxCount
    minCount: minCount
    enableAutoScaling: true
    type: 'VirtualMachineScaleSets'
    mode: mode
    upgradeSettings: {
      maxSurge: maxSurge
    }
    availabilityZones: availabilityZones
    enableNodePublicIP: enableNodePublicIP
    tags: tags
    nodeLabels: nodeLabels
    nodeTaints: nodeTaints
  }
}

output agentPool object = reference(clusterName_poolName.id, '2020-11-01', 'Full')