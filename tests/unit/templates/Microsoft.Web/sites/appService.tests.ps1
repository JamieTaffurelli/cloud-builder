$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "App Service Parameter Validation" {

    Context "appName Validation" {

        It "Has appName parameter" {

            $json.parameters.appName | should not be $null
        }

        It "appName parameter is of type string" {

            $json.parameters.appName.type | should be "string"
        }

        It "appName parameter is mandatory" {

            ($json.parameters.appName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "location Validation" {

        It "Has location parameter" {

            $json.parameters.location | should not be $null
        }

        It "location parameter is of type string" {

            $json.parameters.location.type | should be "string"
        }

        It "location parameter default value is [resourceGroup().location]" {

            $json.parameters.location.defaultValue | should be "[resourceGroup().location]"
        }

        It "location parameter allowed values are northeurope, westeurope" {

            (Compare-Object -ReferenceObject $json.parameters.location.allowedValues -DifferenceObject @("northeurope", "westeurope")).Length | should be 0
        }
    }


    Context "kind Validation" {

        It "Has kind parameter" {

            $json.parameters.kind | should not be $null
        }

        It "kind parameter is of type string" {

            $json.parameters.kind.type | should be "string"
        }

        It "kind parameter default value is app" {

            $json.parameters.kind.defaultValue | should be "app"
        }

        It "kind parameter allowed values are 'app', 'functionapp', 'app', 'linux'" {

            (Compare-Object -ReferenceObject $json.parameters.kind.allowedValues -DifferenceObject @("app", "functionapp", "app,linux")).Length | should be 0
        }
    }

    Context "appServicePlanSubscriptionId Validation" {

        It "Has appServicePlanSubscriptionId parameter" {

            $json.parameters.appServicePlanSubscriptionId | should not be $null
        }

        It "appServicePlanSubscriptionId parameter is of type string" {

            $json.parameters.appServicePlanSubscriptionId.type | should be "string"
        }

        It "appServicePlanSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appServicePlanSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appServicePlanResourceGroupName Validation" {

        It "Has appServicePlanResourceGroupName parameter" {

            $json.parameters.appServicePlanResourceGroupName | should not be $null
        }

        It "appServicePlanResourceGroupName parameter is of type string" {

            $json.parameters.appServicePlanResourceGroupName.type | should be "string"
        }

        It "appServicePlanResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appServicePlanResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "appServicePlanName Validation" {

        It "Has appServicePlanName parameter" {

            $json.parameters.appServicePlanName | should not be $null
        }

        It "appServicePlanName parameter is of type string" {

            $json.parameters.appServicePlanName.type | should be "string"
        }

        It "appServicePlanName parameter is mandatory" {

            ($json.parameters.appServicePlanName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "netFrameworkVersion Validation" {

        It "Has netFrameworkVersion parameter" {

            $json.parameters.netFrameworkVersion | should not be $null
        }

        It "netFrameworkVersion parameter is of type string" {

            $json.parameters.netFrameworkVersion.type | should be "string"
        }

        It "netFrameworkVersion parameter default value is an empty string" {

            $json.parameters.netFrameworkVersion.defaultValue | should be ([String]::Empty)
        }
    }

    Context "phpVersion Validation" {

        It "Has phpVersion parameter" {

            $json.parameters.phpVersion | should not be $null
        }

        It "phpVersion parameter is of type string" {

            $json.parameters.phpVersion.type | should be "string"
        }

        It "phpVersion parameter default value is an empty string" {

            $json.parameters.phpVersion.defaultValue | should be ([String]::Empty)
        }
    }

    Context "pythonVersion Validation" {

        It "Has pythonVersion parameter" {

            $json.parameters.pythonVersion | should not be $null
        }

        It "pythonVersion parameter is of type string" {

            $json.parameters.pythonVersion.type | should be "string"
        }

        It "pythonVersion parameter default value is an empty string" {

            $json.parameters.pythonVersion.defaultValue | should be ([String]::Empty)
        }
    }

    Context "nodeVersion Validation" {

        It "Has nodeVersion parameter" {

            $json.parameters.nodeVersion | should not be $null
        }

        It "nodeVersion parameter is of type string" {

            $json.parameters.nodeVersion.type | should be "string"
        }

        It "nodeVersion parameter default value is an empty string" {

            $json.parameters.nodeVersion.defaultValue | should be ([String]::Empty)
        }
    }

    Context "appSettings Validation" {

        It "Has appSettings parameter" {

            $json.parameters.appSettings | should not be $null
        }

        It "appSettings parameter is of type array" {

            $json.parameters.appSettings.type | should be "array"
        }

        It "appSettings parameter default value is an empty array" {

            $json.parameters.appSettings.defaultValue | should be @()
        }
    }

    Context "azureStorageAccounts Validation" {

        It "Has azureStorageAccounts parameter" {

            $json.parameters.azureStorageAccounts | should not be $null
        }

        It "azureStorageAccounts parameter is of type object" {

            $json.parameters.azureStorageAccounts.type | should be "object"
        }

        It "azureStorageAccounts parameter default value is an empty object" {

            $json.parameters.azureStorageAccounts.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "connectionStrings Validation" {

        It "Has connectionStrings parameter" {

            $json.parameters.connectionStrings | should not be $null
        }

        It "connectionStrings parameter is of type array" {

            $json.parameters.connectionStrings.type | should be "array"
        }

        It "connectionStrings parameter default value is an empty array" {

            $json.parameters.connectionStrings.defaultValue | should be @()
        }
    }

    Context "handlerMappings Validation" {

        It "Has handlerMappings parameter" {

            $json.parameters.handlerMappings | should not be $null
        }

        It "handlerMappings parameter is of type array" {

            $json.parameters.handlerMappings.type | should be "array"
        }

        It "handlerMappings parameter default value is an empty array" {

            $json.parameters.handlerMappings.defaultValue | should be @()
        }
    }

    Context "use32BitWorkerProcess Validation" {

        It "Has use32BitWorkerProcess parameter" {

            $json.parameters.use32BitWorkerProcess | should not be $null
        }

        It "use32BitWorkerProcess parameter is of type bool" {

            $json.parameters.use32BitWorkerProcess.type | should be "bool"
        }

        It "use32BitWorkerProcess parameter default value is true" {

            $json.parameters.use32BitWorkerProcess.defaultValue | should be $false
        }
    }

    Context "javaVersion Validation" {

        It "Has javaVersion parameter" {

            $json.parameters.javaVersion | should not be $null
        }

        It "javaVersion parameter is of type string" {

            $json.parameters.javaVersion.type | should be "string"
        }

        It "javaVersion parameter default value is an empty string" {

            $json.parameters.javaVersion.defaultValue | should be ([String]::Empty)
        }
    }

    Context "javaContainer Validation" {

        It "Has javaContainer parameter" {

            $json.parameters.javaContainer | should not be $null
        }

        It "javaContainer parameter is of type string" {

            $json.parameters.javaContainer.type | should be "string"
        }

        It "javaContainer parameter default value is an empty string" {

            $json.parameters.javaContainer.defaultValue | should be ([String]::Empty)
        }
    }

    Context "javaContainerVersion Validation" {

        It "Has javaContainerVersion parameter" {

            $json.parameters.javaContainerVersion | should not be $null
        }

        It "javaContainerVersion parameter is of type string" {

            $json.parameters.javaContainerVersion.type | should be "string"
        }

        It "javaContainerVersion parameter default value is an empty string" {

            $json.parameters.javaContainerVersion.defaultValue | should be ([String]::Empty)
        }
    }

    Context "virtualApplications Validation" {

        It "Has virtualApplications parameter" {

            $json.parameters.virtualApplications | should not be $null
        }

        It "virtualApplications parameter is of type array" {

            $json.parameters.virtualApplications.type | should be "array"
        }

        It "virtualApplications parameter default value is has count 1" {

            $json.parameters.virtualApplications.defaultValue.Count | should be 1
        }

        It "virtualApplications parameter default value virtualPath is '/'" {

            $json.parameters.virtualApplications.defaultValue[0].virtualPath | should be "/"
        }

        It "virtualApplications parameter default value physical path is site\wwwroot" {

            $json.parameters.virtualApplications.defaultValue[0].physicalPath | should be "site\wwwroot"
        }

        It "virtualApplications parameter default value preLoadEnabled is true" {

            $json.parameters.virtualApplications.defaultValue[0].preloadEnabled | should be $true
        }

        It "virtualApplications parameter default value virtualDirectories is null" {

            $json.parameters.virtualApplications.defaultValue[0].virtualDirectories | should be $null
        }
    }

    Context "loadBalancing Validation" {

        It "Has loadBalancing parameter" {

            $json.parameters.loadBalancing | should not be $null
        }

        It "loadBalancing parameter is of type string" {

            $json.parameters.loadBalancing.type | should be "string"
        }

        It "loadBalancing parameter default value is LeastRequests" {

            $json.parameters.loadBalancing.defaultValue | should be "LeastRequests"
        }

        It "loadBalancing parameter allowed values are 'app', 'functionapp', 'app', 'linux'" {

            (Compare-Object -ReferenceObject $json.parameters.loadBalancing.allowedValues -DifferenceObject @("WeightedRoundRobin", "LeastRequests", "LeastResponseTime", "WeightedTotalTraffic", "RequestHash")).Length | should be 0
        }
    }

    Context "experiments Validation" {

        It "Has experiments parameter" {

            $json.parameters.experiments | should not be $null
        }

        It "experiments parameter is of type object" {

            $json.parameters.experiments.type | should be "object"
        }

        It "experiments parameter default value is an empty object" {

            $json.parameters.experiments.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "siteAuthEnabled Validation" {

        It "Has siteAuthEnabled parameter" {

            $json.parameters.siteAuthEnabled | should not be $null
        }

        It "siteAuthEnabled parameter is of type bool" {

            $json.parameters.siteAuthEnabled.type | should be "bool"
        }

        It "siteAuthEnabled parameter default value is true" {

            $json.parameters.siteAuthEnabled.defaultValue | should be $true
        }
    }

    Context "allowedExternalRedirectUrls Validation" {

        It "Has allowedExternalRedirectUrls parameter" {

            $json.parameters.allowedExternalRedirectUrls | should not be $null
        }

        It "allowedExternalRedirectUrls parameter is of type array" {

            $json.parameters.allowedExternalRedirectUrls.type | should be "array"
        }

        It "allowedExternalRedirectUrls parameter default value is an empty array" {

            $json.parameters.allowedExternalRedirectUrls.defaultValue | should be @()
        }
    }

    Context "defaultProvider Validation" {

        It "Has defaultProvider parameter" {

            $json.parameters.defaultProvider | should not be $null
        }

        It "defaultProvider parameter is of type string" {

            $json.parameters.defaultProvider.type | should be "string"
        }

        It "defaultProvider parameter default value is AzureActiveDirectory" {

            $json.parameters.defaultProvider.defaultValue | should be "AzureActiveDirectory"
        }

        It "defaultProvider parameter allowed values are 'AzureActiveDirectory', 'Facebook', 'Google', 'MicrosoftAccount', 'Twitter'" {

            (Compare-Object -ReferenceObject $json.parameters.defaultProvider.allowedValues -DifferenceObject @("AzureActiveDirectory", "Facebook", "Google", "MicrosoftAccount", "Twitter")).Length | should be 0
        }
    }

    Context "tokenRefreshExtensionHours Validation" {

        It "Has tokenRefreshExtensionHours parameter" {

            $json.parameters.tokenRefreshExtensionHours | should not be $null
        }

        It "tokenRefreshExtensionHours parameter is of type int" {

            $json.parameters.tokenRefreshExtensionHours.type | should be "int"
        }

        It "tokenRefreshExtensionHours parameter default value is an 72" {

            $json.parameters.tokenRefreshExtensionHours.defaultValue | should be 72
        }
    }

    Context "clientId Validation" {

        It "Has clientId parameter" {

            $json.parameters.clientId | should not be $null
        }

        It "clientId parameter is of type string" {

            $json.parameters.clientId.type | should be "string"
        }

        It "clientId parameter default value is an empty string" {

            $json.parameters.clientId.defaultValue | should be ([String]::Empty)
        }
    }

    Context "tenantId Validation" {

        It "Has tenantId parameter" {

            $json.parameters.tenantId | should not be $null
        }

        It "tenantId parameter is of type string" {

            $json.parameters.tenantId.type | should be "string"
        }

        It "tenantId parameter default value is [subscription().tenantId]" {

            $json.parameters.tenantId.defaultValue | should be "[subscription().tenantId]"
        }
    }

    Context "allowedAudiences Validation" {

        It "Has allowedAudiences parameter" {

            $json.parameters.allowedAudiences | should not be $null
        }

        It "allowedAudiences parameter is of type array" {

            $json.parameters.allowedAudiences.type | should be "array"
        }

        It "allowedAudiences parameter default value is an empty array" {

            $json.parameters.allowedAudiences.defaultValue | should be @()
        }
    }

    Context "additionalLoginParams Validation" {

        It "Has additionalLoginParams parameter" {

            $json.parameters.additionalLoginParams | should not be $null
        }

        It "additionalLoginParams parameter is of type array" {

            $json.parameters.additionalLoginParams.type | should be "array"
        }

        It "additionalLoginParams parameter default value is an empty array" {

            $json.parameters.additionalLoginParams.defaultValue | should be @()
        }
    }

    Context "googleClientId Validation" {

        It "Has googleClientId parameter" {

            $json.parameters.googleClientId | should not be $null
        }

        It "googleClientId parameter is of type string" {

            $json.parameters.googleClientId.type | should be "string"
        }

        It "googleClientId parameter default value is an empty string" {

            $json.parameters.googleClientId.defaultValue | should be ([String]::Empty)
        }
    }

    Context "googleClientSecret Validation" {

        It "Has googleClientSecret parameter" {

            $json.parameters.googleClientSecret | should not be $null
        }

        It "googleClientSecret parameter is of type string" {

            $json.parameters.googleClientSecret.type | should be "string"
        }

        It "googleClientSecret parameter default value is an empty string" {

            $json.parameters.googleClientSecret.defaultValue | should be ([String]::Empty)
        }
    }

    Context "facebookAppId Validation" {

        It "Has facebookAppId parameter" {

            $json.parameters.facebookAppId | should not be $null
        }

        It "facebookAppId parameter is of type string" {

            $json.parameters.facebookAppId.type | should be "string"
        }

        It "facebookAppId parameter default value is an empty string" {

            $json.parameters.facebookAppId.defaultValue | should be ([String]::Empty)
        }
    }

    Context "facebookAppSecret Validation" {

        It "Has facebookAppSecret parameter" {

            $json.parameters.facebookAppSecret | should not be $null
        }

        It "facebookAppSecret parameter is of type string" {

            $json.parameters.facebookAppSecret.type | should be "string"
        }

        It "facebookAppSecret parameter default value is an empty string" {

            $json.parameters.facebookAppSecret.defaultValue | should be ([String]::Empty)
        }
    }

    Context "twitterConsumerKey Validation" {

        It "Has twitterConsumerKey parameter" {

            $json.parameters.twitterConsumerKey | should not be $null
        }

        It "twitterConsumerKey parameter is of type string" {

            $json.parameters.twitterConsumerKey.type | should be "string"
        }

        It "twitterConsumerKey parameter default value is an empty string" {

            $json.parameters.twitterConsumerKey.defaultValue | should be ([String]::Empty)
        }
    }

    Context "twitterConsumerSecret Validation" {

        It "Has twitterConsumerSecret parameter" {

            $json.parameters.twitterConsumerSecret | should not be $null
        }

        It "twitterConsumerSecret parameter is of type string" {

            $json.parameters.twitterConsumerSecret.type | should be "string"
        }

        It "twitterConsumerSecret parameter default value is an empty string" {

            $json.parameters.twitterConsumerSecret.defaultValue | should be ([String]::Empty)
        }
    }

    Context "microsoftAccountClientId Validation" {

        It "Has microsoftAccountClientId parameter" {

            $json.parameters.microsoftAccountClientId | should not be $null
        }

        It "microsoftAccountClientId parameter is of type string" {

            $json.parameters.microsoftAccountClientId.type | should be "string"
        }

        It "microsoftAccountClientId parameter default value is an empty string" {

            $json.parameters.microsoftAccountClientId.defaultValue | should be ([String]::Empty)
        }
    }

    Context "microsoftAccountClientSecret Validation" {

        It "Has microsoftAccountClientSecret parameter" {

            $json.parameters.microsoftAccountClientSecret | should not be $null
        }

        It "microsoftAccountClientSecret parameter is of type string" {

            $json.parameters.microsoftAccountClientSecret.type | should be "string"
        }

        It "microsoftAccountClientSecret parameter default value is an empty string" {

            $json.parameters.microsoftAccountClientSecret.defaultValue | should be ([String]::Empty)
        }
    }

    Context "cors Validation" {

        It "Has cors parameter" {

            $json.parameters.cors | should not be $null
        }

        It "cors parameter is of type object" {

            $json.parameters.cors.type | should be "object"
        }

        It "cors parameter default value is an empty object" {

            $json.parameters.cors.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "localMySQLEnabled Validation" {

        It "Has localMySQLEnabled parameter" {

            $json.parameters.localMySQLEnabled | should not be $null
        }

        It "localMySQLEnabled parameter is of type bool" {

            $json.parameters.localMySQLEnabled.type | should be "bool"
        }

        It "localMySQLEnabled parameter default value is false" {

            $json.parameters.localMySQLEnabled.defaultValue | should be $false
        }
    }

    Context "ipSecurityRestrictions Validation" {

        It "Has ipSecurityRestrictions parameter" {

            $json.parameters.ipSecurityRestrictions | should not be $null
        }

        It "ipSecurityRestrictions parameter is of type array" {

            $json.parameters.ipSecurityRestrictions.type | should be "array"
        }

        It "ipSecurityRestrictions parameter default value is an empty array" {

            $json.parameters.ipSecurityRestrictions.defaultValue | should be @()
        }
    }

    Context "scmIpSecurityRestrictions Validation" {

        It "Has scmIpSecurityRestrictions parameter" {

            $json.parameters.scmIpSecurityRestrictions | should not be $null
        }

        It "scmIpSecurityRestrictions parameter is of type array" {

            $json.parameters.scmIpSecurityRestrictions.type | should be "array"
        }

        It "scmIpSecurityRestrictions parameter default value is an empty array" {

            $json.parameters.scmIpSecurityRestrictions.defaultValue | should be @()
        }
    }

    Context "clientAffinityEnabled Validation" {

        It "Has clientAffinityEnabled parameter" {

            $json.parameters.clientAffinityEnabled | should not be $null
        }

        It "clientAffinityEnabled parameter is of type bool" {

            $json.parameters.clientAffinityEnabled.type | should be "bool"
        }

        It "clientAffinityEnabled parameter default value is true" {

            $json.parameters.clientAffinityEnabled.defaultValue | should be $true
        }
    }

    Context "clientCertEnabled Validation" {

        It "Has clientCertEnabled parameter" {

            $json.parameters.clientCertEnabled | should not be $null
        }

        It "clientCertEnabled parameter is of type bool" {

            $json.parameters.clientCertEnabled.type | should be "bool"
        }

        It "clientCertEnabled parameter default value is true" {

            $json.parameters.clientCertEnabled.defaultValue | should be $true
        }
    }

    Context "clientCertExclusionPaths Validation" {

        It "Has clientCertExclusionPaths parameter" {

            $json.parameters.clientCertExclusionPaths | should not be $null
        }

        It "clientCertExclusionPaths parameter is of type string" {

            $json.parameters.clientCertExclusionPaths.type | should be "string"
        }

        It "clientCertExclusionPaths parameter default value is an empty string" {

            $json.parameters.clientCertExclusionPaths.defaultValue | should be ([String]::Empty)
        }
    }

    Context "hostNamesDisabled Validation" {

        It "Has hostNamesDisabled parameter" {

            $json.parameters.hostNamesDisabled | should not be $null
        }

        It "hostNamesDisabled parameter is of type bool" {

            $json.parameters.hostNamesDisabled.type | should be "bool"
        }

        It "hostNamesDisabled parameter default value is true" {

            $json.parameters.hostNamesDisabled.defaultValue | should be $false
        }
    }

    Context "httpsOnly Validation" {

        It "Has httpsOnly parameter" {

            $json.parameters.httpsOnly | should not be $null
        }

        It "httpsOnly parameter is of type bool" {

            $json.parameters.httpsOnly.type | should be "bool"
        }

        It "httpsOnly parameter default value is true" {

            $json.parameters.httpsOnly.defaultValue | should be $true
        }
    }

    Context "tags Validation" {

        It "Has tags parameter" {

            $json.parameters.tags | should not be $null
        }

        It "tags parameter is of type object" {

            $json.parameters.tags.type | should be "object"
        }

        It "tags parameter is mandatory" {

            ($json.parameters.tags.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "App Service Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Web/sites" {

            $json.resources.type | should be "Microsoft.Web/sites"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $json.resources.apiVersion | should be "2018-11-01"
        }
    }

    Context "Site Enabled Validation" {

        It "enabled is true" {

            $json.resources.properties.enabled | should be $true
        }
    }

    Context "Request Tracing Validation" {

        It "requestTracingEnabled is true" {

            $json.resources.properties.siteconfig.requestTracingEnabled | should be $true
        }

        It "requestTracingExpirationTime is 9999-12-31T23:59:00Z" {

            $json.resources.properties.siteconfig.requestTracingExpirationTime | should be "9999-12-31T23:59:00Z"
        }
    }

    Context "Remote Debugging Validation" {

        It "remoteDebuggingEnabled is false" {

            $json.resources.properties.siteconfig.remoteDebuggingEnabled | should be $false
        }
    }

    Context "HTTP Logging Validation" {

        It "httpLoggingEnabled is true" {

            $json.resources.properties.siteconfig.httpLoggingEnabled | should be $true
        }

        It "logsDirectorySizeLimit is 128" {

            $json.resources.properties.siteconfig.logsDirectorySizeLimit | should be 128
        }

        It "detailedErrorLoggingEnabled is true" {

            $json.resources.properties.siteconfig.detailedErrorLoggingEnabled | should be $true
        }
    }

    Context "Web Sockets Enabled Validation" {

        It "webSocketsEnabled is false" {

            $json.resources.properties.siteconfig.webSocketsEnabled | should be $false
        }
    }

    Context "Always On Validation" {

        It "alwaysOn is true" {

            $json.resources.properties.siteconfig.alwaysOn | should be $true
        }
    }

    Context "Pipeline Mode Validation" {

        It "managedPipelineMode is Integrated" {

            $json.resources.properties.siteconfig.managedPipelineMode | should be "Integrated"
        }
    }

    Context "Auto Heal Validation" {

        It "autoHealEnabled is false" {

            $json.resources.properties.siteconfig.autoHealEnabled | should be $false
        }
    }

    Context "Site Authentication Validation" {

        It "unauthenticatedClientAction is RedirectToLoginPage" {

            $json.resources.properties.siteconfig.siteAuthSettings.unauthenticatedClientAction | should be "RedirectToLoginPage"
        }

        It "validateIssuer is true" {

            $json.resources.properties.siteconfig.siteAuthSettings.validateIssuer | should be $true
        }
    }

    Context "HTTP Version Validation" {

        It "http20Enabled is true" {

            $json.resources.properties.siteconfig.http20Enabled | should be $true
        }
    }

    Context "TLS Version Validation" {

        It "minTlsVersion is 1.2" {

            $json.resources.properties.siteconfig.minTlsVersion | should be "1.2"
        }
    }

    Context "FTP Validation" {

        It "ftpsState is FtpsOnly" {

            $json.resources.properties.siteconfig.ftpsState | should be "FtpsOnly"
        }
    }

    Context "SCM Validation" {

        It "scmType is VSTSRM" {

            $json.resources.properties.siteconfig.scmType | should be "VSTSRM"
        }

        It "scmIpSecurityRestrictionsUseMain is false" {

            $json.resources.properties.siteconfig.scmIpSecurityRestrictionsUseMain | should be $false
        }

        It "scmSiteAlsoStopped is false" {

            $json.resources.properties.scmSiteAlsoStopped | should be $false
        }
    }

    Context "Managed Service Identity Validation" {

        It "type is SystemAssigned" {

            $json.resources.identity.type | should be "SystemAssigned"
        }
    }
}
Describe "App Service Output Validation" {

    Context "App Service Plan Reference Validation" {

        It "type value is object" {

            $json.outputs.app.type | should be "object"
        }

        It "Uses full reference for App Service" {

            $json.outputs.app.value | should be "[reference(resourceId('Microsoft.Web/sites', parameters('appName')), '2018-11-01', 'Full')]"
        }
    }
}