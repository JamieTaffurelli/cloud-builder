$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory = $PSScriptRoot -Replace "tests(\\|\/)unit(\\|\/)", "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "New-AzureBuilderStorageContext.ps1" -Resolve)

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    Context "Storage Context Validation" {

        Mock -CommandName New-AzureBuilderStorageContext -MockWith { }
        Mock -CommandName Get-AzStorageBlob -MockWith { }
        
        It "Uses OAuth authentication if specified" {

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses OAuth authentication by default" {

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "OAuth" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses dynamic key authentication by if specified" {

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Key" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Key" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses anonymous authentication by if specified" {

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "Anonymous" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $AuthMethod -eq "Anonymous" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses static key authentication by if specified" {

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -StorageAccountKey "StorageKey" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $StorageAccountKey -eq "StorageKey" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Uses static sas authentication by if specified" {

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -SasToken "StorageSas" | Out-Null

            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly -ParameterFilter { $SasToken -eq "StorageSas" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }
    }

    Context "Blob Retreival Validation" {

        Mock -CommandName New-AzureBuilderStorageContext -MockWith { }

        It "Returns false if Get-AzStorageBlob returns null" {

            Mock -CommandName Get-AzStorageBlob -MockWith { }

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" | should be $false

            Assert-MockCalled -CommandName Get-AzStorageBlob -Times 1 -Scope It -Exactly -ParameterFilter { $Blob -eq "storage/blob.txt" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Returns true if Get-AzStorageBlob returns something" {

            Mock -CommandName Get-AzStorageBlob -MockWith { "Blob" }

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" | should be $true

            Assert-MockCalled -CommandName Get-AzStorageBlob -Times 1 -Scope It -Exactly -ParameterFilter { $Blob -eq "storage/blob.txt" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Returns false if Get-AzStorageBlob does not find the blob" {

            Mock -CommandName Get-AzStorageBlob -MockWith { throw [Microsoft.WindowsAzure.Commands.Storage.Common.ResourceNotFoundException]::new("cannot find blob") }

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth" | should be $false

            Assert-MockCalled -CommandName Get-AzStorageBlob -Times 1 -Scope It -Exactly -ParameterFilter { $Blob -eq "storage/blob.txt" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
        }

        It "Writes an error if other exception is thrown" {

            Mock -CommandName Get-AzStorageBlob -MockWith { throw [System.Exception]::new("cannot find blob") }
            Mock -CommandName Write-Error -MockWith { }

            Test-AzureBuilderBlobItem -StorageAccountName "storageaccount" -ContainerName "storagecontainer" -Blob "storage/blob.txt" -AuthMethod "OAuth"

            Assert-MockCalled -CommandName Get-AzStorageBlob -Times 1 -Scope It -Exactly -ParameterFilter { $Blob -eq "storage/blob.txt" }
            Assert-MockCalled -CommandName New-AzureBuilderStorageContext -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "cannot find blob" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly
        }
    }
}