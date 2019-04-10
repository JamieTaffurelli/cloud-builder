$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), "module"
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "storageAccount Parameter Validation" {

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

        It "storageAccountName parameter is minlength is 3" {

            $json.parameters.storageAccountName.minLength | should be 3
        }

        It "storageAccountName parameter is maxlength is 24" {

            $json.parameters.storageAccountName.maxLength | should be 24
        }
    }

    Context "apiVersion Validation" {

        It "Has apiversion parameter" {

            $json.parameters.apiVersion | should not be $null
        }

        It "apiversion parameter is of type string" {

            $json.parameters.apiVersion.type | should be "string"
        }

        It "apiVersion parameter default value is 2018-11-01" {

            $json.parameters.apiVersion.defaultValue | should be "2018-11-01"
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

        It "customDomainName parameter default value is and empty string" {

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

            $json.parameters.virtualNetworkRules.defaultValue | should be @()
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

            $json.parameters.ipRules.defaultValue | should be @()
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

Describe "storageAccount Resource Validation" {

    Context "Network ACL Validation" {

        It "Default action is deny" {

            (($json.variables.defaultAction -eq "Deny") -and ($json.resources[0].properties.networkAcls.defaultAction -eq "[variables('defaultAction')]")) | should be $true
        }
    }

    Context "Encryption at rest Validation" {

        It "File encryption is enabled" {

            $json.resources.properties.encryption.services.file.enabled | should be $true
        }

        It "Blob encryption is enabled" {

            $json.resources.properties.encryption.services.blob.enabled | should be $true
        }
    }

    Context "Encryption in transit Validation" {

        It "supportsHttpsTrafficOnly is true" {

            $json.resources.properties.supportsHttpsTrafficOnly| should be $true
        }
    }
}