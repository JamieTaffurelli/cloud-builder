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
    $ModulePath = (Get-ChildItem -Path $env:SYSTEM_DEFAULTWORKINGDIRECTORY -Recurse -Include "*AzureBuilder.psd1").FullName,

    [Parameter()]
    [ValidateSet( 'ARM', 'DSC', 'Script')]
    [String]
    $FileType = "ARM"
)

Import-Module $ModulePath -Force

Copy-AzureBuilderFilesWithVersion -SearchFolder $SearchFolder -OutputFolder $OutputFolder -FileType $FileType

