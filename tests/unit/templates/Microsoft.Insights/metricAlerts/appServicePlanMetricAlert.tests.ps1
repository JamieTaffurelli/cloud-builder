$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "App Service Plan Metric Alert Parameter Validation" {

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

    Context "appServicePlanRegion Validation" {

        It "Has appServicePlanRegion parameter" {

            $json.parameters.appServicePlanRegion | should not be $null
        }

        It "appServicePlanRegion parameter is of type string" {

            $json.parameters.appServicePlanRegion.type | should be "string"
        }

        It "appServicePlanRegion parameter default value is [resourceGroup().location]" {

            $json.parameters.appServicePlanRegion.defaultValue | should be "[resourceGroup().location]"
        }
    }

    Context "cpuThreshold Validation" {

        It "Has cpuThreshold parameter" {

            $json.parameters.cpuThreshold | should not be $null
        }

        It "cpuThreshold parameter is of type string" {

            $json.parameters.cpuThreshold.type | should be "string"
        }

        It "cpuThreshold parameter default value is 3" {

            $json.parameters.cpuThreshold.defaultValue | should be "70"
        }
    }

    Context "memoryThreshold Validation" {

        It "Has memoryThreshold parameter" {

            $json.parameters.memoryThreshold | should not be $null
        }

        It "memoryThreshold parameter is of type string" {

            $json.parameters.memoryThreshold.type | should be "string"
        }

        It "memoryThreshold parameter default value is 3" {

            $json.parameters.memoryThreshold.defaultValue | should be "70"
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

Describe "App Service Plan Metric Alert Resource Validation" {

    $cpuAlert = $json.resources | Where-Object { $PSItem.properties.criteria.allof.metricName -eq "CpuPercentage" }
    $memoryAlert = $json.resources | Where-Object { $PSItem.properties.criteria.allof.metricName -eq "MemoryPercentage" }
    
    Context "type Validation" {

        It "CPU alert type value is Microsoft.Insights/metricAlerts" {

            $cpuAlert.type | should be "Microsoft.Insights/metricAlerts"
        }

        It "Memory alert type value is Microsoft.Insights/metricAlerts" {

            $memoryAlert.type | should be "Microsoft.Insights/metricAlerts"
        }
    }

    Context "apiVersion Validation" {

        It "CPU alert apiVersion value is 2018-03-01" {

            $cpuAlert.apiVersion | should be "2018-03-01"
        }

        It "Memory alert apiVersion value is 2018-03-01" {

            $memoryAlert.apiVersion | should be "2018-03-01"
        }
    }

    Context "location Validation" {

        It "CPU alert location value is global" {

            $cpuAlert.location | should be "global"
        }

        It "Memory alert location value is global" {

            $memoryAlert.location | should be "global"
        }
    }

    Context "metricName Validation" {

        It "CPU alert metricName value is CpuPercentage" {

            $cpuAlert.properties.criteria.allof.metricName | should be "CpuPercentage"
        }

        It "Memory alert metricName value is MemoryPercentage" {

            $memoryAlert.properties.criteria.allof.metricName | should be "MemoryPercentage"
        }
    }

    Context "operator Validation" {

        It "CPU alert operator value is GreaterThan" {

            $cpuAlert.properties.criteria.allof.operator | should be "GreaterThan"
        }

        It "Memory alert operator value is GreaterThan" {

            $memoryAlert.properties.criteria.allof.operator | should be "GreaterThan"
        }
    }

    Context "timeAggregation Validation" {

        It "CPU alert timeAggregation value is Total" {

            $cpuAlert.properties.criteria.allof.timeAggregation | should be "Average"
        }

        It "Memory alert timeAggregation value is Total" {

            $memoryAlert.properties.criteria.allof.timeAggregation | should be "Average"
        }
    }
}

Describe "Metric Alert Output Validation" {

    $cpuAlert = $json.outputs.cpuMetricAlert 
    $memoryAlert = $json.outputs.memoryMetricAlert

    Context "CPU Metric Alert Reference Validation" {

        It "type value is object" {

            $cpuAlert.type | should be "object"
        }

        It "Uses full reference for Metric Alert" {

            $cpuAlert.value | should be "[reference(resourceId('Microsoft.Insights/metricAlerts', variables('cpuMetricAlertName')), '2018-03-01', 'Full')]"
        }
    }

    Context "Memory Metric Alert Reference Validation" {

        It "type value is object" {

            $memoryAlert.type | should be "object"
        }

        It "Uses full reference for Metric Alert" {

            $memoryAlert.value | should be "[reference(resourceId('Microsoft.Insights/metricAlerts', variables('memoryMetricAlertName')), '2018-03-01', 'Full')]"
        }
    }
}