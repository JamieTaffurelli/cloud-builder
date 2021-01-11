$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Web Test Parameter Validation" {

    Context "webTestName Validation" {

        It "Has webTestName parameter" {

            $json.parameters.webTestName | should not be $null
        }

        It "webTestName parameter is of type string" {

            $json.parameters.webTestName.type | should be "string"
        }

        It "webTestName parameter is mandatory" {

            ($json.parameters.webTestName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "appInsightsSubscriptionId Validation" {

        It "Has appInsightsSubscriptionId parameter" {

            $json.parameters.appInsightsSubscriptionId | should not be $null
        }

        It "appInsightsSubscriptionId parameter is of type string" {

            $json.parameters.appInsightsSubscriptionId.type | should be "string"
        }

        It "appInsightsSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appInsightsSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appInsightsResourceGroupName Validation" {

        It "Has appInsightsResourceGroupName parameter" {

            $json.parameters.appInsightsResourceGroupName | should not be $null
        }

        It "appInsightsResourceGroupName parameter is of type string" {

            $json.parameters.appInsightsResourceGroupName.type | should be "string"
        }

        It "appInsightsResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appInsightsResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "appInsightsName Validation" {

        It "Has appInsightsName parameter" {

            $json.parameters.appInsightsName | should not be $null
        }

        It "appInsightsName parameter is of type string" {

            $json.parameters.appInsightsName.type | should be "string"
        }

        It "appInsightsName parameter is mandatory" {

            ($json.parameters.appInsightsName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

        It "kind parameter default value is ping" {

            $json.parameters.kind.defaultValue | should be "ping"
        }

        It "kind parameter allowed values are ping, multistep" {

            (Compare-Object -ReferenceObject $json.parameters.kind.allowedValues -DifferenceObject @("ping", "multistep")).Length | should be 0
        }
    }

    Context "description Validation" {

        It "Has description parameter" {

            $json.parameters.description | should not be $null
        }

        It "description parameter is of type string" {

            $json.parameters.description.type | should be "string"
        }

        It "description parameter is mandatory" {

            ($json.parameters.description.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "enabled Validation" {

        It "Has enabled parameter" {

            $json.parameters.enabled | should not be $null
        }

        It "enabled parameter is of type bool" {

            $json.parameters.enabled.type | should be "bool"
        }

        It "enabled parameter default value is true" {

            $json.parameters.enabled.defaultValue | should be $true
        }
    }

    Context "frequency Validation" {

        It "Has frequency parameter" {

            $json.parameters.frequency | should not be $null
        }

        It "frequency parameter is of type int" {

            $json.parameters.frequency.type | should be "int"
        }

        It "frequency parameter default value is 300" {

            $json.parameters.frequency.defaultValue | should be 300
        }
    }

    Context "timeout Validation" {

        It "Has timeout parameter" {

            $json.parameters.timeout | should not be $null
        }

        It "timeout parameter is of type int" {

            $json.parameters.timeout.type | should be "int"
        }

        It "timeout parameter default value is 30" {

            $json.parameters.timeout.defaultValue | should be 30
        }
    }

    Context "retryEnabled Validation" {

        It "Has retryEnabled parameter" {

            $json.parameters.retryEnabled | should not be $null
        }

        It "retryEnabled parameter is of type bool" {

            $json.parameters.retryEnabled.type | should be "bool"
        }

        It "retryEnabled parameter default value is true" {

            $json.parameters.retryEnabled.defaultValue | should be $true
        }
    }

    Context "locationIds Validation" {

        It "Has locationIds parameter" {

            $json.parameters.locationIds | should not be $null
        }

        It "locationIds parameter is of type array" {

            $json.parameters.locationIds.type | should be "array"
        }

        It "locationIds parameter default value is emea-nl-ams-azr, emea-ru-msa-edge, emea-se-sto-edge, emea-gb-db3-azr, us-va-ash-azr" {

            (Compare-Object -ReferenceObject $json.parameters.locationIds.defaultValue -DifferenceObject @("emea-nl-ams-azr", "emea-ru-msa-edge", "emea-se-sto-edge", "emea-gb-db3-azr", "us-va-ash-azr")).Length | should be 0
        }
    }

    Context "webTest Validation" {

        It "Has webTest parameter" {

            $json.parameters.webTest | should not be $null
        }

        It "webTest parameter is of type string" {

            $json.parameters.webTest.type | should be "string"
        }

        It "webTest parameter is mandatory" {

            ($json.parameters.webTest.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Web Test Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/webTests" {

            $json.resources.type | should be "Microsoft.Insights/webTests"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-05-01" {

            $json.resources.apiVersion | should be "2015-05-01"
        }
    }
}

Describe "Web Test Output Validation" {

    Context "Web Test Reference Validation" {

        It "type value is object" {

            $json.outputs.webTest.type | should be "object"
        }

        It "Uses full reference for Web Test" {

            $json.outputs.webTest.value | should be "[reference(resourceId('Microsoft.Insights/webTests', parameters('webTestName')), '2015-05-01', 'Full')]"
        }
    }
}