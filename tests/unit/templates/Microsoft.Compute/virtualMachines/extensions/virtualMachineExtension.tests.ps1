$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Virtual Machine Extension Parameter Validation" {

    Context "vmExtensionName Validation" {

        It "Has vmExtensionName parameter" {

            $json.parameters.vmExtensionName | should not be $null
        }

        It "vmExtensionName parameter is of type string" {

            $json.parameters.vmExtensionName.type | should be "string"
        }

        It "vmExtensionName parameter is mandatory" {

            ($json.parameters.vmExtensionName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "vmName Validation" {

        It "Has vmName parameter" {

            $json.parameters.vmName | should not be $null
        }

        It "vmName parameter is of type string" {

            $json.parameters.vmName.type | should be "string"
        }

        It "vmName parameter is mandatory" {

            ($json.parameters.vmName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "typeHandlerVersion Validation" {

        It "Has typeHandlerVersion parameter" {

            $json.parameters.typeHandlerVersion | should not be $null
        }

        It "typeHandlerVersion parameter is of type string" {

            $json.parameters.typeHandlerVersion.type | should be "string"
        }

        It "typeHandlerVersion parameter is mandatory" {

            ($json.parameters.typeHandlerVersion.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "publisher Validation" {

        It "Has publisher parameter" {

            $json.parameters.publisher | should not be $null
        }

        It "publisher parameter is of type string" {

            $json.parameters.publisher.type | should be "string"
        }

        It "publisher parameter is mandatory" {

            ($json.parameters.publisher.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "type Validation" {

        It "Has type parameter" {

            $json.parameters.type | should not be $null
        }

        It "type parameter is of type string" {

            $json.parameters.type.type | should be "string"
        }

        It "type parameter is mandatory" {

            ($json.parameters.publisher.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "forceUpdateTag Validation" {

        It "Has forceUpdateTag parameter" {

            $json.parameters.forceUpdateTag | should not be $null
        }

        It "forceUpdateTag parameter is of type string" {

            $json.parameters.forceUpdateTag.type | should be "string"
        }

        It "forceUpdateTag parameter default value is v1.0" {

            $json.parameters.forceUpdateTag.defaultValue | should be "v1.0"
        }
    }

    Context "settings Validation" {

        It "Has settings parameter" {

            $json.parameters.settings | should not be $null
        }

        It "settings parameter is of type object" {

            $json.parameters.settings.type | should be "object"
        }

        It "settings parameter default value is an empty object" {

            $json.parameters.settings.defaultValue.PSObject.Properties.Name.Count | should be 0
        }
    }

    Context "protectedSettings Validation" {

        It "Has protectedSettings parameter" {

            $json.parameters.protectedSettings | should not be $null
        }

        It "protectedSettings parameter is of type secureobject" {

            $json.parameters.protectedSettings.type | should be "secureobject"
        }

        It "protectedSettings parameter default value is an empty secureobject" {

            $json.parameters.protectedSettings.defaultValue.PSObject.Properties.Name.Count | should be 0
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

Describe "Virtual Machine Extension Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Compute/virtualMachines/extensions" {

            $json.resources.type | should be "Microsoft.Compute/virtualMachines/extensions"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-03-01" {

            $json.resources.apiVersion | should be "2019-03-01"
        }
    }
}

Describe "Virtual Machine Extension Output Validation" {

    Context "Virtual Machine Extension Reference Validation" {

        It "type value is object" {

            $json.outputs.virtualMachineExtension.type | should be "object"
        }

        It "Uses full reference for Virtual Machine Extension" {

            $json.outputs.virtualMachineExtension.value | should be "[reference(resourceId('Microsoft.Compute/virtualMachines/extensions', parameters('vmName'), parameters('vmExtensionName')), '2019-03-01', 'Full')]"
        }
    }
}