function Set-ABJsonSchema
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $ResourceObject,

        [Parameter()]
        [ValidateScript( { $PSItem -like "https://schema.management.azure.com/schemas/*/deploymentParameters.json#" } )]
        [String]
        $Schema = "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#"
    )
    begin
    {
        Write-Verbose "Starting Set-ABJsonSchema"
    }
    process
    {
        if($ResourceObject.PSObject.Properties.Name -contains ("schema"))
        {
            Write-Verbose "Resource parameters will use schema $($ResourceObject.schema)"
        }
        else
        {
            Write-Verbose "Resource parameters will have version ${schema}"

            $ResourceObject | Add-Member -MemberType NoteProperty -Name "schema" -Value $schema
        }
    }
    end
    {
        Write-Verbose "Finished Set-ABJsonSchema"
    }
}