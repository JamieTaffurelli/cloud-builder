$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Container Registry Parameter Validation" {

    Context "registryName Validation" {

        It "Has registryName parameter" {

            $json.parameters.registryName | should not be $null
        }

        It "registryName parameter is of type string" {

            $json.parameters.registryName.type | should be "string"
        }

        It "registryName parameter is mandatory" {

            ($json.parameters.registryName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "sku Validation" {

        It "Has sku parameter" {

            $json.parameters.sku | should not be $null
        }

        It "sku parameter is of type string" {

            $json.parameters.sku.type | should be "string"
        }

        It "sku parameter default value is Basic" {

            $json.parameters.sku.defaultValue | should be "Basic"
        }

        It "sku parameter allowed values are Basic, Standard, Premium" {

            (Compare-Object -ReferenceObject $json.parameters.sku.allowedValues -DifferenceObject @("Basic", "Standard", "Premium")).Length | should be 0
        }
    }

    Context "adminUserEnabled Validation" {

        It "Has adminUserEnabled parameter" {

            $json.parameters.adminUserEnabled | should not be $null
        }

        It "adminUserEnabled parameter is of type bool" {

            $json.parameters.adminUserEnabled.type | should be "bool"
        }

        It "adminUserEnabled parameter default value is false" {

            $json.parameters.adminUserEnabled.defaultValue | should be $false
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

    Context "quarantinePolicy Validation" {

        It "Has quarantinePolicy parameter" {

            $json.parameters.quarantinePolicy | should not be $null
        }

        It "quarantinePolicy parameter is of type string" {

            $json.parameters.quarantinePolicy.type | should be "string"
        }

        It "quarantinePolicy parameter default value is Disabled" {

            $json.parameters.quarantinePolicy.defaultValue | should be "Disabled"
        }

        It "quarantinePolicy parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.quarantinePolicy.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
        }
    }

    Context "trustPolicy Validation" {

        It "Has trustPolicy parameter" {

            $json.parameters.trustPolicy | should not be $null
        }

        It "trustPolicy parameter is of type string" {

            $json.parameters.trustPolicy.type | should be "string"
        }

        It "trustPolicy parameter default value is Disabled" {

            $json.parameters.trustPolicy.defaultValue | should be "Disabled"
        }

        It "trustPolicy parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.trustPolicy.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
        }
    }

    Context "retentionDays Validation" {

        It "Has retentionDays parameter" {

            $json.parameters.retentionDays | should not be $null
        }

        It "retentionDays parameter is of type int" {

            $json.parameters.retentionDays.type | should be "int"
        }

        It "retentionDays parameter default value is 0" {

            $json.parameters.retentionDays.defaultValue | should be 0
        }

        It "retentionDays parameter is minValue is 0" {

            $json.parameters.retentionDays.minValue | should be 0
        }

        It "retentionDays parameter is maxValue is 365" {

            $json.parameters.retentionDays.maxValue | should be 365
        }
    }

    Context "retentionPolicy Validation" {

        It "Has retentionPolicy parameter" {

            $json.parameters.retentionPolicy | should not be $null
        }

        It "retentionPolicy parameter is of type string" {

            $json.parameters.retentionPolicy.type | should be "string"
        }

        It "retentionPolicy parameter default value is Disabled" {

            $json.parameters.retentionPolicy.defaultValue | should be "Disabled"
        }

        It "retentionPolicy parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.retentionPolicy.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
        }
    }

    Context "dataEndpointEnabled Validation" {

        It "Has dataEndpointEnabled parameter" {

            $json.parameters.dataEndpointEnabled | should not be $null
        }

        It "dataEndpointEnabled parameter is of type bool" {

            $json.parameters.dataEndpointEnabled.type | should be "bool"
        }

        It "dataEndpointEnabled parameter default value is false" {

            $json.parameters.dataEndpointEnabled.defaultValue | should be $false
        }
    }

    Context "publicNetworkAccess Validation" {

        It "Has publicNetworkAccess parameter" {

            $json.parameters.publicNetworkAccess | should not be $null
        }

        It "publicNetworkAccess parameter is of type string" {

            $json.parameters.publicNetworkAccess.type | should be "string"
        }

        It "publicNetworkAccess parameter default value is Disabled" {

            $json.parameters.publicNetworkAccess.defaultValue | should be "Disabled"
        }

        It "publicNetworkAccess parameter allowed values are Enabled, Disabled" {

            (Compare-Object -ReferenceObject $json.parameters.publicNetworkAccess.allowedValues -DifferenceObject @("Enabled", "Disabled")).Length | should be 0
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

Describe "Container Registry Resource Validation" {

    $registry = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.ContainerRegistry/registries" }
    $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.ContainerRegistry/registries" {

            $registry.type | should be "Microsoft.ContainerRegistry/registries"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-12-01-preview" {

            $registry.apiVersion | should be "2019-12-01-preview"
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

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("ContainerRegistryLoginEvents", "ContainerRegistryRepositoryEvents")).Length | should be 0
        }
    }
}

Describe "Container Registry Output Validation" {

    Context "Container Registry Reference Validation" {

        It "type value is object" {

            $json.outputs.registry.type | should be "object"
        }

        It "Uses full reference for Container Registry" {

            $json.outputs.registry.value | should be "[reference(resourceId('Microsoft.ContainerRegistry/registries', parameters('registryName')), '2019-12-01-preview', 'Full')]"
        }
    }
}