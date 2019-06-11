[CmdletBinding()]
param
(
    [Parameter()]
    [ValidateScript( { $PSItem | Test-Path -PathType Container } )]
    [String]
    $SearchFolder = "${env:SYSTEM_DEFAULTWORKINGDIRECTORY}\templates",

    [Parameter()]
    [Switch]
    $AsCsv
)

$inclusionTemplates = @(
    "Microsoft.Web/sites", 
    "Microsoft.Cdn/profiles", 
    "Microsoft.DocumentDb/databaseAccounts", 
    "Microsoft.DataLakeStore/accounts", 
    "Microsoft.Cache/Redis", 
    "Microsoft.Sql/servers", 
    "Microsoft.Storage/storageAccounts", 
    "Microsoft.Network/trafficmanagerprofiles", 
    "Microsoft.ServiceFabric/clusters", 
    "Microsoft.ContainerService/ManagedClusters",
    "Microsoft.Logic/workflows",
    "Microsoft.ContainerRegistry/registries",
    "Microsoft.KeyVault/vaults",
    "Microsoft.Network/virtualNetworks",
    "Microsoft.Search/searchServices",
    "Microsoft.EventHub/namespaces",
    "Microsoft.ContainerInstance/containerGroups"
)

$templateFilePaths = (Get-ChildItem -Path $SearchFolder -Recurse -File).FullName
$excludedTemplateFileNames = @()

foreach($templateFilePath in $templateFilePaths)
{
    $json = Get-Content -Path $templateFilePath | ConvertFrom-Json

    if($inclusionTemplates -notcontains $json.resources.type)
    {
        Write-Verbose "${templateFilePath} will be excluded from AzSK ARM template scanning"
        $excludedTemplateFileNames += Split-Path -Path $templateFilePath -Leaf
    }
}

if($AsCsv)
{
    $csvExcludedTemplateFileNames = ($excludedTemplateFileNames -join ',')
    Write-Host "##vso[task.setvariable variable=ExclusionTemplates]${csvExcludedTemplateFileNames}"

    return $csvExcludedTemplateFileNames
}
else
{
    return $excludedTemplateFileNames
}