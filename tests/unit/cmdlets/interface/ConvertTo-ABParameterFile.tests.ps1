$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory  = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"

. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "Out-ABParameterFile.ps1" -Resolve)

Describe "${cmdletFile}" {

    New-Item -Path "TestDrive:\" -Name "envfile.txt" -ItemType File -Force
    New-Item -Path "TestDrive:\" -Name "envfile.json" -ItemType File -Force

    Context "Parameter Validation" {

        It "Errors if environment file is not a JSON file" {
            
            Test-Path -Path "TestDrive:\envfile.txt" | should be $true

            { ConvertTo-ABParameterFile -EnvironmentPath "TestDrive:\envfile.txt" } | should throw "Cannot validate argument on parameter 'EnvironmentPath'. The `" [System.IO.Path]::GetExtension(`$PSItem) -eq `".json`" `" validation script for the argument with value `"TestDrive:\envfile.txt`" did not return a result of True. Determine why the validation script failed, and then try the command again."
        }

        It "Does not allow invalid output path" {

            { ConvertTo-ABParameterFile -EnvironmentPath "TestDrive:\envfile.json" -OutputPath "TestDrive:\dir\?" } | should throw "Cannot validate argument on parameter 'OutputPath'. The `" `$PSItem | Test-Path -IsValid `" validation script for the argument with value `"TestDrive:\dir\?`" did not return a result of True. Determine why the validation script failed, and then try the command again."
        }

        It "Does not allow non Azure parameter template schema" {

            { ConvertTo-ABParameterFile -EnvironmentPath "TestDrive:\envfile.json" -OutputPath "TestDrive:\dir" -Schema "https://schema.notazure.com/schema.json" } | should throw "Cannot validate argument on parameter 'Schema'. The `" `$PSItem -like `"https://schema.management.azure.com/schemas/*/deploymentParameters.json#`""
        }
    }

    Context "Parameter file creation validation" {

        Mock Write-Error { throw } -Verifiable
        Mock Get-Content { "{}" } -Verifiable
        Mock ConvertFrom-Json { [PSCustomObject]@{} } -Verifiable
        Mock Out-ABParameterFile {} -Verifiable

        It "Errors if resources object is not present" {

            Mock ConvertFrom-Json { [PSCustomObject]@{} } -Verifiable

            { ConvertTo-ABParameterFile -EnvironmentPath "TestDrive:\envfile.json" -OutputPath "TestDrive:\dir" } | should throw

            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\envfile.json" }
            Assert-MockCalled -CommandName ConvertFrom-Json -Times 1 -Scope It -Exactly -ParameterFilter { $InputObject -eq "{}" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "No resources were found in TestDrive:\envfile.json or resources was not a JSON object" }
            Assert-MockCalled -CommandName Out-ABParameterFile -Times 0 -Scope It -Exactly
        }

        It "Errors if resources object is not a JSON object" {

            Mock ConvertFrom-Json { [PSCustomObject]@{ resources = "resource"} } -Verifiable

            { ConvertTo-ABParameterFile -EnvironmentPath "TestDrive:\envfile.json" -OutputPath "TestDrive:\dir" } | should throw

            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\envfile.json" }
            Assert-MockCalled -CommandName ConvertFrom-Json -Times 1 -Scope It -Exactly -ParameterFilter { $InputObject -eq "{}" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "No resources were found in TestDrive:\envfile.json or resources was not a JSON object" }
            Assert-MockCalled -CommandName Out-ABParameterFile -Times 0 -Scope It -Exactly
        }

        It "Creates parameter file if resources is a JSON object" {

            Mock ConvertFrom-Json { [PSCustomObject]@{ resources = [PSCustomObject]@{} } } -Verifiable

            { ConvertTo-ABParameterFile -EnvironmentPath "TestDrive:\envfile.json" -OutputPath "TestDrive:\dir" } | should not throw

            Assert-MockCalled -CommandName Get-Content -Times 1 -Scope It -Exactly -ParameterFilter { $Path -eq "TestDrive:\envfile.json" }
            Assert-MockCalled -CommandName ConvertFrom-Json -Times 1 -Scope It -Exactly -ParameterFilter { $InputObject -eq "{}" }
            Assert-MockCalled -CommandName Write-Error -Times 0 -Scope It -Exactly
            Assert-MockCalled -CommandName Out-ABParameterFile -Times 1 -Scope It -Exactly
        }
    }
}