$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory = $PSScriptRoot -Replace "tests(\\|\/)unit(\\|\/)", "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath "Test-AzureBuilderBlobItem.ps1" -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "New-AzureBuilderStorageContext.ps1" -Resolve)v

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    New-Item -Path "TestDrive:\blob1.txt" -ItemType File
    New-Item -Path "TestDrive:\blob2.txt" -ItemType File

    Context "Storage Context Validation" {

        Mock -CommandName New-AzureBuilderStorageContext -MockWith { }
        Mock -CommandName Get-AzStorageBlob -MockWith { }
        Mock -CommandName Get-AzStorageContainer -MockWith { }
        Mock -CommandName Test-AzureBuilderBlobItem -MockWith { }
        Mock -CommandName Set-AzStorageBlobContent -MockWith { }
        Mock -CommandName Write-Host -MockWith { }
        
        It "Uses OAuth authentication if specified" {

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses OAuth authentication by default" {

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses dynamic key authentication by if specified" {

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Key" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Key" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses anonymous authentication by if specified" {

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Anonymous" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Anonymous" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses static key authentication by if specified" {

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -StorageAccountKey "StorageKey" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $StorageAccountKey -eq "StorageKey" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses static sas authentication by if specified" {

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -SasToken "StorageSas" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $SasToken -eq "StorageSas" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }
    }

    Context "Blob Upload Validation" {

        Mock -CommandName New-AzureBuilderStorageContext -MockWith { }
        Mock -CommandName Get-AzStorageBlob -MockWith { }
        Mock -CommandName Get-AzStorageContainer -MockWith { }
        Mock -CommandName Set-AzStorageBlobContent -MockWith { }
        Mock -CommandName Write-Host -MockWith { }
        Mock -CommandName Write-Verbose -MockWith { }
        
        It "Does not upload if blob found and SkipExisting is true" {

            Mock -CommandName Test-AzureBuilderBlobItem -MockWith { $true }

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" -SkipExisting | Out-Null

            Assert-MockCalled -CommandName Test-AzureBuilderBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 0 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }

        It "Does upload if blob not found and SkipExisting is true" {

            Mock -CommandName Test-AzureBuilderBlobItem -MockWith { $false }

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" -SkipExisting | Out-Null

            Assert-MockCalled -CommandName Test-AzureBuilderBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 0 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }

        It "Does upload if blob not found and SkipExisting is false" {

            Mock -CommandName Test-AzureBuilderBlobItem -MockWith { $false }

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName Test-AzureBuilderBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 0 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }

        It "Does upload if blob is found and SkipExisting is false" {

            Mock -CommandName Test-AzureBuilderBlobItem -MockWith { $true }

            Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" -File "TestDrive:\blob1.txt" | Out-Null

            Assert-MockCalled -CommandName Test-AzureBuilderBlobItem -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Verbose -Times 0 -Scope It -Exactly -ParameterFilter { $Message -eq "Blob storage/blob.txt exists, skipping" }
        }

        It "Accepts file object and fullname pipeline input" {

            Mock -CommandName Test-AzureBuilderBlobItem -MockWith { }

            @("TestDrive:\blob1.txt", (Get-Item -Path "TestDrive:\blob2.txt")) | Copy-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" | Out-Null

            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly -ParameterFilter { $File -eq "TestDrive:\blob1.txt" }
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 1 -Scope It -Exactly -ParameterFilter { $File -eq "${TestDrive}\blob2.txt" }
            Assert-MockCalled -CommandName Set-AzStorageBlobContent -Times 2 -Scope It -Exactly
        }
    }
}