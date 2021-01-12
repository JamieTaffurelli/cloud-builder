$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
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

    Context "skuName Validation" {

        It "Has skuName parameter" {

            $json.parameters.skuName | should not be $null
        }

        It "skuName parameter is of type string" {

            $json.parameters.skuName.type | should be "string"
        }

        It "skuName parameter default value is Standard_LRS" {

            $json.parameters.skuName.defaultValue | should be "Standard_LRS"
        }

        It "skuName parameter allowed values are Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS" {

            (Compare-Object -ReferenceObject $json.parameters.skuName.allowedValues -DifferenceObject @("Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS", "Premium_ZRS")).Length | should be 0
        }
    }

    Context "customDomainName Validation" {

        It "Has customDomainName parameter" {

            $json.parameters.customDomainName | should not be $null
        }

        It "customDomainName parameter is of type string" {

            $json.parameters.customDomainName.type | should be "string"
        }

        It "customDomainName parameter default value is an empty string" {

            $json.parameters.customDomainName.defaultValue | should be ([String]::Empty)
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

    Context "logAnalyticsSubscriptionId Validation" {

        It "Has logAnalyticsSubscriptionId parameter" {

            $json.parameters.logAnalyticsSubscriptionId | should not be $null
        }

        It "logAnalyticsSubscriptionId parameter is of type string" {

            $json.parameters.logAnalyticsSubscriptionId.type | should be "string"
        }

        It "logAnalyticsSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.logAnalyticsSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "logAnalyticsResourceGroupName Validation" {

        It "Has logAnalyticsResourceGroupName parameter" {

            $json.parameters.logAnalyticsResourceGroupName | should not be $null
        }

        It "logAnalyticsResourceGroupName parameter is of type string" {

            $json.parameters.logAnalyticsResourceGroupName.type | should be "string"
        }

        It "logAnalyticsResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.logAnalyticsResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "logAnalyticsName Validation" {

        It "Has logAnalyticsName parameter" {

            $json.parameters.logAnalyticsName | should not be $null
        }

        It "logAnalyticsName parameter is of type string" {

            $json.parameters.logAnalyticsName.type | should be "string"
        }

        It "logAnalyticsName parameter is mandatory" {

            ($json.parameters.logAnalyticsName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Storage Account Resource Validation" {

    $storageAccount = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Storage/storageAccounts" }
    $blobService = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Storage/storageAccounts/blobServices" }
    $atpSetting = $json.resources.resources | Where-Object { $PSItem.type -eq "providers/advancedThreatProtectionSettings" }
    $diagnosticSetting = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }
    $blobDiagnosticSetting = $json.resources.resources | Where-Object { $PSItem.type -eq "blobServices/providers/diagnosticSettings" }
    $tableDiagnosticSetting = $json.resources.resources | Where-Object { $PSItem.type -eq "tableServices/providers/diagnosticSettings" }
    $fileDiagnosticSetting = $json.resources.resources | Where-Object { $PSItem.type -eq "fileServices/providers/diagnosticSettings" }
    $queueDiagnosticSetting = $json.resources.resources | Where-Object { $PSItem.type -eq "queueServices/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.Storage/storageAccounts" {

            $storageAccount.type | should be "Microsoft.Storage/storageAccounts"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-06-01" {

            $storageAccount.apiVersion | should be "2019-06-01"
        }
    }

    Context "Encryption at rest Validation" {

        It "File encryption is enabled" {

            $storageAccount.properties.encryption.services.file.enabled | should be $true
        }

        It "Blob encryption is enabled" {

            $storageAccount.properties.encryption.services.blob.enabled | should be $true
        }
    }

    Context "Encryption in transit Validation" {

        It "supportsHttpsTrafficOnly is true" {

            $storageAccount.properties.supportsHttpsTrafficOnly | should be $true
        }
    }

    Context "TLS Version Validation" {

        It "minimumTlsVersion is TLS1_2" {

            $storageAccount.properties.minimumTlsVersion | should be "TLS1_2"
        }
    }

    Context "Advanced Threat Protection Validation" {

        It "ATP Resource exists" {

            $atpSetting.type | should be "providers/advancedThreatProtectionSettings"
        }

        It "ATP is enabled" {

            $atpSetting.properties.isEnabled | should be $true
        }
    }

    Context "Diagnostic Settings Validation" {

        It "type value is /providers/diagnosticSettings" {

            $diagnosticSetting.type | should be "/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $diagnosticSetting.apiVersion | should be "2015-07-01"
        }

        It "Metrics category is set to Transaction" {

            $diagnosticSetting.properties.metrics.category | should be "Transaction"
        }
    }

    Context "Blob Diagnostic Settings Validation" {

        It "type value is blobServices/providers/diagnosticSettings" {

            $blobDiagnosticSetting.type | should be "blobServices/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $blobDiagnosticSetting.apiVersion | should be "2015-07-01"
        }

        It "Metrics category is set to Transaction" {

            $blobDiagnosticSetting.properties.metrics.category | should be "Transaction"
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $blobDiagnosticSetting.properties.logs.category -DifferenceObject @("StorageRead", "StorageWrite", "StorageDelete")).Length | should be 0
        }
    }

    Context "Table Diagnostic Settings Validation" {

        It "type value is tableServices/providers/diagnosticSettings" {

            $tableDiagnosticSetting.type | should be "tableServices/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $tableDiagnosticSetting.apiVersion | should be "2015-07-01"
        }

        It "Metrics category is set to Transaction" {

            $tableDiagnosticSetting.properties.metrics.category | should be "Transaction"
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $tableDiagnosticSetting.properties.logs.category -DifferenceObject @("StorageRead", "StorageWrite", "StorageDelete")).Length | should be 0
        }
    }

    Context "File Diagnostic Settings Validation" {

        It "type value is fileServices/providers/diagnosticSettings" {

            $fileDiagnosticSetting.type | should be "fileServices/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $fileDiagnosticSetting.apiVersion | should be "2015-07-01"
        }

        It "Metrics category is set to Transaction" {

            $fileDiagnosticSetting.properties.metrics.category | should be "Transaction"
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $fileDiagnosticSetting.properties.logs.category -DifferenceObject @("StorageRead", "StorageWrite", "StorageDelete")).Length | should be 0
        }
    }

    Context "Queue Diagnostic Settings Validation" {

        It "type value is blobServices/providers/diagnosticSettings" {

            $queueDiagnosticSetting.type | should be "queueServices/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $queueDiagnosticSetting.apiVersion | should be "2015-07-01"
        }

        It "Metrics category is set to Transaction" {

            $queueDiagnosticSetting.properties.metrics.category | should be "Transaction"
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $queueDiagnosticSetting.properties.logs.category -DifferenceObject @("StorageRead", "StorageWrite", "StorageDelete")).Length | should be 0
        }
    }

    Context "blobServices Type Validation" {

        It "type value is Microsoft.Storage/storageAccounts/blobServices" {

            $blobService.type | should be "Microsoft.Storage/storageAccounts/blobServices"
        }
    }

    Context "blobServices apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $blobService.apiVersion | should be "2019-04-01"
        }
    }

    Context "blobServices deleteRetentionPolicy Validation" {

        It "deleteRetentionPolicy is always enabled" {

            $blobService.properties.deleteRetentionPolicy.enabled | should be $true
        }
    }
}