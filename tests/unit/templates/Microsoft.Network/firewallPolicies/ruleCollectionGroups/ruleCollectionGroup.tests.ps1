$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Rule Collection Group Parameter Validation" {

    Context "ruleCollectionGroupName Validation" {

        It "Has ruleCollectionGroupName parameter" {

            $json.parameters.ruleCollectionGroupName | should not be $null
        }

        It "ruleCollectionGroupName parameter is of type string" {

            $json.parameters.ruleCollectionGroupName.type | should be "string"
        }

        It "ruleCollectionGroupName parameter is mandatory" {

            ($json.parameters.ruleCollectionGroupName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "firewallPolicyName Validation" {

        It "Has firewallPolicyName parameter" {

            $json.parameters.firewallPolicyName | should not be $null
        }

        It "firewallPolicyName parameter is of type string" {

            $json.parameters.firewallPolicyName.type | should be "string"
        }

        It "firewallPolicyName parameter is mandatory" {

            ($json.parameters.firewallPolicyName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "ruleCollections Validation" {

        It "Has ruleCollections parameter" {

            $json.parameters.ruleCollections | should not be $null
        }

        It "ruleCollections parameter is of type array" {

            $json.parameters.ruleCollections.type | should be "array"
        }

        It "ruleCollections parameter default value is an empty array" {

            $json.parameters.ruleCollections.defaultValue.Count | should be 0
        }
    }
}

Describe "Rule Collection Group Resource Validation" {

    $policy = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/firewallPolicies/ruleCollectionGroups" }

    Context "type Validation" {

        It "type value is Microsoft.Network/firewallPolicies/ruleCollectionGroups" {

            $policy.type | should be "Microsoft.Network/firewallPolicies/ruleCollectionGroups"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-07-01" {

            $policy.apiVersion | should be "2020-07-01"
        }
    }
}

Describe "Rule Collection Group Output Validation" {

    Context "Rule Collection Group Reference Validation" {

        It "type value is object" {

            $json.outputs.ruleCollectionGroup.type | should be "object"
        }

        It "Uses full reference for Rule Collection Group" {

            $json.outputs.ruleCollectionGroup.value | should be "[reference(resourceId('Microsoft.Network/firewallPolicies/ruleCollectionGroups', parameters('firewallPolicyName'), parameters('ruleCollectionGroupName')), '2020-07-01', 'Full')]"
        }
    }
}