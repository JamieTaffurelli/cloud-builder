$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath "Test-AzBuildBlobItem.ps1" -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "New-AzBuildStorageContext.ps1" -Resolve)v

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    New-Item -Path "TestDrive:\blob1.txt" -ItemType File

    Context "Storage Context Validation" {

        Mock -CommandName New-AzBuildStorageContext -MockWith { }
        Mock -CommandName Get-AzStorageBlob -MockWith { }
        Mock -CommandName Get-AzStorageContainer -MockWith { }
        Mock -CommandName Test-AzBuildBlobItem -MockWith { }
        Mock -CommandName Set-AzStorageBlobContent -MockWith { }
        Mock -CommandName Write-Host -MockWith { }
        
        It "Uses OAuth authentication if specified" {

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses OAuth authentication by default" {

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses dynamic key authentication by if specified" {

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Key" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Key" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses anonymous authentication by if specified" {

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Anonymous" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Anonymous" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses static key authentication by if specified" {

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -StorageAccountKey "StorageKey" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $StorageAccountKey -eq "StorageKey" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses static sas authentication by if specified" {

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -SasToken "StorageSas" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $SasToken -eq "StorageSas" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }
    }

    Context "Storage Container Validation" {

        Mock -CommandName New-AzBuildStorageContext -MockWith { }
        Mock -CommandName Get-AzStorageBlob -MockWith { }
        Mock -CommandName Test-AzBuildBlobItem -MockWith { }
        Mock -CommandName Set-AzStorageBlobContent -MockWith { }
        Mock -CommandName Write-Host -MockWith { }
        
        It "Gets Storage Account Container" {

            Mock -CommandName Get-AzStorageContainer -MockWith { }

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName Get-AzStorageContainer -Times 1 -Scope It -Exactly -ParameterFilter { $Name -eq "storagecontainer" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }

        It "Throws if Storage Account Container not found" {

            Mock -CommandName Get-AzStorageContainer -MockWith { Write-Error "Container not found" }
            
            { Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" } | should throw "Container not found"

            Assert-MockCalled -CommandName Get-AzStorageContainer -Times 1 -Scope It -Exactly -ParameterFilter { $Name -eq "storagecontainer" }
            Assert-MockCalled -CommandName New-AzBuildStorageContext -Times 1 -Scope It -Exactly
        }
    }

    Context "Blob Upload Validation" {

        Mock -CommandName New-AzBuildStorageContext -MockWith { }
        Mock -CommandName Get-AzStorageBlob -MockWith { }
        Mock -CommandName Get-AzStorageContainer -MockWith { }
        Mock -CommandName Set-AzStorageBlobContent -MockWith { }
        Mock -CommandName Write-Host -MockWith { }
        Mock -CommandName Write-Verbose -MockWith { }
        
        It "Does not upload if blob found and SkipExisting is true" {

            Mock -CommandName Test-AzBuildBlobItem -MockWith { $true }

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" -SkipExisting | Out-Null

            Assert-MockCalled -CommandName Test-AzBuildBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 0 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }

        It "Does upload if blob not found and SkipExisting is true" {

            Mock -CommandName Test-AzBuildBlobItem -MockWith { $false }

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" -SkipExisting | Out-Null

            Assert-MockCalled -CommandName Test-AzBuildBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 0 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }

        It "Does upload if blob not found and SkipExisting is false" {

            Mock -CommandName Test-AzBuildBlobItem -MockWith { $false }

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName Test-AzBuildBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 0 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }

        It "Does upload if blob is found and SkipExisting is false" {

            Mock -CommandName Test-AzBuildBlobItem -MockWith { $true }

            Copy-AzBuildItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName Test-AzBuildBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 0 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }
    }
}