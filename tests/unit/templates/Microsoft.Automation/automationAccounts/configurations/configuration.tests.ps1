$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Configuration Parameter Validation" {

    Context "configurationName Validation" {

        It "Has configurationName parameter" {

            $json.parameters.configurationName | should not be $null
        }

        It "configurationName parameter is of type string" {

            $json.parameters.configurationName.type | should be "string"
        }

        It "configurationName parameter is mandatory" {

            ($json.parameters.configurationName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "automationAccountName Validation" {

        It "Has automationAccountName parameter" {

            $json.parameters.automationAccountName | should not be $null
        }

        It "automationAccountName parameter is of type string" {

            $json.parameters.automationAccountName.type | should be "string"
        }

        It "automationAccountName parameter is mandatory" {

            ($json.parameters.automationAccountName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "logVerbose Validation" {

        It "Has logVerbose parameter" {

            $json.parameters.logVerbose | should not be $null
        }

        It "logVerbose parameter is of type bool" {

            $json.parameters.logVerbose.type | should be "bool"
        }

        It "logVerbose parameter default value is true" {

            $json.parameters.logVerbose.defaultValue | should be $true
        }
    }

    Context "logProgress Validation" {

        It "Has logProgress parameter" {

            $json.parameters.logProgress | should not be $null
        }

        It "logProgress parameter is of type bool" {

            $json.parameters.logProgress.type | should be "bool"
        }

        It "logProgress parameter default value is true" {

            $json.parameters.logProgress.defaultValue | should be $true
        }
    }

    Context "storageAccountContainerUrl Validation" {

        It "Has storageAccountContainerUrl parameter" {

            $json.parameters.storageAccountContainerUrl | should not be $null
        }

        It "storageAccountContainerUrl parameter is of type securestring" {

            $json.parameters.storageAccountContainerUrl.type | should be "string"
        }

        It "storageAccountContainerUrl parameter is mandatory" {

            ($json.parameters.storageAccountContainerUrl.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "sasToken Validation" {

        It "Has sasToken parameter" {

            $json.parameters.sasToken | should not be $null
        }

        It "sasToken parameter is of type securestring" {

            $json.parameters.sasToken.type | should be "securestring"
        }

        It "sasToken parameter is mandatory" {

            ($json.parameters.sasToken.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "configurationVersion Validation" {

        It "Has configurationVersion parameter" {

            $json.parameters.configurationVersion | should not be $null
        }

        It "configurationVersion parameter is of type string" {

            $json.parameters.configurationVersion.type | should be "string"
        }

        It "configurationVersion parameter is mandatory" {

            ($json.parameters.configurationVersion.PSObject.Properties.Name -contains "defaultValue") | should be $false
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
}

Describe "Automation Account Configuration Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/configurations" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/configurations"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-10-31" {

            $json.resources.apiVersion | should be "2015-10-31"
        }
    }
}

Describe "Automation Account Configuration Output Validation" {

    Context "Automation Account Configuration Reference Validation" {

        It "type value is object" {

            $json.outputs.configuration.type | should be "object"
        }

        It "Uses full reference for Automation Account Configuration" {

            $json.outputs.configuration.value | should be "[reference(resourceId('Microsoft.Automation/automationAccounts/configurations', parameters('automationAccountName'), variables('configurationName')), '2015-10-31', 'Full')]"
        }
    }
}