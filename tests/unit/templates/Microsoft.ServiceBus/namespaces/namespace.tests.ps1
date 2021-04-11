$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Service Bus Namespace Parameter Validation" {

    Context "serviceBusName Validation" {

        It "Has serviceBusName parameter" {

            $json.parameters.serviceBusName | should not be $null
        }

        It "serviceBusName parameter is of type string" {

            $json.parameters.serviceBusName.type | should be "string"
        }

        It "serviceBusName parameter is mandatory" {

            ($json.parameters.serviceBusName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "skuName Validation" {

        It "Has skuName parameter" {

            $json.parameters.skuName | should not be $null
        }

        It "skuName parameter is of type string" {

            $json.parameters.skuName.type | should be "string"
        }

        It "skuName parameter default value is Basic" {

            $json.parameters.skuName.defaultValue | should be "Basic"
        }

        It "skuName parameter allowed values are Basic, Standard, Premium" {

            (Compare-Object -ReferenceObject $json.parameters.skuName.allowedValues -DifferenceObject @("Basic", "Standard", "Premium")).Length | should be 0
        }
    }

    Context "capacity Validation" {

        It "Has capacity parameter" {

            $json.parameters.capacity | should not be $null
        }

        It "capacity parameter is of type int" {

            $json.parameters.capacity.type | should be "int"
        }

        It "capacity parameter default value is 1" {

            $json.parameters.capacity.defaultValue | should be 1
        }

        It "capacity parameter allowed values are 1, 2, 4" {

            (Compare-Object -ReferenceObject $json.parameters.capacity.allowedValues -DifferenceObject @(1, 2, 4)).Length | should be 0
        }
    }

    Context "zoneRedundant Validation" {

        It "Has zoneRedundant parameter" {

            $json.parameters.zoneRedundant | should not be $null
        }

        It "zoneRedundant parameter is of type bool" {

            $json.parameters.zoneRedundant.type | should be "bool"
        }

        It "zoneRedundant parameter default value is false" {

            $json.parameters.zoneRedundant.defaultValue | should be $false
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

            ($json.parameters.logAnalyticsName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Service Bus Namespace Resource Validation" {

    $serviceBus = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.ServiceBus/namespaces" }
    $diagnostics = $serviceBus.resources | Where-Object { $PSItem.type -eq "/providers/diagnosticSettings" }

    Context "type Validation" {

        It "type value is Microsoft.ServiceBus/namespaces" {

            $serviceBus.type | should be "Microsoft.ServiceBus/namespaces"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-01-01-preview" {

            $serviceBus.apiVersion | should be "2018-01-01-preview"
        }
    }

    Context "Managed Service Identity Validation" {

        It "Managed Service Identity is SystemAssigned" {

            $serviceBus.properties.identity.type -eq "SystemAssigned" | should be $true
        }
    }

    Context "Diagnostic Settings Validation" {

        It "type value is /providers/diagnosticSettings" {

            $diagnostics.type | should be "/providers/diagnosticSettings"
        }

        It "apiVersion value is 2015-07-01" {

            $diagnostics.apiVersion | should be "2015-07-01"
        }

        It "All metrics are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.metrics.category -DifferenceObject @("AllMetrics")).Length | should be 0
        }

        It "All logs are enabled" {

            (Compare-Object -ReferenceObject $diagnostics.properties.logs.category -DifferenceObject @("OperationalLogs")).Length | should be 0
        }
    }
}

Describe "Service Bus Namespace Output Validation" {

    Context "Service Bus Namespace Reference Validation" {

        It "type value is object" {

            $json.outputs.serviceBus.type | should be "object"
        }

        It "Uses full reference for Service Bus Namespace" {

            $json.outputs.serviceBus.value | should be "[reference(resourceId('Microsoft.ServiceBus/namespaces', parameters('serviceBusName')), '2018-01-01-preview', 'Full')]"
        }
    }
}