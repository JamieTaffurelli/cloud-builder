$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$internalCmdletDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
. (Join-Path -Path $internalcmdletDirectory -ChildPath $cmdletFile -Resolve)

Describe "${cmdletFile}" {

    Context "Content Version Validation" {

        Mock -CommandName Write-Verbose {} -Verifiable

        It "Sets default schema if not present" {

            $resourceObject = [pscustomobject]@{}

            Set-ABJsonSchema -ResourceObject $resourceObject

            $resourceObject.schema | should be "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#"

            Assert-MockCalled -CommandName Write-Verbose -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Resource parameters will have version https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#" }
        }

        It "Sets custom schema if not present" {

            $resourceObject = [pscustomobject]@{}

            Set-ABJsonSchema -ResourceObject $resourceObject -Schema "https://schema.management.azure.com/schemas/2017-01-01/deploymentParameters.json#"

            $resourceObject.schema | should be "https://schema.management.azure.com/schemas/2017-01-01/deploymentParameters.json#"

            Assert-MockCalled -CommandName Write-Verbose -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Resource parameters will have version https://schema.management.azure.com/schemas/2017-01-01/deploymentParameters.json#" }
        }

        It "Uses current schema if present and schema not passed in as parameter" {

            $resourceObject = [pscustomobject]@{ Schema = "https://schema.management.azure.com/schemas/2017-01-01/deploymentParameters.json#" }

            Set-ABJsonSchema -ResourceObject $resourceObject

            $resourceObject.schema | should be "https://schema.management.azure.com/schemas/2017-01-01/deploymentParameters.json#"
        }

        It "Uses current schema if present and schema passed in as parameter" {

            $resourceObject = [pscustomobject]@{ Schema = "https://schema.management.azure.com/schemas/2017-01-01/deploymentParameters.json#" }

            Set-ABJsonSchema -ResourceObject $resourceObject -Schema "https://schema.management.azure.com/schemas/2018-01-01/deploymentParameters.json#"
            
            $resourceObject.schema | should be "https://schema.management.azure.com/schemas/2017-01-01/deploymentParameters.json#"
        }
    }
}