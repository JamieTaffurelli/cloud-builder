$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Service Bus Queue Parameter Validation" {

    Context "queueName Validation" {

        It "Has queueName parameter" {

            $json.parameters.queueName | should not be $null
        }

        It "queueName parameter is of type string" {

            $json.parameters.queueName.type | should be "string"
        }

        It "queueName parameter is mandatory" {

            ($json.parameters.queueName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

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

    Context "lockDuration Validation" {

        It "Has lockDuration parameter" {

            $json.parameters.lockDuration | should not be $null
        }

        It "lockDuration parameter is of type string" {

            $json.parameters.lockDuration.type | should be "string"
        }

        It "lockDuration parameter default value is PT1M" {

            $json.parameters.lockDuration.defaultValue | should be "PT1M"
        }
    }
    
    Context "maxSizeInMegabytes Validation" {

        It "Has maxSizeInMegabytes parameter" {

            $json.parameters.maxSizeInMegabytes | should not be $null
        }

        It "maxSizeInMegabytes parameter is of type int" {

            $json.parameters.maxSizeInMegabytes.type | should be "int"
        }

        It "maxSizeInMegabytes parameter default value is 1024" {

            $json.parameters.maxSizeInMegabytes.defaultValue | should be 1024
        }
    }

    Context "requiresDuplicateDetection Validation" {

        It "Has requiresDuplicateDetection parameter" {

            $json.parameters.requiresDuplicateDetection | should not be $null
        }

        It "requiresDuplicateDetection parameter is of type bool" {

            $json.parameters.requiresDuplicateDetection.type | should be "bool"
        }

        It "requiresDuplicateDetection parameter default value is false" {

            $json.parameters.requiresDuplicateDetection.defaultValue | should be $false
        }
    }

    Context "defaultMessageTimeToLive Validation" {

        It "Has defaultMessageTimeToLive parameter" {

            $json.parameters.defaultMessageTimeToLive | should not be $null
        }

        It "defaultMessageTimeToLive parameter is of type string" {

            $json.parameters.defaultMessageTimeToLive.type | should be "string"
        }

        It "defaultMessageTimeToLive parameter default value is P14D" {

            $json.parameters.defaultMessageTimeToLive.defaultValue | should be "P14D"
        }
    }

    Context "deadLetteringOnMessageExpiration Validation" {

        It "Has deadLetteringOnMessageExpiration parameter" {

            $json.parameters.deadLetteringOnMessageExpiration | should not be $null
        }

        It "deadLetteringOnMessageExpiration parameter is of type bool" {

            $json.parameters.deadLetteringOnMessageExpiration.type | should be "bool"
        }

        It "deadLetteringOnMessageExpiration parameter default value is false" {

            $json.parameters.deadLetteringOnMessageExpiration.defaultValue | should be $false
        }
    }

    Context "duplicateDetectionHistoryTimeWindow Validation" {

        It "Has duplicateDetectionHistoryTimeWindow parameter" {

            $json.parameters.duplicateDetectionHistoryTimeWindow | should not be $null
        }

        It "duplicateDetectionHistoryTimeWindow parameter is of type string" {

            $json.parameters.duplicateDetectionHistoryTimeWindow.type | should be "string"
        }

        It "duplicateDetectionHistoryTimeWindow parameter default value is PT10M" {

            $json.parameters.duplicateDetectionHistoryTimeWindow.defaultValue | should be "PT10M"
        }
    }

    Context "maxDeliveryCount Validation" {

        It "Has maxDeliveryCount parameter" {

            $json.parameters.maxDeliveryCount | should not be $null
        }

        It "maxDeliveryCount parameter is of type int" {

            $json.parameters.maxDeliveryCount.type | should be "int"
        }

        It "maxDeliveryCount parameter default value is false" {

            $json.parameters.maxDeliveryCount.defaultValue | should be 10
        }
    }

    Context "enableBatchedOperations Validation" {

        It "Has enableBatchedOperations parameter" {

            $json.parameters.enableBatchedOperations | should not be $null
        }

        It "enableBatchedOperations parameter is of type bool" {

            $json.parameters.enableBatchedOperations.type | should be "bool"
        }

        It "enableBatchedOperations parameter default value is true" {

            $json.parameters.enableBatchedOperations.defaultValue | should be $true
        }
    }

    Context "autoDeleteOnIdle Validation" {

        It "Has autoDeleteOnIdle parameter" {

            $json.parameters.autoDeleteOnIdle | should not be $null
        }

        It "autoDeleteOnIdle parameter is of type string" {

            $json.parameters.autoDeleteOnIdle.type | should be "string"
        }

        It "autoDeleteOnIdle parameter default value is an empty string" {

            $json.parameters.autoDeleteOnIdle.defaultValue | should be ([string]::Empty)
        }
    }

    Context "enablePartitioning Validation" {

        It "Has enablePartitioning parameter" {

            $json.parameters.enablePartitioning | should not be $null
        }

        It "enablePartitioning parameter is of type bool" {

            $json.parameters.enablePartitioning.type | should be "bool"
        }

        It "enablePartitioning parameter default value is false" {

            $json.parameters.enablePartitioning.defaultValue | should be $false
        }
    }

    Context "enableExpress Validation" {

        It "Has enableExpress parameter" {

            $json.parameters.enableExpress | should not be $null
        }

        It "enableExpress parameter is of type bool" {

            $json.parameters.enableExpress.type | should be "bool"
        }

        It "enableExpress parameter default value is false" {

            $json.parameters.enableExpress.defaultValue | should be $false
        }
    }

    Context "forwardTo Validation" {

        It "Has forwardTo parameter" {

            $json.parameters.forwardTo | should not be $null
        }

        It "forwardTo parameter is of type string" {

            $json.parameters.forwardTo.type | should be "string"
        }

        It "forwardTo parameter default value is an empty string" {

            $json.parameters.forwardTo.defaultValue | should be ([string]::Empty)
        }
    }

    Context "forwardDeadLetteredMessagesTo Validation" {

        It "Has forwardDeadLetteredMessagesTo parameter" {

            $json.parameters.forwardDeadLetteredMessagesTo | should not be $null
        }

        It "forwardDeadLetteredMessagesTo parameter is of type string" {

            $json.parameters.forwardDeadLetteredMessagesTo.type | should be "string"
        }

        It "forwardDeadLetteredMessagesTo parameter default value is an empty string" {

            $json.parameters.forwardDeadLetteredMessagesTo.defaultValue | should be ([string]::Empty)
        }
    }
}

Describe "Service Bus Queue Resource Validation" {

    $serviceBusQueue = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.ServiceBus/namespaces/queues" }

    Context "type Validation" {

        It "type value is Microsoft.ServiceBus/namespaces/queues" {

            $serviceBusQueue.type | should be "Microsoft.ServiceBus/namespaces/queues"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2017-04-01" {

            $serviceBusQueue.apiVersion | should be "2017-04-01"
        }
    }
}

Describe "Service Bus Queue Output Validation" {

    Context "Service Bus Queue Reference Validation" {

        It "type value is object" {

            $json.outputs.serviceBusQueue.type | should be "object"
        }

        It "Uses full reference for Service Bus Queue" {

            $json.outputs.serviceBusQueue.value | should be "[reference(resourceId('Microsoft.ServiceBus/namespaces/queues', parameters('serviceBusName'), parameters('queueName')), '2017-04-01', 'Full')]"
        }
    }
}