[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceGroupName = $env:ResourceGroupName
)

$scripts = (Get-ChildItem "${PSScriptRoot}\module\cmdlets" -Include "*.ps1" -Recurse).FullName

Invoke-Pester `
    -Script @{ Path = "${PSScriptRoot}\tests\*"; Parameters = @{ ResourceGroupName = $ResourceGroupName } } `
    -OutputFile "${PSScriptRoot}\test-results.xml" `
    -OutputFormat "NUnitXML" `
    -CodeCoverage $scripts `
    -CodeCoverageOutputFile "${PSScriptRoot}\code-coverage.xml" `
    -Show "All"