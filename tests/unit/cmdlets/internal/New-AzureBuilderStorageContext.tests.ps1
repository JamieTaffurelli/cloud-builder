$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$internalCmdletDirectory  = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
$interfaceCmdletDirectory = $internalCmdletDirectory -Replace "internal", "interface"
. (Join-Path -Path $internalCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath "Get-AzureBuilderResource.ps1" -Resolve)

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    Context "Storage Context Validation" {

        Mock -CommandName New-AzStorageContext -MockWith { "Storage Context" }
        Mock -CommandName Get-AzureBuilderResource -MockWith { @{ ResourceGroupName = "ResourceGroup"; StorageAccountName = "StorageAccount" } }
        Mock -CommandName Get-AzStorageAccountKey -MockWith { @("PrimaryStorageKey", "SecondaryStorageKey") }
        Mock -CommandName Write-Warning -MockWith {}

        It "Sets Storage Context with OAuth authentication as default" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" | should be "Storage Context"

            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { ($StorageAccountName -eq "StorageAccount") -and ($UseConnectedAccount -eq $true) }
            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly
        }

        It "Sets Storage Context with OAuth authentication if specified" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -AuthMethod "OAuth" | should be "Storage Context"

            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { ($StorageAccountName -eq "StorageAccount") -and ($UseConnectedAccount -eq $true) }
            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly
        }

        It "Sets Storage Context with dynamic key authentication if specified" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -AuthMethod "Key" | should be "Storage Context"

            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { ($StorageAccountName -eq "StorageAccount") -and ($StorageAccountKey -eq "PrimaryStorageKey") }
            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Get-AzureBuilderResource -Times 1 -Scope It -Exactly -ParameterFilter { ($Name -eq "StorageAccount") -and ($Type -eq "Storage Account") }
            Assert-MockCalled -CommandName Get-AzureBuilderResource -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Get-AzStorageAccountKey -Times 1 -Scope It -Exactly -ParameterFilter { ($Name -eq "StorageAccount") -and ($ResourceGroupName -eq "ResourceGroup") }
            Assert-MockCalled -CommandName Get-AzStorageAccountKey -Times 1 -Scope It -Exactly
        }

        It "Sets Storage Context with anonymous authentication if specified" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -AuthMethod "Anonymous" | should be "Storage Context"

            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { ($StorageAccountName -eq "StorageAccount") -and ($Anonymous -eq $true) }
            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly
        }

        It "Sets Storage Context with static key authentication if specified" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -StorageAccountKey "StorageKey" | should be "Storage Context"

            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { ($StorageAccountName -eq "StorageAccount") -and ($StorageAccountKey -eq "StorageKey") }
            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly
        }

        It "Sets Storage Context with static SAS token authentication if specified" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -SasToken "StorageSAS" | should be "Storage Context"

            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { ($StorageAccountName -eq "StorageAccount") -and ($SasToken -eq "StorageSAS") }
            Assert-MockCalled -CommandName New-AzStorageContext -Times 1 -Scope It -Exactly
        }

        It "Enforces use of https in all cases" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" | should be "Storage Context"
            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -AuthMethod "OAuth" | should be "Storage Context"
            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -AuthMethod "Key" | should be "Storage Context"
            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -AuthMethod "Anonymous" | should be "Storage Context"
            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -StorageAccountKey "StorageKey" | should be "Storage Context"
            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -SasToken "StorageSAS" | should be "Storage Context"

            Assert-MockCalled -CommandName New-AzStorageContext -Times 6 -Scope It -Exactly -ParameterFilter { ($StorageAccountName -eq "StorageAccount") -and ($Protocol -eq "https") }
            Assert-MockCalled -CommandName New-AzStorageContext -Times 6 -Scope It -Exactly
        }

        It "Warns if not using OAuth authentication" {

            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -AuthMethod "Key" | should be "Storage Context"
            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -StorageAccountKey "StorageKey" | should be "Storage Context"
            New-AzureBuilderStorageContext -StorageAccountName "StorageAccount" -SasToken "StorageSAS" | should be "Storage Context"

            Assert-MockCalled -CommandName Write-Warning -Times 3 -Scope It -Exactly -ParameterFilter { $Message -eq "Consider using default OAuth method of authentication for Storage Account authentication" }
            Assert-MockCalled -CommandName Write-Warning -Times 3 -Scope It -Exactly
        }
    }
}