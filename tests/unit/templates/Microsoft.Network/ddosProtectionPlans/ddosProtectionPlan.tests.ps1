$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "DDOS Protection Plan Parameter Validation" {

    Context "ddosProtectionPlanName Validation" {

        It "Has ddosProtectionPlanName parameter" {

            $json.parameters.ddosProtectionPlanName | should not be $null
        }

        It "ddosProtectionPlanName parameter is of type string" {

            $json.parameters.ddosProtectionPlanName.type | should be "string"
        }

        It "ddosProtectionPlanName parameter is mandatory" {

            ($json.parameters.ddosProtectionPlanName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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
}

Describe "DDOS Protection Plan Group Resource Validation" {

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $json.resources.apiVersion | should be "2018-11-01"
        }
    }
}