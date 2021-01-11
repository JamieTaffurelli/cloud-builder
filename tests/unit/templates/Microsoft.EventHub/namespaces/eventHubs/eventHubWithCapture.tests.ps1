$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Event Hub Namespace Parameter Validation" {

    Context "eventHubName Validation" {

        It "Has eventHubName parameter" {

            $json.parameters.eventHubName | should not be $null
        }

        It "eventHubName parameter is of type string" {

            $json.parameters.eventHubName.type | should be "string"
        }

        It "eventHubName parameter is mandatory" {

            ($json.parameters.eventHubName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "eventHubNamespaceName Validation" {

        It "Has eventHubNamespaceName parameter" {

            $json.parameters.eventHubNamespaceName | should not be $null
        }

        It "eventHubNamespaceName parameter is of type string" {

            $json.parameters.eventHubNamespaceName.type | should be "string"
        }

        It "eventHubNamespaceName parameter is mandatory" {

            ($json.parameters.eventHubNamespaceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "messageRetentionInDays Validation" {

        It "Has messageRetentionInDays parameter" {

            $json.parameters.messageRetentionInDays | should not be $null
        }

        It "messageRetentionInDays parameter is of type int" {

            $json.parameters.messageRetentionInDays.type | should be "int"
        }

        It "messageRetentionInDays parameter default value is 1" {

            $json.parameters.messageRetentionInDays.defaultValue | should be 1
        }

        It "messageRetentionInDays parameter is minValue is 1" {

            $json.parameters.messageRetentionInDays.minValue | should be 1
        }

        It "messageRetentionInDays parameter is maxValue is 7" {

            $json.parameters.messageRetentionInDays.maxValue | should be 7
        }
    }

    Context "partitionCount Validation" {

        It "Has partitionCount parameter" {

            $json.parameters.partitionCount | should not be $null
        }

        It "partitionCount parameter is of type int" {

            $json.parameters.partitionCount.type | should be "int"
        }

        It "partitionCount parameter is minValue is 2" {

            $json.parameters.partitionCount.minValue | should be 2
        }

        It "partitionCount parameter is maxValue is 32" {

            $json.parameters.partitionCount.maxValue | should be 32
        }
    }

    Context "intervalInSeconds Validation" {

        It "Has intervalInSeconds parameter" {

            $json.parameters.intervalInSeconds | should not be $null
        }

        It "intervalInSeconds parameter is of type int" {

            $json.parameters.intervalInSeconds.type | should be "int"
        }

        It "intervalInSeconds parameter default value is 300" {

            $json.parameters.intervalInSeconds.defaultValue | should be 300
        }

        It "intervalInSeconds parameter is minValue is 60" {

            $json.parameters.intervalInSeconds.minValue | should be 60
        }

        It "intervalInSeconds parameter is maxValue is 900" {

            $json.parameters.intervalInSeconds.maxValue | should be 900
        }
    }

    Context "sizeLimitInBytes Validation" {

        It "Has sizeLimitInBytes parameter" {

            $json.parameters.sizeLimitInBytes | should not be $null
        }

        It "sizeLimitInBytes parameter is of type int" {

            $json.parameters.sizeLimitInBytes.type | should be "int"
        }

        It "sizeLimitInBytes parameter default value is 30000000" {

            $json.parameters.sizeLimitInBytes.defaultValue | should be 30000000
        }

        It "sizeLimitInBytes parameter is minValue is 10485760" {

            $json.parameters.sizeLimitInBytes.minValue | should be 10485760
        }

        It "sizeLimitInBytes parameter is maxValue is 524288000" {

            $json.parameters.sizeLimitInBytes.maxValue | should be 524288000
        }
    }

    Context "captureResourceType Validation" {

        It "Has location parameter" {

            $json.parameters.captureResourceType | should not be $null
        }

        It "captureResourceType parameter is of type string" {

            $json.parameters.captureResourceType.type | should be "string"
        }

        It "captureResourceType parameter default value is DataLake" {

            $json.parameters.captureResourceType.defaultValue | should be "DataLake"
        }

        It "captureResourceType parameter allowed values are DataLake, StorageAccount" {

            (Compare-Object -ReferenceObject $json.parameters.captureResourceType.allowedValues -DifferenceObject @("DataLake", "StorageAccount")).Length | should be 0
        }
    }

    Context "captureResourceSubscriptionId Validation" {

        It "Has captureResourceSubscriptionId parameter" {

            $json.parameters.captureResourceSubscriptionId | should not be $null
        }

        It "captureResourceSubscriptionId parameter is of type string" {

            $json.parameters.captureResourceSubscriptionId.type | should be "string"
        }

        It "captureResourceSubscriptionId parameter default value is [subscription().subscriptionId]" {

            $json.parameters.captureResourceSubscriptionId.defaultValue | should be "[subscription().subscriptionId]"
        }
    }

    Context "captureResourceResourceGroupName Validation" {

        It "Has captureResourceResourceGroupName parameter" {

            $json.parameters.captureResourceResourceGroupName | should not be $null
        }

        It "captureResourceResourceGroupName parameter is of type string" {

            $json.parameters.captureResourceResourceGroupName.type | should be "string"
        }

        It "captureResourceResourceGroupName parameter default value is [resourceGroup().name]" {

            $json.parameters.captureResourceResourceGroupName.defaultValue | should be "[resourceGroup().name]"
        }
    }

    Context "captureResourceName Validation" {

        It "Has captureResourceName parameter" {

            $json.parameters.captureResourceName | should not be $null
        }

        It "captureResourceName parameter is of type string" {

            $json.parameters.captureResourceName.type | should be "string"
        }

        It "captureResourceName parameter is mandatory" {

            ($json.parameters.captureResourceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "captureLocation Validation" {

        It "Has captureLocation parameter" {

            $json.parameters.captureLocation | should not be $null
        }

        It "captureLocation parameter is of type string" {

            $json.parameters.captureLocation.type | should be "string"
        }

        It "captureLocation parameter is mandatory" {

            ($json.parameters.captureLocation.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "captureNameFormat Validation" {

        It "Has captureNameFormat parameter" {

            $json.parameters.captureNameFormat | should not be $null
        }

        It "captureNameFormat parameter is of type string" {

            $json.parameters.captureNameFormat.type | should be "string"
        }

        It "captureNameFormat parameter default value is {Namespace}/{EventHub}/{Year}{Month}{Day}/{Hour}/{Minute}/{Second}_{PartitionId}_N" {

            $json.parameters.captureNameFormat.defaultValue | should be "{Namespace}/{EventHub}/{Year}{Month}{Day}/{Hour}/{Minute}/{Second}_{PartitionId}_N"
        }
    }

    Context "skipEmptyArchives Validation" {

        It "Has skipEmptyArchives parameter" {

            $json.parameters.skipEmptyArchives | should not be $null
        }

        It "skipEmptyArchives parameter is of type bool" {

            $json.parameters.skipEmptyArchives.type | should be "bool"
        }

        It "skipEmptyArchives parameter default value is true" {

            $json.parameters.skipEmptyArchives.defaultValue | should be $true
        }
    }
}

Describe "Event Hub Namespace Resource Validation" {

    $eventHub = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.EventHub/namespaces/eventHubs" }

    Context "type Validation" {

        It "type value is Microsoft.EventHub/namespaces/eventHubs" {

            $eventHub.type | should be "Microsoft.EventHub/namespaces/eventHubs"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2017-04-01" {

            $eventHub.apiVersion | should be "2017-04-01"
        }
    }
}