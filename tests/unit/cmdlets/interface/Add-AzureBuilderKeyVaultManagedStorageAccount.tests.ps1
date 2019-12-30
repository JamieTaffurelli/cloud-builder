$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath "Test-AzureBuilderBlobItem.ps1" -Resolve)
. (Join-Path -Path $internalCmdletDirectory -ChildPath "New-AzureBuilderStorageContext.ps1" -Resolve)v

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    Mock -CommandName Add-AzKeyVaultManagedStorageAccount -MockWith { }

    Context "Key Rotation Validation" {

        It "Errors if Storage Account not found" {

            Mock -CommandName Get-AzStorageAccount -MockWith { }
            Mock -CommandName Write-Error -MockWith { }

            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" } | should not throw

            Assert-MockCalled Write-Error -Times 1 -Exactly -Scope It -ParameterFilter { $Message -eq "Storage Account mystorage not found, please make sure it exists and you have permissions to view it" }
        }

        It "Applies key rotation" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ Id = "myStorageId"; StorageAccountName = "mystorage" } }
            Mock -CommandName Add-AzKeyVaultManagedStorageAccount -MockWith { }

            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" } | should not throw

            Assert-MockCalled -Times 1 -Exactly -Scope It Add-AzKeyVaultManagedStorageAccount -ParameterFilter { $AccountResourceId -eq "myStorageId" }
        }

        It "Sets custom regen period" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ Id = "myStorageId"; StorageAccountName = "mystorage" } }
            Mock -CommandName Add-AzKeyVaultManagedStorageAccount -MockWith { }

            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" -RegenerationPeriodDays 50 } | should not throw

            Assert-MockCalled -Times 1 -Exactly -Scope It Add-AzKeyVaultManagedStorageAccount -ParameterFilter { ($AccountResourceId -eq "myStorageId") -and ($RegenerationPeriod -eq ([System.Timespan]::FromDays(50))) }
        }

        It "Sets active keys" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ Id = "myStorageId"; StorageAccountName = "mystorage" } }
            Mock -CommandName Add-AzKeyVaultManagedStorageAccount -MockWith { }

            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" -ActiveKey 'key1' } | should not throw
            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" -ActiveKey 'key2' } | should not throw

            Assert-MockCalled -Times 1 -Exactly -Scope It Add-AzKeyVaultManagedStorageAccount -ParameterFilter { ($AccountResourceId -eq "myStorageId") -and ($ActiveKeyName -eq 'key1') }
            Assert-MockCalled -Times 1 -Exactly -Scope It Add-AzKeyVaultManagedStorageAccount -ParameterFilter { ($AccountResourceId -eq "myStorageId") -and ($ActiveKeyName -eq 'key2') }
        }
    }

    Context "Role Creation Validation" {

        Mock -CommandName New-AzRoleAssignment -MockWith { }

        It "Skips Role Assignment if flag is false" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ Id = "myStorageId"; StorageAccountName = "mystorage" } }
            Mock -CommandName Add-AzKeyVaultManagedStorageAccount -MockWith { }
            Mock -CommandName Get-AzADServicePrincipal -MockWith { @{ Id = "myServicePrinicipalId" } }
            Mock -CommandName Get-AzRoleAssignment -MockWith { }

            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" } | should not throw
            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" -CreateRoleAssignment:$false } | should not throw

            Assert-MockCalled -Times 0 -Exactly -Scope It Get-AzRoleAssignment
            Assert-MockCalled -Times 0 -Exactly -Scope It Get-AzADServicePrincipal
            Assert-MockCalled -Times 0 -Exactly -Scope It New-AzRoleAssignment
        }

        It "Skips Role Assignment if it already exists" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ Id = "myStorageId"; StorageAccountName = "mystorage" } }
            Mock -CommandName Add-AzKeyVaultManagedStorageAccount -MockWith { }
            Mock -CommandName Get-AzRoleAssignment -MockWith { "NotNull" }
            Mock -CommandName Get-AzADServicePrincipal -MockWith { @{ Id = "myServicePrinicipalId" } }
            
            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" -CreateRoleAssignment } | should not throw

            Assert-MockCalled -Times 1 -Exactly -Scope It Get-AzRoleAssignment
            Assert-MockCalled -Times 1 -Exactly -Scope It Get-AzADServicePrincipal
            Assert-MockCalled -Times 0 -Exactly -Scope It New-AzRoleAssignment
        }

        It "Creates Role Assignment if it already exists" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ Id = "myStorageId"; StorageAccountName = "mystorage" } }
            Mock -CommandName Add-AzKeyVaultManagedStorageAccount -MockWith { }
            Mock -CommandName Get-AzRoleAssignment -MockWith { }
            Mock -CommandName Get-AzADServicePrincipal -MockWith { @{ Id = "myServicePrinicipalId" } }
            
            { Add-AzureBuilderKeyVaultManagedStorageAccount -StorageAccountName "mystorage" -VaultName "myvault" -CreateRoleAssignment } | should not throw

            Assert-MockCalled -Times 1 -Exactly -Scope It Get-AzRoleAssignment
            Assert-MockCalled -Times 1 -Exactly -Scope It Get-AzADServicePrincipal
            Assert-MockCalled -Times 1 -Exactly -Scope It New-AzRoleAssignment -ParameterFilter { ($ObjectId -eq "myServicePrinicipalId") -and ($RoleDefinitionName -eq 'Storage Account Key Operator Service Role') -and ($Scope -eq "myStorageId") }
        }
    }
}