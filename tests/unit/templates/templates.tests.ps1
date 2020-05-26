$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$templateFolderPath = Split-Path -Path ($testPath -replace [regex]::Escape("tests\unit"), [String]::Empty) -Parent
$armTemplatePaths = (Get-ChildItem -Path $templateFolderPath -Recurse -File -Filter "*.json").FullName

Describe "Template Validation" -Tag @("AllTemplates") {
    $schemaUrl = "https://schema.management.azure.com/schemas/"
    $validSchemas = @("${schemaUrl}2015-01-01/deploymentTemplate.json#",
                      "${schemaUrl}2019-04-01/deploymentTemplate.json#",
                      "${schemaUrl}2019-08-01/managementGroupDeploymentTemplate.json#",
                      "${schemaUrl}2018-05-01/subscriptionDeploymentTemplate.json#" )
    Context "JSON Validation" {

        foreach($armTemplatePath in $armTemplatePaths)
        {
            It "${armTemplatePath} is valid JSON" {

                { (Get-Content -Path $armTemplatePath) | ConvertFrom-Json -ErrorAction Stop } | should not throw
            }

            $arm = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

            It "${armTemplatePath} has valid schema" {
                $validSchemas -contains $arm.'$schema' | should be $true
            }

            It "${armTemplatePath} has valid content version" {

                $arm.contentVersion -as [version] | should not be $null 
            }

            It "${armTemplatePath} has a resource block" {

                ($arm.PSObject.Properties.Name -contains "resources") | should be $true
            }
        }
    }
}