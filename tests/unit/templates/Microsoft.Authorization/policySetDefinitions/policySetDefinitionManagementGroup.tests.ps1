$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Policy Set Definition Parameter Validation" {

    Context "policySetDefinitionName Validation" {

        It "Has policySetDefinitionName parameter" {

            $json.parameters.policySetDefinitionName | should not be $null
        }

        It "policySetDefinitionName parameter is of type string" {

            $json.parameters.policySetDefinitionName.type | should be "string"
        }

        It "policySetDefinitionName parameter is mandatory" {

            ($json.parameters.policySetDefinitionName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "policyDefinitions Validation" {

        It "Has policyDefinitions parameter" {

            $json.parameters.policyDefinitions | should not be $null
        }

        It "policyDefinitions parameter is of type array" {

            $json.parameters.policyDefinitions.type | should be "array"
        }

        It "policyDefinitions parameter is mandatory" {

            ($json.parameters.policyDefinitions.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Policy Set Definition Resource Validation" {

    $roleAssignment = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Authorization/policySetDefinitions" }

    Context "type Validation" {

        It "type value is Microsoft.Authorization/policySetDefinitions" {

            $roleAssignment.type | should be "Microsoft.Authorization/policySetDefinitions"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-06-01" {

            $roleAssignment.apiVersion | should be "2019-06-01"
        }
    }
}