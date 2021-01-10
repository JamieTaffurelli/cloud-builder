$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$internalCmdletDirectory = $PSScriptRoot -Replace "tests(\\|\/)unit(\\|\/)", "module"
. (Join-Path -Path $internalcmdletDirectory -ChildPath $cmdletFile -Resolve)

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    New-Item -Path "TestDrive:\" -Name "template.json" -ItemType "File"

    Context "Parameter Validation" {

        It "Errors if Path does not exist" {

            { "TestDrive:\file.json" | Set-AzureBuilderTemplateFilePathWithVersion -ErrorAction Stop } | should throw 'Cannot validate argument on parameter 'Path'. The " ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq "json") " validation script for the argument with value "TestDrive:\file.json" did not return a result of True. Determine why the validation script failed, and then try the command again.'
        }

        It "Errors if Path is not a JSON file" {

            New-Item -Path "TestDrive:\" -Name "template.txt" -ItemType "File"

            { "TestDrive:\template.txt" | Set-AzureBuilderTemplateFilePathWithVersion -ErrorAction Stop } | should throw 'Cannot validate argument on parameter 'Path'. The " ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq "json") " validation script for the argument with value "TestDrive:\file.json" did not return a result of True. Determine why the validation script failed, and then try the command again.'
        }
    }

    Context "Version Validation" {

        It "Errors if contentVersion is not valid" {

            Mock -CommandName Get-Content -MockWith {'{}'} -Verifiable

            { "TestDrive:\template.json" | Set-AzureBuilderTemplateFilePathWithVersion -ErrorAction Stop } | should throw "TestDrive:\template.json does not have a valid content version ''"

            Mock -CommandName Get-Content -MockWith {'{ "contentVersion": "invalid"}'} -Verifiable

            { "TestDrive:\template.json" | Set-AzureBuilderTemplateFilePathWithVersion -ErrorAction Stop } | should throw "TestDrive:\template.json does not have a valid content version 'invalid'"

            Assert-MockCalled -CommandName Get-Content -Times 2 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\template.json" }
            Assert-MockCalled -CommandName Get-Content -Times 2 -Scope It -Exactly
        }

        It "Returns versioned file path" {

            Mock -CommandName Get-Content -MockWith {'{ "contentVersion": "1.0.0.0"}'} -Verifiable

            "TestDrive:\template.json" | Set-AzureBuilderTemplateFilePathWithVersion -ErrorAction Stop | should be "TestDrive:\template.1.0.0.0.json"

            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\template.json" }
            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly
        }
    }
}