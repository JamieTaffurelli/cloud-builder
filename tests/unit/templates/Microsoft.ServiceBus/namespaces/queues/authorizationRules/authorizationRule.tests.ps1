$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Authorization Rule Parameter Validation" {

    Context "authorizationRuleName Validation" {

        It "Has authorizationRuleName parameter" {

            $json.parameters.authorizationRuleName | should not be $null
        }

        It "authorizationRuleName parameter is of type string" {

            $json.parameters.authorizationRuleName.type | should be "string"
        }

        It "authorizationRuleName parameter is mandatory" {

            ($json.parameters.authorizationRuleName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "rights Validation" {

        It "Has rights parameter" {

            $json.parameters.rights | should not be $null
        }

        It "rights parameter is of type array" {

            $json.parameters.rights.type | should be "array"
        }

        It "rights parameter is mandatory" {

            ($json.parameters.rights.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "Authorization Rule Resource Validation" {

    $authorizationRule = $json.resources | Where-Object { $PSItem.type -eq "Microsoft.ServiceBus/namespaces/queues/authorizationRules" }

    Context "type Validation" {

        It "type value is Microsoft.ServiceBus/namespaces/queues/authorizationRules" {

            $authorizationRule.type | should be "Microsoft.ServiceBus/namespaces/queues/authorizationRules"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-01-01-preview" {

            $authorizationRule.apiVersion | should be "2018-01-01-preview"
        }
    }
}

Describe "Authorization Rule Output Validation" {

    Context "Authorization Rule Reference Validation" {

        It "type value is object" {

            $json.outputs.authorizationRule.type | should be "object"
        }

        It "Uses full reference for Authorization Rule" {

            $json.outputs.authorizationRule.value | should be "[reference(resourceId('Microsoft.ServiceBus/namespaces/queues/authorizationRules', parameters('serviceBusName'), parameters('queueName'), parameters('authorizationRuleName')), '2018-01-01-preview', 'Full')]"
        }
    }
}