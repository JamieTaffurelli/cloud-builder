$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Credential Parameter Validation" {

    Context "credentialName Validation" {

        It "Has credentialName parameter" {

            $json.parameters.credentialName | should not be $null
        }

        It "credentialName parameter is of type string" {

            $json.parameters.credentialName.type | should be "string"
        }

        It "credentialName parameter is mandatory" {

            ($json.parameters.credentialName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "userName Validation" {

        It "Has userName parameter" {

            $json.parameters.userName | should not be $null
        }

        It "userName parameter is of type securestring" {

            $json.parameters.userName.type | should be "string"
        }

        It "userName parameter is mandatory" {

            ($json.parameters.value.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "password Validation" {

        It "Has password parameter" {

            $json.parameters.password | should not be $null
        }

        It "password parameter is of type securestring" {

            $json.parameters.password.type | should be "securestring"
        }

        It "password parameter is mandatory" {

            ($json.parameters.password.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Automation Account Credential Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/credentials" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/credentials"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-10-31" {

            $json.resources.apiVersion | should be "2015-10-31"
        }
    }
}