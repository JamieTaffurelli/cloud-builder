$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory = $PSScriptRoot -Replace "tests(\\|\/)unit(\\|\/)", "module"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    Context "Parameter Validation" {

        It "Only allows supported resource types" {

            $supportedResourceTypes = @("Storage Account")
            $cmdletResourceTypes = (Get-Command Get-AzureBuilderResource).Parameters.Type.Attributes.ValidValues

            @(Compare-Object -ReferenceObject $supportedResourceTypes -DifferenceObject $cmdletResourceTypes -SyncWindow 0).Length | should be 0
        }
    }

    Context "General Resource Validation" {

        It "Writes error if Get-AzResource returns null" {

            Mock -CommandName Get-AzResource -MockWith { }
            Mock -CommandName Write-Error -MockWith { }

            Get-AzureBuilderResource -Name "ResourceName"

            Assert-MockCalled -CommandName Get-AzResource -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq " 'ResourceName' not found, make sure it exists and you have the permissions to view it" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly
        }

        It "Writes error if Get-AzResource returns no resources with the specified name" {

            Mock -CommandName Get-AzResource -MockWith { @{ Name = "OtherResourceName" } }
            Mock -CommandName Write-Error -MockWith { }

            Get-AzureBuilderResource -Name "ResourceName"

            Assert-MockCalled -CommandName Get-AzResource -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq " 'ResourceName' not found, make sure it exists and you have the permissions to view it" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly
        }

        It "Returns resources with the same name if found" {

            Mock -CommandName Get-AzResource -MockWith { @{ Name = "ResourceName" } }
            Mock -CommandName Write-Error -MockWith { }

            (Get-AzureBuilderResource -Name "ResourceName").Name | should be "ResourceName"

            Assert-MockCalled -CommandName Get-AzResource -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 0 -Scope It -Exactly
        }
    }

    Context "Storage Account Validation" {

        It "Writes error if Get-AzStorageAccount returns null" {

            Mock -CommandName Get-AzStorageAccount -MockWith { }
            Mock -CommandName Write-Error -MockWith { }

            Get-AzureBuilderResource -Name "ResourceName" -Type "Storage Account"

            Assert-MockCalled -CommandName Get-AzStorageAccount -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Storage Account 'ResourceName' not found, make sure it exists and you have the permissions to view it" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly
        }

        It "Writes error if Get-AzStorageAccount returns no resources with the specified name" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ Name = "OtherResourceName" } }
            Mock -CommandName Write-Error -MockWith { }

            Get-AzureBuilderResource -Name "ResourceName"  -Type "Storage Account"

            Assert-MockCalled -CommandName Get-AzStorageAccount -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly -ParameterFilter { $Message -eq "Storage Account 'ResourceName' not found, make sure it exists and you have the permissions to view it" }
            Assert-MockCalled -CommandName Write-Error -Times 1 -Scope It -Exactly
        }

        It "Returns Storage Account with the same name if found" {

            Mock -CommandName Get-AzStorageAccount -MockWith { @{ StorageAccountName = "ResourceName" } }
            Mock -CommandName Write-Error -MockWith { }

            (Get-AzureBuilderResource -Name "ResourceName"  -Type "Storage Account").StorageAccountName | should be "ResourceName"

            Assert-MockCalled -CommandName Get-AzStorageAccount -Times 1 -Scope It -Exactly
            Assert-MockCalled -CommandName Write-Error -Times 0 -Scope It -Exactly
        }
    }
}