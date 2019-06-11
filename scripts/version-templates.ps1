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

Import-Module "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\module\AzureBuilder.psd1" -Force

Copy-AzBuildTemplateFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder

