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
    $OutputFolder = "$env:BUILD_ARTIFACTSTAGINGDIRECTORY\templates",

    [Parameter()]
    [ValidateScript( { ($PSItem | Test-Path -PathType Leaf) -and ([System.IO.Path]::GetExtension($PSItem) -eq ".psd1") } )]
    [String]
    $ModulePath = "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\module\AzureBuilder.psd1"
)

Import-Module $ModulePath -Force

Copy-AzBuildTemplateFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder

