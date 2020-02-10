$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Recovery Services Vault Parameter Validation" {

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

Describe "Recovery Services Vault Resource Validation" {

    $rsv = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.RecoveryServices/vaults" }
    $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.RecoveryServices/vaults" {

            $rsv.type | should be "Microsoft.RecoveryServices/vaults"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-01-10" {

            $rsv.apiVersion | should be "2018-01-10"
        }
    }

    Context "Diagnostic Settings Validation" {

        It "type value is /providers/diagnosticSettings" {

            $diagnostics.type | should be "/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $diagnostics.apiVersion | should be "2015-07-01"
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("AzureBackupReport", "CoreAzureBackup", "AddonAzureBackupJobs", "AddonAzureBackupAlerts", "AddonAzureBackupPolicy", "AddonAzureBackupStorage", "AddonAzureBackupProtectedInstance", "AzureSiteRecoveryJobs", "AzureSiteRecoveryEvents", "AzureSiteRecoveryReplicatedItems", "AzureSiteRecoveryReplicationStats", "AzureSiteRecoveryRecoveryPoints", "AzureSiteRecoveryReplicationDataUploadRate", "AzureSiteRecoveryProtectedDiskDataChurn")).Length | should be 0
        }
    }
}
Describe "Recovery Services Vault Output Validation" {

    Context "Recovery Services Vault Reference Validation" {

        It "type value is object" {

            $json.outputs.vault.type | should be "object"
        }

        It "Uses full reference for Recovery Services Vault" {

            $json.outputs.vault.value | should be "[reference(resourceId('Microsoft.RecoveryServices/vaults', parameters('vaultName')), '2018-01-10', 'Full')]"
        }
    }
}