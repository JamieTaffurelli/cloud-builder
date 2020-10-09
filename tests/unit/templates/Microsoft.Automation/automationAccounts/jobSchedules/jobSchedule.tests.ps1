$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Job Schedule Parameter Validation" {

    Context "scheduleName Validation" {

        It "Has scheduleName parameter" {

            $json.parameters.scheduleName | should not be $null
        }

        It "scheduleName parameter is of type string" {

            $json.parameters.scheduleName.type | should be "string"
        }

        It "scheduleName parameter is mandatory" {

            ($json.parameters.scheduleName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "runbookName Validation" {

        It "Has runbookName parameter" {

            $json.parameters.runbookName | should not be $null
        }

        It "runbookName parameter is of type string" {

            $json.parameters.runbookName.type | should be "string"
        }

        It "runbookName parameter is mandatory" {

            ($json.parameters.runbookName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "automationAccountName Validation" {

        It "Has automationAccountName parameter" {

            $json.parameters.automationAccountName | should not be $null
        }

        It "automationAccountName parameter is of type string" {

            $json.parameters.automationAccountName.type | should be "string"
        }

        It "automationAccountName parameter is mandatory" {

            ($json.parameters.automationAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }


    Context "parameters Validation" {

        It "Has parameters parameter" {

            $json.parameters.parameters | should not be $null
        }

        It "parameters parameter is of type secureObject" {

            $json.parameters.parameters.type | should be "secureObject"
        }

        It "parameters parameter default value is an empty object" {

            $json.parameters.parameters.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "runOn Validation" {

        It "Has runOn parameter" {

            $json.parameters.runOn | should not be $null
        }

        It "runOn parameter is of type string" {

            $json.parameters.runOn.type | should be "string"
        }

        It "runOn parameter default value is an empty string" {

            $json.parameters.runOn.defaultValue | should be ([string]::Empty)
        }
    }
}

Describe "Automation Account Job Schedule Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/jobSchedules" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/jobSchedules"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-10-31" {

            $json.resources.apiVersion | should be "2015-10-31"
        }
    }
}

Describe "Automation Account Job Schedule Output Validation" {

    Context "Automation Account Job Schedule Reference Validation" {

        It "type value is object" {

            $json.outputs.jobSchedule.type | should be "object"
        }

        It "Uses full reference for Automation Account Job Schedule" {

            $json.outputs.jobSchedule.value | should be "[reference(resourceId('Microsoft.Automation/automationAccounts/jobs', parameters('automationAccountName'), guid(concat(parameters('runbookName'), '-', parameters('scheduleName')))), '2015-10-31', 'Full')]"
        }
    }
}