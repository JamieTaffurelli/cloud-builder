$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), "module"
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Storage Account Template Validation" {

    Context "Parameter Validation" {

        It "Has storageAccountName Parameter" {

            $json.parameters.storageAccountName | should not be $null
        }

        It "storageAccountName Parameter is of type string" {

            $json.parameters.storageAccountName.type | should be "string"
        }

        It "storageAccountName Parameter is of mandatory" {

            ($json.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}