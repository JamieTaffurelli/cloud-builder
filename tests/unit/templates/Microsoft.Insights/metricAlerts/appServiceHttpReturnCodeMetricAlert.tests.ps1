$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "App Service HTTP Return Code Metric Alert Parameter Validation" {

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

    Context "appServiceSubscriptionId Validation" {

        It "Has appServiceSubscriptionId parameter" {

            $json.parameters.appServiceSubscriptionId | should not be $null
        }

        It "appServiceSubscriptionId parameter is of type string" {

            $json.parameters.appServiceSubscriptionId.type | should be "string"
        }

        It "appServiceSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appServiceSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appServiceResourceGroupName Validation" {

        It "Has appServiceResourceGroupName parameter" {

            $json.parameters.appServiceResourceGroupName | should not be $null
        }

        It "appServiceResourceGroupName parameter is of type string" {

            $json.parameters.appServiceResourceGroupName.type | should be "string"
        }

        It "appServiceResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appServiceResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

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

    Context "appServiceRegion Validation" {

        It "Has appServiceRegion parameter" {

            $json.parameters.appServiceRegion | should not be $null
        }

        It "appServiceRegion parameter is of type string" {

            $json.parameters.appServiceRegion.type | should be "string"
        }

        It "appServiceRegion parameter default value is [resourceGroup().location]" {

            $json.parameters.appServiceRegion.defaultValue | should be "[resourceGroup().location]"
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

Describe "App Service HTTP Return Code Metric Alert Resource Validation" {

    $4xxAlert = $json.resources | Where-Object { $PSItem.properties.criteria.allof.metricName -eq "Http4xx" }
    $5xxAlert = $json.resources | Where-Object { $PSItem.properties.criteria.allof.metricName -eq "Http5xx" }
    
    Context "type Validation" {

        It "4xx alert type value is Microsoft.Insights/metricAlerts" {

            $4xxAlert.type | should be "Microsoft.Insights/metricAlerts"
        }

        It "5xx alert type value is Microsoft.Insights/metricAlerts" {

            $5xxAlert.type | should be "Microsoft.Insights/metricAlerts"
        }
    }

    Context "apiVersion Validation" {

        It "4xx alert apiVersion value is 2018-03-01" {

            $4xxAlert.apiVersion | should be "2018-03-01"
        }

        It "5xx alert apiVersion value is 2018-03-01" {

            $5xxAlert.apiVersion | should be "2018-03-01"
        }
    }

    Context "location Validation" {

        It "4xx alert location value is global" {

            $4xxAlert.location | should be "global"
        }

        It "5xx alert location value is global" {

            $5xxAlert.location | should be "global"
        }
    }

    Context "metricName Validation" {

        It "4xx alert metricName value is Http4xx" {

            $4xxAlert.properties.criteria.allof.metricName | should be "Http4xx"
        }

        It "5xx alert metricName value is Http5xx" {

            $5xxAlert.properties.criteria.allof.metricName | should be "Http5xx"
        }
    }

    Context "operator Validation" {

        It "4xx alert operator value is GreaterThan" {

            $4xxAlert.properties.criteria.allof.operator | should be "GreaterThan"
        }

        It "5xx alert operator value is GreaterThan" {

            $5xxAlert.properties.criteria.allof.operator | should be "GreaterThan"
        }
    }

    Context "timeAggregation Validation" {

        It "4xx alert timeAggregation value is Total" {

            $4xxAlert.properties.criteria.allof.timeAggregation | should be "Total"
        }

        It "5xx alert timeAggregation value is Total" {

            $5xxAlert.properties.criteria.allof.timeAggregation | should be "Total"
        }
    }
}

Describe "Metric Alert Output Validation" {

    $4xxAlert = $json.outputs."4xxMetricAlert" 
    $5xxAlert = $json.outputs."5xxMetricAlert"

    Context "4xx Metric Alert Reference Validation" {

        It "type value is object" {

            $4xxAlert.type | should be "object"
        }

        It "Uses full reference for Metric Alert" {

            $4xxAlert.value | should be "[reference(resourceId('Microsoft.Insights/metricAlerts', variables('appService4xxAlertName')), '2018-03-01', 'Full')]"
        }
    }

    Context "5xx Metric Alert Reference Validation" {

        It "type value is object" {

            $5xxAlert.type | should be "object"
        }

        It "Uses full reference for Metric Alert" {

            $5xxAlert.value | should be "[reference(resourceId('Microsoft.Insights/metricAlerts', variables('appService5xxAlertName')), '2018-03-01', 'Full')]"
        }
    }
}