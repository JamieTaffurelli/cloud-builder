$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Secret Parameter Validation" {

    Context "secretName Validation" {

        It "Has secretName parameter" {

            $json.parameters.secretName | should not be $null
        }

        It "secretName parameter is of type string" {

            $json.parameters.secretName.type | should be "string"
        }

        It "secretName parameter is mandatory" {

            ($json.parameters.secretName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "secretValue Validation" {

        It "Has secretValue parameter" {

            $json.parameters.secretValue | should not be $null
        }

        It "secretValue parameter is of type securestring" {

            $json.parameters.secretValue.type | should be "securestring"
        }

        It "secretValue parameter is mandatory" {

            ($json.parameters.secretValue.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "enabled Validation" {

        It "Has enabled parameter" {

            $json.parameters.enabled | should not be $null
        }

        It "enabled parameter is of type bool" {

            $json.parameters.enabled.type | should be "bool"
        }

        It "enabled default value is true" {

            ($json.parameters.enabled.defaultValue) | should be $true
        }
    }

    Context "NotBeforeDate Validation" {

        It "Has NotBeforeDate parameter" {

            $json.parameters.NotBeforeDate | should not be $null
        }

        It "NotBeforeDate parameter is of type string" {

            $json.parameters.NotBeforeDate.type | should be "string"
        }

        It "NotBeforeDate default value is an empty string" {

            ($json.parameters.NotBeforeDate.defaultValue) | should be ([String]::Empty)
        }
    }

    Context "ExpiryDate Validation" {

        It "Has ExpiryDate parameter" {

            $json.parameters.ExpiryDate | should not be $null
        }

        It "ExpiryDate parameter is of type string" {

            $json.parameters.ExpiryDate.type | should be "string"
        }

        It "ExpiryDate default value is an empty string" {

            ($json.parameters.ExpiryDate.defaultValue) | should be ([String]::Empty)
        }
    }
}

Describe "Secret Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.KeyVault/vaults/secrets" {

            $json.resources.type | should be "Microsoft.KeyVault/vaults/secrets"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-02-14" {

            $json.resources.apiVersion | should be "2018-02-14"
        }
    }
}

Describe "Secret Output Validation" {

    Context "Secret Reference Validation" {

        It "type value is string" {

            $json.outputs.secretUri.type | should be "string"
        }

        It "Uses full reference for Secret" {

            $json.outputs.secretUri.value | should be "[reference(resourceId('Microsoft.KeyVault/vaults/secrets', parameters('keyVaultName'), parameters('secretName')), '2018-02-14', 'Full').properties.secretUriWithVersion]"
        }
    }
}