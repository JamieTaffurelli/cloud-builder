$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory  = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath "Test-AzBuildBlobItem.ps1" -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "New-AzBuildStorageContext.ps1" -Resolve)v

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    New-Item -Path "TestDrive:\blob1.txt" -ItemType File

    Context "Storage Context Validation" {

        Mock -CommandName New-AzBuildStorageContext -MockWith { "StorageContext" }
        Mock -CommandName Get-AzStorageBlob -MockWith {}
        Mock -CommandName Get-AzStorageContainer -MockWith {}
        Mock -CommandName Test-AzBuildBlobItem -MockWith {}
        
        It "Uses OAuth authentication if specified" {

            Copy-AzBuildItem  -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses OAuth authentication by default" {

            Test-AzBuildBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses dynamic key authentication by if specified" {

            Test-AzBuildBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Key" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Key" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses anonymous authentication by if specified" {

            Test-AzBuildBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Anonymous" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Anonymous" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses static key authentication by if specified" {

            Test-AzBuildBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -StorageAccountKey "StorageKey" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $StorageAccountKey -eq "StorageKey" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }
    }
}