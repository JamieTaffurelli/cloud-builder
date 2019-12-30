$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Autoscale Setting Parameter Validation" {

    Context "autoscaleSettingName Validation" {

        It "Has autoscaleSettingName parameter" {

            $json.parameters.autoscaleSettingName | should not be $null
        }

        It "autoscaleSettingName parameter is of type string" {

            $json.parameters.autoscaleSettingName.type | should be "string"
        }

        It "autoscaleSettingName parameter is mandatory" {

            ($json.parameters.autoscaleSettingName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "profiles Validation" {

        It "Has profiles parameter" {

            $json.parameters.profiles | should not be $null
        }

        It "profiles parameter is of type array" {

            $json.parameters.profiles.type | should be "array"
        }

        It "profiles parameter is mandatory" {

            ($json.parameters.profiles.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "sendToSubscriptionAdministrator Validation" {

        It "Has sendToSubscriptionAdministrator parameter" {

            $json.parameters.sendToSubscriptionAdministrator | should not be $null
        }

        It "sendToSubscriptionAdministrator parameter is of type bool" {

            $json.parameters.sendToSubscriptionAdministrator.type | should be "bool"
        }

        It "sendToSubscriptionAdministrator parameter default value is true" {

            $json.parameters.sendToSubscriptionAdministrator.defaultValue | should be $false
        }
    }

    Context "sendToSubscriptionCoAdministrators Validation" {

        It "Has sendToSubscriptionCoAdministrators parameter" {

            $json.parameters.sendToSubscriptionCoAdministrators | should not be $null
        }

        It "sendToSubscriptionCoAdministrators parameter is of type bool" {

            $json.parameters.sendToSubscriptionCoAdministrators.type | should be "bool"
        }
        
        It "sendToSubscriptionCoAdministrators parameter default value is true" {

            $json.parameters.sendToSubscriptionCoAdministrators.defaultValue | should be $false
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


    Context "webHooks Validation" {

        It "Has webHooks parameter" {

            $json.parameters.webHooks | should not be $null
        }

        It "webHooks parameter is of type array" {

            $json.parameters.webHooks.type | should be "array"
        }

        It "webHooks parameter default value is an empty array" {

            $json.parameters.webHooks.defaultValue | should be @()
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

    Context "targetResourceId Validation" {

        It "Has targetResourceId parameter" {

            $json.parameters.targetResourceId | should not be $null
        }

        It "targetResourceId parameter is of type string" {

            $json.parameters.targetResourceId.type | should be "string"
        }

        It "targetResourceId parameter is mandatory" {

            ($json.parameters.targetResourceId.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

Describe "Autoscale Setting Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/autoscaleSettings" {

            $json.resources.type | should be "Microsoft.Insights/autoscaleSettings"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2014-04-01" {

            $json.resources.apiVersion | should be "2014-04-01"
        }
    }
}

Describe "Autoscale Setting Output Validation" {

    Context "Autoscale Setting Reference Validation" {

        It "type value is object" {

            $json.outputs.autoscaleSetting.type | should be "object"
        }

        It "Uses full reference for Autoscale Setting" {

            $json.outputs.autoscaleSetting.value | should be "[reference(resourceId('Microsoft.Insights/autoscaleSettings', parameters('autoscaleSettingName')), '2014-04-01', 'Full')]"
        }
    }
}