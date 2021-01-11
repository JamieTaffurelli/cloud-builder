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

    Context "kind Validation" {

        It "Has kind parameter" {

            $json.parameters.kind | should not be $null
        }

        It "kind parameter is of type string" {

            $json.parameters.kind.type | should be "string"
        }

        It "kind parameter default value is StorageV2" {

            $json.parameters.kind.defaultValue | should be "StorageV2"
        }

        It "kind parameter allowed values are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage" {

            (Compare-Object -ReferenceObject $json.parameters.kind.allowedValues -DifferenceObject @("Storage", "StorageV2", "BlobStorage", "FileStorage", "BlockBlobStorage")).Length | should be 0
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

    Context "bypass Validation" {

        It "Has bypass parameter" {

            $json.parameters.bypass | should not be $null
        }

        It "bypass parameter is of type string" {

            $json.parameters.bypass.type | should be "string"
        }

        It "bypass parameter default value is None" {

            $json.parameters.bypass.defaultValue | should be "None"
        }

        It "bypass parameter allowed values are None, Logging, Metrics, 'Logging, Metrics', 'Logging, AzureServices', 'Metrics, AzureServices', 'Logging, Metrics, AzureServices'" {

            (Compare-Object -ReferenceObject $json.parameters.bypass.allowedValues -DifferenceObject @("None", "Logging", "Metrics", "AzureServices", "Logging, Metrics", "Logging, AzureServices", "Metrics, AzureServices", "Logging, Metrics, AzureServices")).Length | should be 0
        }
    }

    Context "virtualNetworkRules Validation" {

        It "Has virtualNetworkRules parameter" {

            $json.parameters.virtualNetworkRules | should not be $null
        }

        It "virtualNetworkRules parameter is of type array" {

            $json.parameters.virtualNetworkRules.type | should be "array"
        }

        It "virtualNetworkRules parameter default value is an empty array" {

            $json.parameters.virtualNetworkRules.defaultValue.Count | should be 0
        }
    }

    Context "ipRules Validation" {

        It "Has ipRules parameter" {

            $json.parameters.ipRules | should not be $null
        }

        It "ipRules parameter is of type array" {

            $json.parameters.ipRules.type | should be "array"
        }

        It "ipRules parameter default value is an empty array" {

            $json.parameters.ipRules.defaultValue.Count | should be 0
        }
    }

    Context "accessTier Validation" {

        It "Has accessTier parameter" {

            $json.parameters.accessTier | should not be $null
        }

        It "accessTier parameter is of type string" {

            $json.parameters.accessTier.type | should be "string"
        }

        It "accessTier parameter default value is Hot" {

            $json.parameters.accessTier.defaultValue | should be "Hot"
        }

        It "accessTier parameter allowed values are Hot, Cold" {

            (Compare-Object -ReferenceObject $json.parameters.accessTier.allowedValues -DifferenceObject @("Hot", "Cool")).Length | should be 0
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

    Context "type Validation" {

        It "type value is Microsoft.Storage/storageAccounts" {

            $storageAccount.type | should be "Microsoft.Storage/storageAccounts"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $storageAccount.apiVersion | should be "2018-11-01"
        }
    }

    Context "Network ACL Validation" {

        It "Default action is deny when no rule is satisfied" {

            $storageAccount.properties.networkAcls.defaultAction -eq "Deny" | should be $true
        }

        It "Default action for explicit network ACLs is allow" {

            $json.variables.defaultAction -eq "Allow" | should be $true
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

    Context "Advanced Threat Protection Validation" {

        It "ATP Resource exists" {

            $storageAccount.resources.type | should be "providers/advancedThreatProtectionSettings"
        }

        It "ATP is enabled" {

            $storageAccount.resources.properties.isEnabled | should be $true
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