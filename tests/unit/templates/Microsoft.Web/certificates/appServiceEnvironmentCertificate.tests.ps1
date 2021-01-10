$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Application Service Environment Certificate Parameter Validation" {

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

    Context "pfxString Validation" {

        It "Has pfxString parameter" {

            $json.parameters.pfxString | should not be $null
        }

        It "pfxString parameter is of type securestring" {

            $json.parameters.pfxString.type | should be "securestring"
        }

        It "pfxString parameter is mandatory" {

            ($json.parameters.pfxString.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "appServiceEnvironmentSubscriptionId Validation" {

        It "Has appServiceEnvironmentSubscriptionId parameter" {

            $json.parameters.appServiceEnvironmentSubscriptionId | should not be $null
        }

        It "appServiceEnvironmentSubscriptionId parameter is of type string" {

            $json.parameters.appServiceEnvironmentSubscriptionId.type | should be "string"
        }

        It "appServiceEnvironmentSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appServiceEnvironmentSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appServiceEnvironmentResourceGroupName Validation" {

        It "Has appServiceEnvironmentResourceGroupName parameter" {

            $json.parameters.appServiceEnvironmentResourceGroupName | should not be $null
        }

        It "appServiceEnvironmentResourceGroupName parameter is of type string" {

            $json.parameters.appServiceEnvironmentResourceGroupName.type | should be "string"
        }

        It "appServiceEnvironmentResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appServiceEnvironmentResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "appServiceEnvironmentName Validation" {

        It "Has appServiceEnvironmentName parameter" {

            $json.parameters.appServiceEnvironmentName | should not be $null
        }

        It "appServiceEnvironmentName parameter is of type string" {

            $json.parameters.appServiceEnvironmentName.type | should be "string"
        }

        It "appServiceEnvironmentName parameter is mandatory" {

            ($json.parameters.appServiceEnvironmentName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Application Service Environment Certificate Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Web/certificates" {

            $json.resources.type | should be "Microsoft.Web/certificates"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-08-01" {

            $json.resources.apiVersion | should be "2015-08-01"
        }
    }
}