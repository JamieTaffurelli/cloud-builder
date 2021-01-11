$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Recovery Services Vault Back Up Policy Parameter Validation" {

    Context "backupPolicyName Validation" {

        It "Has backupPolicyName parameter" {

            $json.parameters.backupPolicyName | should not be $null
        }

        It "backupPolicyName parameter is of type string" {

            $json.parameters.backupPolicyName.type | should be "string"
        }

        It "backupPolicyName parameter is mandatory" {

            ($json.parameters.backupPolicyName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vaultName Validation" {

        It "Has vaultName parameter" {

            $json.parameters.vaultName | should not be $null
        }

        It "vaultName parameter is of type string" {

            $json.parameters.vaultName.type | should be "string"
        }

        It "vaultName parameter is mandatory" {

            ($json.parameters.vaultName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "location Validation" {

        It "Has location parameter" {

            $json.parameters.location | should not be $null
        }

        It "location parameter is of type string" {

            $json.parameters.location.type | should be "string"
        }

        It "location parameter default value is [resourceGroup().location]" {

            $json.parameters.location.defaultValue | should be "[resourceGroup().location]"
        }

        It "location parameter allowed values are northeurope, westeurope" {

            (Compare-Object -ReferenceObject $json.parameters.location.allowedValues -DifferenceObject @("northeurope", "westeurope")).Length | should be 0
        }
    }

    Context "properties Validation" {

        It "Has properties parameter" {

            $json.parameters.properties | should not be $null
        }

        It "properties parameter is of type object" {

            $json.parameters.properties.type | should be "object"
        }

        It "properties parameter is mandatory" {

            ($json.parameters.properties.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "tags Validation" {

        It "Has tags parameter" {

            $json.parameters.tags | should not be $null
        }

        It "tags parameter is of type object" {

            $json.parameters.tags.type | should be "object"
        }

        It "tags parameter is mandatory" {

            ($json.parameters.tags.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "Recovery Services Vault Backup Policy Resource Validation" {

    $backupPolicy = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.RecoveryServices/vaults/backupPolicies" }

    Context "type Validation" {

        It "type value is Microsoft.RecoveryServices/vaults/backupPolicies" {

            $backupPolicy.type | should be "Microsoft.RecoveryServices/vaults/backupPolicies"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2016-06-01" {

            $backupPolicy.apiVersion | should be "2016-06-01"
        }
    }
}
Describe "Recovery Services Vault Backup Policy Output Validation" {

    Context "Recovery Services Vault Backup Policy Reference Validation" {

        It "type value is object" {

            $json.outputs.backupPolicy.type | should be "object"
        }

        It "Uses full reference for Recovery Services Vault Backup Policy" {

            $json.outputs.backupPolicy.value | should be "[reference(resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', parameters('vaultName'), parameters('backupPolicyName')), '2016-06-01', 'Full')]"
        }
    }
}