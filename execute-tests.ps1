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
    -OutputFile "${PSScriptRoot}\test-results.xml" `
    -CodeCoverage "${PSScriptRoot}\module\cmdlets\*" `
    -CodeCoverageOutputFile "${PSScriptRoot}\code-coverage.xml" `
    -CodeCoverageOutputFileFormat "JaCoCo" `
    -Show "All"