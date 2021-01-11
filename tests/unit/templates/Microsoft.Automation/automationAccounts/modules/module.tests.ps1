$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Automation Account Module Parameter Validation" {

    Context "moduleName Validation" {

        It "Has moduleName parameter" {

            $json.parameters.moduleName | should not be $null
        }

        It "moduleName parameter is of type string" {

            $json.parameters.moduleName.type | should be "string"
        }

        It "moduleName parameter is mandatory" {

            ($json.parameters.moduleName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "moduleVersion Validation" {

        It "Has moduleVersion parameter" {

            $json.parameters.moduleVersion | should not be $null
        }

        It "moduleVersion parameter is of type string" {

            $json.parameters.moduleVersion.type | should be "string"
        }

        It "moduleVersion parameter is mandatory" {

            ($json.parameters.moduleVersion.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "moduleFileType Validation" {

        It "Has moduleFileType parameter" {

            $json.parameters.moduleFileType | should not be $null
        }

        It "moduleFileType parameter is of type string" {

            $json.parameters.moduleFileType.type | should be "string"
        }

        It "moduleFileType parameter default value is nupkg" {

            $json.parameters.moduleFileType.defaultValue | should be "nupkg"
        }

        It "moduleFileType parameter allowed values are zip, nupkg" {

            (Compare-Object -ReferenceObject $json.parameters.moduleFileType.allowedValues -DifferenceObject @("zip", "nupkg")).Length | should be 0
        }
    }
}

Describe "Automation Account Variable Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Automation/automationAccounts/modules" {

            $json.resources.type | should be "Microsoft.Automation/automationAccounts/modules"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-10-31" {

            $json.resources.apiVersion | should be "2015-10-31"
        }
    }
}

Describe "Automation Account Module Output Validation" {

    Context "Automation Account Module Reference Validation" {

        It "type value is object" {

            $json.outputs.module.type | should be "object"
        }

        It "Uses full reference for Automation Account Module" {

            $json.outputs.module.value | should be "[reference(resourceId('Microsoft.Automation/automationAccounts/modules', parameters('automationAccountName'), parameters('moduleName')), '2015-10-31', 'Full')]"
        }
    }
}