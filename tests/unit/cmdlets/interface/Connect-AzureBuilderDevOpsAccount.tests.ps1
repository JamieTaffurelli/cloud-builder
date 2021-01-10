$cmdletFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$interfaceCmdletDirectory = $PSScriptRoot -Replace "tests(\\|\/)unit(\\|\/)", "module"
$internalCmdletDirectory = $interfaceCmdletDirectory -Replace "interface", "internal"
. (Join-Path -Path $interfaceCmdletDirectory -ChildPath $cmdletFile -Resolve)

function Get-VstsInput
{
    param($Name, [switch]$Require, $Default)
    throw [System.NotImplementedException]
}

function Get-VstsEndpoint
{
    param($Name, [switch]$Require, $Default)
    throw [System.NotImplementedException]
}

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    Context "Authentication Validation" {

        It "Throws if there is an error connecting to Azure Subscription" {

            Mock Get-VstsInput { "ServicePrincipal" } -Verifiable
            Mock Get-VstsEndpoint { @{ Auth = @{ Parameters = @{ TenantId = "Tenant"; ServicePrincipalId = "Id"; ServicePrincipalKey = "Key" }; }; Data = @{ SubscriptionId = "SubId" } } } -Verifiable
            Mock Connect-AzAccount { throw "Cannot Connect" } -Verifiable
            Mock Select-AzSubscription { } -Verifiable

            { Connect-AzureBuilderDevOpsAccount -Name "ServicePrincipal" -ErrorAction Stop } | should throw "An error occurred whilst attempting to connect to Azure using the Service Connection: Cannot Connect"

            Assert-MockCalled Get-VstsInput -Times 1 -Scope It -Exactly
            Assert-MockCalled Get-VstsEndpoint -Times 1 -Scope It -Exactly
            Assert-MockCalled Add-AzAccount -Times 1 -Scope It -Exactly
            Assert-MockCalled Select-AzSubscription -Times 0 -Scope It -Exactly
        }

        It "Connects to Azure Subscription" {

            Mock Get-VstsInput { "ServicePrincipal" } -Verifiable
            Mock Get-VstsEndpoint { @{ Auth = @{ Parameters = @{ TenantId = "Tenant"; ServicePrincipalId = "Id"; ServicePrincipalKey = "Key" }; }; Data = @{ SubscriptionId = "SubId" } } } -Verifiable
            Mock Add-AzAccount { } -Verifiable
            Mock Select-AzSubscription { } -Verifiable

            { Connect-AzureBuilderDevOpsAccount -Name "ServicePrincipal" -ErrorAction Stop } | should not throw

            Assert-MockCalled Get-VstsInput -Times 1 -Scope It -Exactly
            Assert-MockCalled Get-VstsEndpoint -Times 1 -Scope It -Exactly
            Assert-MockCalled Add-AzAccount -Times 1 -Scope It -Exactly
            Assert-MockCalled Select-AzSubscription -Times 1 -Scope It -Exactly
        }
    }
}