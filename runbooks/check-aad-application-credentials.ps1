
<#PSScriptInfo

.VERSION 0.1.0

.GUID 3e1b78ea-8a5b-4fa6-a45f-a8ea4cb24d8b

.AUTHOR jamie.taffurelli@swiftcover.com

.COMPANYNAME AXA Insurance UK

.COPYRIGHT 2020 AXA Insurance UK. All rights reserved.

#>

<# 

.DESCRIPTION 
 Query AAD for application secrets and certificates that are expiring in a specified number of days 

#> 

param
(
    [Parameter()]
    [int] 
    $DaysBeforeExpiry = 30,

    [Parameter()]
    [string[]] 
    $ExcludeTags
)

Write-Output "Getting automation connection AzureRunAsConnection"
$connection = Get-AutomationConnection -Name AzureRunAsConnection

Write-Output "Authenticating with AzureRunAsConnection"
Connect-AzureAD -Tenant $connection.TenantID -ApplicationId $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint -ErrorAction "Stop"

Write-Output "Getting application details"
$apps = Get-AzureADApplication -All $true
$message = "{0} with object ID {1} has key ID {2} that expires on {3}, which is {4} than the specified {5} days"

foreach($app in $apps)
{
    if($app.Tags | Where-Object { $ExcludeTags -contains $_ })
    {
        Write-Output "Excluding $($app.DisplayName) with object ID $($app.ObjectId) as there are matching exclusion tags"
    }
    else 
    {
        $secrets = $app.PasswordCredentials
        $certs = $app.KeyCredentials

        foreach($secret in $secrets)
        {
            if($secret.EndDate -lt (Get-Date).AddDays($DaysBeforeExpiry))
            {
                Write-Error (($message) -f $app.DisplayName, $app.ObjectId, $secret.KeyId, $secret.EndDate.ToString("dd/MM/yyyy"), "less", $DaysBeforeExpiry)
            }
            else 
            {
                Write-Output (($message) -f $app.DisplayName, $app.ObjectId, $secret.KeyId, $secret.EndDate.ToString("dd/MM/yyyy"), "more", $DaysBeforeExpiry)
            }
        }

        foreach($cert in $certs)
        {
            if($cert.EndDate -lt (Get-Date).AddDays($DaysBeforeExpiry))
            {
                Write-Error (($message) -f $app.DisplayName, $app.ObjectId, $cert.KeyId, $cert.EndDate.ToString("dd/MM/yyyy"), "less", $DaysBeforeExpiry)
            }
            else 
            {
                Write-Output (($message) -f $app.DisplayName, $app.ObjectId, $cert.KeyId, $cert.EndDate.ToString("dd/MM/yyyy"), "more", $DaysBeforeExpiry)
            }
        }
    }
}


