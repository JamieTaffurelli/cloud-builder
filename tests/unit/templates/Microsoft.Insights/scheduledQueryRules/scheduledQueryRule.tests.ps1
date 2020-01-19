$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Scheduled Query Rule Parameter Validation" {

    Context "scheduledQueryRuleName Validation" {

        It "Has scheduledQueryRuleName parameter" {

            $json.parameters.scheduledQueryRuleName | should not be $null
        }

        It "scheduledQueryRuleName parameter is of type string" {

            $json.parameters.scheduledQueryRuleName.type | should be "string"
        }

        It "scheduledQueryRuleName parameter is mandatory" {

            ($json.parameters.scheduledQueryRuleName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "description Validation" {

        It "Has description parameter" {

            $json.parameters.description | should not be $null
        }

        It "description parameter is of type string" {

            $json.parameters.description.type | should be "string"
        }

        It "description parameter is mandatory" {

            ($json.parameters.description.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "enabled Validation" {

        It "Has enabled parameter" {

            $json.parameters.enabled | should not be $null
        }

        It "enabled parameter is of type string" {

            $json.parameters.enabled.type | should be "string"
        }

        It "enabled parameter default value is true" {

            $json.parameters.enabled.defaultValue | should be "true"
        }
    }

    Context "query Validation" {

        It "Has query parameter" {

            $json.parameters.query | should not be $null
        }

        It "query parameter is of type string" {

            $json.parameters.query.type | should be "string"
        }

        It "query parameter is mandatory" {

            ($json.parameters.query.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "authorizedResources Validation" {

        It "Has authorizedResources parameter" {

            $json.parameters.authorizedResources | should not be $null
        }

        It "authorizedResources parameter is of type array" {

            $json.parameters.authorizedResources.type | should be "array"
        }

        It "authorizedResources parameter default value is an empty array" {

            $json.parameters.authorizedResources.defaultValue | should be @()
        }
    }

    Context "dataSourceSubscriptionId Validation" {

        It "Has dataSourceSubscriptionId parameter" {

            $json.parameters.dataSourceSubscriptionId | should not be $null
        }

        It "dataSourceSubscriptionId parameter is of type string" {

            $json.parameters.dataSourceSubscriptionId.type | should be "string"
        }

        It "dataSourceSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.dataSourceSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "dataSourceResourceGroupName Validation" {

        It "Has dataSourceResourceGroupName parameter" {

            $json.parameters.dataSourceResourceGroupName | should not be $null
        }

        It "dataSourceResourceGroupName parameter is of type string" {

            $json.parameters.dataSourceResourceGroupName.type | should be "string"
        }

        It "dataSourceResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.dataSourceResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "dataSourceType Validation" {

        It "Has dataSourceType parameter" {

            $json.parameters.dataSourceType | should not be $null
        }

        It "dataSourceType parameter is of type string" {

            $json.parameters.dataSourceType.type | should be "string"
        }

        It "dataSourceType parameter default value is Microsoft.OperationalInsights/workspaces" {

            $json.parameters.dataSourceType.defaultValue | should be "Microsoft.OperationalInsights/workspaces"
        }

        It "dataSourceType parameter allowed values are Microsoft.OperationalInsights/workspaces, Microsoft.Insights/components" {

            (Compare-Object -ReferenceObject $json.parameters.dataSourceType.allowedValues -DifferenceObject @("Microsoft.OperationalInsights/workspaces", "Microsoft.Insights/components")).Length | should be 0
        }
    }

    Context "dataSourceName Validation" {

        It "Has dataSourceName parameter" {

            $json.parameters.dataSourceName | should not be $null
        }

        It "dataSourceName parameter is of type string" {

            $json.parameters.dataSourceName.type | should be "string"
        }

        It "dataSourceName parameter is mandatory" {

            ($json.parameters.dataSourceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "frequencyInMinutes Validation" {

        It "Has frequencyInMinutes parameter" {

            $json.parameters.frequencyInMinutes | should not be $null
        }

        It "frequencyInMinutes parameter is of type int" {

            $json.parameters.frequencyInMinutes.type | should be "int"
        }

        It "frequencyInMinutes parameter is mandatory" {

            ($json.parameters.frequencyInMinutes.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "timeWindowInMinutes Validation" {

        It "Has timeWindowInMinutes parameter" {

            $json.parameters.timeWindowInMinutes | should not be $null
        }

        It "timeWindowInMinutes parameter is of type int" {

            $json.parameters.timeWindowInMinutes.type | should be "int"
        }

        It "timeWindowInMinutes parameter is mandatory" {

            ($json.parameters.timeWindowInMinutes.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "severity Validation" {

        It "Has severity parameter" {

            $json.parameters.severity | should not be $null
        }

        It "severity parameter is of type int" {

            $json.parameters.severity.type | should be "int"
        }

        It "severity parameter is mandatory" {

            ($json.parameters.severity.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "severity parameter allowed values are web and other" {

            (Compare-Object -ReferenceObject $json.parameters.severity.allowedValues -DifferenceObject @(0, 1, 2, 3 , 4)).Length | should be 0
        }
    }

    Context "aznsAction Validation" {

        It "Has aznsAction parameter" {

            $json.parameters.aznsAction | should not be $null
        }

        It "aznsAction parameter is of type object" {

            $json.parameters.aznsAction.type | should be "object"
        }

        It "aznsAction parameter is mandatory" {

            ($json.parameters.aznsAction.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "trigger Validation" {

        It "Has trigger parameter" {

            $json.parameters.trigger | should not be $null
        }

        It "trigger parameter is of type object" {

            $json.parameters.trigger.type | should be "object"
        }

        It "trigger parameter is mandatory" {

            ($json.parameters.trigger.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Scheduled Query Rule Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/scheduledQueryRules" {

            $json.resources.type | should be "Microsoft.Insights/scheduledQueryRules"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-04-16" {

            $json.resources.apiVersion | should be "2018-04-16"
        }
    }

    Context "source Validation" {

        It "queryType is ResultCount" {

            $json.resources.properties.source.queryType | should be "ResultCount"
        }
    }
}

Describe "Scheduled Query Rule Output Validation" {

    Context "Scheduled Query Rule Reference Validation" {

        It "type value is object" {

            $json.outputs.scheduledQueryRule.type | should be "object"
        }

        It "Uses full reference for Scheduled Query Rule" {

            $json.outputs.scheduledQueryRule.value | should be "[reference(resourceId('Microsoft.Insights/scheduledQueryRules', parameters('scheduledQueryRuleName')), '2018-04-16', 'Full')]"
        }
    }
}