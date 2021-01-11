$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Policy Definition Parameter Validation" {

    Context "policyDefinitionName Validation" {

        It "Has policyDefinitionName parameter" {

            $json.parameters.policyDefinitionName | should not be $null
        }

        It "policyDefinitionName parameter is of type string" {

            $json.parameters.policyDefinitionName.type | should be "string"
        }

        It "policyDefinitionName parameter is mandatory" {

            ($json.parameters.policyDefinitionName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "policyType Validation" {

        It "Has policyType parameter" {

            $json.parameters.policyType | should not be $null
        }

        It "policyType parameter is of type string" {

            $json.parameters.policyType.type | should be "string"
        }

        It "policyType parameter default value is Custom" {

            $json.parameters.policyType.defaultValue | should be "Custom"
        }

        It "policyType parameter allowed values are BuiltIn, Custom, NotSpecified" {

            (Compare-Object -ReferenceObject $json.parameters.policyType.allowedValues -DifferenceObject @("BuiltIn", "Custom", "NotSpecified")).Length | should be 0
        }
    }

    Context "mode Validation" {

        It "Has mode parameter" {

            $json.parameters.mode | should not be $null
        }

        It "mode parameter is of type string" {

            $json.parameters.mode.type | should be "string"
        }

        It "mode parameter default value is All" {

            $json.parameters.mode.defaultValue | should be "All"
        }
    }

    Context "displayName Validation" {

        It "Has displayName parameter" {

            $json.parameters.displayName | should not be $null
        }

        It "displayName parameter is of type string" {

            $json.parameters.displayName.type | should be "string"
        }

        It "displayName parameter is mandatory" {

            ($json.parameters.displayName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "description Validation" {

        It "Has description parameter" {

            $json.parameters.description | should not be $null
        }

        It "description parameter is of type string" {

            $json.parameters.description.type | should be "string"
        }

        It "description parameter is mandatory" {

            ($json.parameters.description.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "policyRule Validation" {

        It "Has policyRule parameter" {

            $json.parameters.policyRule | should not be $null
        }

        It "policyRule parameter is of type object" {

            $json.parameters.policyRule.type | should be "object"
        }

        It "policyRule parameter is mandatory" {

            ($json.parameters.policyRule.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "metadata Validation" {

        It "Has metadata parameter" {

            $json.parameters.metadata | should not be $null
        }

        It "metadata parameter is of type object" {

            $json.parameters.metadata.type | should be "object"
        }

        It "metadata parameter is mandatory" {

            ($json.parameters.metadata.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "parameters Validation" {

        It "Has parameters parameter" {

            $json.parameters.parameters | should not be $null
        }

        It "parameters parameter is of type object" {

            $json.parameters.parameters.type | should be "object"
        }

        It "parameters parameter is mandatory" {

            ($json.parameters.parameters.PSObject.Properties.Name -contains "parameters") | should be $false
        }
    }
}

Describe "Policy Definition Resource Validation" {

    $roleAssignment = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Authorization/policyDefinitions" }

    Context "type Validation" {

        It "type value is Microsoft.Authorization/policyDefinitions" {

            $roleAssignment.type | should be "Microsoft.Authorization/policyDefinitions"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-06-01" {

            $roleAssignment.apiVersion | should be "2019-06-01"
        }
    }
}