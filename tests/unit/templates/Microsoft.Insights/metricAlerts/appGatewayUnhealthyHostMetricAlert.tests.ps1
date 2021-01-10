$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "App Gateway Unhealthy Host Metric Alert Parameter Validation" {

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

    Context "appGatewaySubscriptionId Validation" {

        It "Has appGatewaySubscriptionId parameter" {

            $json.parameters.appGatewaySubscriptionId | should not be $null
        }

        It "appGatewaySubscriptionId parameter is of type string" {

            $json.parameters.appGatewaySubscriptionId.type | should be "string"
        }

        It "appGatewaySubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appGatewaySubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appGatewayResourceGroupName Validation" {

        It "Has appGatewayResourceGroupName parameter" {

            $json.parameters.appGatewayResourceGroupName | should not be $null
        }

        It "appGatewayResourceGroupName parameter is of type string" {

            $json.parameters.appGatewayResourceGroupName.type | should be "string"
        }

        It "appGatewayResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appGatewayResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "appGatewayName Validation" {

        It "Has appGatewayName parameter" {

            $json.parameters.appGatewayName | should not be $null
        }

        It "appGatewayName parameter is of type string" {

            $json.parameters.appGatewayName.type | should be "string"
        }

        It "appGatewayName parameter is mandatory" {

            ($json.parameters.appGatewayName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "evaluationFrequency Validation" {

        It "Has evaluationFrequency parameter" {

            $json.parameters.evaluationFrequency | should not be $null
        }

        It "evaluationFrequency parameter is of type string" {

            $json.parameters.evaluationFrequency.type | should be "string"
        }

        It "evaluationFrequency parameter default value is PT5M" {

            $json.parameters.evaluationFrequency.defaultValue | should be "PT5M"
        }
    }

    Context "windowSize Validation" {

        It "Has windowSize parameter" {

            $json.parameters.windowSize | should not be $null
        }

        It "windowSize parameter is of type string" {

            $json.parameters.windowSize.type | should be "string"
        }

        It "windowSize parameter default value is PT5M" {

            $json.parameters.windowSize.defaultValue | should be "PT5M"
        }
    }

    Context "appGatewayRegion Validation" {

        It "Has appGatewayRegion parameter" {

            $json.parameters.appGatewayRegion | should not be $null
        }

        It "appGatewayRegion parameter is of type string" {

            $json.parameters.appGatewayRegion.type | should be "string"
        }

        It "appGatewayRegion parameter default value is [resourceGroup().location]" {

            $json.parameters.appGatewayRegion.defaultValue | should be "[resourceGroup().location]"
        }
    }

    Context "threshold Validation" {

        It "Has threshold parameter" {

            $json.parameters.threshold | should not be $null
        }

        It "threshold parameter is of type string" {

            $json.parameters.threshold.type | should be "string"
        }

        It "threshold parameter default value is 0" {

            $json.parameters.threshold.defaultValue | should be "0"
        }
    }

    Context "timeAggregation Validation" {

        It "Has timeAggregation parameter" {

            $json.parameters.timeAggregation | should not be $null
        }

        It "timeAggregation parameter is of type string" {

            $json.parameters.timeAggregation.type | should be "string"
        }

        It "timeAggregation parameter default value is Average" {

            $json.parameters.timeAggregation.defaultValue | should be "Average"
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

Describe "App Gateway Unhealthy Host Metric Alert Resource Validation" {

    $unhealthyHost = $json.resources | Where-Object { $PSItem.properties.criteria.allof.metricName -eq "UnhealthyHostCount" }
    
    Context "type Validation" {

        It "alert type value is Microsoft.Insights/metricAlerts" {

            $unhealthyHost.type | should be "Microsoft.Insights/metricAlerts"
        }
    }

    Context "apiVersion Validation" {

        It "alert apiVersion value is 2018-03-01" {

            $unhealthyHost.apiVersion | should be "2018-03-01"
        }
    }

    Context "location Validation" {

        It "location value is global" {

            $unhealthyHost.location | should be "global"
        }
    }

    Context "metricName Validation" {

        It "metricName value is unhealthyHosts" {

            $unhealthyHost.properties.criteria.allof.metricName | should be "UnhealthyHostCount"
        }
    }

    Context "operator Validation" {

        It "operator value is GreaterThan" {

            $unhealthyHost.properties.criteria.allof.operator | should be "GreaterThan"
        }
    }
}

Describe "Metric Alert Output Validation" {

    $unhealthyHost = $json.outputs.metricAlert

    Context "Unhealthy Host Metric Alert Reference Validation" {

        It "type value is object" {

            $unhealthyHost.type | should be "object"
        }

        It "Uses full reference for Metric Alert" {

            $unhealthyHost.value | should be "[reference(resourceId('Microsoft.Insights/metricAlerts', variables('appGatewayUnheathyHostAlertName')), '2018-03-01', 'Full')]"
        }
    }
}