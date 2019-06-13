$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Access Policies Parameter Validation" {

    Context "accessPoliciesName Validation" {

        It "Has accessPoliciesName parameter" {

            $json.parameters.accessPoliciesName | should not be $null
        }

        It "accessPoliciesName parameter is of type string" {

            $json.parameters.accessPoliciesName.type | should be "string"
        }

        It "accessPoliciesName parameter is mandatory" {

            ($json.parameters.accessPoliciesName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "keyVaultName Validation" {

        It "Has keyVaultName parameter" {

            $json.parameters.keyVaultName | should not be $null
        }

        It "keyVaultName parameter is of type string" {

            $json.parameters.keyVaultName.type | should be "string"
        }

        It "keyVaultName parameter is mandatory" {

            ($json.parameters.keyVaultName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "accessPolicies Validation" {

        It "Has accessPolicies parameter" {

            $json.parameters.accessPolicies | should not be $null
        }

        It "accessPolicies parameter is of type array" {

            $json.parameters.accessPolicies.type | should be "array"
        }

        It "accessPolicies parameter default value is an empty array" {

            $json.parameters.accessPolicies.defaultValue.Count | should be 0
        }
    }
}

Describe "Access Policies Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.KeyVault/vaults/accessPolicies" {

            $json.resources.type | should be "Microsoft.KeyVault/vaults/accessPolicies"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-02-14" {

            $json.resources.apiVersion | should be "2018-02-14"
        }
    }
}