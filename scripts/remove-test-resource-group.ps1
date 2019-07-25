[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceGroupName = $env:ResourceGroupName
)

Remove-AzResourceGroup -Name $ResourceGroupName -Force
