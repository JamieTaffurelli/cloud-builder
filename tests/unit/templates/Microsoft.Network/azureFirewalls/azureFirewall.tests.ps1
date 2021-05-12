$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Azure Firewall Parameter Validation" {

    Context "firewallName Validation" {

        It "Has firewallName parameter" {

            $json.parameters.firewallName | should not be $null
        }

        It "firewallName parameter is of type string" {

            $json.parameters.firewallName.type | should be "string"
        }

        It "firewallName parameter is mandatory" {

            ($json.parameters.firewallName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "applicationRuleCollections Validation" {

        It "Has applicationRuleCollections parameter" {

            $json.parameters.applicationRuleCollections | should not be $null
        }

        It "applicationRuleCollections parameter is of type array" {

            $json.parameters.applicationRuleCollections.type | should be "array"
        }

        It "applicationRuleCollections parameter default value is an empty array" {

            $json.parameters.applicationRuleCollections.defaultValue.Count | should be 0
        }
    }

    Context "natRuleCollections Validation" {

        It "Has natRuleCollections parameter" {

            $json.parameters.natRuleCollections | should not be $null
        }

        It "natRuleCollections parameter is of type array" {

            $json.parameters.natRuleCollections.type | should be "array"
        }

        It "natRuleCollections parameter default value is an empty array" {

            $json.parameters.natRuleCollections.defaultValue.Count | should be 0
        }
    }

    Context "networkRuleCollections Validation" {

        It "Has networkRuleCollections parameter" {

            $json.parameters.networkRuleCollections | should not be $null
        }

        It "networkRuleCollections parameter is of type array" {

            $json.parameters.networkRuleCollections.type | should be "array"
        }

        It "networkRuleCollections parameter default value is an empty array" {

            $json.parameters.networkRuleCollections.defaultValue.Count | should be 0
        }
    }

    Context "addressPrefixes Validation" {

        It "Has ipConfigurations parameter" {

            $json.parameters.ipConfigurations | should not be $null
        }

        It "ipConfigurations parameter is of type array" {

            $json.parameters.ipConfigurations.type | should be "array"
        }

        It "ipConfigurations parameter is mandatory" {

            ($json.parameters.ipConfigurations.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "threatIntelMode Validation" {

        It "Has threatIntelMode parameter" {

            $json.parameters.threatIntelMode | should not be $null
        }

        It "threatIntelMode parameter is of type string" {

            $json.parameters.threatIntelMode.type | should be "string"
        }

        It "threatIntelMode parameter default value is Deny" {

            $json.parameters.threatIntelMode.defaultValue | should be "Deny"
        }

        It "threatIntelMode parameter allowed values are Alert, Deny, Off" {

            (Compare-Object -ReferenceObject $json.parameters.threatIntelMode.allowedValues -DifferenceObject @("Alert", "Deny", "Off")).Length | should be 0
        }
    }

    Context "firewallPolicySubscriptionId Validation" {

        It "Has firewallPolicySubscriptionId parameter" {

            $json.parameters.firewallPolicySubscriptionId | should not be $null
        }

        It "firewallPolicySubscriptionId parameter is of type string" {

            $json.parameters.firewallPolicySubscriptionId.type | should be "string"
        }

        It "firewallPolicySubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.firewallPolicySubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "firewallPolicyResourceGroupName Validation" {

        It "Has firewallPolicyResourceGroupName parameter" {

            $json.parameters.firewallPolicyResourceGroupName | should not be $null
        }

        It "firewallPolicyResourceGroupName parameter is of type string" {

            $json.parameters.firewallPolicyResourceGroupName.type | should be "string"
        }

        It "firewallPolicyResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.firewallPolicyResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "firewallPolicyName Validation" {

        It "Has firewallPolicyName parameter" {

            $json.parameters.firewallPolicyName | should not be $null
        }

        It "firewallPolicyName parameter is of type string" {

            $json.parameters.firewallPolicyName.type | should be "string"
        }

        It "firewallPolicyName parameter is mandatory" {

            ($json.parameters.firewallPolicyName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "skuTier Validation" {

        It "Has skuTier parameter" {

            $json.parameters.skuTier | should not be $null
        }

        It "skuTier parameter is of type string" {

            $json.parameters.skuTier.type | should be "string"
        }

        It "skuTier parameter default value is Standard" {

            $json.parameters.skuTier.defaultValue | should be "Standard"
        }

        It "skuTier parameter allowed values are Standard, Premium" {

            (Compare-Object -ReferenceObject $json.parameters.skuTier.allowedValues -DifferenceObject @("Standard", "Premium")).Length | should be 0
        }
    }

    Context "zones Validation" {

        It "Has zones parameter" {

            $json.parameters.zones | should not be $null
        }

        It "zones parameter is of type array" {

            $json.parameters.zones.type | should be "array"
        }

        It "zones parameter default value is an empty array" {

            $json.parameters.zones.defaultValue.Count | should be 0
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

Describe "Azure Firewall Resource Validation" {

    $firewall = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/azureFirewalls" }
    $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.Network/azureFirewalls" {

            $firewall.type | should be "Microsoft.Network/azureFirewalls"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-07-01" {

            $firewall.apiVersion | should be "2020-07-01"
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

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("AzureFirewallApplicationRule", "AzureFirewallNetworkRule", "AzureFirewallDNSProxy")).Length | should be 0
        }
    }
}

Describe "Azure Firewall Output Validation" {

    Context "Azure Firewall Reference Validation" {

        It "type value is object" {

            $json.outputs.firewall.type | should be "object"
        }

        It "Uses full reference for Azure Firewall" {

            $json.outputs.firewall.value | should be "[reference(resourceId('Microsoft.Network/azureFirewalls', parameters('firewallName')), '2020-07-01', 'Full')]"
        }
    }
}