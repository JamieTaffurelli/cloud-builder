$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Key Vault Parameter Validation" {

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

    Context "tenantId Validation" {

        It "Has tenantId parameter" {

            $json.parameters.tenantId | should not be $null
        }

        It "tenantId parameter is of type string" {

            $json.parameters.tenantId.type | should be "string"
        }

        It "tenantId parameter default value is [subscription().tenantId]" {

            $json.parameters.tenantId.defaultValue | should be "[subscription().tenantId]"
        }
    }

    Context "skuName Validation" {

        It "Has skuName parameter" {

            $json.parameters.skuName | should not be $null
        }

        It "protocol parameter is of type string" {

            $json.parameters.skuName.type | should be "string"
        }

        It "skuName parameter default value is Standard" {

            $json.parameters.skuName.defaultValue | should be "Standard"
        }

        It "skuName parameter allowed values are Standard, Premium" {

            (Compare-Object -ReferenceObject $json.parameters.skuName.allowedValues -DifferenceObject @("Standard", "Premium")).Length | should be 0
        }
    }

    Context "enabledForDeployment Validation" {

        It "Has enabledForDeployment parameter" {

            $json.parameters.enabledForDeployment | should not be $null
        }

        It "enabledForDeployment parameter is of type bool" {

            $json.parameters.enabledForDeployment.type | should be "bool"
        }

        It "enabledForDeployment parameter default value is false" {

            $json.parameters.enabledForDeployment.defaultValue | should be $false
        }
    }

    Context "enabledForDiskEncryption Validation" {

        It "Has enabledForDiskEncryption parameter" {

            $json.parameters.enabledForDiskEncryption | should not be $null
        }

        It "enabledForDiskEncryption parameter is of type bool" {

            $json.parameters.enabledForDiskEncryption.type | should be "bool"
        }

        It "enabledForDiskEncryption parameter default value is false" {

            $json.parameters.enabledForDiskEncryption.defaultValue | should be $false
        }
    }

    Context "enabledForTemplateDeployment Validation" {

        It "Has enabledForTemplateDeployment parameter" {

            $json.parameters.enabledForTemplateDeployment | should not be $null
        }

        It "enabledForTemplateDeployment parameter is of type bool" {

            $json.parameters.enabledForTemplateDeployment.type | should be "bool"
        }

        It "enabledForTemplateDeployment parameter default value is false" {

            $json.parameters.enabledForTemplateDeployment.defaultValue | should be $false
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

        It "bypass parameter allowed values are None, AzureServices" {

            (Compare-Object -ReferenceObject $json.parameters.bypass.allowedValues -DifferenceObject @("None", "AzureServices")).Length | should be 0
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

            ($json.parameters.solutionName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "Diagnostic Settings Validation" {

        It "diagnosticsEnabled variable is true" {

            $json.variables.diagnosticsEnabled | should be $true
        }

        It "diagnosticsRetentionInDays is 400" {

            $json.variables.diagnosticsRetentionInDays | should be 400
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

Describe "Key Vault Resource Validation" {

    $vault = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.KeyVault/vaults" }
    $diagnostics = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Insights/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.KeyVault/vaults" {

            $vault.type | should be "Microsoft.KeyVault/vaults"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-02-14" {

            $vault.apiVersion | should be "2018-02-14"
        }
    }

    Context "enableSoftDelete Validation" {

        It "enableSoftDelete value is true" {

            $vault.properties.enableSoftDelete | should be $true
        }
    }

    Context "createMode Validation" {

        It "createMode value is recover" {

            $vault.properties.createMode | should be "recover"
        }
    }

    Context "enablePurgeProtection Validation" {

        It "enablePurgeProtection value is true" {

            $vault.properties.enablePurgeProtection | should be $true
        }
    }

    Context "defaultAction Validation" {

        It "defaultAction value is deny" {

            $vault.properties.networkAcls.defaultAction | should be "Deny"
        }
    }

    Context "Diagnostic Settings Validation" {

        It "type value is Microsoft.Insights/diagnosticSettings" {

            $diagnostics.type | should be "Microsoft.Insights/diagnosticSettings"
        }

        It "apiVersion value is 2017-05-01-preview" {

            $diagnostics.apiVersion | should be "2017-05-01-preview"
        }

        It "Metrics category is set to AllMetrics" {

            $diagnostics.properties.metrics.category | should be "AllMetrics"
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("AuditEvent")).Length | should be 0
        }
    }
}

Describe "Key Vault Output Validation" {

    Context "Key Vault Reference Validation" {

        It "type value is object" {

            $json.outputs.KeyVault.type | should be "object"
        }

        It "Uses full reference for Key Vault" {

            $json.outputs.KeyVault.value | should be "[reference(resourceId('Microsoft.KeyVault/vaults', parameters('keyVaultName')), '2018-02-14', 'Full')]"
        }
    }
}