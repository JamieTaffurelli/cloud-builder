$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Solution Parameter Validation" {

    Context "solutionName Validation" {

        It "Has solutionName parameter" {

            $json.parameters.solutionName | should not be $null
        }

        It "solutionName parameter is of type string" {

            $json.parameters.solutionName.type | should be "string"
        }

        It "solutionName parameter is mandatory" {

            ($json.parameters.solutionName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "publisher Validation" {

        It "Has publisher parameter" {

            $json.parameters.publisher | should not be $null
        }

        It "publisher parameter is of type string" {

            $json.parameters.publisher.type | should be "string"
        }

        It "publisher parameter default value is Microsoft" {

            $json.parameters.publisher.defaultValue | should be "Microsoft"
        }
    }

    Context "product Validation" {

        It "Has product parameter" {

            $json.parameters.product | should not be $null
        }

        It "product parameter is of type string" {

            $json.parameters.product.type | should be "string"
        }

        It "product parameter is mandatory" {

            ($json.parameters.product.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "logAnalyticsSubscriptionId Validation" {

        It "Has logAnalyticsSubscriptionId parameter" {

            $json.parameters.logAnalyticsSubscriptionId | should not be $null
        }

        It "logAnalyticsSubscriptionId parameter is of type string" {

            $json.parameters.logAnalyticsSubscriptionId.type | should be "string"
        }

        It "logAnalyticsSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.logAnalyticsSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "logAnalyticsResourceGroupName Validation" {

        It "Has logAnalyticsResourceGroupName parameter" {

            $json.parameters.logAnalyticsResourceGroupName | should not be $null
        }

        It "logAnalyticsResourceGroupName parameter is of type string" {

            $json.parameters.logAnalyticsResourceGroupName.type | should be "string"
        }

        It "logAnalyticsResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.logAnalyticsResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "logAnalyticsName Validation" {

        It "Has logAnalyticsName parameter" {

            $json.parameters.logAnalyticsName | should not be $null
        }

        It "logAnalyticsName parameter is of type string" {

            $json.parameters.logAnalyticsName.type | should be "string"
        }

        It "logAnalyticsName parameter is mandatory" {

            ($json.parameters.solutionName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Solution Validation" {

    Context "type Validation" {

        It "type value is Microsoft.OperationsManagement/solutions" {

            $json.resources.type | should be "Microsoft.OperationsManagement/solutions"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-11-01-preview" {

            $json.resources.apiVersion | should be "2015-11-01-preview"
        }
    }

    Context "location Validation" {

        It "location is westeurope" {

            $json.resources.location -eq "westeurope" | should be $true
        }
    }

    Context "promotionCode Validation" {

        It "promotionCode is an empty string" {

            $json.resources.plan.promotionCode | should be ([String]::Empty)
        }
    }
}

Describe "Solution Output Validation" {

    Context "Solution Reference Validation" {

        It "type value is object" {

            $json.outputs.solution.type | should be "object"
        }

        It "Uses full reference for Solution" {

            $json.outputs.solution.value | should be "[reference(resourceId('Microsoft.OperationsManagement/solutions', variables('name')), '2015-11-01-preview', 'Full')]"
        }
    }
}