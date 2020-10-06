$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Runbook Parameter Validation" {

    Context "runbookName Validation" {

        It "Has runbookName parameter" {

            $json.parameters.runbookName | should not be $null
        }

        It "runbookName parameter is of type string" {

            $json.parameters.runbookName.type | should be "string"
        }

        It "runbookName parameter is mandatory" {

            ($json.parameters.runbookName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "runbookVersion Validation" {

        It "Has runbookVersion parameter" {

            $json.parameters.runbookVersion | should not be $null
        }

        It "runbookVersion parameter is of type string" {

            $json.parameters.runbookVersion.type | should be "string"
        }

        It "runbookVersion parameter is mandatory" {

            ($json.parameters.runbookVersion.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "logActivityTrace Validation" {

        It "Has logActivityTrace parameter" {

            $json.parameters.logActivityTrace | should not be $null
        }

        It "logActivityTrace parameter is of type int" {

            $json.parameters.logActivityTrace.type | should be "int"
        }

        It "logActivityTrace parameter default value is 0" {

            $json.parameters.logActivityTrace.defaultValue | should be 0
        }

        It "logActivityTrace parameter allowed values are 0, 1, 2" {

            (Compare-Object -ReferenceObject $json.parameters.logActivityTrace.allowedValues -DifferenceObject @(0, 1, 2)).Length | should be 0
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

Describe "Automation Account Runbook Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/runbooks" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/runbooks"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-06-30" {

            $json.resources.apiVersion | should be "2018-06-30"
        }
    }
}

Describe "Automation Account Runbook Output Validation" {

    Context "Automation Account Runbook Reference Validation" {

        It "type value is object" {

            $json.outputs.runbook.type | should be "object"
        }

        It "Uses full reference for Automation Account Runbook" {

            $json.outputs.runbook.value | should be "[reference(resourceId('Microsoft.Automation/automationAccounts/runbooks', parameters('automationAccountName'), parameters('runbookName')), '2018-06-30', 'Full')]"
        }
    }
}