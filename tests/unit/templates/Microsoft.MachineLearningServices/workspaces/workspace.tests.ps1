$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Machine Learning Workspace Parameter Validation" {

    Context "workspaceName Validation" {

        It "Has workspaceName parameter" {

            $json.parameters.workspaceName | should not be $null
        }

        It "workspaceName parameter is of type string" {

            $json.parameters.workspaceName.type | should be "string"
        }

        It "workspaceName parameter is mandatory" {

            ($json.parameters.workspaceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "description Validation" {

        It "Has description parameter" {

            $json.parameters.description | should not be $null
        }

        It "description parameter is of type string" {

            $json.parameters.description.type | should be "string"
        }

        It "description parameter is mandatory" {

            ($json.parameters.description.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "friendlyName Validation" {

        It "Has friendlyName parameter" {

            $json.parameters.friendlyName | should not be $null
        }

        It "friendlyName parameter is of type string" {

            $json.parameters.friendlyName.type | should be "string"
        }

        It "friendlyName parameter is mandatory" {

            ($json.parameters.friendlyName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "keyVaultSubscriptionId Validation" {

        It "Has keyVaultSubscriptionId parameter" {

            $json.parameters.keyVaultSubscriptionId | should not be $null
        }

        It "keyVaultSubscriptionId parameter is of type string" {

            $json.parameters.keyVaultSubscriptionId.type | should be "string"
        }

        It "keyVaultSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.keyVaultSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "keyVaultResourceGroupName Validation" {

        It "Has keyVaultResourceGroupName parameter" {

            $json.parameters.keyVaultResourceGroupName | should not be $null
        }

        It "keyVaultResourceGroupName parameter is of type string" {

            $json.parameters.keyVaultResourceGroupName.type | should be "string"
        }

        It "keyVaultResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.keyVaultResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

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

    Context "appInsightsSubscriptionId Validation" {

        It "Has appInsightsSubscriptionId parameter" {

            $json.parameters.appInsightsSubscriptionId | should not be $null
        }

        It "appInsightsSubscriptionId parameter is of type string" {

            $json.parameters.appInsightsSubscriptionId.type | should be "string"
        }

        It "appInsightsSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appInsightsSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appInsightsResourceGroupName Validation" {

        It "Has appInsightsResourceGroupName parameter" {

            $json.parameters.appInsightsResourceGroupName | should not be $null
        }

        It "appInsightsResourceGroupName parameter is of type string" {

            $json.parameters.appInsightsResourceGroupName.type | should be "string"
        }

        It "appInsightsResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appInsightsResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "appInsightsName Validation" {

        It "Has appInsightsName parameter" {

            $json.parameters.appInsightsName | should not be $null
        }

        It "appInsightsName parameter is of type string" {

            $json.parameters.appInsightsName.type | should be "string"
        }

        It "appInsightsName parameter is mandatory" {

            ($json.parameters.appInsightsName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "containerRegistrySubscriptionId Validation" {

        It "Has containerRegistrySubscriptionId parameter" {

            $json.parameters.containerRegistrySubscriptionId | should not be $null
        }

        It "containerRegistrySubscriptionId parameter is of type string" {

            $json.parameters.containerRegistrySubscriptionId.type | should be "string"
        }

        It "containerRegistrySubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.containerRegistrySubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "containerRegistryResourceGroupName Validation" {

        It "Has containerRegistryResourceGroupName parameter" {

            $json.parameters.containerRegistryResourceGroupName | should not be $null
        }

        It "containerRegistryResourceGroupName parameter is of type string" {

            $json.parameters.containerRegistryResourceGroupName.type | should be "string"
        }

        It "containerRegistryResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.containerRegistryResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "containerRegistryName Validation" {

        It "Has containerRegistryName parameter" {

            $json.parameters.containerRegistryName | should not be $null
        }

        It "containerRegistryName parameter is of type string" {

            $json.parameters.containerRegistryName.type | should be "string"
        }

        It "containerRegistryName parameter is mandatory" {

            ($json.parameters.containerRegistryName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "storageAccountSubscriptionId Validation" {

        It "Has storageAccountSubscriptionId parameter" {

            $json.parameters.storageAccountSubscriptionId | should not be $null
        }

        It "storageAccountSubscriptionId parameter is of type string" {

            $json.parameters.storageAccountSubscriptionId.type | should be "string"
        }

        It "storageAccountSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.storageAccountSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "storageAccountResourceGroupName Validation" {

        It "Has storageAccountResourceGroupName parameter" {

            $json.parameters.storageAccountResourceGroupName | should not be $null
        }

        It "storageAccountResourceGroupName parameter is of type string" {

            $json.parameters.storageAccountResourceGroupName.type | should be "string"
        }

        It "storageAccountResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.storageAccountResourceGroupName.defaultValue | should be "[resourceGroup().name]"
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
    }

    Context "customerEncryption Validation" {

        It "Has customerEncryption parameter" {

            $json.parameters.customerEncryption | should not be $null
        }

        It "customerEncryption parameter is of type string" {

            $json.parameters.customerEncryption.type | should be "string"
        }

        It "customerEncryption parameter default value is Disabled" {

            $json.parameters.customerEncryption.defaultValue | should be "Disabled"
        }

        It "customerEncryption parameter allowed values are 'Enabled', 'Disabled'" {

            (Compare-Object -ReferenceObject $json.parameters.customerEncryption.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
        }
    }

    Context "encryptionKeyVaultSubscriptionId Validation" {

        It "Has encryptionKeyVaultSubscriptionId parameter" {

            $json.parameters.encryptionKeyVaultSubscriptionId | should not be $null
        }

        It "encryptionKeyVaultSubscriptionId parameter is of type string" {

            $json.parameters.encryptionKeyVaultSubscriptionId.type | should be "string"
        }

        It "encryptionKeyVaultSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.encryptionKeyVaultSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "encryptionKeyVaultResourceGroupName Validation" {

        It "Has encryptionKeyVaultResourceGroupName parameter" {

            $json.parameters.encryptionKeyVaultResourceGroupName | should not be $null
        }

        It "encryptionKeyVaultResourceGroupName parameter is of type string" {

            $json.parameters.encryptionKeyVaultResourceGroupName.type | should be "string"
        }

        It "encryptionKeyVaultResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.encryptionKeyVaultResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "encryptionKeyVaultName Validation" {

        It "Has encryptionKeyVaultName parameter" {

            $json.parameters.encryptionKeyVaultName | should not be $null
        }

        It "encryptionKeyVaultName parameter is of type string" {

            $json.parameters.encryptionKeyVaultName.type | should be "string"
        }

        It "encryptionKeyVaultName parameter default value is an empty string" {

            $json.parameters.encryptionKeyVaultName.defaultValue | should be ([String]::Empty)
        }
    }

    Context "encryptionKeyVersion Validation" {

        It "Has encryptionKeyVersion parameter" {

            $json.parameters.encryptionKeyVersion | should not be $null
        }

        It "encryptionKeyVersion parameter is of type string" {

            $json.parameters.encryptionKeyVersion.type | should be "string"
        }

        It "encryptionKeyVersion parameter default value is an empty string" {

            $json.parameters.encryptionKeyVersion.defaultValue | should be ([String]::Empty)
        }
    }

    Context "hbiWorkspace Validation" {

        It "Has hbiWorkspace parameter" {

            $json.parameters.hbiWorkspace | should not be $null
        }

        It "hbiWorkspace parameter is of type bool" {

            $json.parameters.hbiWorkspace.type | should be "bool"
        }

        It "hbiWorkspace parameter default value is true" {

            $json.parameters.hbiWorkspace.defaultValue | should be $false
        }
    }

    Context "imageBuildCompute Validation" {

        It "Has imageBuildCompute parameter" {

            $json.parameters.imageBuildCompute | should not be $null
        }

        It "imageBuildCompute parameter is of type string" {

            $json.parameters.imageBuildCompute.type | should be "string"
        }

        It "imageBuildCompute parameter default value is an empty string" {

            $json.parameters.imageBuildCompute.defaultValue | should be ([String]::Empty)
        }
    }

    Context "allowPublicAccessWhenBehindVnet Validation" {

        It "Has allowPublicAccessWhenBehindVnet parameter" {

            $json.parameters.allowPublicAccessWhenBehindVnet | should not be $null
        }

        It "allowPublicAccessWhenBehindVnet parameter is of type bool" {

            $json.parameters.allowPublicAccessWhenBehindVnet.type | should be "bool"
        }

        It "allowPublicAccessWhenBehindVnet parameter default value is true" {

            $json.parameters.allowPublicAccessWhenBehindVnet.defaultValue | should be $false
        }
    }

    Context "sharedPrivateLinkResources Validation" {

        It "Has sharedPrivateLinkResources parameter" {

            $json.parameters.sharedPrivateLinkResources | should not be $null
        }

        It "sharedPrivateLinkResources parameter is of type array" {

            $json.parameters.sharedPrivateLinkResources.type | should be "array"
        }

        It "sharedPrivateLinkResources parameter default value is an empty array" {

            $json.parameters.sharedPrivateLinkResources.defaultValue | should be @()
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

    Context "Diagnostic Settings Validation" {

        It "diagnosticsEnabled variable is true" {

            $json.variables.diagnosticsEnabled | should be $true
        }

        It "diagnosticsRetentionInDays is 365" {

            $json.variables.diagnosticsRetentionInDays | should be 365
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

Describe "Machine Learning Workspace Resource Validation" {

    $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.MachineLearningServices/workspaces" {

            $json.resources.type | should be "Microsoft.MachineLearningServices/workspaces"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-08-01" {

            $json.resources.apiVersion | should be "2020-08-01"
        }
    }

    Context "Managed Service Identity Validation" {

        It "type is SystemAssigned" {

            $json.resources.identity.type | should be "SystemAssigned"
        }
    }

    Context "Diagnostic Settings Validation" {

        It "type value is /providers/diagnosticSettings" {

            $diagnostics.type | should be "/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $diagnostics.apiVersion | should be "2015-07-01"
        }

        It "Metrics category is set to AllMetrics" {

            $diagnostics.properties.metrics.category | should be "AllMetrics"
        }

        It "Logs are enabled" {

            $diagnostics.properties.logs | should not be $null
        }
    }
}
Describe "Machine Learning Workspace Output Validation" {

    Context "Machine Learning Workspace Reference Validation" {

        It "type value is object" {

            $json.outputs.workspace.type | should be "object"
        }

        It "Uses full reference for Machine Learning Workspace" {

            $json.outputs.workspace.value | should be "[reference(resourceId('Microsoft.MachineLearningServices/workspaces', parameters('workspaceName')), '2020-08-01', 'Full')]"
        }
    }
}