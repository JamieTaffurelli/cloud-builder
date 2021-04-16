$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Resource Group Parameter Validation" {

    Context "resourceGroupName Validation" {

        It "Has resourceGroupName parameter" {

            $json.parameters.resourceGroupName | should not be $null
        }

        It "resourceGroupName parameter is of type string" {

            $json.parameters.resourceGroupName.type | should be "string"
        }

        It "resourceGroupName parameter is mandatory" {

            ($json.parameters.resourceGroupName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "location Validation" {

        It "Has location parameter" {

            $json.parameters.location | should not be $null
        }

        It "location parameter is of type string" {

            $json.parameters.location.type | should be "string"
        }

        It "location parameter is mandatory" {

            ($json.parameters.location.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Resource Group Resource Validation" {

    $resourceGroup = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Resources/resourceGroups" }

    Context "type Validation" {

        It "type value is Microsoft.Resources/resourceGroups" {

            $resourceGroup.type | should be "Microsoft.Resources/resourceGroups"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-06-01" {

            $resourceGroup.apiVersion | should be "2020-06-01"
        }
    }
}

Describe "Resource Group Output Validation" {

    Context "Resource Group Reference Validation" {

        It "type value is object" {

            $json.outputs.resourceGroup.type | should be "object"
        }

        It "Uses full reference for Resource Group" {

            $json.outputs.resourceGroup.value | should be "[reference(resourceId('Microsoft.Resources/resourceGroups', parameters('resourceGroupName')), '2020-06-01', 'Full')]"
        }
    }
}