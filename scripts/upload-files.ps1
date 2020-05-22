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
    $ModulePath = (Get-ChildItem -Path $env:PIPELINE_WORKSPACE -Recurse -Include "*AzureBuilder.psd1").FullName
)

Import-Module $ModulePath -Force

$SearchPath = $SearchPath -replace "/", "\"
$files = Get-ChildItem -Path $SearchPath -Recurse -File

if($files)
{
    foreach($file in $files)
    {
        Copy-AzureBuilderBlobItem -File $file.FullName -StorageAccountName $StorageAccountName -ContainerName $ContainerName -Blob ($file.FullName -replace [Regex]::Escape($SearchPath), [String]::Empty) -SkipExisting
    }
}
else 
{
    Write-Warning "No files found in ${SearchPath}"
}

