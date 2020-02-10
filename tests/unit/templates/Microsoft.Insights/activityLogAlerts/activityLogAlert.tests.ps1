$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Activity Log Alert Parameter Validation" {

    Context "activityLogAlertName Validation" {

        It "Has activityLogAlertName parameter" {

            $json.parameters.activityLogAlertName | should not be $null
        }

        It "activityLogAlertName parameter is of type string" {

            $json.parameters.activityLogAlertName.type | should be "string"
        }

        It "activityLogAlertName parameter is mandatory" {

            ($json.parameters.activityLogAlertName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "actions Validation" {

        It "Has actions parameter" {

            $json.parameters.actions | should not be $null
        }

        It "actions parameter is of type object" {

            $json.parameters.actions.type | should be "object"
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

Describe "Activity Log Alert Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/activityLogAlerts" {

            $json.resources.type | should be "Microsoft.Insights/activityLogAlerts"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2017-04-01" {

            $json.resources.apiVersion | should be "2017-04-01"
        }
    }

    Context "location Validation" {

        It "location value is global" {

            $json.resources.location | should be "global"
        }
    }
}

Describe "Activity Log Alert Output Validation" {

    Context "Activity Log Alert Reference Validation" {

        It "type value is object" {

            $json.outputs.metricAlert.type | should be "object"
        }

        It "Uses full reference for Activity Log Alert" {

            $json.outputs.metricAlert.value | should be "[reference(resourceId('Microsoft.Insights/activityLogAlerts', parameters('activityLogAlertName')), '2017-04-01', 'Full')]"
        }
    }
}