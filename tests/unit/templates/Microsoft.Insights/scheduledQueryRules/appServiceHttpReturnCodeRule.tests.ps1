$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "App Service HTTP Return Code Rule Parameter Validation" {

    Context "appServiceName Validation" {

        It "Has appServiceName parameter" {

            $json.parameters.appServiceName | should not be $null
        }

        It "appServiceName parameter is of type string" {

            $json.parameters.appServiceName.type | should be "string"
        }

        It "appServiceName parameter is mandatory" {

            ($json.parameters.appServiceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "failurePercentage Validation" {

        It "Has failurePercentage parameter" {

            $json.parameters.failurePercentage | should not be $null
        }

        It "failurePercentage parameter is of type int" {

            $json.parameters.failurePercentage.type | should be "int"
        }

        It "failurePercentage parameter default value is 0" {

            $json.parameters.failurePercentage.defaultValue | should be 0
        }

        It "failurePercentage parameter minimum value is 0" {

            $json.parameters.failurePercentage.minValue | should be 0
        }

        It "failurePercentage parameter maximum value is 100" {

            $json.parameters.failurePercentage.maxValue | should be 100
        }
    }

    Context "enabled Validation" {

        It "Has enabled parameter" {

            $json.parameters.enabled | should not be $null
        }

        It "enabled parameter is of type string" {

            $json.parameters.enabled.type | should be "string"
        }

        It "enabled parameter default value is true" {

            $json.parameters.enabled.defaultValue | should be "true"
        }
    }

    Context "dataSourceSubscriptionId Validation" {

        It "Has dataSourceSubscriptionId parameter" {

            $json.parameters.dataSourceSubscriptionId | should not be $null
        }

        It "dataSourceSubscriptionId parameter is of type string" {

            $json.parameters.dataSourceSubscriptionId.type | should be "string"
        }

        It "dataSourceSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.dataSourceSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "dataSourceResourceGroupName Validation" {

        It "Has dataSourceResourceGroupName parameter" {

            $json.parameters.dataSourceResourceGroupName | should not be $null
        }

        It "dataSourceResourceGroupName parameter is of type string" {

            $json.parameters.dataSourceResourceGroupName.type | should be "string"
        }

        It "dataSourceResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.dataSourceResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "dataSourceName Validation" {

        It "Has dataSourceName parameter" {

            $json.parameters.dataSourceName | should not be $null
        }

        It "dataSourceName parameter is of type string" {

            $json.parameters.dataSourceName.type | should be "string"
        }

        It "dataSourceName parameter is mandatory" {

            ($json.parameters.dataSourceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "frequencyInMinutes Validation" {

        It "Has frequencyInMinutes parameter" {

            $json.parameters.frequencyInMinutes | should not be $null
        }

        It "frequencyInMinutes parameter is of type int" {

            $json.parameters.frequencyInMinutes.type | should be "int"
        }

        It "frequencyInMinutes parameter default value is 5" {

            $json.parameters.frequencyInMinutes.defaultValue | should be 5
        }
    }

    Context "timeWindowInMinutes Validation" {

        It "Has timeWindowInMinutes parameter" {

            $json.parameters.timeWindowInMinutes | should not be $null
        }

        It "timeWindowInMinutes parameter is of type int" {

            $json.parameters.timeWindowInMinutes.type | should be "int"
        }

        It "timeWindowInMinutes parameter default value is 5" {

            $json.parameters.timeWindowInMinutes.defaultValue | should be 5
        }
    }

    Context "severity Validation" {

        It "Has severity parameter" {

            $json.parameters.severity | should not be $null
        }

        It "severity parameter is of type int" {

            $json.parameters.severity.type | should be "int"
        }

        It "severity parameter is mandatory" {

            ($json.parameters.severity.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "severity parameter allowed values are web and other" {

            (Compare-Object -ReferenceObject $json.parameters.severity.allowedValues -DifferenceObject @(0, 1, 2, 3 , 4)).Length | should be 0
        }
    }

    Context "aznsAction Validation" {

        It "Has aznsAction parameter" {

            $json.parameters.aznsAction | should not be $null
        }

        It "aznsAction parameter is of type object" {

            $json.parameters.aznsAction.type | should be "object"
        }

        It "aznsAction parameter is mandatory" {

            ($json.parameters.aznsAction.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "App Service HTTP Return Code Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/scheduledQueryRules" {

            $json.resources.type | should be "Microsoft.Insights/scheduledQueryRules"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-04-16" {

            $json.resources.apiVersion | should be "2018-04-16"
        }
    }

    Context "source Validation" {

        It "queryType is ResultCount" {

            $json.resources.properties.source.queryType | should be "ResultCount"
        }
    }
}

Describe "App Service HTTP Return Code Output Validation" {

    Context "App Service HTTP Return Code Reference Validation" {

        It "type value is object" {

            $json.outputs.scheduledQueryRule.type | should be "object"
        }

        It "Uses full reference for Scheduled Query Rule" {

            $json.outputs.scheduledQueryRule.value | should be "[reference(resourceId('Microsoft.Insights/scheduledQueryRules', variables('queryName')), '2018-04-16', 'Full')]"
        }
    }
}