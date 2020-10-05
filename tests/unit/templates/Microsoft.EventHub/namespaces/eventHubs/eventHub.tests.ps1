$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
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