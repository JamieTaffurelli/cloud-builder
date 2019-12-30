$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Immutability Policy Parameter Validation" {

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

    Context "immutabilityPeriodSinceCreationInDays Validation" {

        It "Has immutabilityPeriodSinceCreationInDays parameter" {

            $json.parameters.immutabilityPeriodSinceCreationInDays | should not be $null
        }

        It "immutabilityPeriodSinceCreationInDays parameter is of type int" {

            $json.parameters.immutabilityPeriodSinceCreationInDays.type | should be "int"
        }

        It "immutabilityPeriodSinceCreationInDays parameter default value is 146000" {

            $json.parameters.immutabilityPeriodSinceCreationInDays.defaultValue | should be 146000
        }

        It "immutabilityPeriodSinceCreationInDays parameter minimum value is 1" {

            $json.parameters.immutabilityPeriodSinceCreationInDays.minValue | should be 1
        }

        It "immutabilityPeriodSinceCreationInDays parameter maximum length is 146000" {

            $json.parameters.immutabilityPeriodSinceCreationInDays.maxValue | should be 146000
        }
    }
}

Describe "Immutability Policy Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies" {

            $json.resources.type | should be "Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $json.resources.apiVersion | should be "2019-04-01"
        }
    }
}