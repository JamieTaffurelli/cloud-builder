<#PSScriptInfo

.VERSION 1.1.0

.GUID 3e9cc084-703b-496f-b508-ced49bb46061

.AUTHOR jltaffurelli@outlook.com

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

$ErrorActionPreference = "Stop"

Write-Output "Getting automation connection AzureRunAsConnection"
$connection = Get-AutomationConnection -Name AzureRunAsConnection

Write-Output "Authenticating with AzureRunAsConnection"
Connect-AzureAD -Tenant $connection.TenantID -ApplicationId $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint

Write-Output "Getting application details"
$apps = Get-AzureADApplication -All $true
$message = "{0} with object ID {1} has key ID {2} that expires on {3}, which is {4} than the specified {5} days"
$errCount = 0
foreach($app in $apps)
{
    if($app.Tags | Where-Object { $ExcludeTags -contains $_ })
    {
        Write-Output "Excluding $($app.DisplayName) with object ID $($app.ObjectId) as there are matching exclusion tags"
    }
    else 
    {
        $keys = @($app.PasswordCredentials) + @($app.KeyCredentials)

        foreach($key in $keys)
        {
            if($key.EndDate -lt (Get-Date).AddDays($DaysBeforeExpiry))
            {
                $errCount++
                Write-Error (($message) -f $app.DisplayName, $app.ObjectId, $key.KeyId, $key.EndDate.ToString("dd/MM/yyyy"), "less", $DaysBeforeExpiry)
            }
            else 
            {
                Write-Output (($message) -f $app.DisplayName, $app.ObjectId, $key.KeyId, $key.EndDate.ToString("dd/MM/yyyy"), "more", $DaysBeforeExpiry)
            }
        }
    }
}

if($errCount)
{
    throw "Applications are expiring in less than ${DaysBeforeExpiry} days"
}


