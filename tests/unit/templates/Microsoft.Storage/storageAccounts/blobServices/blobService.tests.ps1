$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Blob Services Parameter Validation" {

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

    Context "corsRules Validation" {

        It "Has corsRules parameter" {

            $json.parameters.corsRules | should not be $null
        }

        It "corsRules parameter is of type array" {

            $json.parameters.corsRules.type | should be "array"
        }

        It "corsRules parameter default value is an empty array" {

            $json.parameters.corsRules.defaultValue.Count | should be 0
        }
    }

    Context "retentionDays Validation" {

        It "Has retentionDays parameter" {

            $json.parameters.retentionDays | should not be $null
        }

        It "retentionDays parameter is of type int" {

            $json.parameters.retentionDays.type | should be "int"
        }

        It "retentionDays parameter default value is 365" {

            $json.parameters.retentionDays.defaultValue | should be 365
        }

        It "retentionDays parameter minimum value is 1" {

            $json.parameters.retentionDays.minValue | should be 1
        }

        It "retentionDays parameter maximum value is 365" {

            $json.parameters.retentionDays.maxValue | should be 365
        }
    }

    Context "automaticSnapshotEnabled Validation" {

        It "Has automaticSnapshotEnabled parameter" {

            $json.parameters.automaticSnapshotEnabled | should not be $null
        }

        It "automaticSnapshotEnabled parameter is of type bool" {

            $json.parameters.automaticSnapshotEnabled.type | should be "bool"
        }

        It "automaticSnapshotEnabled parameter default value is true" {

            $json.parameters.automaticSnapshotEnabled.defaultValue | should be $true
        }
    }
}

Describe "Blob Service Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Storage/storageAccounts/blobServices" {

            $json.resources.type | should be "Microsoft.Storage/storageAccounts/blobServices"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $json.resources.apiVersion | should be "2019-04-01"
        }
    }

    Context "deleteRetentionPolicy Validation" {

        It "deleteRetentionPolicy is always enabled" {

            $json.resources.properties.deleteRetentionPolicy.enabled | should be $true
        }
    }
}