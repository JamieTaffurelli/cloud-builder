$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Application Service Plan Parameter Validation" {

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

    Context "kind Validation" {

        It "Has kind parameter" {

            $json.parameters.kind | should not be $null
        }

        It "kind parameter is of type string" {

            $json.parameters.kind.type | should be "string"
        }

        It "kind parameter default value is Windows" {

            $json.parameters.kind.defaultValue | should be "Windows"
        }

        It "kind parameter allowed values are 'Windows', 'Linux', 'FunctionApp', 'Elastic'" {

            (Compare-Object -ReferenceObject $json.parameters.kind.allowedValues -DifferenceObject @("Windows", "Linux", "FunctionApp", "Elastic")).Length | should be 0
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

    Context "perSiteScaling Validation" {

        It "Has perSiteScaling parameter" {

            $json.parameters.perSiteScaling | should not be $null
        }

        It "perSiteScaling parameter is of type bool" {

            $json.parameters.perSiteScaling.type | should be "bool"
        }

        It "perSiteScaling parameter default value is true" {

            $json.parameters.perSiteScaling.defaultValue | should be $true
        }
    }

    Context "maximumElasticWorkerCount Validation" {

        It "Has maximumElasticWorkerCount parameter" {

            $json.parameters.maximumElasticWorkerCount | should not be $null
        }

        It "maximumElasticWorkerCount parameter is of type int" {

            $json.parameters.maximumElasticWorkerCount.type | should be "int"
        }

        It "maximumElasticWorkerCount parameter default value is 5" {

            $json.parameters.maximumElasticWorkerCount.defaultValue | should be 5
        }
    }

    Context "skuSize Validation" {

        It "Has skuSize parameter" {

            $json.parameters.skuSize | should not be $null
        }

        It "skuSize parameter is of type string" {

            $json.parameters.skuSize.type | should be "string"
        }

        It "skuSize parameter default value is Small" {

            $json.parameters.skuSize.defaultValue | should be "Small"
        }

        It "skuSize parameter allowed values are 'Small', 'Medium', 'Large'" {

            (Compare-Object -ReferenceObject $json.parameters.skuSize.allowedValues -DifferenceObject @("Small", "Medium", "Large")).Length | should be 0
        }
    }

    Context "capacity Validation" {

        It "Has capacity parameter" {

            $json.parameters.capacity | should not be $null
        }

        It "capacity parameter is of type int" {

            $json.parameters.capacity.type | should be "int"
        }

        It "capacity parameter default value is 2" {

            $json.parameters.capacity.defaultValue | should be 2
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

Describe "Application Service Plan Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Web/serverFarms" {

            $json.resources.type | should be "Microsoft.Web/serverFarms"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-02-01" {

            $json.resources.apiVersion | should be "2018-02-01"
        }
    }

    Context "Sku Validation" {

        It "tier is Isolated" {

            $json.resources.sku.tier | should be "Isolated"
        }

        It "family is I" {

            $json.resources.sku.family | should be "I"
        }
    }
}
Describe "App Service Plan Output Validation" {

    Context "App Service Plan Reference Validation" {

        It "type value is object" {

            $json.outputs.appServicePlan.type | should be "object"
        }

        It "Uses full reference for App Service Plan" {

            $json.outputs.appServicePlan.value | should be "[reference(resourceId('Microsoft.Web/serverFarms', parameters('appServicePlanName')), '2018-02-01', 'Full')]"
        }
    }
}