$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Storage Account Parameter Validation" {

    Context "storageAccountName Validation" {

        It "Has storageAccountName parameter" {

            $json.parameters.storageAccountName | should not be $null
        }

        It "storageAccountName parameter is of type string" {

            $json.parameters.storageAccountName.type | should be "string"
        }

        It "storageAccountName parameter is mandatory" {

            ($json.parameters.storageAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "storageAccountName parameter minimum length is 3" {

            $json.parameters.storageAccountName.minLength | should be 3
        }

        It "storageAccountName parameter maximum length is 24" {

            $json.parameters.storageAccountName.maxLength | should be 24
        }
    }

    Context "rules Validation" {

        It "Has rules parameter" {

            $json.parameters.rules | should not be $null
        }

        It "rules parameter is of type array" {

            $json.parameters.rules.type | should be "array"
        }

        It "rules parameter is mandatory" {

            ($json.parameters.rules.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "Storage Account Resource Validation" {

    $managementPolicies = $json.resources 

    Context "type Validation" {

        It "type value is Microsoft.Storage/storageAccounts/managementPolicies" {

            $managementPolicies.type | should be "Microsoft.Storage/storageAccounts/managementPolicies"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-06-01" {

            $managementPolicies.apiVersion | should be "2019-06-01"
        }
    }
}