$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Application Service Plan Parameter Validation" {

    Context "aspName Validation" {

        It "Has aspName parameter" {

            $json.parameters.aspName | should not be $null
        }

        It "aspName parameter is of type string" {

            $json.parameters.aspName.type | should be "string"
        }

        It "aspName parameter is mandatory" {

            ($json.parameters.aspName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "appServiceenvironmentSubscriptionId Validation" {

        It "Has appServiceenvironmentSubscriptionId parameter" {

            $json.parameters.appServiceenvironmentSubscriptionId | should not be $null
        }

        It "appServiceenvironmentSubscriptionId parameter is of type string" {

            $json.parameters.appServiceenvironmentSubscriptionId.type | should be "string"
        }

        It "appServiceenvironmentSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.appServiceenvironmentSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "appServiceenvironmentResourceGroupName Validation" {

        It "Has appServiceenvironmentResourceGroupName parameter" {

            $json.parameters.appServiceenvironmentResourceGroupName | should not be $null
        }

        It "appServiceenvironmentResourceGroupName parameter is of type string" {

            $json.parameters.appServiceenvironmentResourceGroupName.type | should be "string"
        }

        It "appServiceenvironmentResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.appServiceenvironmentResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "appServiceenvironmentName Validation" {

        It "Has appServiceenvironmentName parameter" {

            $json.parameters.appServiceenvironmentName | should not be $null
        }

        It "appServiceenvironmentName parameter is of type string" {

            $json.parameters.appServiceenvironmentName.type | should be "string"
        }

        It "appServiceenvironmentName parameter is mandatory" {

            ($json.parameters.appServiceenvironmentName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "minimumCapacity Validation" {

        It "Has minimumCapacity parameter" {

            $json.parameters.minimumCapacity | should not be $null
        }

        It "minimumCapacity parameter is of type int" {

            $json.parameters.minimumCapacity.type | should be "int"
        }

        It "minimumCapacity parameter default value is 1" {

            $json.parameters.minimumCapacity.defaultValue | should be 1
        }
    }

    Context "maximumCapacity Validation" {

        It "Has maximumCapacity parameter" {

            $json.parameters.maximumCapacity | should not be $null
        }

        It "maximumCapacity parameter is of type int" {

            $json.parameters.maximumCapacity.type | should be "int"
        }

        It "maximumCapacity parameter default value is 5" {

            $json.parameters.maximumCapacity.defaultValue | should be 5
        }
    }

    Context "defaultCapacity Validation" {

        It "Has defaultCapacity parameter" {

            $json.parameters.defaultCapacity | should not be $null
        }

        It "defaultCapacity parameter is of type int" {

            $json.parameters.defaultCapacity.type | should be "int"
        }

        It "defaultCapacity parameter default value is 2" {

            $json.parameters.defaultCapacity.defaultValue | should be 2
        }
    }

    Context "capabilities Validation" {

        It "Has capabilities parameter" {

            $json.parameters.capabilities | should not be $null
        }

        It "capabilities parameter is of type array" {

            $json.parameters.capabilities.type | should be "array"
        }

        It "capabilities parameter default value is an empty array" {

            $json.parameters.capabilities.defaultValue | should be @()
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

            $json.outputs.asp.type | should be "object"
        }

        It "Uses full reference for App Service Plan" {

            $json.outputs.asp.value | should be "[reference(resourceId('Microsoft.Web/serverFarms', parameters('aspName')), '2018-02-01', 'Full')]"
        }
    }
}