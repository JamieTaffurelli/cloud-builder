$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$templateFolderPath = Split-Path -Path ($testPath -replace [regex]::Escape("tests\unit"), [String]::Empty) -Parent
$armTemplatePaths = (Get-ChildItem -Path $templateFolderPath -Recurse -File -Filter "*.json").FullName

Describe "Template Validation" -Tag @("AllTemplates") {
    $schemaUrl = "https://schema.management.azure.com/schemas/"
    $validTemplateSchemas = @(
        "${schemaUrl}2015-01-01/deploymentTemplate.json#",
        "${schemaUrl}2019-04-01/deploymentTemplate.json#",
        "${schemaUrl}2019-08-01/managementGroupDeploymentTemplate.json#",
        "${schemaUrl}2018-05-01/subscriptionDeploymentTemplate.json#",
        "${schemaUrl}2018-05-01/subscriptionDeploymentTemplate.json#"
    )

    $validParameterSchemas = @( "${schemaUrl}2015-01-01/deploymentParameters.json#" )

    Context "JSON Validation" {

        foreach($armTemplatePath in $armTemplatePaths)
        {
            $arm = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

            It "${armTemplatePath} is valid JSON" {

                { (Get-Content -Path $armTemplatePath) | ConvertFrom-Json -ErrorAction Stop } | should not throw
            }

            It "${armTemplatePath} has valid content version" {

                $arm.contentVersion -as [version] | should not be $null 
            }
        }
    }

    Context "Template Validation" {

        $templatePaths = $armTemplatePaths | Where-Object { $_ -notlike "*.parameters.json" }

        foreach($templatePath in $templatePaths)
        {
            $arm = (Get-Content -Path $templatePath) | ConvertFrom-Json

            It "${templatePath} has valid schema" {
                $validTemplateSchemas -contains $arm.'$schema' | should be $true
            }

            It "${templatePath} has a resource block" {

                ($arm.PSObject.Properties.Name -contains "resources") | should be $true
            }
        }
    }

    Context "Parameter Validation" {
        
        $parameterPaths = $armTemplatePaths | Where-Object { $_ -like "*.parameters.json" }

        foreach($parameterPath in $parameterPaths)
        {
            $arm = (Get-Content -Path $parameterPath) | ConvertFrom-Json

            It "${parameterPath} has valid schema" {
                $validParameterSchemas -contains $arm.'$schema' | should be $true
            }

            It "${parameterPath} has a parameters block" {

                ($arm.PSObject.Properties.Name -contains "parameters") | should be $true
            }
        }
    }
}