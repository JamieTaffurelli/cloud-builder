$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$internalCmdletDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
. (Join-Path -Path $internalcmdletDirectory -ChildPath $cmdletFile -Resolve)

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    New-Item -Path "TestDrive:\" -Name "WebServer.ps1" -ItemType "File"

    Context "Parameter Validation" {

        It "Errors if Path does not exist" {

            { "TestDrive:\file.ps1" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop } | should throw 'Cannot validate argument on parameter 'Path'. The " ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq "ps1") " validation script for the argument with value "TestDrive:\file.json" did not return a result of True. Determine why the validation script failed, and then try the command again.'
        }

        It "Errors if Path is not a JSON file" {

            New-Item -Path "TestDrive:\" -Name "template.txt" -ItemType "File"

            { "TestDrive:\template.txt" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop } | should throw 'Cannot validate argument on parameter 'Path'. The " ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq "ps1") " validation script for the argument with value "TestDrive:\file.json" did not return a result of True. Determine why the validation script failed, and then try the command again.'
        }
    }

    Context "Version Validation" {

        It "Errors if contentVersion is not valid" {

            Mock -CommandName Get-Content -MockWith { 'configuration WebServer' } -Verifiable

            { "TestDrive:\WebServer.ps1" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop } | should throw "WebServer does not end with a 3 digit verion (without periods '.')"

            Mock -CommandName Get-Content -MockWith { 'configuration WebServer1x2' } -Verifiable

            { "TestDrive:\WebServer.ps1" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop } | should throw "WebServer1x2 does not end with a 3 digit verion (without periods '.')"

            Mock -CommandName Get-Content -MockWith { 'configuration WebServer1234' } -Verifiable

            { "TestDrive:\WebServer.ps1" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop } | should throw "WebServer1234 does not end with a 3 digit verion (without periods '.')"

            Assert-MockCalled -CommandName Get-Content -Times 3 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\WebServer.ps1" }
            Assert-MockCalled -CommandName Get-Content -Times 3 -Scope It -Exactly
        }

        It "Returns versioned file path" {

            Mock -CommandName Get-Content -MockWith { 'configuration WebServer123' } -Verifiable

            "TestDrive:\WebServer.ps1" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop | should be "TestDrive:\WebServer123.ps1"

            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\WebServer.ps1" }

            "TestDrive:\WebServer.ps1" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop | should be "TestDrive:\WebServer123.ps1"

            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\WebServer.ps1" }

            "TestDrive:\WebServer.ps1" | Set-AzureBuilderConfigurationFilePathWithVersion -ErrorAction Stop | should be "TestDrive:\WebServer123.ps1"

            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\WebServer.ps1" }
            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly
        }
    }
}