function ConvertTo-ABParameterFile
{
    <#
        .DESCRIPTION

        .EXAMPLE
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { [System.IO.Path]::GetExtension($PSItem) -eq ".json" } )]
        [String]
        $EnvironmentPath,

        [Parameter()]
        [ValidateScript( { $PSItem | Test-Path -IsValid } )]
        [String]
        $OutputPath = (Get-Location),

        [Parameter()]
        [ValidateScript( { $PSItem -like "https://schema.management.azure.com/schemas/*/deploymentParameters.json#" } )]
        [String]
        $Schema = "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",

        [Parameter()]
        [Switch]
        $Force
    )
    begin
    {
        Write-Verbose "Starting ConvertTo-ABParameterFile"
        Write-Verbose "All files will be output to ${OutputPath}"
    }
    process
    {
        Write-Verbose "Converting ${EnvironmentPath} to separate parameter files"

        $jsonConversion = (Get-Content -Path $EnvironmentPath) | ConvertFrom-Json

        $resources = $jsonConversion.resources

        if(($null -eq $resources) -or ($resources.GetType().Name -ne "PSCustomObject") )
        {
            Write-Error "No resources were found in ${EnvironmentPath} or resources was not a JSON object"
        }
        else
        {
            Out-ABParameterFile -InputObject $jsonConversion -ResourcesObject $resources -OutputPath $OutputPath -Schema $Schema -Force:$Force
        }
    }
    end
    {
        Write-Verbose "Finished ConvertTo-ABParameterFile"
    }
}