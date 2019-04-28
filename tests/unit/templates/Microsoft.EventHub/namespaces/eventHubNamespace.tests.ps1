$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), "module"
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "eventHubNamespace Parameter Validation" {

    Context "eventHubNamespaceName Validation" {

        It "Has eventHubNamespaceName parameter" {

            $json.parameters.eventHubNamespaceName | should not be $null
        }

        It "eventHubNamespaceName parameter is of type string" {

            $json.parameters.eventHubNamespaceName.type | should be "string"
        }

        It "storageAccountName parameter is mandatory" {

            ($json.parameters.eventHubNamespaceName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

        It "sku parameter default value is Standard" {

            $json.parameters.sku.defaultValue | should be "Standard"
        }

        It "sku parameter allowed values are Basic, Standard" {

            (Compare-Object -ReferenceObject $json.parameters.sku.allowedValues -DifferenceObject @("Basic", "Standard")).Length | should be 0
        }
    }

    Context "capacity Validation" {

        It "Has capacity parameter" {

            $json.parameters.capacity | should not be $null
        }

        It "capacity parameter is of type int" {

            $json.parameters.capacity.type | should be "int"
        }

        It "capacity parameter default value is 1" {

            $json.parameters.capacity.defaultValue | should be 1
        }

        It "capacity parameter is minValue is 1" {

            $json.parameters.capacity.minValue | should be 1
        }

        It "capacity parameter is maxValue is 20" {

            $json.parameters.capacity.maxValue | should be 20
        }
    }

    Context "isAutoInflateEnabled Validation" {

        It "Has isAutoInflateEnabled parameter" {

            $json.parameters.isAutoInflateEnabled | should not be $null
        }

        It "isAutoInflateEnabled parameter is of type bool" {

            $json.parameters.isAutoInflateEnabled.type | should be "bool"
        }

        It "isAutoInflateEnabled parameter default value is true" {

            $json.parameters.isAutoInflateEnabled.defaultValue | should be $true
        }
    }

    Context "maximumThroughputUnits Validation" {

        It "Has maximumThroughputUnits parameter" {

            $json.parameters.maximumThroughputUnits | should not be $null
        }

        It "maximumThroughputUnits parameter is of type int" {

            $json.parameters.maximumThroughputUnits.type | should be "int"
        }

        It "maximumThroughputUnits parameter default value is 1" {

            $json.parameters.maximumThroughputUnits.defaultValue | should be 1
        }

        It "maximumThroughputUnits parameter is minValue is 1" {

            $json.parameters.maximumThroughputUnits.minValue | should be 0
        }

        It "maximumThroughputUnits parameter is maxValue is 20" {

            $json.parameters.maximumThroughputUnits.maxValue | should be 20
        }
    }

    Context "kafkaEnabled Validation" {

        It "Has kafkaEnabled parameter" {

            $json.parameters.kafkaEnabled | should not be $null
        }

        It "kafkaEnabled parameter is of type bool" {

            $json.parameters.kafkaEnabled.type | should be "bool"
        }

        It "kafkaEnabled parameter default value is false" {

            $json.parameters.kafkaEnabled.defaultValue | should be $false
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

Describe "eventHubNamespace Resource Validation" {

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $json.resources.apiVersion | should be "2018-11-01"
        }
    }
}