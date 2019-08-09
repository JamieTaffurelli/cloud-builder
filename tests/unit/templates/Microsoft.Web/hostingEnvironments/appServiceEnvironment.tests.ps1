$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Application Service Environment Parameter Validation" {

    Context "aseName Validation" {

        It "Has aseName parameter" {

            $json.parameters.aseName | should not be $null
        }

        It "aseName parameter is of type string" {

            $json.parameters.aseName.type | should be "string"
        }

        It "aseName parameter is mandatory" {

            ($json.parameters.aseName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "vnetName Validation" {

        It "Has vnetName parameter" {

            $json.parameters.vnetName | should not be $null
        }

        It "vnetName parameter is of type string" {

            $json.parameters.vnetName.type | should be "string"
        }

        It "vnetName parameter is mandatory" {

            ($json.parameters.vnetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vnetResourceGroupName Validation" {

        It "Has vnetResourceGroupName parameter" {

            $json.parameters.vnetResourceGroupName | should not be $null
        }

        It "vnetResourceGroupName parameter is of type string" {

            $json.parameters.vnetResourceGroupName.type | should be "string"
        }

        It "vnetResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.vnetResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "vnetSubnetName Validation" {

        It "Has vnetSubnetName parameter" {

            $json.parameters.vnetSubnetName | should not be $null
        }

        It "vnetSubnetName parameter is of type string" {

            $json.parameters.vnetSubnetName.type | should be "string"
        }

        It "vnetSubnetName parameter is mandatory" {

            ($json.parameters.vnetSubnetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "internalLoadBalancingMode Validation" {

        It "Has internalLoadBalancingMode parameter" {

            $json.parameters.internalLoadBalancingMode | should not be $null
        }

        It "internalLoadBalancingMode parameter is of type string" {

            $json.parameters.internalLoadBalancingMode.type | should be "string"
        }

        It "internalLoadBalancingMode parameter default value is Web" {

            $json.parameters.internalLoadBalancingMode.defaultValue | should be "Web"
        }

        It "internalLoadBalancingMode parameter allowed values are 'None', 'Web', 'Publishing'" {

            (Compare-Object -ReferenceObject $json.parameters.internalLoadBalancingMode.allowedValues -DifferenceObject @("None", "Web", "Publishing")).Length | should be 0
        }
    }

    Context "multiSize Validation" {

        It "Has multiSize parameter" {

            $json.parameters.multiSize | should not be $null
        }

        It "multiSize parameter is of type string" {

            $json.parameters.multiSize.type | should be "string"
        }

        It "multiSize parameter default value is Small" {

            $json.parameters.multiSize.defaultValue | should be "Small"
        }

        It "multiSize parameter allowed values are 'Small', 'Medium', 'Large'" {

            (Compare-Object -ReferenceObject $json.parameters.multiSize.allowedValues -DifferenceObject @("Small", "Medium", "Large")).Length | should be 0
        }
    }

    Context "multiRoleCount Validation" {

        It "Has multiRoleCount parameter" {

            $json.parameters.multiRoleCount | should not be $null
        }

        It "multiRoleCount parameter is of type int" {

            $json.parameters.multiRoleCount.type | should be "int"
        }

        It "multiRoleCount parameter default value is 2" {

            $json.parameters.multiRoleCount.defaultValue | should be 2
        }
    }

    Context "dnsSuffix Validation" {

        It "Has dnsSuffix parameter" {

            $json.parameters.dnsSuffix | should not be $null
        }

        It "dnsSuffix parameter is of type string" {

            $json.parameters.dnsSuffix.type | should be "string"
        }

        It "dnsSuffix parameter is mandatory" {

            ($json.parameters.dnsSuffix.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "frontEndScaleFactor Validation" {

        It "Has frontEndScaleFactor parameter" {

            $json.parameters.frontEndScaleFactor | should not be $null
        }

        It "frontEndScaleFactor parameter is of type int" {

            $json.parameters.frontEndScaleFactor.type | should be "int"
        }

        It "frontEndScaleFactor parameter default value is 15" {

            $json.parameters.frontEndScaleFactor.defaultValue | should be 15
        }
    }

    Context "apiManagementAccountSubscriptionId Validation" {

        It "Has apiManagementAccountSubscriptionId parameter" {

            $json.parameters.apiManagementAccountSubscriptionId | should not be $null
        }

        It "apiManagementAccountSubscriptionId parameter is of type string" {

            $json.parameters.apiManagementAccountSubscriptionId.type | should be "string"
        }

        It "apiManagementAccountSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.apiManagementAccountSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "apiManagementAccountResourceGroupName Validation" {

        It "Has apiManagementAccountResourceGroupName parameter" {

            $json.parameters.apiManagementAccountResourceGroupName | should not be $null
        }

        It "apiManagementAccountResourceGroupName parameter is of type string" {

            $json.parameters.apiManagementAccountResourceGroupName.type | should be "string"
        }

        It "apiManagementAccountResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.apiManagementAccountResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "apiManagementAccountName Validation" {

        It "Has apiManagementAccountName parameter" {

            $json.parameters.apiManagementAccountName | should not be $null
        }

        It "apiManagementAccountName parameter is of type string" {

            $json.parameters.apiManagementAccountName.type | should be "string"
        }

        It "apiManagementAccountName parameter default value is an empty string" {

            $json.parameters.apiManagementAccountName.defaultValue | should be ([String]::Empty)
        }
    }

    Context "userWhitelistedIpRanges Validation" {

        It "Has userWhitelistedIpRanges parameter" {

            $json.parameters.userWhitelistedIpRanges | should not be $null
        }

        It "userWhitelistedIpRanges parameter is of type array" {

            $json.parameters.userWhitelistedIpRanges.type | should be "array"
        }

        It "userWhitelistedIpRanges parameter default value is an empty array" {

            $json.parameters.userWhitelistedIpRanges.defaultValue | should be @()
        }
    }

    Context "hasLinuxWorkers Validation" {

        It "Has hasLinuxWorkers parameter" {

            $json.parameters.hasLinuxWorkers | should not be $null
        }

        It "hasLinuxWorkers parameter is of type bool" {

            $json.parameters.hasLinuxWorkers.type | should be "bool"
        }

        It "hasLinuxWorkers parameter default value is false" {

            $json.parameters.hasLinuxWorkers.defaultValue | should be $false
        }
    }

    Context "sslKeyVaultSubscriptionId Validation" {

        It "Has sslKeyVaultSubscriptionId parameter" {

            $json.parameters.sslKeyVaultSubscriptionId | should not be $null
        }

        It "sslKeyVaultSubscriptionId parameter is of type string" {

            $json.parameters.sslKeyVaultSubscriptionId.type | should be "string"
        }

        It "sslKeyVaultSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.sslKeyVaultSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "sslKeyVaultResourceGroupName Validation" {

        It "Has sslKeyVaultResourceGroupName parameter" {

            $json.parameters.sslKeyVaultResourceGroupName | should not be $null
        }

        It "sslKeyVaultResourceGroupName parameter is of type string" {

            $json.parameters.sslKeyVaultResourceGroupName.type | should be "string"
        }

        It "sslKeyVaultResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.sslKeyVaultResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "sslKeyVaultName Validation" {

        It "Has sslKeyVaultName parameter" {

            $json.parameters.sslKeyVaultName | should not be $null
        }

        It "sslKeyVaultName parameter is of type string" {

            $json.parameters.sslKeyVaultName.type | should be "string"
        }

        It "sslKeyVaultName parameter default value is an empty string" {

            $json.parameters.sslKeyVaultName.defaultValue | should be ([String]::Empty)
        }
    }

    Context "sslKeyVaultSecretName Validation" {

        It "Has sslKeyVaultSecretName parameter" {

            $json.parameters.sslKeyVaultSecretName | should not be $null
        }

        It "sslKeyVaultSecretName parameter is of type string" {

            $json.parameters.sslKeyVaultSecretName.type | should be "string"
        }

        It "sslKeyVaultSecretName parameter default value is an empty string" {

            $json.parameters.sslKeyVaultSecretName.defaultValue | should be ([String]::Empty)
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

Describe "Application Service Environment Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Web/hostingEnvironments" {

            $json.resources.type | should be "Microsoft.Web/hostingEnvironments"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-02-01" {

            $json.resources.apiVersion | should be "2018-02-01"
        }
    }

    Context "Version Validation" {

        It "kind is ASEV2" {

            $json.resources.kind | should be "ASEV2"
        }
    }

    Context "Network ACL Validation" {

        It "defaultAction is Deny" {

            $json.variables.defaultAction | should be "Deny"
        }
    }
}
Describe "App Service Environment Output Validation" {

    Context "App Service Environment Reference Validation" {

        It "type value is object" {

            $json.outputs.ase.type | should be "object"
        }

        It "Uses full reference for App Service Environment" {

            $json.outputs.ase.value | should be "[reference(resourceId('Microsoft.Web/hostingEnvironments', parameters('aseName')), '2018-02-01', 'Full')]"
        }
    }
}