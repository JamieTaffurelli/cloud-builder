#$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
#$templatePath = $testPath -replace [regex]::Escape("tests\unit\"), [string]::Empty
#$Json = (Get-Content -Path $templatePath) | ConvertFrom-Json

Describe "${testPath} Validation" {

    Context "Parameter Validation" {

        It "Has virtualNetworkNameParameter" {

        }
    }
}