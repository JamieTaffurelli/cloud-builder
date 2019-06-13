$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Data Disk Parameter Validation" {

    Context "diskName Validation" {

        It "Has diskName parameter" {

            $json.parameters.diskName | should not be $null
        }

        It "diskName parameter is of type string" {

            $json.parameters.diskName.type | should be "string"
        }

        It "diskName parameter is mandatory" {

            ($json.parameters.diskName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "sku Validation" {

        It "Has sku parameter" {

            $json.parameters.sku | should not be $null
        }

        It "sku parameter is of type string" {

            $json.parameters.sku.type | should be "string"
        }

        It "sku parameter default value is Premium_LRS" {

            $json.parameters.sku.defaultValue | should be "Premium_LRS"
        }

        It "sku parameter allowed values are Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS" {

            (Compare-Object -ReferenceObject $json.parameters.sku.allowedValues -DifferenceObject @("Standard_LRS", "Premium_LRS", "StandardSSD_LRS", "UltraSSD_LRS")).Length | should be 0
        }
    }

    Context "diskSizeGB Validation" {

        It "Has diskSizeGB parameter" {

            $json.parameters.diskSizeGB | should not be $null
        }

        It "diskSizeGB parameter is of type int" {

            $json.parameters.diskSizeGB.type | should be "int"
        }

        It "diskSizeGB parameter default value is 127" {

            ($json.parameters.diskSizeGB.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "diskSizeGB parameter minimum value is 32" {

            $json.parameters.diskSizeGB.minValue | should be 32
        }

        It "diskSizeGB parameter maximum value is 32767" {

            $json.parameters.diskSizeGB.maxValue | should be 32767
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

Describe "Data Disk Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Compute/disks" {

            $json.resources.type | should be "Microsoft.Compute/disks"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-09-30" {

            $json.resources.apiVersion | should be "2018-09-30"
        }
    }

    Context "creationData Validation" {

        It "createOption value is Empty" {

            $json.resources.properties.creationData.createOption | should be "Empty"
        }
    }

    Context "encryptionSettingsCollection Validation" {

        It "Disk encryption is disabled" {

            $json.resources.properties.encryptionSettingsCollection.enabled | should be $false
        }
    }
}