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

    Context "hostNameSslStates Validation" {

        It "Has hostNameSslStates parameter" {

            $json.parameters.hostNameSslStates | should not be $null
        }

        It "hostNameSslStates parameter is of type array" {

            $json.parameters.hostNameSslStates.type | should be "array"
        }

        It "hostNameSslStates parameter default value is an empty array" {

            $json.parameters.hostNameSslStates.defaultValue | should be @()
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

        It "clientCertExclusionPaths parameter default value is 5" {

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

    Context "SCM Validation" {

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