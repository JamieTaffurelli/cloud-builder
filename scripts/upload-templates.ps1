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

$SearchPath = $SearchPath -replace "/", "\"
$templates = Get-ChildItem -Path $SearchPath -Recurse -Include "*.json"

if($templates)
{
    foreach($template in $templates)
    {
        Copy-AzBuildBlobItem -File $template.FullName -StorageAccountName $StorageAccountName -ContainerName $ContainerName -Blob ($template.FullName -replace [Regex]::Escape($SearchPath), [String]::Empty) -SkipExisting
    }
}
else 
{
    Write-Warning "No json templates found in ${SearchPath}"
}

