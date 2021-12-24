@description('The name of the AKS cluster to create')
param clusterName string

@description('The location to deploy the AKS cluster to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Version of Kubernetes to run')
param kubernetesVersion string

@description('DNS prefix of nodes')
param dnsPrefix string

@description('System and user agent pools')
param agentPoolProfiles array

@description('Admin username on VMs')
param adminUserName string = 'kubemonkey'

@description('SSH public key for authentication')
@secure()
param keyData string

@description('Password for authentication')
@secure()
param adminPassword string

@description('Enable Azure Hybrid Benefit')
@allowed([
  'None'
  'Windows_Server'
])
param licenseType string = 'None'

@description('Service Principal client ID and secret for cluster to use for manipulating Azure APIs')
@secure()
param servicePrincipalProfile object = {}

@description('Profile of managed cluster add-on')
param addOnProfiles object = {}

@description('Enable pod identity add-on')
param podIdentityEnabled bool = false

@description('User assigned pod identity settings')
param userAssignedIdentities array = []

@description('User assigned pod identity exception settings')
param userAssignedIdentityExceptions array = []

@description('Resource Group to deploy nodes to')
param nodeResourceGroup string

@description('Enable Kubernetes RBAC')
param enableRBAC bool = true

@description('Profile of network configuration')
param networkProfile object = {}

@description('Enable Kubernetes RBAC')
param enableManagedAad bool = true

@description('Enable Kubernetes RBAC')
param enableAzureRBAC bool = false

@description('Enable Kubernetes RBAC')
param adminGroupObjectIDs array = []

@description('Parameters to be applied to the cluster-autoscaler when enabled')
param autoScalerProfile object = {}

@description('Authorized IP Ranges to kubernetes API server')
param authorizedIPRanges array = []

@description('Enable Kubernetes RBAC')
param enablePrivateCluster bool = true

@description('Enable Kubernetes RBAC')
param privateDNSZone string = ''

@description('Tier of a managed cluster SKU')
@allowed([
  'Free'
  'Paid'
])
param tier string = 'Free'

@description('The Subscription ID of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsResourceGroupName string = resourceGroup().name

@description('The name of the Log Analytics Workspace to send diagnostics to')
param logAnalyticsName string
param tags object

var omsagent = {
  omsagent: {
    enabled: true
    config: {
      logAnalyticsWorkspaceResourceID: resourceId(logAnalyticsSubscriptionId, logAnalyticsResourceGroupName, 'Microsoft.OperationalInsights/workspaces', logAnalyticsName)
    }
  }
}
var addonProfiles_var = union(addOnProfiles, omsagent)
var diagnosticsEnabled = true
var diagnosticsRetentionInDays = 365

resource clusterName_resource 'Microsoft.ContainerService/managedClusters@2020-11-01' = {
  name: clusterName
  location: location
  tags: tags
  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    agentPoolProfiles: agentPoolProfiles
    linuxProfile: {
      adminUsername: adminUserName
      ssh: {
        publicKeys: [
          {
            keyData: keyData
          }
        ]
      }
    }
    windowsProfile: {
      adminUsername: adminUserName
      adminPassword: adminPassword
      licenseType: licenseType
    }
    servicePrincipalProfile: servicePrincipalProfile
    addonProfiles: addonProfiles_var
    podIdentityProfile: {
      enabled: podIdentityEnabled
      userAssignedIdentities: userAssignedIdentities
      userAssignedIdentityExceptions: userAssignedIdentityExceptions
    }
    nodeResourceGroup: nodeResourceGroup
    enableRBAC: enableRBAC
    networkProfile: networkProfile
    aadProfile: {
      managed: enableManagedAad
      enableAzureRBAC: enableAzureRBAC
      adminGroupObjectIDs: adminGroupObjectIDs
    }
    autoScalerProfile: autoScalerProfile
    apiServerAccessProfile: {
      authorizedIPRanges: authorizedIPRanges
      enablePrivateCluster: enablePrivateCluster
      privateDNSZone: privateDNSZone
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Basic'
    tier: tier
  }
}

resource clusterName_Microsoft_Insights_service 'Microsoft.ContainerService/managedClusters//providers/diagnosticSettings@2015-07-01' = {
  name: '${clusterName}/Microsoft.Insights/service'
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
        category: 'kube-apiserver'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'kube-audit'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'kube-audit-admin'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'kube-controller-manager'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'kube-scheduler'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'cluster-autoscaler'
        enabled: diagnosticsEnabled
        retentionPolicy: {
          enabled: diagnosticsEnabled
          days: diagnosticsRetentionInDays
        }
      }
      {
        category: 'guard'
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
    clusterName_resource
  ]
}

output cluster object = reference(clusterName_resource.id, '2020-11-01', 'Full')