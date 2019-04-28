[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateScript( { $_ | Test-Path -PathType "Container" } )]
    [String]
    $SearchFolder = "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\templates",

    [Parameter()]
    [ValidateScript( { $_ | Test-Path -PathType "Container" -IsValid } )]
    [String]
    $OutputFolder = $env:BUILD_ARTIFACTSTAGINGDIRECTORY
)

Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Install-Module -Name Az -Force -Scope CurrentUser

Import-Module "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\module\AzureBuilder.psd1" -Force

Copy-AzBuildTemplateFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder

