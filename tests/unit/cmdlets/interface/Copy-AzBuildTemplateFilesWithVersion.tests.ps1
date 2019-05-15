$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory  = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "Set-AzBuildTemplateFilePathWithVersion.ps1" -Resolve)

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    New-Item -Path "TestDrive:\" -Name "templates" -ItemType "Directory"
    New-Item -Path "TestDrive:\templates" -Name "template1.json" -ItemType "File"
    New-Item -Path "TestDrive:\templates" -Name "template2.json" -ItemType "File"
    New-Item -Path "TestDrive:\templates" -Name "template3.json" -ItemType "File"

    Context "Parameter Validation" { 

        It "Errors if SearchFolder does not exist" {

            { Copy-AzBuildTemplateFilesWithVersion -SearchFolder "TestDrive:\folder" -OutputFolder "TestDrive\versioned" } | should throw "Cannot validate argument on parameter 'SearchFolder'. The `" `$PSItem | Test-Path -PathType `"Container`" `" validation script for the argument with value `"TestDrive:\folder`" did not return a result of True. Determine why the validation script failed, and then try the command again."
        }

        It "Errors if SearchFolder is a file" {

            { Copy-AzBuildTemplateFilesWithVersion -SearchFolder "TestDrive:\templates\template1.json" -OutputFolder "TestDrive\versioned" } | should throw "Cannot validate argument on parameter 'SearchFolder'. The `" `$PSItem | Test-Path -PathType `"Container`" `" validation script for the argument with value `"TestDrive:\templates\template1.json`" did not return a result of True. Determine why the validation script failed, and then try the command again."
        }

        It "Errors if OutputFolder is not a valid path" {

            { Copy-AzBuildTemplateFilesWithVersion -SearchFolder "TestDrive:\templates" -OutputFolder "TestDrive:\>" } | should throw "Cannot validate argument on parameter 'OutputFolder'. The `" `$PSItem | Test-Path -PathType `"Container`" -IsValid `" validation script for the argument with value `"TestDrive:\>`" did not return a result of True. Determine why the validation script failed, and then try the command again."
        }
    }

    Context "Template Output Validation" {

        It "Warns if no template files were found" {

            Mock -CommandName Get-ChildItem -MockWith {} -Verifiable
            Mock -CommandName Write-Warning -MockWith {} -Verifiable

            Copy-AzBuildTemplateFilesWithVersion -SearchFolder "TestDrive:\templates" -OutputFolder "TestDrive:\versioned" | should be $null

            Assert-MockCalled -CommandName Get-ChildItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Warning -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "No templates found in TestDrive:\templates" }
        }

        It "Does not attempt to create file if it exists" {

            Mock -CommandName Get-ChildItem -MockWith { @(@{ FullName = "TestDrive:\templates\template3.json" }) } -Verifiable
            Mock -CommandName Set-AzBuildTemplateFilePathWithVersion -MockWith { "TestDrive:\templates\template3.1.0.0.0.json" } -ParameterFilter { $Path -eq "TestDrive:\templates\template3.json" } -Verifiable
            Mock -CommandName Copy-Item -MockWith {} -Verifiable
            Mock -CommandName New-Item -MockWith {} -Verifiable
            Mock -CommandName Test-Path -MockWith { $true } -ParameterFilter { $Path -eq "TestDrive:\versioned\template3.1.0.0.0.json"} -Verifiable

            Copy-AzBuildTemplateFilesWithVersion -SearchFolder "TestDrive:\templates" -OutputFolder "TestDrive:\versioned" | should be $null

            Assert-MockCalled -CommandName Get-ChildItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzBuildTemplateFilePathWithVersion -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\templates\template3.json" }
            Assert-MockCalled -CommandName Set-AzBuildTemplateFilePathWithVersion -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Copy-Item -Times 1 -Scope It -Exactly -ParameterFilter { $Destination -eq "TestDrive:\versioned\template3.1.0.0.0.json" }
            Assert-MockCalled -CommandName Copy-Item -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName New-Item -Times 0 -Scope It -Exactly
        }

        It "Attempts to create files if it does not exist" {

            Mock -CommandName Get-ChildItem -MockWith { @(@{ FullName = "TestDrive:\templates\template3.json" }) } -Verifiable
            Mock -CommandName Set-AzBuildTemplateFilePathWithVersion -MockWith { "TestDrive:\templates\template3.1.0.0.0.json" } -ParameterFilter { $Path -eq "TestDrive:\templates\template3.json" } -Verifiable
            Mock -CommandName Copy-Item -MockWith {} -Verifiable
            Mock -CommandName New-Item -MockWith {} -Verifiable
            Mock -CommandName Test-Path -MockWith { $false } -ParameterFilter { $Path -eq "TestDrive:\versioned\template3.1.0.0.0.json"} -Verifiable

            Copy-AzBuildTemplateFilesWithVersion -SearchFolder "TestDrive:\templates" -OutputFolder "TestDrive:\versioned" | should be $null

            Assert-MockCalled -CommandName Get-ChildItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzBuildTemplateFilePathWithVersion -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\templates\template3.json" }
            Assert-MockCalled -CommandName Set-AzBuildTemplateFilePathWithVersion -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Copy-Item -Times 1 -Scope It -Exactly -ParameterFilter { $Destination -eq "TestDrive:\versioned\template3.1.0.0.0.json" }
            Assert-MockCalled -CommandName Copy-Item -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName New-Item -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\versioned\template3.1.0.0.0.json" }
            Assert-MockCalled -CommandName New-Item -Times 1 -Scope It -Exactly
        }

        It "Copies multiple versioned template files to output folder" {
            
            Mock -CommandName Get-ChildItem -MockWith { @(@{ FullName = "TestDrive:\templates\template1.json" }, @{ FullName = "TestDrive:\templates\template2.json" }) } -Verifiable
            Mock -CommandName Set-AzBuildTemplateFilePathWithVersion -MockWith { "TestDrive:\templates\template1.1.0.0.0.json" } -ParameterFilter { $Path -eq "TestDrive:\templates\template1.json" } -Verifiable
            Mock -CommandName Set-AzBuildTemplateFilePathWithVersion -MockWith { "TestDrive:\templates\template2.1.0.0.0.json" } -ParameterFilter { $Path -eq "TestDrive:\templates\template2.json" } -Verifiable
            Mock -CommandName Copy-Item -MockWith {} -Verifiable
            Mock -CommandName New-Item -MockWith {} -Verifiable

            Copy-AzBuildTemplateFilesWithVersion -SearchFolder "TestDrive:\templates" -OutputFolder "TestDrive:\versioned" | should be $null

            Assert-MockCalled -CommandName Get-ChildItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzBuildTemplateFilePathWithVersion -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\templates\template1.json" }
            Assert-MockCalled -CommandName Set-AzBuildTemplateFilePathWithVersion -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\templates\template2.json" }
            Assert-MockCalled -CommandName Set-AzBuildTemplateFilePathWithVersion -Times 2 -Scope It -Exactly
            Assert-MockCalled -CommandName Copy-Item -Times 1 -Scope It -Exactly -ParameterFilter { $Destination -eq "TestDrive:\versioned\template1.1.0.0.0.json" }
            Assert-MockCalled -CommandName Copy-Item -Times 1 -Scope It -Exactly -ParameterFilter { $Destination -eq "TestDrive:\versioned\template2.1.0.0.0.json" }
            Assert-MockCalled -CommandName Copy-Item -Times 2 -Scope It -Exactly
            Assert-MockCalled -CommandName New-Item -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\versioned\template1.1.0.0.0.json" }
            Assert-MockCalled -CommandName New-Item -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\versioned\template2.1.0.0.0.json" }
            Assert-MockCalled -CommandName New-Item -Times 2 -Scope It -Exactly
        }
    }
}