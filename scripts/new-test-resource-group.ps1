[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String[]]
    $CharacterCodes = @(97..122),

    [Parameter()]
    [ValidateRange(1, 90)]
    [int]
    $RandomStringCount = 5,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $ResourceGroupPrefix = "rgtest",

    [Parameter()]
    [Switch]
    $Force
)

$random = ((97..122) | Get-Random -Count 5 | ForEach-Object { [char]$PSItem }) -Join [String]::Empty
$resourceGroupName = ("{0}-{1}") -f $ResourceGroupPrefix, $random

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if($resourceGroup)
{
    if($Force)
    {
        Set-AzResourceGroup -Name $resourceGroupName -Tag @{ Purpose = "TemplateUnitTesting" }
        Write-Host "##vso[task.setvariable variable=ResourceGroupName]${resourceGroupName}"
    }
    else
    {
        Write-Error "Resource Group ${resourceGroupName} with Resource ID $($resourceGroup.ResourceId) already exists"
    } 
}
else
{
    New-AzResourceGroup -Name $resourceGroupName -Location "northeurope" -Tag @{ Purpose = "TemplateUnitTesting" } -Force
    Write-Host "##vso[task.setvariable variable=ResourceGroupName]${resourceGroupName}"
}