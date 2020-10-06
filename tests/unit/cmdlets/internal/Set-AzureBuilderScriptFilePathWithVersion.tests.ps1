$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$internalCmdletDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
. (Join-Path -Path $internalcmdletDirectory -ChildPath $cmdletFile -Resolve)

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    New-ScriptFileInfo -Path "TestDrive:\script.ps1" -Version "1.0.0" -Description "test"

    Context "Parameter Validation" {

        It "Errors if Path does not exist" {

            { "TestDrive:\file.ps1" | Set-AzureBuilderScriptFilePathWithVersion -ErrorAction Stop } | should throw 'Cannot validate argument on parameter 'Path'. The " ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq "json") " validation script for the argument with value "TestDrive:\script.ps1" did not return a result of True. Determine why the validation script failed, and then try the command again.'
        }

        It "Errors if Path is not a ps1 file" {

            New-Item -Path "TestDrive:\" -Name "script.txt" -ItemType "File"

            { "TestDrive:\script.txt" | Set-AzureBuilderScriptFilePathWithVersion -ErrorAction Stop } | should throw 'Cannot validate argument on parameter 'Path'. The " ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq "json") " validation script for the argument with value "TestDrive:\script.ps1" did not return a result of True. Determine why the validation script failed, and then try the command again.'
        }
    }

    Context "Version Validation" {

        It "Errors if script is not valid" {

            Mock -CommandName Test-ScriptFileInfo -MockWith {} -Verifiable

            { "TestDrive:\script.ps1" | Set-AzureBuilderScriptFilePathWithVersion -ErrorAction Stop } | should throw "TestDrive:\script.ps1 does not have a valid version '', make sure script info is attached to script by using New-ScriptFileInfo and specifiying version"

            Mock -CommandName Test-ScriptFileInfo -MockWith { @{ Version = "invalid" } } -Verifiable

            { "TestDrive:\script.ps1" | Set-AzureBuilderScriptFilePathWithVersion -ErrorAction Stop } | should throw "TestDrive:\script.ps1 does not have a valid version 'invalid', make sure script info is attached to script by using New-ScriptFileInfo and specifiying version"

            Assert-MockCalled -CommandName Test-ScriptFileInfo -Times 2 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\script.ps1" }
            Assert-MockCalled -CommandName Test-ScriptFileInfo -Times 2 -Scope It -Exactly
        }

        It "Returns versioned file path" {

            Mock -CommandName Test-ScriptFileInfo -MockWith { @{ Version = "1.0.0" } } -Verifiable

            "TestDrive:\script.ps1" | Set-AzureBuilderScriptFilePathWithVersion -ErrorAction Stop | should be "TestDrive:\script.1.0.0.ps1"

            Assert-MockCalled -CommandName Test-ScriptFileInfo -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\script.ps1" }
            Assert-MockCalled -CommandName Test-ScriptFileInfo -Times 1 -Scope It -Exactly
        }
    }
}