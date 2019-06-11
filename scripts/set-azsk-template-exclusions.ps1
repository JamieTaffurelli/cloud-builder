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
    "Microsoft.Web\sites", 
    "Microsoft.Cdn\profiles", 
    "Microsoft.DocumentDb\databaseAccounts", 
    "Microsoft.DataLakeStore\accounts", 
    "Microsoft.Cache\Redis", 
    "Microsoft.Sql\servers", 
    "Microsoft.Storage\storageAccounts", 
    "Microsoft.Network\trafficmanagerprofiles", 
    "Microsoft.ServiceFabric\clusters", 
    "Microsoft.ContainerService\ManagedClusters",
    "Microsoft.Logic\workflows",
    "Microsoft.ContainerRegistry\registries",
    "Microsoft.KeyVault\vaults",
    "Microsoft.Network\virtualNetworks",
    "Microsoft.Search\searchServices",
    "Microsoft.EventHub\namespaces",
    "Microsoft.ContainerInstance\containerGroups"
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
















foreach($InclusionFolder in $InclusionFolders)
{
    $inclusionFolderPath = Join-Path -Path $SearchFolder -ChildPath $InclusionFolder

    if(Test-Path -Path $inclusionFolderPath -PathType Container)
    {
        Write-Verbose "Including ${inclusionFolderPath} for ARM template scanning"
        $inclusionTemplates += (Get-ChildItem -Path $inclusionFolderPath -File).FullName
    }
    else 
    {
        Write-Verbose "${inclusionFolderPath} not found for ARM template scanning"
    }
}

$exclusionTemplates = ((Get-ChildItem -Path $SearchFolder -File -Recurse).FullName | Where-Object { $inclusionTemplates -notcontains $PSItem })

if($AsCsv)
{
    $csvExclusionTemplatesFullPath = ($exclusionTemplates -join ',')

    Write-Host "Search folder:"
    Write-Host $SearchFolder

    Write-Host "Full paths:"
    Write-Host $csvExclusionTemplatesFullPath
    $csvExclusionTemplatesRelativePath = (($csvExclusionTemplatesFullPath -replace [Regex]::Escape("D:\_work\1\s\templates"), [String]::Empty) -replace [Regex]::Escape(',\'), ",").Trim('\')

    Write-Host "Relative paths:"
    Write-Host $csvExclusionTemplatesRelativePath
    Write-Host "##vso[task.setvariable variable=ExclusionTemplates]${csvExclusionTemplatesRelativePath}"

    return $csvExclusionTemplatesFullPath
}
else
{
    return $exclusionTemplates
}