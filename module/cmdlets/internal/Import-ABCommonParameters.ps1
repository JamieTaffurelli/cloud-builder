function Import-ABCommonParameters
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $ResourceObject,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $CommonParameters
    )
    begin
    {
        Write-Verbose "Starting Import-ABCommonParameters"
    }
    process
    {
        foreach($importedParameterName in $ResourceObject.importedParameters.PSObject.Properties.Name)
        {
            if($CommonParameters.PSObject.Properties.Name -contains $ResourceObject.importedParameters.$importedParameterName)
            {
                $ResourceObject.Parameters | Add-Member -MemberType NoteProperty -Name $importedParameterName -Value $CommonParameters.($ResourceObject.importedParameters.$importedParameterName)
            }
            else 
            {
                Write-Error "$($ResourceObject.importedParameters.$importedParameterName) was not found in common parameters"
            }
        }
    }
    end
    {
        Write-Verbose "Finished Import-ABCommonParameters"
    }
}