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
    $ModulePath = (Get-ChildItem -Path $env:SYSTEM_DEFAULTWORKINGDIRECTORY -Recurse -Include "*AzureBuilder.psd1").FullName
)

Import-Module $ModulePath -Force

Copy-AzureBuilderTemplateFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder

