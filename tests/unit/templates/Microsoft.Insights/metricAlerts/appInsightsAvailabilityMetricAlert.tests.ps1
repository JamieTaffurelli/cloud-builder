$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Metric Alert Parameter Validation" {

    Context "metricAlertName Validation" {

        It "Has metricAlertName parameter" {

            $json.parameters.metricAlertName | should not be $null
        }

        It "metricAlertName parameter is of type string" {

            $json.parameters.metricAlertName.type | should be "string"
        }

        It "metricAlertName parameter is mandatory" {

            ($json.parameters.metricAlertName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

        It "severity parameter allowed values are 0, 1, 2, 3 and 4" {

            (Compare-Object -ReferenceObject $json.parameters.severity.allowedValues -DifferenceObject @(0, 1, 2, 3 , 4)).Length | should be 0
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

    Context "webTestSubscriptionId Validation" {

        It "Has webTestSubscriptionId parameter" {

            $json.parameters.webTestSubscriptionId | should not be $null
        }

        It "webTestSubscriptionId parameter is of type string" {

            $json.parameters.webTestSubscriptionId.type | should be "string"
        }

        It "webTestSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.webTestSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "webTestResourceGroupName Validation" {

        It "Has webTestResourceGroupName parameter" {

            $json.parameters.webTestResourceGroupName | should not be $null
        }

        It "webTestResourceGroupName parameter is of type string" {

            $json.parameters.webTestResourceGroupName.type | should be "string"
        }

        It "webTestResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.webTestResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

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

    Context "evaluationFrequency Validation" {

        It "Has evaluationFrequency parameter" {

            $json.parameters.evaluationFrequency | should not be $null
        }

        It "evaluationFrequency parameter is of type string" {

            $json.parameters.evaluationFrequency.type | should be "string"
        }

        It "evaluationFrequency parameter is mandatory" {

            ($json.parameters.evaluationFrequency.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "windowSize Validation" {

        It "Has windowSize parameter" {

            $json.parameters.windowSize | should not be $null
        }

        It "windowSize parameter is of type string" {

            $json.parameters.windowSize.type | should be "string"
        }

        It "windowSize parameter is mandatory" {

            ($json.parameters.windowSize.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "failedLocationCount Validation" {

        It "Has failedLocationCount parameter" {

            $json.parameters.failedLocationCount | should not be $null
        }

        It "failedLocationCount parameter is of type int" {

            $json.parameters.failedLocationCount.type | should be "int"
        }

        It "failedLocationCount parameter is mandatory" {

            ($json.parameters.windowSize.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "autoMitigate Validation" {

        It "Has autoMitigate parameter" {

            $json.parameters.autoMitigate | should not be $null
        }

        It "autoMitigate parameter is of type bool" {

            $json.parameters.autoMitigate.type | should be "bool"
        }

        It "autoMitigate parameter default value is true" {

            $json.parameters.autoMitigate.defaultValue | should be $true
        }
    }

    Context "actions Validation" {

        It "Has actions parameter" {

            $json.parameters.actions | should not be $null
        }

        It "actions parameter is of type array" {

            $json.parameters.actions.type | should be "array"
        }

        It "actions parameter is mandatory" {

            ($json.parameters.actions.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Metric Alert Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/metricAlerts" {

            $json.resources.type | should be "Microsoft.Insights/metricAlerts"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-03-01" {

            $json.resources.apiVersion | should be "2018-03-01"
        }
    }

    Context "location Validation" {

        It "location value is global" {

            $json.resources.location | should be "global"
        }
    }
}

Describe "Metric Alert Output Validation" {

    Context "Metric Alert Reference Validation" {

        It "type value is object" {

            $json.outputs.metricAlert.type | should be "object"
        }

        It "Uses full reference for Metric Alert" {

            $json.outputs.metricAlert.value | should be "[reference(resourceId('Microsoft.Insights/metricAlerts', parameters('metricAlertName')), '2018-03-01', 'Full')]"
        }
    }
}