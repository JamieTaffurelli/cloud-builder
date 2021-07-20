@description('The name of the App Service Environment')
param aseName string

@description('The location to deploy the App Service Environment to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('Virtual Network in which to deploy the App Service Environment')
param vnetName string

@description('Resource Group of the Virtual Network in which to deploy the App Service Environment')
param vnetResourceGroupName string = resourceGroup().name

@description('Subnet in which to deploy the App Service Environment')
param vnetSubnetName string

@description('Subnet in which to deploy the App Service Environment')
@allowed([
  'None'
  'Web'
  'Publishing'
])
param internalLoadBalancingMode string = 'Web'

@description('The size of the front-end workers: 1 CPU 1.75 GB RAM, 2 CPU 3.5 GB RAM, 4 CPU 7 GB RAM')
@allowed([
  'Standard_D1_V2'
  'Standard_D2_V2'
  'Standard_D3_V2'
])
param multiSize string = 'Standard_D1_V2'

@description('The number of front-end workers')
param multiRoleCount int = 2

@description('DNS Suffix of all App Services deployed into the App Service Environment')
param dnsSuffix string

@description('When to add front-end worker based on number of App Service Plan instances')
param frontEndScaleFactor int = 15

@description('False for Windows, true for Linux')
param hasLinuxWorkers bool = false

@description('Thumbprint of the SSL certificate to put on the ASE ILB')
@secure()
param certificateThumbprint string

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

resource aseName_resource 'Microsoft.Web/hostingEnvironments@2018-02-01' = {
  name: aseName
  kind: 'ASEV2'
  location: location
  tags: tags
  properties: {
    virtualNetwork: {
      id: resourceId(vnetResourceGroupName, 'Microsoft.Network/virtualNetworks', vnetName)
      subnet: vnetSubnetName
    }
    internalLoadBalancingMode: internalLoadBalancingMode
    multiSize: multiSize
    multiRoleCount: multiRoleCount
    ipsslAddressCount: 0
    dnsSuffix: dnsSuffix
    frontEndScaleFactor: frontEndScaleFactor
    hasLinuxWorkers: hasLinuxWorkers
    clusterSettings: [
      {
        name: 'DefaultSslCertificateThumbprint'
        value: certificateThumbprint
      }
    ]
  }
}

resource aseName_Microsoft_Insights_service 'Microsoft.Web/hostingEnvironments//providers/diagnosticSettings@2015-07-01' = {
  name: '${aseName}/Microsoft.Insights/service'
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
        category: 'AppServiceEnvironmentPlatformLogs'
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
    aseName_resource
  ]
}

output ase object = reference(aseName_resource.id, '2018-02-01', 'Full')