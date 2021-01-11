$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Role Assignment Parameter Validation" {

    Context "roleDefinitionGuid Validation" {

        It "Has roleDefinitionGuid parameter" {

            $json.parameters.roleDefinitionGuid | should not be $null
        }

        It "roleDefinitionGuid parameter is of type string" {

            $json.parameters.roleDefinitionGuid.type | should be "string"
        }

        It "roleDefinitionGuid parameter is mandatory" {

            ($json.parameters.roleDefinitionGuid.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "principalGuid Validation" {

        It "Has principalGuid parameter" {

            $json.parameters.principalGuid | should not be $null
        }

        It "principalGuid parameter is of type string" {

            $json.parameters.principalGuid.type | should be "string"
        }

        It "principalGuid parameter is mandatory" {

            ($json.parameters.principalGuid.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "Role Assignment Resource Validation" {

    $roleAssignment = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Authorization/roleAssignments" }

    Context "type Validation" {

        It "type value is Microsoft.Authorization/roleAssignments" {

            $roleAssignment.type | should be "Microsoft.Authorization/roleAssignments"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-04-01-preview" {

            $roleAssignment.apiVersion | should be "2019-04-01-preview"
        }
    }
}

Describe "Role Assignment Output Validation" {

    Context "Role Assignment Reference Validation" {

        It "type value is object" {

            $json.outputs.roleAssignment.type | should be "object"
        }

        It "Uses full reference for Role Assignment" {

            $json.outputs.roleAssignment.value | should be "[reference(resourceId('Microsoft.Authorization/roleAssignments', variables('name')), '2019-04-01-preview', 'Full')]"
        }
    }
}