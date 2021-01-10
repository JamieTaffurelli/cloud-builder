$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
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

        It "severity parameter allowed values are 0, 1, 2, 3 and 4 " {

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

    Context "scopes Validation" {

        It "Has scopes parameter" {

            $json.parameters.scopes | should not be $null
        }

        It "scopes parameter is of type array" {

            $json.parameters.scopes.type | should be "array"
        }

        It "scopes parameter is mandatory" {

            ($json.parameters.scopes.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "targetResourceType Validation" {

        It "Has targetResourceType parameter" {

            $json.parameters.targetResourceType | should not be $null
        }

        It "targetResourceType parameter is of type string" {

            $json.parameters.targetResourceType.type | should be "string"
        }

        It "targetResourceType parameter is mandatory" {

            ($json.parameters.targetResourceType.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "targetResourceRegion Validation" {

        It "Has targetResourceRegion parameter" {

            $json.parameters.targetResourceType | should not be $null
        }

        It "targetResourceRegion parameter is of type string" {

            $json.parameters.targetResourceRegion.type | should be "string"
        }

        It "targetResourceRegion parameter default value is [resourceGroup().location]" {

            $json.parameters.targetResourceRegion.defaultValue | should be "[resourceGroup().location]"
        }
    }

    Context "type Validation" {

        It "Has type parameter" {

            $json.parameters.type | should not be $null
        }

        It "type parameter is of type string" {

            $json.parameters.type.type | should be "string"
        }

        It "type parameter is mandatory" {

            ($json.parameters.type.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "type parameter allowed values are Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria, Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria" {

            (Compare-Object -ReferenceObject $json.parameters.type.allowedValues -DifferenceObject @("Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria", "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria")).Length | should be 0
        }
    }

    Context "allOf Validation" {

        It "Has allOf parameter" {

            $json.parameters.allOf | should not be $null
        }

        It "allOf parameter is of type array" {

            $json.parameters.allOf.type | should be "array"
        }

        It "allOf parameter is mandatory" {

            ($json.parameters.allOf.PSObject.Properties.Name -contains "defaultValue") | should be $false
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