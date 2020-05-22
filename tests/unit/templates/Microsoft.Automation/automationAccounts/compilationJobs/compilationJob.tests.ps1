$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Compilation Job Parameter Validation" {

    Context "compilationJobName Validation" {

        It "Has compilationJobName parameter" {

            $json.parameters.compilationJobName | should not be $null
        }

        It "compilationJobName parameter is of type string" {

            $json.parameters.compilationJobName.type | should be "string"
        }

        It "compilationJobName parameter default value is [resourceGroup().location]" {

            $json.parameters.compilationJobName.defaultValue | should be "[newGuid()]"
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

    Context "configurationData Validation" {

        It "Has configurationData parameter" {

            $json.parameters.configurationData | should not be $null
        }

        It "configurationData parameter is of type string" {

            $json.parameters.configurationData.type | should be "string"
        }

        It "configurationData parameter is mandatory" {

            ($json.parameters.configurationData.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "incrementNodeConfigurationBuild Validation" {

        It "Has incrementNodeConfigurationBuild parameter" {

            $json.parameters.incrementNodeConfigurationBuild | should not be $null
        }

        It "incrementNodeConfigurationBuild parameter is of type bool" {

            $json.parameters.incrementNodeConfigurationBuild.type | should be "bool"
        }

        It "incrementNodeConfigurationBuild parameter default value is false" {

            $json.parameters.incrementNodeConfigurationBuild.defaultValue | should be $false
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

Describe "Automation Account Compilation Job Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/compilationJobs" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/compilationJobs"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-10-31" {

            $json.resources.apiVersion | should be "2015-10-31"
        }
    }
}

Describe "Automation Account Compilation Job Output Validation" {

    Context "Automation Account Compilation Job Reference Validation" {

        It "type value is object" {

            $json.outputs.compilationJob.type | should be "object"
        }

        It "Uses full reference for Automation Account Compilation Job" {

            $json.outputs.compilationJob.value | should be "[reference(resourceId('Microsoft.Automation/automationAccounts/compilationJobs', parameters('automationAccountName'), parameters('compilationJobName')), '2015-10-31', 'Full')]"
        }
    }
}