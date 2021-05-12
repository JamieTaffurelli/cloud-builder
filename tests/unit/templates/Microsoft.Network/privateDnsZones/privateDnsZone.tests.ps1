$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Private DNS Zone Parameter Validation" {

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

Describe "Private DNS Zone Resource Validation" {

    $zone = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/privateDnsZones" }

    Context "type Validation" {

        It "type value is Microsoft.Network/privateDnsZones" {

            $zone.type | should be "Microsoft.Network/privateDnsZones"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-06-01" {

            $zone.apiVersion | should be "2020-06-01"
        }
    }
}

Describe "Private DNS Zone Output Validation" {

    Context "Private DNS Zone Reference Validation" {

        It "type value is object" {

            $json.outputs.privateDnsZone.type | should be "object"
        }

        It "Uses full reference for Private DNS Zone" {

            $json.outputs.privateDnsZone.value | should be "[reference(resourceId('Microsoft.Network/privateDnsZones', parameters('privateDnsZoneName')), '2020-06-01', 'Full')]"
        }
    }
}