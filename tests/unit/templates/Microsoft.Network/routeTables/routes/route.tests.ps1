$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Route Parameter Validation" {

    Context "routeTableName Validation" {

        It "Has routeTableName parameter" {

            $json.parameters.routeTableName | should not be $null
        }

        It "routeTableName parameter is of type string" {

            $json.parameters.routeTableName.type | should be "string"
        }

        It "routeTableName parameter is mandatory" {

            ($json.parameters.routeTableName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "routeName Validation" {

        It "Has routeName parameter" {

            $json.parameters.routeTableName | should not be $null
        }

        It "routeName parameter is of type string" {

            $json.parameters.routeName.type | should be "string"
        }

        It "routeName parameter is mandatory" {

            ($json.parameters.routeName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "addressPrefix Validation" {

        It "Has addressPrefix parameter" {

            $json.parameters.addressPrefix | should not be $null
        }

        It "addressPrefix parameter is of type string" {

            $json.parameters.addressPrefix.type | should be "string"
        }

        It "addressPrefix parameter is mandatory" {

            ($json.parameters.addressPrefix.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "nextHopType Validation" {

        It "Has nextHopType parameter" {

            $json.parameters.nextHopType | should not be $null
        }

        It "nextHopType parameter is of type string" {

            $json.parameters.nextHopType.type | should be "string"
        }

        It "nextHopType parameter is mandatory" {

            ($json.parameters.nextHopType.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "nextHopType parameter allowed values are 'VirtualNetworkGateway', 'VnetLocal', 'Internet', 'VirtualAppliance', 'None'" {

            (Compare-Object -ReferenceObject $json.parameters.nextHopType.allowedValues -DifferenceObject @("VirtualNetworkGateway", "VnetLocal", "Internet", "VirtualAppliance", "None")).Length | should be 0
        }
    }

    Context "nextHopIpAddress Validation" {

        It "Has nextHopIpAddress parameter" {

            $json.parameters.nextHopIpAddress | should not be $null
        }

        It "nextHopIpAddress parameter is of type string" {

            $json.parameters.nextHopIpAddress.type | should be "string"
        }

        It "nextHopIpAddress parameter default value is an empty string" {

            $json.parameters.nextHopIpAddress.defaultValue | should be ([String]::Empty)
        }
    }
}

Describe "Route Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Network/routeTables/routes" {

            $json.resources.type | should be "Microsoft.Network/routeTables/routes"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $json.resources.apiVersion | should be "2019-04-01"
        }
    }
}

Describe "Route Output Validation" {

    Context "Route Reference Validation" {

        It "type value is object" {

            $json.outputs.route.type | should be "object"
        }

        It "Uses full reference for Route" {

            $json.outputs.route.value | should be "[reference(resourceId('Microsoft.Network/routeTables/routes', parameters('routeTableName'), parameters('routeName')), '2019-04-01', 'Full')]"
        }
    }
}