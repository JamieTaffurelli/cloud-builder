$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Application Service Environment Parameter Validation" {

    Context "aseName Validation" {

        It "Has aseName parameter" {

            $json.parameters.aseName | should not be $null
        }

        It "aseName parameter is of type string" {

            $json.parameters.aseName.type | should be "string"
        }

        It "aseName parameter is mandatory" {

            ($json.parameters.aseName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "vnetName Validation" {

        It "Has vnetName parameter" {

            $json.parameters.vnetName | should not be $null
        }

        It "vnetName parameter is of type string" {

            $json.parameters.vnetName.type | should be "string"
        }

        It "vnetName parameter is mandatory" {

            ($json.parameters.vnetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vnetResourceGroupName Validation" {

        It "Has vnetResourceGroupName parameter" {

            $json.parameters.vnetResourceGroupName | should not be $null
        }

        It "vnetResourceGroupName parameter is of type string" {

            $json.parameters.vnetResourceGroupName.type | should be "string"
        }

        It "vnetResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.vnetResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "vnetSubnetName Validation" {

        It "Has vnetSubnetName parameter" {

            $json.parameters.vnetSubnetName | should not be $null
        }

        It "vnetSubnetName parameter is of type string" {

            $json.parameters.vnetSubnetName.type | should be "string"
        }

        It "vnetSubnetName parameter is mandatory" {

            ($json.parameters.vnetSubnetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "internalLoadBalancingMode Validation" {

        It "Has internalLoadBalancingMode parameter" {

            $json.parameters.internalLoadBalancingMode | should not be $null
        }

        It "internalLoadBalancingMode parameter is of type string" {

            $json.parameters.internalLoadBalancingMode.type | should be "string"
        }

        It "internalLoadBalancingMode parameter default value is Web" {

            $json.parameters.internalLoadBalancingMode.defaultValue | should be "Web"
        }

        It "internalLoadBalancingMode parameter allowed values are 'None', 'Web', 'Publishing'" {

            (Compare-Object -ReferenceObject $json.parameters.internalLoadBalancingMode.allowedValues -DifferenceObject @("None", "Web", "Publishing")).Length | should be 0
        }
    }

    Context "multiSize Validation" {

        It "Has multiSize parameter" {

            $json.parameters.multiSize | should not be $null
        }

        It "multiSize parameter is of type string" {

            $json.parameters.multiSize.type | should be "string"
        }

        It "multiSize parameter default value is Standard_D1_V2" {

            $json.parameters.multiSize.defaultValue | should be "Standard_D1_V2"
        }

        It "multiSize parameter allowed values are 'Standard_D1_V2', 'Standard_D2_V2', 'Standard_D3_V2'" {

            (Compare-Object -ReferenceObject $json.parameters.multiSize.allowedValues -DifferenceObject @("Standard_D1_V2", "Standard_D2_V2", "Standard_D3_V2")).Length | should be 0
        }
    }

    Context "multiRoleCount Validation" {

        It "Has multiRoleCount parameter" {

            $json.parameters.multiRoleCount | should not be $null
        }

        It "multiRoleCount parameter is of type int" {

            $json.parameters.multiRoleCount.type | should be "int"
        }

        It "multiRoleCount parameter default value is 2" {

            $json.parameters.multiRoleCount.defaultValue | should be 2
        }
    }

    Context "dnsSuffix Validation" {

        It "Has dnsSuffix parameter" {

            $json.parameters.dnsSuffix | should not be $null
        }

        It "dnsSuffix parameter is of type string" {

            $json.parameters.dnsSuffix.type | should be "string"
        }

        It "dnsSuffix parameter is mandatory" {

            ($json.parameters.dnsSuffix.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "frontEndScaleFactor Validation" {

        It "Has frontEndScaleFactor parameter" {

            $json.parameters.frontEndScaleFactor | should not be $null
        }

        It "frontEndScaleFactor parameter is of type int" {

            $json.parameters.frontEndScaleFactor.type | should be "int"
        }

        It "frontEndScaleFactor parameter default value is 15" {

            $json.parameters.frontEndScaleFactor.defaultValue | should be 15
        }
    }

    Context "hasLinuxWorkers Validation" {

        It "Has hasLinuxWorkers parameter" {

            $json.parameters.hasLinuxWorkers | should not be $null
        }

        It "hasLinuxWorkers parameter is of type bool" {

            $json.parameters.hasLinuxWorkers.type | should be "bool"
        }

        It "hasLinuxWorkers parameter default value is false" {

            $json.parameters.hasLinuxWorkers.defaultValue | should be $false
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

Describe "Application Service Environment Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Web/hostingEnvironments" {

            $json.resources.type | should be "Microsoft.Web/hostingEnvironments"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-02-01" {

            $json.resources.apiVersion | should be "2018-02-01"
        }
    }

    Context "Version Validation" {

        It "kind is ASEV2" {

            $json.resources.kind | should be "ASEV2"
        }
    }

    Context "IP Address Validation" {

        It "ipSslAddressCount is 0" {

            $json.resources.properties.ipSslAddressCount | should be 0
        }
    }
}
Describe "App Service Environment Output Validation" {

    Context "App Service Environment Reference Validation" {

        It "type value is object" {

            $json.outputs.ase.type | should be "object"
        }

        It "Uses full reference for App Service Environment" {

            $json.outputs.ase.value | should be "[reference(resourceId('Microsoft.Web/hostingEnvironments', parameters('aseName')), '2018-02-01', 'Full')]"
        }
    }
}