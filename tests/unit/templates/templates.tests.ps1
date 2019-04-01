#$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
#$templateFolderPath = Split-Path -Path ($testPath -replace [regex]::Escape("tests\unit\"), [string]::Empty) -Parent
#$armTemplatePaths = (Get-ChildItem -Path $templateFolderPath -Recurse -File -Filter "*.json").FullName

Describe "Template Validation" {

    Context "JSON Validation" {

        foreach($armTemplatePath in $armTemplatePaths)
        {
            It "$armTemplatePath is valid JSON" {

                { (Get-Content -Path $armTemplatePath) | ConvertFrom-Json -ErrorAction Stop } | should not throw
            }

            $arm = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

            It "$armTemplatePath has valid schema" {
                $arm.'$schema' | should be "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
            }

            It "$armTemplatePath has valid content version" {

                $arm.contentVersion -as [version] | should not be $null 
            }
        }
    }
}