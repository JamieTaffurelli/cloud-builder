$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Recovery Services Vault Parameter Validation" {

    Context "templateStorageAccountName Validation" {

        It "Has templateStorageAccountName parameter" {

            $json.parameters.templateStorageAccountName | should not be $null
        }

        It "templateStorageAccountName parameter is of type string" {

            $json.parameters.templateStorageAccountName.type | should be "string"
        }

        It "templateStorageAccountName parameter is mandatory" {

            ($json.parameters.templateStorageAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "templatesSas Validation" {

        It "Has templatesSas parameter" {

            $json.parameters.templatesSas | should not be $null
        }

        It "templatesSas parameter is of type string" {

            $json.parameters.templatesSas.type | should be "securestring"
        }

        It "templatesSas parameter is mandatory" {

            ($json.parameters.templatesSas.PSObject.Properties.Name -contains "defaultValue") | should be $false
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
    $backupPolicy = $json.resources | Where-Object { $PSItem.name -like "*iaas-backup*" }
    $alerts = $json.resources | Where-Object { $PSItem.name -like "*recovery-service-alerts*" }

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

    Context "Backup Policy Validation" {

        It "Has a IaaS Backup Policy" {
            $backupPolicy.properties.parameters.properties.value.backupManagementType | should be "AzureIaasVM"
        }

        It "Has 5 day instant recovery" {
            $backupPolicy.properties.parameters.properties.value.instantRpRetentionRangeInDays | should be 5
        }

        It "Has a daily backup" {
            $backupPolicy.properties.parameters.properties.value.schedulePolicy.scheduleRunFrequency | should be "Daily"
        }

        It "Retains daily backups backups for 7 days" {
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.dailySchedule.retentionDuration.count | should be 7
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.dailySchedule.retentionDuration.durationType | should be "Days"
        }

        It "Retains weekly backups backups for 4 weeks" {
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.weeklySchedule.retentionDuration.count | should be 4
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.weeklySchedule.retentionDuration.durationType | should be "Weeks"
        }

        It "Retains monthly backups backups for 12 months" {
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.monthlySchedule.retentionDuration.count | should be 12
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.monthlySchedule.retentionDuration.durationType | should be "Months"
        }

        It "Retains yearly backups backups for 10 years" {
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.yearlySchedule.retentionDuration.count | should be 10
            $backupPolicy.properties.parameters.properties.value.retentionPolicy.yearlySchedule.retentionDuration.durationType | should be "Years"
        }
    }

    Context "Alerts Validation" {

        It "Deploys Alerts" {
            $alerts | should not be $null
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