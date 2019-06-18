$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Network Security Group Parameter Validation" {

    Context "nsgName Validation" {

        It "Has nsgName parameter" {

            $json.parameters.nsgName | should not be $null
        }

        It "nsgName parameter is of type string" {

            $json.parameters.nsgName.type | should be "string"
        }

        It "nsgName parameter is mandatory" {

            ($json.parameters.nsgName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "nsgName parameter is minimum length is 1" {

            $json.parameters.nsgName.minLength | should be 1
        }

        It "nsgName parameter is maximum length is 80" {

            $json.parameters.nsgName.maxLength | should be 80
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

Describe "Network Security Group Output Validation" {

    Context "Network Security Group Reference Validation" {

        It "type value is object" {

            $json.outputs.networkSecurityGroup.type | should be "object"
        }

        It "Uses full reference for Network Security Group" {

            $json.outputs.networkSecurityGroup.value | should be "[reference(resourceId('Microsoft.Network/networkSecurityGroups', parameters('nsgName')), '2018-11-01', 'Full')]"
        }
    }
}