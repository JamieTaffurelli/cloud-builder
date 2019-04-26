function Out-ABParameterFile
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $InputObject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $ResourcesObject,

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
        Write-Verbose "Starting Out-ABParameterFile"
        Write-Verbose "All files will be output to ${OutputPath}"
    }
    process
    {
        foreach($resourceObjectName in $ResourcesObject.PSObject.Properties.Name)
        {
            $resourceObject = $ResourcesObject.$resourceObjectName

            Write-Verbose "Setting content version of ${resourceObjectName}"
            Set-ABContentVersion -ResourceObject $resourceObject

            Write-Verbose "Setting schema of ${resourceObjectName}"
            Set-ABJsonSchema -ResourceObject $resourceObject -Schema $Schema

            if($null -eq $resourceObject.importedParameters)
            {
                $commonParameters = $jsonConversion.commonParameters

                if($null -eq $jsonConversion.commonParameters)
                {
                    Write-Error "Could not find common parameters in ${resourceObjectName}"
                }
                else 
                {
                    Import-ABCommonParameters -ResourceObject $resourceObject -CommonParameters $commonParameters
                }                   
            }

            $templateParametersPath = Join-Path -Path $resourceObject.type -ChildPath "$(resourceObject.template).json"
            $outputTemplateParametersPath = Join-Path -Path $OutputPath -ChildPath $templateParametersPath

            @("type", "template") | ForEach-Object { $resourceObject.PSObject.Properties.Remove($PSItem) }

            if((Test-Path -Path $outputTemplateParametersPath) -and !($Force))
            {
                Write-Verbose "${outputTemplateParametersPath} exists, skipping"
            }
            else 
            {
                Write-Verbose "Writing parameter file to ${outputTemplateParametersPath}"

                $resourceObject | ConvertFrom-Json | Set-Content -Path $outputTemplateParametersPath
            }
        }
    }
    end
    {
        Write-Verbose "Finished Out-ABParameterFile"
    }
}