[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateScript( { $PSItem | Test-Path -PathType "Container" } )]
    [String]
    $SearchFolder = "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\templates",

    [Parameter()]
    [ValidateScript( { $PSItem | Test-Path -PathType "Container" -IsValid } )]
    [String]
    $OutputFolder = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY\templates"
)

Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Install-Module -Name Az -Force -Scope CurrentUser

Import-Module "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\module\AzureBuilder.psd1" -Force

Copy-AzBuildTemplateFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder

