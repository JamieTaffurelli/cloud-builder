$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "A Record Parameter Validation" {

    Context "recordName Validation" {

        It "Has recordName parameter" {

            $json.parameters.recordName | should not be $null
        }

        It "recordName parameter is of type string" {

            $json.parameters.recordName.type | should be "string"
        }

        It "recordName parameter is mandatory" {

            ($json.parameters.recordName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "properties Validation" {

        It "Has properties parameter" {

            $json.parameters.properties | should not be $null
        }

        It "properties parameter is of type object" {

            $json.parameters.properties.type | should be "object"
        }

        It "properties parameter is mandatory" {

            ($json.parameters.recordName.PSObject.Properties.Name -contains "object") | should be $false
        }
    }
}

Describe "A Record Resource Validation" {

    $aRecord = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/privateDnsZones/A" }

    Context "type Validation" {

        It "type value is Microsoft.Network/privateDnsZones/A" {

            $aRecord.type | should be "Microsoft.Network/privateDnsZones/A"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-06-01" {

            $aRecord.apiVersion | should be "2020-06-01"
        }
    }
}

Describe "A Record Output Validation" {

    Context "A Record Reference Validation" {

        It "type value is object" {

            $json.outputs.aRecord.type | should be "object"
        }

        It "Uses full reference for A Record" {

            $json.outputs.aRecord.value | should be "[reference(resourceId('Microsoft.Network/privateDnsZones/A', parameters('privateDnsZoneName'), parameters('recordName')), '2020-06-01', 'Full')]"
        }
    }
}