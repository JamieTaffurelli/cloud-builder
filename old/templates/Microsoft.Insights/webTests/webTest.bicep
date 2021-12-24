@description('The name of the Web Test to deploy')
param webTestName string

@description('The Subscription ID of the App Insights to run Web Tests from')
param appInsightsSubscriptionId string = subscription().subscriptionId

@description('The Resource Group of the App Insights to run Web Tests from')
param appInsightsResourceGroupName string = resourceGroup().name

@description('The name of the App Insights to run Web Tests from')
param appInsightsName string

@description('The location to deploy the Web Test to')
@allowed([
  'northeurope'
  'westeurope'
])
param location string = resourceGroup().location

@description('The location to deploy the Web Test to')
@allowed([
  'ping'
  'multistep'
])
param kind string = 'ping'

@description('The description of the Web Test')
param description string

@description('Enable or Disable the Web Test')
param enabled bool = true

@description('Frequency in seconds to run the Web Test')
param frequency int = 300

@description('Timeout for requests')
param timeout int = 30

@description('Enable retries for failed requests')
param retryEnabled bool = true

@description('Locations to run Web Tests from')
param locationIds array = [
  'emea-nl-ams-azr'
  'emea-ru-msa-edge'
  'emea-se-sto-edge'
  'emea-gb-db3-azr'
  'us-va-ash-azr'
]

@description('XML specification of Web Test to run')
param webTest string

@description('Tags to apply to Web Test Rule')
param tags object

var appInsightsTag = {
  'hidden-link:${resourceId(appInsightsSubscriptionId, appInsightsResourceGroupName, 'Microsoft.Insights/components/', appInsightsName)}': 'Resource'
}
var tags_var = union(tags, appInsightsTag)
var locations = {
  locations: [for item in locationIds: {
    id: item
  }]
}

resource webtestName_resource 'Microsoft.Insights/webTests@2015-05-01' = {
  name: webTestName
  location: location
  tags: tags_var
  kind: kind
  properties: {
    SyntheticMonitorId: webTestName
    Name: webTestName
    Description: description
    Enabled: enabled
    Frequency: frequency
    Timeout: timeout
    Kind: kind
    RetryEnabled: retryEnabled
    Locations: locations.locations
    Configuration: {
      WebTest: webTest
    }
  }
}

output webTest object = reference(webtestName_resource.id, '2015-05-01', 'Full')