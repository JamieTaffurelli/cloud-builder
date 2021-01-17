$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Application Service Plan Certificate Parameter Validation" {

    Context "certName Validation" {

        It "Has certName parameter" {

            $json.parameters.certName | should not be $null
        }

        It "certName parameter is of type string" {

            $json.parameters.certName.type | should be "string"
        }

        It "certName parameter is mandatory" {

            ($json.parameters.certName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "hostNames Validation" {

        It "Has hostNames parameter" {

            $json.parameters.hostNames | should not be $null
        }

        It "hostNames parameter is of type array" {

            $json.parameters.hostNames.type | should be "array"
        }

        It "hostNames parameter is mandatory" {

            ($json.parameters.hostNames.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "password Validation" {

        It "Has password parameter" {

            $json.parameters.password | should not be $null
        }

        It "password parameter is of type securestring" {

            $json.parameters.password.type | should be "securestring"
        }

        It "password parameter is mandatory" {

            ($json.parameters.password.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "keyVaultSubscriptionId Validation" {

        It "Has keyVaultSubscriptionId parameter" {

            $json.parameters.keyVaultSubscriptionId | should not be $null
        }

        It "keyVaultSubscriptionId parameter is of type string" {

            $json.parameters.keyVaultSubscriptionId.type | should be "string"
        }

        It "keyVaultSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.keyVaultSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "KeyVaultResourceGroupName Validation" {

        It "Has KeyVaultResourceGroupName parameter" {

            $json.parameters.KeyVaultResourceGroupName | should not be $null
        }

        It "KeyVaultResourceGroupName parameter is of type string" {

            $json.parameters.KeyVaultResourceGroupName.type | should be "string"
        }

        It "KeyVaultResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.KeyVaultResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "KeyVaultName Validation" {

        It "Has KeyVaultName parameter" {

            $json.parameters.KeyVaultName | should not be $null
        }

        It "KeyVaultName parameter is of type string" {

            $json.parameters.KeyVaultName.type | should be "string"
        }

        It "KeyVaultName parameter is mandatory" {

            ($json.parameters.KeyVaultName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "secretName Validation" {

        It "Has secretName parameter" {

            $json.parameters.secretName | should not be $null
        }

        It "secretName parameter is of type string" {

            $json.parameters.secretName.type | should be "string"
        }

        It "secretName parameter is mandatory" {

            ($json.parameters.secretName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "appServicePlanSubscriptionId Validation" {

        It "Has appServicePlanSubscriptionId parameter" {

            $json.parameters.appServicePlanSubscriptionId | should not be $null
        }

        It "appServicePlanSubscriptionId parameter is of type string" {

            $json.parameters.appServicePlanSubscriptionId.type | should be "string"
        }

        It "appServicePlanSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appServicePlanSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appServicePlanResourceGroupName Validation" {

        It "Has appServicePlanResourceGroupName parameter" {

            $json.parameters.appServicePlanResourceGroupName | should not be $null
        }

        It "appServicePlanResourceGroupName parameter is of type string" {

            $json.parameters.appServicePlanResourceGroupName.type | should be "string"
        }

        It "appServicePlanResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appServicePlanResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "appServicePlanName Validation" {

        It "Has appServicePlanName parameter" {

            $json.parameters.appServicePlanName | should not be $null
        }

        It "appServicePlanName parameter is of type string" {

            $json.parameters.appServicePlanName.type | should be "string"
        }

        It "appServicePlanName parameter is mandatory" {

            ($json.parameters.appServicePlanName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Application Service Plan Certificate Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Web/certificates" {

            $json.resources.type | should be "Microsoft.Web/certificates"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-08-01" {

            $json.resources.apiVersion | should be "2019-08-01"
        }
    }
}