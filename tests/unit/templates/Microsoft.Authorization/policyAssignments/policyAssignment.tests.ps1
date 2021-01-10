$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Policy Assignment Parameter Validation" {

    Context "policyAssignmentName Validation" {

        It "Has policyAssignmentName parameter" {

            $json.parameters.policyAssignmentName | should not be $null
        }

        It "policyAssignmentName parameter is of type string" {

            $json.parameters.policyAssignmentName.type | should be "string"
        }

        It "policyAssignmentName parameter is mandatory" {

            ($json.parameters.policyAssignmentName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "policyDefinitionType Validation" {

        It "Has policyDefinitionType parameter" {

            $json.parameters.policyDefinitionType | should not be $null
        }

        It "policyDefinitionType parameter is of type string" {

            $json.parameters.policyDefinitionType.type | should be "string"
        }

        It "policyDefinitionType parameter default value is Initiative" {

            $json.parameters.policyDefinitionType.defaultValue | should be "Initiative"
        }

        It "policyDefinitionType parameter allowed values are Initiative, Standard" {

            (Compare-Object -ReferenceObject $json.parameters.policyDefinitionType.allowedValues -DifferenceObject @("Initiative", "Standard")).Length | should be 0
        }
    }

    Context "notScopes Validation" {

        It "Has notScopes parameter" {

            $json.parameters.notScopes | should not be $null
        }

        It "notScopes parameter is of type array" {

            $json.parameters.notScopes.type | should be "array"
        }

        It "notScopes parameter default value is an empty array" {

            $json.parameters.notScopes.defaultValue | should be @()
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

            ($json.parameters.parameters.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "description Validation" {

        It "Has description parameter" {

            $json.parameters.description | should not be $null
        }

        It "parameters parameter is of type string" {

            $json.parameters.description.type | should be "string"
        }

        It "parameters parameter is mandatory" {

            ($json.parameters.description.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "enforcementMode Validation" {

        It "Has enforcementMode parameter" {

            $json.parameters.enforcementMode | should not be $null
        }

        It "enforcementMode parameter is of type string" {

            $json.parameters.enforcementMode.type | should be "string"
        }

        It "enforcementMode parameter default value is Default" {

            $json.parameters.enforcementMode.defaultValue | should be "Default"
        }

        It "enforcementMode parameter allowed values are Default, DoNotEnforce" {

            (Compare-Object -ReferenceObject $json.parameters.enforcementMode.allowedValues -DifferenceObject @("Default", "DoNotEnforce")).Length | should be 0
        }
    }

    Context "skuName Validation" {

        It "Has skuName parameter" {

            $json.parameters.skuName | should not be $null
        }

        It "skuName parameter is of type string" {

            $json.parameters.skuName.type | should be "string"
        }

        It "skuName parameter default value is A1" {

            $json.parameters.skuName.defaultValue | should be "A1"
        }

        It "skuName parameter allowed values are A1, A0" {

            (Compare-Object -ReferenceObject $json.parameters.skuName.allowedValues -DifferenceObject @("A0", "A1")).Length | should be 0
        }
    }

    Context "skuTier Validation" {

        It "Has skuTier parameter" {

            $json.parameters.skuTier | should not be $null
        }

        It "skuTier parameter is of type string" {

            $json.parameters.skuTier.type | should be "string"
        }

        It "skuTier parameter default value is Standard" {

            $json.parameters.skuTier.defaultValue | should be "Standard"
        }

        It "skuTier parameter allowed values are Default, DoNotEnforce" {

            (Compare-Object -ReferenceObject $json.parameters.skuTier.allowedValues -DifferenceObject @("Free", "Standard")).Length | should be 0
        }
    }

    Context "resourceGroupName Validation" {

        It "Has resourceGroupName parameter" {

            $json.parameters.resourceGroupName | should not be $null
        }

        It "resourceGroupName parameter is of type string" {

            $json.parameters.resourceGroupName.type | should be "string"
        }

        It "resourceGroupName parameter default value is an empty string" {

            $json.parameters.resourceGroupName.defaultValue | should be ([String]::Empty)
        }
    }
}

Describe "Policy Assignment Resource Validation" {

    $roleAssignment = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Authorization/policyAssignments" }

    Context "type Validation" {

        It "type value is Microsoft.Authorization/policyAssignments" {

            $roleAssignment.type | should be "Microsoft.Authorization/policyAssignments"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-06-01" {

            $roleAssignment.apiVersion | should be "2019-06-01"
        }
    }
}