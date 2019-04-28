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
    
Import-Module "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\module\AzureBuilder.psd1" -Force

Copy-AzBuildTemplateFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder

