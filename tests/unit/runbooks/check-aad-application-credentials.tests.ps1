$runbookFile = $MyInvocation.MyCommand.Name -Replace ".tests", ""
$runbookDirectory = $PSScriptRoot -Replace [Regex]::Escape("tests\unit"), ""

function Get-AutomationConnection
{
    $connection = @{
        TenantId              = "guid"
        ApplicationId         = "guid"
        CertificateThumbprint = "hash"
    }

    return $connection
}

Describe "$(Split-Path -Path $PSCommandPath -Leaf)" {

    $app = @{
        DisplayName         = "app"
        objectID            = "guid"
        Tags                = @("Exclude", "NotExclude") 
        PasswordCredentials = @{
            KeyId   = "guid"
            EndDate = ""
        }
        KeyCredentials      = @{
            KeyId   = "guid"
            EndDate = ""
        }
    }

    Mock -CommandName Connect-AzureAD -MockWith { }
    Mock -CommandName Write-Output -MockWith { }
    Mock -CommandName Write-Error -MockWith { }
    Mock -CommandName Get-AzureADApplication -MockWith { $app }

    Context "Check credential validation" {

        It "Skips if matching tags are found" {

            Mock -CommandName Get-AzureADApplication -MockWith { $app }

            . (Join-Path -Path $runbookDirectory -ChildPath $runbookFile -Resolve) -ExcludeTags @("Exclude")

            Assert-MockCalled -CommandName Get-AzureADApplication -Scope It -Times 1 -Exactly
            Assert-MockCalled -CommandName Write-Output -Scope It -Times 1 -Exactly -ParameterFilter { $InputObject -eq "Excluding $($app.DisplayName) with object ID guid as there are matching exclusion tags" }
        }

        It "Not expiring values" {

            $app.PasswordCredentials.EndDate = (Get-Date).AddDays(31)
            $app.KeyCredentials.EndDate = (Get-Date).AddDays(31)

            . (Join-Path -Path $runbookDirectory -ChildPath $runbookFile -Resolve)

            Assert-MockCalled -CommandName Get-AzureADApplication -Scope It -Times 1 -Exactly
            Assert-MockCalled -CommandName Write-Output -Scope It -Times 2 -Exactly -ParameterFilter { $InputObject -eq "$($app.DisplayName) with object ID $($app.ObjectId) has key ID $($app.PasswordCredentials.KeyId) that expires on $($app.PasswordCredentials.EndDate.ToString("dd/MM/yyyy")), which is more than the specified 30 days" }
        }

        It "Expiring values" {

            $app.PasswordCredentials.EndDate = (Get-Date).AddDays(29)
            $app.KeyCredentials.EndDate = (Get-Date).AddDays(29)

            { . (Join-Path -Path $runbookDirectory -ChildPath $runbookFile -Resolve) } | should throw "Applications are expiring in less than 30"

            Assert-MockCalled -CommandName Get-AzureADApplication -Scope It -Times 1 -Exactly
            Assert-MockCalled -CommandName Write-Error -Scope It -Times 2 -Exactly -ParameterFilter { $Message -eq "$($app.DisplayName) with object ID $($app.ObjectId) has key ID $($app.PasswordCredentials.KeyId) that expires on $($app.PasswordCredentials.EndDate.ToString("dd/MM/yyyy")), which is less than the specified 30 days" }
        }
    }
}