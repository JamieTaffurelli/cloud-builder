$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Route Table Parameter Validation" {

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

    Context "routeTableName Validation" {

        It "Has routeTableName parameter" {

            $json.parameters.routeTableName | should not be $null
        }

        It "routeTableName parameter is of type array" {

            $json.parameters.routeTableName.type | should be "array"
        }

        It "routeTableName parameter is mandatory" {

            ($json.parameters.routeTableName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "disableBgpRoutePropagation Validation" {

        It "Has disableBgpRoutePropagation parameter" {

            $json.parameters.disableBgpRoutePropagation | should not be $null
        }

        It "disableBgpRoutePropagation parameter is of type bool" {

            $json.parameters.disableBgpRoutePropagation.type | should be "bool"
        }

        It "disableBgpRoutePropagation parameter default value is false" {

            $json.parameters.disableBgpRoutePropagation.defaultValue | should be $false
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

Describe "Route Table Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Network/routeTables" {

            $json.resources.type | should be "Microsoft.Network/routeTables"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01" {

            $json.resources.apiVersion | should be "2019-04-01"
        }
    }
}

Describe "Route Table Output Validation" {

    Context "Route Table Reference Validation" {

        It "type value is object" {

            $json.outputs.routeTable.type | should be "object"
        }

        It "Uses full reference for Route Table" {

            $json.outputs.routeTable.value | should be "[reference(resourceId('Microsoft.Network/routeTables', parameters('routeTableName')), '2019-04-01', 'Full')]"
        }
    }
}