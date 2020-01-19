$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "App Gateway Total Request Metric Alert Parameter Validation" {

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

    Context "alertSensitivity Validation" {

        It "Has alertSensitivity parameter" {

            $json.parameters.alertSensitivity | should not be $null
        }

        It "alertSensitivity parameter is of type string" {

            $json.parameters.alertSensitivity.type | should be "string"
        }

        It "alertSensitivity parameter default value is High" {

            $json.parameters.alertSensitivity.defaultValue | should be "High"
        }

        It "alertSensitivity parameter allowed values are High, Medium and Low" {

            (Compare-Object -ReferenceObject $json.parameters.alertSensitivity.allowedValues -DifferenceObject @("High", "Medium", "Low")).Length | should be 0
        }
    }

    Context "numberOfEvaluationPeriods Validation" {

        It "Has numberOfEvaluationPeriods parameter" {

            $json.parameters.numberOfEvaluationPeriods | should not be $null
        }

        It "numberOfEvaluationPeriods parameter is of type string" {

            $json.parameters.numberOfEvaluationPeriods.type | should be "string"
        }

        It "numberOfEvaluationPeriods parameter default value is 4" {

            $json.parameters.numberOfEvaluationPeriods.defaultValue | should be "4"
        }
    }

    Context "minFailingPeriodsToAlert Validation" {

        It "Has minFailingPeriodsToAlert parameter" {

            $json.parameters.minFailingPeriodsToAlert | should not be $null
        }

        It "minFailingPeriodsToAlert parameter is of type string" {

            $json.parameters.minFailingPeriodsToAlert.type | should be "string"
        }

        It "minFailingPeriodsToAlert parameter default value is 3" {

            $json.parameters.minFailingPeriodsToAlert.defaultValue | should be "3"
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

Describe "App Gateway Total Request Metric Alert Resource Validation" {

    $totalRequest = $json.resources | Where-Object { $PSItem.properties.criteria.allof.metricName -eq "totalRequests" }
    
    Context "type Validation" {

        It "alert type value is Microsoft.Insights/metricAlerts" {

            $totalRequest.type | should be "Microsoft.Insights/metricAlerts"
        }
    }

    Context "apiVersion Validation" {

        It "alert apiVersion value is 2018-03-01" {

            $totalRequest.apiVersion | should be "2018-03-01"
        }
    }

    Context "location Validation" {

        It "location value is global" {

            $totalRequest.location | should be "global"
        }
    }

    Context "metricName Validation" {

        It "metricName value is TotalRequests" {

            $totalRequest.properties.criteria.allof.metricName | should be "TotalRequests"
        }
    }

    Context "operator Validation" {

        It "operator value is LessThan" {

            $totalRequest.properties.criteria.allof.operator | should be "LessThan"
        }
    }

    Context "timeAggregation Validation" {

        It "timeAggregation value is Total" {

            $totalRequest.properties.criteria.allof.timeAggregation | should be "Total"
        }
    }
}

Describe "Metric Alert Output Validation" {

    $totalRequest = $json.outputs.metricAlert

    Context "Total Request Metric Alert Reference Validation" {

        It "type value is object" {

            $totalRequest.type | should be "object"
        }

        It "Uses full reference for Metric Alert" {

            $totalRequest.value | should be "[reference(resourceId('Microsoft.Insights/metricAlerts', variables('appGatewayTotalRequestAlertName')), '2018-03-01', 'Full')]"
        }
    }
}