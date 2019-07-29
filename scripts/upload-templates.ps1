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
    $SearchPath,

    [Parameter()]
    [ValidateScript( { ($PSItem | Test-Path -PathType Leaf) -and ([System.IO.Path]::GetExtension($PSItem) -eq ".psd1") } )]
    [String]
    $ModulePath = (Get-ChildItem -Path $env:SYSTEM_DEFAULTWORKINGDIRECTORY -Recurse -Include "*AzureBuilder.psd1").FullName
)

Import-Module $ModulePath -Force

$templates = Get-ChildItem -Path $SearchPath -Recurse -Include "*.json"

if($templates)
{
    $templates | Copy-AzBuildBlobItem -StorageAccountName $StorageAccountName -ContainerName $ContainerName -Blob ($PSItem.FullName -replace [Regex]::Escape($SearchPath), [String]::Empty)  -SkipExisting
}
else 
{
    Write-Warning "No json templates found in ${SearchPath}"
}

