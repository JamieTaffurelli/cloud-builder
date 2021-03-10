$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Virtual Network Parameter Validation" {

    Context "virtualNetworkName Validation" {

        It "Has virtualNetworkName parameter" {

            $json.parameters.virtualNetworkName | should not be $null
        }

        It "virtualNetworkName parameter is of type string" {

            $json.parameters.virtualNetworkName.type | should be "string"
        }

        It "virtualNetworkName parameter is mandatory" {

            ($json.parameters.virtualNetworkName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "virtualNetworkName parameter minimum length is 2" {

            $json.parameters.virtualNetworkName.minLength | should be 2
        }

        It "virtualNetworkName parameter maximum length is 64" {

            $json.parameters.virtualNetworkName.maxLength | should be 64
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

    Context "addressPrefixes Validation" {

        It "Has addressPrefixes parameter" {

            $json.parameters.addressPrefixes | should not be $null
        }

        It "addressPrefixes parameter is of type array" {

            $json.parameters.addressPrefixes.type | should be "array"
        }

        It "addressPrefixes parameter is mandatory" {

            ($json.parameters.addressPrefixes.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "dnsServers Validation" {

        It "Has dnsServers parameter" {

            $json.parameters.dnsServers | should not be $null
        }

        It "dnsServers parameter is of type array" {

            $json.parameters.dnsServers.type | should be "array"
        }

        It "dnsServers parameter default value is an empty array" {

            $json.parameters.dnsServers.defaultValue.Count | should be 0
        }
    }

    Context "subnets Validation" {

        It "Has subnets parameter" {

            $json.parameters.subnets | should not be $null
        }

        It "subnets parameter is of type array" {

            $json.parameters.subnets.type | should be "array"
        }

        It "subnets parameter is mandatory" {

            ($json.parameters.subnets.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "gatewaySubnetPrefix Validation" {

        It "Has gatewaySubnetPrefix parameter" {

            $json.parameters.gatewaySubnetPrefix | should not be $null
        }

        It "gatewaySubnetPrefix parameter is of type string" {

            $json.parameters.gatewaySubnetPrefix.type | should be "string"
        }

        It "gatewaySubnetPrefix parameter default value is an empty string" {

            $json.parameters.gatewaySubnetPrefix.defaultValue | should be ([string]::Empty)
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

Describe "Virtual Network Resource Validation" {

    $vnet = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/virtualNetworks" }
    $diagnostics = $json.resources.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.Network/virtualNetworks" {

            $vnet.type | should be "Microsoft.Network/virtualNetworks"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $vnet.apiVersion | should be "2018-11-01"
        }
    }

    Context "subnets Validation" {

        It "subnets variable allows Network Security Group" {

            $json.variables.subnets.copy.input.properties.networkSecurityGroup | should not be $null
        }

        It "subnets variable allows route table" {

            $json.variables.subnets.copy.input.properties.routeTable | should not be $null
        }

        It "subnets variable allows service endpoints" {

            $json.variables.subnets.copy.input.properties.serviceEndpoints | should not be $null
        }
    }

    Context "enableVmProtection Validation" {

        It "enableVmProtection is true" {

            $vnet.properties.enableVmProtection | should be $true
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

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("VMProtectionAlerts")).Length | should be 0
        }
    }
}

Describe "Virtual Network Output Validation" {

    Context "Virtual Network Reference Validation" {

        It "type value is object" {

            $json.outputs.virtualNetwork.type | should be "object"
        }

        It "Uses full reference for Virtual Network" {

            $json.outputs.virtualNetwork.value | should be "[reference(resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworkName')), '2018-11-01', 'Full')]"
        }
    }
}