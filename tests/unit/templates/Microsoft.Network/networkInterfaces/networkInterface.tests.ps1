$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Network Interface Parameter Validation" {

    Context "nicName Validation" {

        It "Has nicName parameter" {

            $json.parameters.nicName | should not be $null
        }

        It "nicName parameter is of type string" {

            $json.parameters.nicName.type | should be "string"
        }

        It "nicName parameter is mandatory" {

            ($json.parameters.nicName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "nicName parameter is minimum length is 1" {

            $json.parameters.nicName.minLength | should be 1
        }

        It "nicName parameter is maximum length is 80" {

            $json.parameters.nicName.maxLength | should be 80
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

    Context "ipConfigurationName Validation" {

        It "Has ipConfigurationName parameter" {

            $json.parameters.ipConfigurationName | should not be $null
        }

        It "ipConfigurationName parameter is of type string" {

            $json.parameters.ipConfigurationName.type | should be "string"
        }

        It "ipConfigurationName parameter default value is ipconfig1" {

            $json.parameters.ipConfigurationName.defaultValue | should be "ipconfig1"
        }
    }

    Context "privateIpAllocationMethod Validation" {

        It "Has privateIpAllocationMethod parameter" {

            $json.parameters.privateIpAllocationMethod | should not be $null
        }

        It "privateIpAllocationMethod parameter is of type string" {

            $json.parameters.privateIpAllocationMethod.type | should be "string"
        }

        It "privateIpAllocationMethod parameter default value is static" {

            $json.parameters.privateIpAllocationMethod.defaultValue | should be "static"
        }

        It "privateIpAllocationMethod parameter allowed values are static, dynamic" {

            (Compare-Object -ReferenceObject $json.parameters.privateIpAllocationMethod.allowedValues -DifferenceObject @("static", "dynamic")).Length | should be 0
        }
    }

    Context "subnetName Validation" {

        It "Has subnetName parameter" {

            $json.parameters.subnetName | should not be $null
        }

        It "subnetName parameter is of type string" {

            $json.parameters.subnetName.type | should be "string"
        }

        It "subnetName parameter is mandatory" {

            ($json.parameters.subnetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "subnetResourceGroup Validation" {

        It "Has subnetResourceGroup parameter" {

            $json.parameters.subnetResourceGroup | should not be $null
        }

        It "subnetResourceGroup parameter is of type string" {

            $json.parameters.subnetResourceGroup.type | should be "string"
        }

        It "subnetSubscriptionId parameter is mandatory" {

            ($json.parameters.subnetResourceGroup.defaultValue) | should be "[resourceGroup().name]"
        }

        It "subnetSubscriptionId parameter is mandatory" {

            ($json.parameters.subnetSubscriptionId.defaultValue) | should be "[subscription().subscriptionId]"
        }
    }

    Context "privateIpAddressVersion Validation" {

        It "Has privateIpAddressVersion parameter" {

            $json.parameters.privateIpAddressVersion | should not be $null
        }

        It "privateIpAddressVersion parameter is of type string" {

            $json.parameters.privateIpAddressVersion.type | should be "string"
        }

        It "privateIpAddressVersion parameter default value is IPv4" {

            $json.parameters.privateIpAddressVersion.defaultValue | should be "IPv4"
        }

        It "privateIpAddressVersion parameter allowed values are IPv4, IPv6" {

            (Compare-Object -ReferenceObject $json.parameters.privateIpAddressVersion.allowedValues -DifferenceObject @("IPv4", "IPv6")).Length | should be 0
        }
    }

    Context "privateIpAddressVersion Validation" {

        It "Has privateIpAddressVersion parameter" {

            $json.parameters.privateIpAddressVersion | should not be $null
        }

        It "privateIpAddressVersion parameter is of type string" {

            $json.parameters.privateIpAddressVersion.type | should be "string"
        }

        It "privateIpAddressVersion parameter default value is IPv4" {

            $json.parameters.privateIpAddressVersion.defaultValue | should be "IPv4"
        }

        It "privateIpAddressVersion parameter allowed values are IPv4, IPv6" {

            (Compare-Object -ReferenceObject $json.parameters.privateIpAddressVersion.allowedValues -DifferenceObject @("IPv4", "IPv6")).Length | should be 0
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

    Context "internalDnsNameLabel Validation" {

        It "Has internalDnsNameLabel parameter" {

            $json.parameters.internalDnsNameLabel | should not be $null
        }

        It "internalDnsNameLabel parameter is of type string" {

            $json.parameters.internalDnsNameLabel.type | should be "string"
        }

        It "internalDnsNameLabel parameter default value is an empty string" {

            $json.parameters.internalDnsNameLabel.defaultValue | should be ([String]::Empty)
        }
    }

    Context "internalFqdn Validation" {

        It "Has internalFqdn parameter" {

            $json.parameters.internalFqdn | should not be $null
        }

        It "internalFqdn parameter is of type string" {

            $json.parameters.internalFqdn.type | should be "string"
        }

        It "internalFqdn parameter default value is an empty string" {

            $json.parameters.internalFqdn.defaultValue | should be ([String]::Empty)
        }
    }

    Context "internalDomainNameSuffix Validation" {

        It "Has internalDomainNameSuffix parameter" {

            $json.parameters.internalDomainNameSuffix | should not be $null
        }

        It "internalDomainNameSuffix parameter is of type string" {

            $json.parameters.internalDomainNameSuffix.type | should be "string"
        }

        It "internalDomainNameSuffix parameter default value is an empty string" {

            $json.parameters.internalDomainNameSuffix.defaultValue | should be ([String]::Empty)
        }
    }

    Context "primary Validation" {

        It "Has primary parameter" {

            $json.parameters.primary | should not be $null
        }

        It "primary parameter is of type bool" {

            $json.parameters.primary.type | should be "bool"
        }

        It "primary parameter default value is true" {

            $json.parameters.primary.defaultValue | should be $true
        }
    }

    Context "enableAcceleratedNetworking Validation" {

        It "Has enableAcceleratedNetworking parameter" {

            $json.parameters.enableAcceleratedNetworking | should not be $null
        }

        It "enableAcceleratedNetworking parameter is of type bool" {

            $json.parameters.enableAcceleratedNetworking.type | should be "bool"
        }

        It "enableAcceleratedNetworking parameter default value is false" {

            $json.parameters.enableAcceleratedNetworking.defaultValue | should be $false
        }
    }

    Context "enableIpForwarding Validation" {

        It "Has enableIpForwarding parameter" {

            $json.parameters.enableIpForwarding | should not be $null
        }

        It "enableIpForwarding parameter is of type bool" {

            $json.parameters.enableIpForwarding.type | should be "bool"
        }

        It "enableIpForwarding parameter default value is false" {

            $json.parameters.enableIpForwarding.defaultValue | should be $false
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

Describe "Network Interface Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Network/networkInterfaces" {

            $json.resources.type | should be "Microsoft.Network/networkInterfaces"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $json.resources.apiVersion | should be "2018-11-01"
        }
    }
}

Describe "Network Interface Output Validation" {

    Context "Network Interface Reference Validation" {

        It "type value is object" {

            $json.outputs.networkInterface.type | should be "object"
        }

        It "Uses full reference for Network Interface" {

            $json.outputs.networkInterface.value | should be "[reference(resourceId('Microsoft.Network/networkInterfaces', parameters('nicName')), '2018-11-01', 'Full')]"
        }
    }
}