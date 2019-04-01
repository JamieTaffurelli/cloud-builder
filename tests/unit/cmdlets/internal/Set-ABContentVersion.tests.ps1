$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$internalCmdletDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
. (Join-Path -Path $internalcmdletDirectory -ChildPath $cmdletFile -Resolve)

Describe "${cmdletFile}" {

    Context "Content Version Validation" {

        Mock -CommandName Write-Verbose {} -Verifiable
        Mock -CommandName Write-Error { throw } -Verifiable

        It "Sets default Content Version if not present" {

            $resourceObject = [pscustomobject]@{}

            Set-ABContentVersion -ResourceObject $resourceObject

            $resourceObject.contentVersion | should be "1.0.0.0"

            Assert-MockCalled -CommandName Write-Verbose -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Resource parameters will have version 1.0.0.0" }
        }

        It "Sets Content Version if present" {

            $resourceObject = [pscustomobject]@{ ContentVersion = "8.9.2" }

            Set-ABContentVersion -ResourceObject $resourceObject

            $resourceObject.contentVersion | should be "8.9.2"

            Assert-MockCalled -CommandName Write-Verbose -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Resource parameters will have version 8.9.2" }
        }

        It "Errors if Content Version is not a valid version" {

            { Set-ABContentVersion -ResourceObject ([pscustomobject]@{ ContentVersion = "ab.k" }) } | should throw

            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "contentVersion 'ab.k' is not a valid version" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly
        }
    }
}