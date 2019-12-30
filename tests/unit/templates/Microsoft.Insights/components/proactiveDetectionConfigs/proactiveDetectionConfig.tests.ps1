$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Proactive Detection Config Parameter Validation" {

    Context "ruleDefinitionName Validation" {

        It "Has ruleDefinitionName parameter" {

            $json.parameters.ruleDefinitionName | should not be $null
        }

        It "ruleDefinitionName parameter is of type string" {

            $json.parameters.ruleDefinitionName.type | should be "string"
        }

        It "ruleDefinitionName parameter is mandatory" {

            ($json.parameters.ruleDefinitionName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "ruleDefinitionName parameter allowed values are web and other" {

            (Compare-Object -ReferenceObject $json.parameters.ruleDefinitionName.allowedValues -DifferenceObject @("slowpageloadtime", "slowserverresponsetime", "longdependencyduration", "degradationinserverresponsetime", "degradationindependencyduration", "extension_traceseveritydetector", "extension_exceptionchangeextension", "extension_memoryleakextension", "extension_securityextensionspackage", "extension_billingdatavolumedailyspikeextension")).Length | should be 0
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

    Context "appInsightsName Validation" {

        It "Has appInsightsName parameter" {

            $json.parameters.appInsightsName | should not be $null
        }

        It "appInsightsName parameter is of type string" {

            $json.parameters.appInsightsName.type | should be "string"
        }

        It "appInsightsName parameter is mandatory" {

            ($json.parameters.appInsightsName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "sendEmailsToSubscriptionOwners Validation" {

        It "Has sendEmailsToSubscriptionOwners parameter" {

            $json.parameters.sendEmailsToSubscriptionOwners | should not be $null
        }

        It "sendEmailsToSubscriptionOwners parameter is of type bool" {

            $json.parameters.sendEmailsToSubscriptionOwners.type | should be "bool"
        }

        It "sendEmailsToSubscriptionOwners parameter default value is false" {

            $json.parameters.sendEmailsToSubscriptionOwners.defaultValue | should be $false
        }
    }

    Context "customEmails Validation" {

        It "Has customEmails parameter" {

            $json.parameters.customEmails | should not be $null
        }

        It "customEmails parameter is of type array" {

            $json.parameters.customEmails.type | should be "array"
        }

        It "customEmails parameter default value is an empty array" {

            $json.parameters.customEmails.defaultValue | should be @()
        }
    }
}

Describe "Proactive Detection Config Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/components/proactiveDetectionConfigs" {

            $json.resources.type | should be "Microsoft.Insights/components/proactiveDetectionConfigs"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-05-01-preview" {

            $json.resources.apiVersion | should be "2018-05-01-preview"
        }
    }
}

Describe "Proactive Detection Config Output Validation" {

    Context "Proactive Detection Config Reference Validation" {

        It "type value is object" {

            $json.outputs.proactiveDetectionConfig.type | should be "object"
        }

        It "Uses full reference for Proactive Detection Config" {

            $json.outputs.proactiveDetectionConfig.value | should be "[reference(resourceId('Microsoft.Insights/components/proactiveDetectionConfigs', parameters('appInsightsName'), parameters('ruleDefinitionName')), '2018-05-01-preview', 'Full')]"
        }
    }
}