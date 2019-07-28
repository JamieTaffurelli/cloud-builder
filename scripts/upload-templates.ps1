[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $StorageAccountName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $ContainerName,

    [Parameter(Mandatory = $true)]
    [ValidateScript( { $PSItem | Test-Path -PathType "Container" -IsValid } )]
    [String]
    $SearchPath
)

Import-Module "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\module\AzureBuilder.psd1" -Force

$templates = Get-ChildItem -Path $SearchPath -Recurse -Include "*.json"

if($templates)
{
    $templates | Copy-AzBuildItem -StorageAccountName $StorageAccountName -ContainerName $ContainerName -Blob ($PSItem.FullName -replace [Regex]::Escape($SearchPath), [String]::Empty)  -SkipExisting
}
else 
{
    Write-Warning "No json templates found in ${SearchPath}"
}

