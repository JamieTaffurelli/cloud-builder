$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Flow Log Parameter Validation" {

    Context "flowLogName Validation" {

        It "Has flowLogName parameter" {

            $json.parameters.flowLogName | should not be $null
        }

        It "flowLogName parameter is of type string" {

            $json.parameters.flowLogName.type | should be "string"
        }

        It "flowLogName parameter is mandatory" {

            ($json.parameters.flowLogName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "networkWatcherName Validation" {

        It "Has networkWatcherName parameter" {

            $json.parameters.networkWatcherName | should not be $null
        }

        It "networkWatcherName parameter is of type string" {

            $json.parameters.networkWatcherName.type | should be "string"
        }

        It "networkWatcherName parameter is mandatory" {

            ($json.parameters.networkWatcherName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "nsgSubscriptionId Validation" {

        It "Has nsgSubscriptionId parameter" {

            $json.parameters.nsgSubscriptionId | should not be $null
        }

        It "nsgSubscriptionId parameter is of type string" {

            $json.parameters.nsgSubscriptionId.type | should be "string"
        }

        It "nsgSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.nsgSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "nsgResourceGroupName Validation" {

        It "Has nsgResourceGroupName parameter" {

            $json.parameters.nsgResourceGroupName | should not be $null
        }

        It "nsgResourceGroupName parameter is of type string" {

            $json.parameters.nsgResourceGroupName.type | should be "string"
        }

        It "nsgResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.nsgResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "nsgName Validation" {

        It "Has nsgName parameter" {

            $json.parameters.nsgName | should not be $null
        }

        It "nsgName parameter is of type string" {

            $json.parameters.nsgName.type | should be "string"
        }

        It "nsgName parameter is mandatory" {

            ($json.parameters.nsgName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "storageAccountSubscriptionId Validation" {

        It "Has storageAccountSubscriptionId parameter" {

            $json.parameters.storageAccountSubscriptionId | should not be $null
        }

        It "storageAccountSubscriptionId parameter is of type string" {

            $json.parameters.storageAccountSubscriptionId.type | should be "string"
        }

        It "storageAccountSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.storageAccountSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "storageAccountResourceGroupName Validation" {

        It "Has storageAccountResourceGroupName parameter" {

            $json.parameters.storageAccountResourceGroupName | should not be $null
        }

        It "storageAccountResourceGroupName parameter is of type string" {

            $json.parameters.storageAccountResourceGroupName.type | should be "string"
        }

        It "storageAccountResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.storageAccountResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "storageAccountName Validation" {

        It "Has storageAccountName parameter" {

            $json.parameters.storageAccountName | should not be $null
        }

        It "storageAccountName parameter is of type string" {

            $json.parameters.storageAccountName.type | should be "string"
        }

        It "storageAccountName parameter is mandatory" {

            ($json.parameters.storageAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "enabled Validation" {

        It "Has enabled parameter" {

            $json.parameters.enabled | should not be $null
        }

        It "enabled parameter is of type bool" {

            $json.parameters.enabled.type | should be "bool"
        }

        It "enabled parameter default value is true" {

            $json.parameters.enabled.defaultValue | should be $true
        }
    }

    Context "retentionInDays Validation" {

        It "Has retentionInDays parameter" {

            $json.parameters.retentionInDays | should not be $null
        }

        It "retentionInDays parameter is of type int" {

            $json.parameters.retentionInDays.type | should be "int"
        }

        It "retentionInDays parameter default value is 90" {

            $json.parameters.retentionInDays.defaultValue | should be 90
        }

        It "retentionInDays parameter minimum value is 1" {

            $json.parameters.retentionInDays.minValue | should be 1
        }

        It "retentionInDays parameter maximum value is 2048" {

            $json.parameters.retentionInDays.maxValue | should be 90
        }
    }

    Context "logAnalyticsId Validation" {

        It "Has logAnalyticsId parameter" {

            $json.parameters.logAnalyticsId | should not be $null
        }

        It "logAnalyticsId parameter is of type string" {

            $json.parameters.logAnalyticsId.type | should be "string"
        }

        It "logAnalyticsId parameter is mandatory" {

            ($json.parameters.logAnalyticsId.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "logAnalyticsLocation Validation" {

        It "Has logAnalyticsLocation parameter" {

            $json.parameters.logAnalyticsLocation | should not be $null
        }

        It "logAnalyticsLocation parameter is of type string" {

            $json.parameters.logAnalyticsLocation.type | should be "string"
        }

        It "logAnalyticsLocation parameter default value is [resourceGroup().location]" {

            $json.parameters.logAnalyticsLocation.defaultValue | should be "[resourceGroup().location]"
        }

        It "logAnalyticsLocation parameter allowed values are northeurope, westeurope" {

            (Compare-Object -ReferenceObject $json.parameters.logAnalyticsLocation.allowedValues -DifferenceObject @("northeurope", "westeurope")).Length | should be 0
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

    Context "trafficAnalyticsInterval Validation" {

        It "Has trafficAnalyticsInterval parameter" {

            $json.parameters.trafficAnalyticsInterval | should not be $null
        }

        It "trafficAnalyticsInterval parameter is of type int" {

            $json.parameters.trafficAnalyticsInterval.type | should be "int"
        }

        It "trafficAnalyticsInterval parameter default value is 10" {

            $json.parameters.trafficAnalyticsInterval.defaultValue | should be 10
        }

        It "trafficAnalyticsInterval parameter allowed values are northeurope, westeurope" {

            (Compare-Object -ReferenceObject $json.parameters.trafficAnalyticsInterval.allowedValues -DifferenceObject @(10, 60)).Length | should be 0
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

Describe "Flow Log Resource Validation" {

    $flowLog = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.Network/networkWatchers/flowLogs" }

    Context "type Validation" {

        It "type value is Microsoft.Network/networkWatchers/flowLogs" {

            $flowLog.type | should be "Microsoft.Network/networkWatchers/flowLogs"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-06-01" {

            $flowLog.apiVersion | should be "2020-06-01"
        }
    }

    Context "Version Validation" {

        It "Flow Log version is version 2" {

            $flowLog.properties.format.version | should be 2
        }
    }
}

Describe "Flow Log Output Validation" {

    Context "Flow Log Reference Validation" {

        It "type value is object" {

            $json.outputs.flowLog.type | should be "object"
        }

        It "Uses full reference for Flow Log" {

            $json.outputs.flowLog.value | should be "[reference(resourceId('Microsoft.Network/networkWatchers/flowLogs', parameters('networkWatcherName'), parameters('flowLogName')), '2020-06-01', 'Full')]"
        }
    }
}