$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Containers Parameter Validation" {

    Context "containerName Validation" {

        It "Has containerName parameter" {

            $json.parameters.storageAccountName | should not be $null
        }

        It "containerName parameter is of type string" {

            $json.parameters.containerName.type | should be "string"
        }

        It "containerName parameter is mandatory" {

            ($json.parameters.containerName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "containerName parameter minimum length is 3" {

            $json.parameters.containerName.minLength | should be 3
        }

        It "containerName parameter maximum length is 63" {

            $json.parameters.containerName.maxLength | should be 63
        }
    }

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
}

Describe "Container Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Storage/storageAccounts/blobServices/containers" {

            $json.resources.type | should be "Microsoft.Storage/storageAccounts/blobServices/containers"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $json.resources.apiVersion | should be "2019-04-01"
        }
    }

    Context "publicAccess Validation" {

        It "publicAccess is not enabled" {

            $json.resources.properties.publicAccess | should be "None"
        }
    }
}