$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Virtual Network Peering Parameter Validation" {

    Context "peeringName Validation" {

        It "Has peeringName parameter" {

            $json.parameters.peeringName | should not be $null
        }

        It "peeringName parameter is of type string" {

            $json.parameters.peeringName.type | should be "string"
        }

        It "peeringName parameter is mandatory" {

            ($json.parameters.peeringName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

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
    }

    Context "allowVirtualNetworkAccess Validation" {

        It "Has allowVirtualNetworkAccess parameter" {

            $json.parameters.allowVirtualNetworkAccess | should not be $null
        }

        It "allowVirtualNetworkAccess parameter is of type bool" {

            $json.parameters.allowVirtualNetworkAccess.type | should be "bool"
        }

        It "allowVirtualNetworkAccess parameter default value is false" {

            $json.parameters.allowVirtualNetworkAccess.defaultValue | should be $false
        }
    }

    Context "allowForwardedTraffic Validation" {

        It "Has allowForwardedTraffic parameter" {

            $json.parameters.allowForwardedTraffic | should not be $null
        }

        It "allowForwardedTraffic parameter is of type bool" {

            $json.parameters.allowForwardedTraffic.type | should be "bool"
        }

        It "allowForwardedTraffic parameter default value is false" {

            $json.parameters.allowForwardedTraffic.defaultValue | should be $false
        }
    }

    Context "allowGatewayTransit Validation" {

        It "Has allowGatewayTransit parameter" {

            $json.parameters.allowGatewayTransit | should not be $null
        }

        It "allowGatewayTransit parameter is of type bool" {

            $json.parameters.allowGatewayTransit.type | should be "bool"
        }

        It "allowGatewayTransit parameter default value is false" {

            $json.parameters.allowGatewayTransit.defaultValue | should be $false
        }
    }

    Context "useRemoteGateways Validation" {

        It "Has useRemoteGateways parameter" {

            $json.parameters.useRemoteGateways | should not be $null
        }

        It "useRemoteGateways parameter is of type bool" {

            $json.parameters.useRemoteGateways.type | should be "bool"
        }

        It "useRemoteGateways parameter default value is false" {

            $json.parameters.useRemoteGateways.defaultValue | should be $false
        }
    }

    Context "remoteVirtualNetworkSubscriptionId Validation" {

        It "Has remoteVirtualNetworkSubscriptionId parameter" {

            $json.parameters.remoteVirtualNetworkSubscriptionId | should not be $null
        }

        It "remoteVirtualNetworkSubscriptionId parameter is of type string" {

            $json.parameters.remoteVirtualNetworkSubscriptionId.type | should be "string"
        }

        It "remoteVirtualNetworkSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.remoteVirtualNetworkSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "remoteVirtualNetworkResourceGroupName Validation" {

        It "Has remoteVirtualNetworkResourceGroupName parameter" {

            $json.parameters.remoteVirtualNetworkResourceGroupName | should not be $null
        }

        It "remoteVirtualNetworkResourceGroupName parameter is of type string" {

            $json.parameters.remoteVirtualNetworkResourceGroupName.type | should be "string"
        }

        It "remoteVirtualNetworkResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.remoteVirtualNetworkResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "remoteVirtualNetworkName Validation" {

        It "Has remoteVirtualNetworkName parameter" {

            $json.parameters.remoteVirtualNetworkName | should not be $null
        }

        It "remoteVirtualNetworkName parameter is of type string" {

            $json.parameters.remoteVirtualNetworkName.type | should be "string"
        }

        It "remoteVirtualNetworkName parameter is mandatory" {

            ($json.parameters.remoteVirtualNetworkName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "Virtual Network Peering Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Network/virtualNetworks/virtualNetworkPeerings" {

            $json.resources.type | should be "Microsoft.Network/virtualNetworks/virtualNetworkPeerings"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $json.resources.apiVersion | should be "2019-04-01"
        }
    }
}

Describe "Virtual Network Peering Output Validation" {

    Context "Virtual Network Peering Reference Validation" {

        It "type value is object" {

            $json.outputs.virtualNetworkPeering.type | should be "object"
        }

        It "Uses full reference for Virtual Network Peering" {

            $json.outputs.virtualNetworkPeering.value | should be "[reference(resourceId('Microsoft.Network/virtualNetworks/virtualNetworkPeerings', parameters('virtualNetworkName'), parameters('peeringName')), '2019-04-01', 'Full')]"
        }
    }
}