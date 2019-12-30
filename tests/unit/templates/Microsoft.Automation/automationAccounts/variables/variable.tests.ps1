$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Variable Parameter Validation" {

    Context "variableName Validation" {

        It "Has variableName parameter" {

            $json.parameters.variableName | should not be $null
        }

        It "variableName parameter is of type string" {

            $json.parameters.variableName.type | should be "string"
        }

        It "variableName parameter is mandatory" {

            ($json.parameters.variableName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "value Validation" {

        It "Has value parameter" {

            $json.parameters.value | should not be $null
        }

        It "value parameter is of type securestring" {

            $json.parameters.value.type | should be "securestring"
        }

        It "value parameter is mandatory" {

            ($json.parameters.value.PSObject.Properties.Name -contains "defaultValue") | should be $false
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
}

Describe "Automation Account Variable Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/variables" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/variables"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-10-31" {

            $json.resources.apiVersion | should be "2015-10-31"
        }
    }

    Context "Encryption Validation" {

        It "isEncrypted is true" {

            $json.resources.properties.isEncrypted | should be $true
        }
    }
}