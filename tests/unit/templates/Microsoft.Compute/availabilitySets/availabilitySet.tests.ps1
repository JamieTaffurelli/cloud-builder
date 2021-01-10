$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace "tests(\\|\/)unit(\\|\/)", [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Availability Set Parameter Validation" {

    Context "availabilitySetName Validation" {

        It "Has availabilitySetName parameter" {

            $json.parameters.availabilitySetName | should not be $null
        }

        It "availabilitySetName parameter is of type string" {

            $json.parameters.availabilitySetName.type | should be "string"
        }

        It "availabilitySetName parameter is mandatory" {

            ($json.parameters.availabilitySetName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

    Context "platformUpdateDomainCount Validation" {

        It "Has platformUpdateDomainCount parameter" {

            $json.parameters.platformUpdateDomainCount | should not be $null
        }

        It "platformUpdateDomainCount parameter is of type int" {

            $json.parameters.platformUpdateDomainCount.type | should be "int"
        }

        It "platformUpdateDomainCount parameter default value is 5" {

            $json.parameters.platformUpdateDomainCount.defaultValue | should be 5
        }
    }

    Context "platformFaultDomainCount Validation" {

        It "Has platformFaultDomainCount parameter" {

            $json.parameters.platformFaultDomainCount | should not be $null
        }

        It "platformFaultDomainCount parameter is of type int" {

            $json.parameters.platformFaultDomainCount.type | should be "int"
        }

        It "platformFaultDomainCount parameter default value is 5" {

            $json.parameters.platformUpdateDomainCount.defaultValue | should be 5
        }
    }

    Context "skuName Validation" {

        It "Has skuName parameter" {

            $json.parameters.skuName | should not be $null
        }

        It "skuName parameter is of type string" {

            $json.parameters.skuName.type | should be "string"
        }

        It "skuName parameter default value is Aligned" {

            $json.parameters.skuName.defaultValue | should be "Aligned"
        }

        It "skuName parameter allowed values are Aligned, Classic" {

            (Compare-Object -ReferenceObject $json.parameters.skuName.allowedValues -DifferenceObject @("Aligned", "Classic")).Length | should be 0
        }
    }
}

Describe " Availability Set Resource Validation" {
  
    Context "type Validation" {

        It "type value is Microsoft.Compute/availabilitySets" {

            $json.resources.type | should be "Microsoft.Compute/availabilitySets"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2019-03-01" {

            $json.resources.apiVersion | should be "2019-03-01"
        }
    }
}

Describe "Availability Set Output Validation" {

    Context "Availability Set Reference Validation" {

        It "type value is object" {

            $json.outputs.availabilitySet.type | should be "object"
        }

        It "Uses full reference for Availability Set " {

            $json.outputs.availabilitySet.value | should be "[reference(resourceId('Microsoft.Compute/availabilitySets', parameters('availabilitySetName')), '2019-03-01', 'Full')]"
        }
    }
}