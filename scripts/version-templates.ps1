[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateScript( { $_ | Test-Path -PathType "Container" } )]
    [String]
    $SearchFolder = "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\templates",

    [Parameter(Mandatory = $true)]
    [ValidateScript( { $_ | Test-Path -PathType "Container" -IsValid } )]
    [String]
    $OutputFolder = $env:BUILD_ARTIFACTSTAGINGDIRECTORY
)
    
Import-Module "$(Split-Path -Path $PSScriptRoot)\module\azurebuild.psd1" -Force
Write-Host "b: $OutputFolder"
Write-Host "c: $env:BUILD_ARTIFACTSTAGINGDIRECTORY"
Copy-AzBuildTemplateFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder

