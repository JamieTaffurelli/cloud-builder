$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "VM Protected Item Parameter Validation" {

    Context "backupPolicyName Validation" {

        It "Has backupPolicyName parameter" {

            $json.parameters.backupPolicyName | should not be $null
        }

        It "backupPolicyName parameter is of type string" {

            $json.parameters.backupPolicyName.type | should be "string"
        }

        It "backupPolicyName parameter is mandatory" {

            ($json.parameters.backupPolicyName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vaultName Validation" {

        It "Has vaultName parameter" {

            $json.parameters.vaultName | should not be $null
        }

        It "vaultName parameter is of type string" {

            $json.parameters.vaultName.type | should be "string"
        }

        It "vaultName parameter is mandatory" {

            ($json.parameters.vaultName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vmName Validation" {

        It "Has vmName parameter" {

            $json.parameters.vmName | should not be $null
        }

        It "vmName parameter is of type string" {

            $json.parameters.vmName.type | should be "string"
        }

        It "vmName parameter is mandatory" {

            ($json.parameters.vmName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vmResourceGroupName Validation" {

        It "Has vmResourceGroupName parameter" {

            $json.parameters.vmResourceGroupName | should not be $null
        }

        It "vmResourceGroupName parameter is of type string" {

            $json.parameters.vmResourceGroupName.type | should be "string"
        }

        It "vmResourceGroupName parameter is [resourceGroup().name]" {

            $json.parameters.vmResourceGroupName.defaultValue | should be "[resourceGroup().name]"
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

Describe "VM Protected Item Resource Validation" {

    $protectedItem = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems" }

    Context "type Validation" {

        It "type value is Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems" {

            $protectedItem.type | should be "Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-05-13" {

            $protectedItem.apiVersion | should be "2019-05-13"
        }
    }
}
Describe "VM Protected Item Output Validation" {

    Context "VM Protected Item Reference Validation" {

        It "type value is object" {

            $json.outputs.vmProtectedItem.type | should be "object"
        }

        It "Uses full reference for VM Protected Item" {

            $json.outputs.vmProtectedItem.value | should be "[reference(resourceId('Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems', parameters('vaultName'), variables('backupFabric'), variables('protectionContainer'), variables('protectedItem')), '2019-05-13', 'Full')]"
        }
    }
}