$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Virtual Network Link Parameter Validation" {

    Context "virtualNetworkLinkName Validation" {

        It "Has virtualNetworkLinkName parameter" {

            $json.parameters.virtualNetworkLinkName | should not be $null
        }

        It "virtualNetworkLinkName parameter is of type string" {

            $json.parameters.virtualNetworkLinkName.type | should be "string"
        }

        It "virtualNetworkLinkName parameter is mandatory" {

            ($json.parameters.virtualNetworkLinkName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "privateDnsZoneName Validation" {

        It "Has privateDnsZoneName parameter" {

            $json.parameters.privateDnsZoneName | should not be $null
        }

        It "privateDnsZoneName parameter is of type string" {

            $json.parameters.privateDnsZoneName.type | should be "string"
        }

        It "privateDnsZoneName parameter is mandatory" {

            ($json.parameters.privateDnsZoneName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "virtualNetworkSubscriptionId Validation" {

        It "Has virtualNetworkSubscriptionId parameter" {

            $json.parameters.virtualNetworkSubscriptionId | should not be $null
        }

        It "virtualNetworkSubscriptionId parameter is of type string" {

            $json.parameters.virtualNetworkSubscriptionId.type | should be "string"
        }

        It "virtualNetworkSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.virtualNetworkSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "virtualNetworkResourceGroupName Validation" {

        It "Has virtualNetworkResourceGroupName parameter" {

            $json.parameters.virtualNetworkResourceGroupName | should not be $null
        }

        It "virtualNetworkResourceGroupName parameter is of type string" {

            $json.parameters.virtualNetworkResourceGroupName.type | should be "string"
        }

        It "virtualNetworkResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.virtualNetworkResourceGroupName.defaultValue | should be "[resourceGroup().name]"
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

    Context "registrationEnabled Validation" {

        It "Has registrationEnabled parameter" {

            $json.parameters.registrationEnabled | should not be $null
        }

        It "registrationEnabled parameter is of type bool" {

            $json.parameters.registrationEnabled.type | should be "bool"
        }

        It "registrationEnabled parameter default value is true" {

            $json.parameters.registrationEnabled.defaultValue | should be $true
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

Describe "Virtual Network Link Resource Validation" {

    $vnetLink = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/privateDnsZones/virtualNetworkLinks" }

    Context "type Validation" {

        It "type value is Microsoft.Network/privateDnsZones/virtualNetworkLinks" {

            $vnetLink.type | should be "Microsoft.Network/privateDnsZones/virtualNetworkLinks"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-06-01" {

            $vnetLink.apiVersion | should be "2020-06-01"
        }
    }
}

Describe "Virtual Network Link Output Validation" {

    Context "Virtual Network Link Reference Validation" {

        It "type value is object" {

            $json.outputs.virtualNetworkLink.type | should be "object"
        }

        It "Uses full reference for Virtual Network Link" {

            $json.outputs.virtualNetworkLink.value | should be "[reference(resourceId('Microsoft.Network/privateDnsZones/virtualNetworkLinks', parameters('privateDnsZoneName'), parameters('virtualNetworkLinkName')), '2020-06-01', 'Full')]"
        }
    }
}