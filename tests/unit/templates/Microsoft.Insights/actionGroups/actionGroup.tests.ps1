$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Action Group Parameter Validation" {

    Context "actionGroupName Validation" {

        It "Has actionGroupName parameter" {

            $json.parameters.actionGroupName | should not be $null
        }

        It "actionGroupName parameter is of type string" {

            $json.parameters.actionGroupName.type | should be "string"
        }

        It "actionGroupName parameter is mandatory" {

            ($json.parameters.actionGroupName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "groupShortName Validation" {

        It "Has groupShortName parameter" {

            $json.parameters.groupShortName | should not be $null
        }

        It "groupShortName parameter is of type string" {

            $json.parameters.groupShortName.type | should be "string"
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

    Context "emailReceivers Validation" {

        It "Has emailReceivers parameter" {

            $json.parameters.emailReceivers | should not be $null
        }

        It "emailReceivers parameter is of type array" {

            $json.parameters.emailReceivers.type | should be "array"
        }

        It "emailReceivers parameter default value is an empty array" {

            $json.parameters.emailReceivers.defaultValue | should be @()
        }
    }

    Context "smsReceivers Validation" {

        It "Has smsReceivers parameter" {

            $json.parameters.smsReceivers | should not be $null
        }

        It "smsReceivers parameter is of type array" {

            $json.parameters.smsReceivers.type | should be "array"
        }

        It "smsReceivers parameter default value is an empty array" {

            $json.parameters.smsReceivers.defaultValue | should be @()
        }
    }

    Context "webhookReceivers Validation" {

        It "Has webhookReceivers parameter" {

            $json.parameters.webhookReceivers | should not be $null
        }

        It "webhookReceivers parameter is of type array" {

            $json.parameters.webhookReceivers.type | should be "array"
        }

        It "webhookReceivers parameter default value is an empty array" {

            $json.parameters.webhookReceivers.defaultValue | should be @()
        }
    }

    Context "itsmReceivers Validation" {

        It "Has itsmReceivers parameter" {

            $json.parameters.itsmReceivers | should not be $null
        }

        It "itsmReceivers parameter is of type array" {

            $json.parameters.itsmReceivers.type | should be "array"
        }

        It "itsmReceivers parameter default value is an empty array" {

            $json.parameters.itsmReceivers.defaultValue | should be @()
        }
    }

    Context "azureAppPushReceivers Validation" {

        It "Has azureAppPushReceivers parameter" {

            $json.parameters.azureAppPushReceivers | should not be $null
        }

        It "azureAppPushReceivers parameter is of type array" {

            $json.parameters.azureAppPushReceivers.type | should be "array"
        }

        It "azureAppPushReceivers default value is an empty array" {

            $json.parameters.azureAppPushReceivers.defaultValue | should be @()
        }
    }

    Context "automationRunbookReceivers Validation" {

        It "Has automationRunbookReceivers parameter" {

            $json.parameters.automationRunbookReceivers | should not be $null
        }

        It "automationRunbookReceivers parameter is of type array" {

            $json.parameters.automationRunbookReceivers.type | should be "array"
        }

        It "automationRunbookReceivers parameter default value is an empty array" {

            $json.parameters.automationRunbookReceivers.defaultValue | should be @()
        }
    }

    Context "voiceReceivers Validation" {

        It "Has voiceReceivers parameter" {

            $json.parameters.voiceReceivers | should not be $null
        }

        It "voiceReceivers parameter is of type array" {

            $json.parameters.voiceReceivers.type | should be "array"
        }

        It "voiceReceivers parameter default value is an empty array" {

            $json.parameters.voiceReceivers.defaultValue | should be @()
        }
    }

    Context "logicAppReceivers Validation" {

        It "Has logicAppReceivers parameter" {

            $json.parameters.logicAppReceivers | should not be $null
        }

        It "logicAppReceivers parameter is of type array" {

            $json.parameters.logicAppReceivers.type | should be "array"
        }

        It "logicAppReceivers parameter default value is an empty array" {

            $json.parameters.logicAppReceivers.defaultValue | should be @()
        }
    }

    Context "azureFunctionReceivers Validation" {

        It "Has azureFunctionReceivers parameter" {

            $json.parameters.azureFunctionReceivers | should not be $null
        }

        It "azureFunctionReceivers parameter is of type array" {

            $json.parameters.azureFunctionReceivers.type | should be "array"
        }

        It "azureFunctionReceivers parameter default value is an empty array" {

            $json.parameters.azureFunctionReceivers.defaultValue | should be @()
        }
    }

    Context "armRoleReceivers Validation" {

        It "Has armRoleReceivers parameter" {

            $json.parameters.armRoleReceivers | should not be $null
        }

        It "armRoleReceivers parameter is of type array" {

            $json.parameters.armRoleReceivers.type | should be "array"
        }

        It "armRoleReceivers parameter default value is an empty array" {

            $json.parameters.armRoleReceivers.defaultValue | should be @()
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

Describe "Action Group Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/actionGroups" {

            $json.resources.type | should be "Microsoft.Insights/actionGroups"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-06-01" {

            $json.resources.apiVersion | should be "2019-06-01"
        }
    }
}

Describe "Action Group Output Validation" {

    Context "Action Group Reference Validation" {

        It "type value is object" {

            $json.outputs.actionGroup.type | should be "object"
        }

        It "Uses full reference for Action Group" {

            $json.outputs.actionGroup.value | should be "[reference(resourceId('Microsoft.Insights/actionGroups', parameters('actionGroupName')), '2019-06-01', 'Full')]"
        }
    }
}