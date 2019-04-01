$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$internalCmdletDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
. (Join-Path -Path $internalcmdletDirectory -ChildPath $cmdletFile -Resolve)

Describe "${cmdletFile}" {

    Context "Common Parameter Import Validation" {

        Mock -CommandName Write-Error { throw } -Verifiable

        It "Errors if common parameter not found" {

            $resourceObject = [PSCustomObject]@{ importedParameters = [PSCustomObject]@{ parameterName = "invalidParameter" } }
            $commonParameters = [PSCustomObject]@{ commonParameter = "resourceName" }

            { Import-ABCommonParameters -ResourceObject $resourceObject -CommonParameters $commonParameters } | should throw

            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "invalidParameter was not found in common parameters" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly
        }

        It "Adds common parameters to parameters" {

            $resourceObject = [PSCustomObject]@{ importedParameters = [PSCustomObject]@{ importedResourceName = "resourceName"; importedResourceSku = "resourceSku" }; parameters = [PSCustomObject]@{} }
            $commonParameters = [PSCustomObject]@{ resourceName = "resource"; resourceSku = "basic" }

            Import-ABCommonParameters -ResourceObject $resourceObject -CommonParameters $commonParameters

            $resourceObject.parameters.importedResourceName | should be "resource"
            $resourceObject.parameters.importedResourceSku | should be "basic"
        }
    }
}