<#$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory  = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"

. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "Import-ABCommonParameters.ps1" -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "Set-ABContentVersion.ps1" -Resolve)

Describe "${cmdletFile}" {

    Context "Parameter Validation" {

        New-Item -Path "TestDrive:\" -Name "envfile.txt" -ItemType File -Force
        New-Item -Path "TestDrive:\" -Name "envfile.json" -ItemType File -Force

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
}#>