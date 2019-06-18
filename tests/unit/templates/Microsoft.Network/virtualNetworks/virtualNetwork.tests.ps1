$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
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

    Context "ddosProtectionPlanId Validation" {

        It "Has ddosProtectionPlanId parameter" {

            $json.parameters.ddosProtectionPlanId | should not be $null
        }

        It "ddosProtectionPlanId parameter is of type string" {

            $json.parameters.ddosProtectionPlanId.type | should be "string"
        }

        It "ddosProtectionPlanId parameter is mandatory" {

            ($json.parameters.ddosProtectionPlanId.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "type Validation" {

        It "type value is Microsoft.Network/virtualNetworks" {

            $json.resources.type | should be "Microsoft.Network/virtualNetworks"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $json.resources.apiVersion | should be "2018-11-01"
        }
    }

    Context "subnets Validation" {

        It "subnets variable must have Network Security Group" {

            $json.variables.subnets.copy.input.properties.networkSecurityGroup.id | should not be $null
        }

        It "subnets variable allows route table" {

            $json.variables.subnets.copy.input.properties.routeTable | should not be $null
        }

        It "subnets variable allows service endpoints" {

            $json.variables.subnets.copy.input.properties.serviceEndpoints | should not be $null
        }

        It "subnets property uses subnets variable" {

            $json.resources.properties.subnets | should be "[variables('subnets').subnets]"
        }
    }

    Context "enableVmProtection Validation" {

        It "enableVmProtection is true" {

            $json.resources.properties.enableVmProtection | should be $true
        }
    }

    Context "ddosProtectionPlan Validation" {

        It "ddosProtectionPlan id is required" {

            $json.resources.properties.ddosProtectionPlan.id | should be "[parameters('ddosProtectionPlanId')]"
        }
    }
}