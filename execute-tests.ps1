[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceGroupName = $env:ResourceGroupName
)

Invoke-Pester `
    -Script @{ Path = "${PSScriptRoot}\tests\*"; Parameters = @{ ResourceGroupName = $ResourceGroupName } } `
    -EnableExit `
    -Show "Failed"