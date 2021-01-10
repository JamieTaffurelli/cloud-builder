$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Job Parameter Validation" {


    Context "jobName Validation" {

        It "Has runboojobNamekName parameter" {

            $json.parameters.jobName | should not be $null
        }

        It "jobName parameter is of type string" {

            $json.parameters.jobName.type | should be "string"
        }

        It "jobName parameter is mandatory" {

            ($json.parameters.jobName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Automation Account Job Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/jobs" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/jobs"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2017-05-15-preview" {

            $json.resources.apiVersion | should be "2017-05-15-preview"
        }
    }
}

Describe "Automation Account Job Output Validation" {

    Context "Automation Account Job Reference Validation" {

        It "type value is object" {

            $json.outputs.job.type | should be "object"
        }

        It "Uses full reference for Automation Account Job" {

            $json.outputs.job.value | should be "[reference(resourceId('Microsoft.Automation/automationAccounts/jobs', parameters('automationAccountName'), parameters('jobName')), '2017-05-15-preview', 'Full')]"
        }
    }
}