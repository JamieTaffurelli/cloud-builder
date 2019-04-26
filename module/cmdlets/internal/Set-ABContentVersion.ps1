function Set-ABContentVersion
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $ResourceObject
    )
    begin
    {
        Write-Verbose "Starting Set-ABContentVersion"
    }
    process
    {
        if($ResourceObject.PSObject.Properties.Name -contains ("contentVersion"))
        {
            if($null -eq ($ResourceObject.contentVersion -as [System.Version]))
            {
                Write-Error "contentVersion '$($ResourceObject.contentVersion)' is not a valid version"
            }
            else
            {
                Write-Verbose "Resource parameters will have version $($ResourceObject.contentVersion)"
            }
        }
        else
        {
            $contentVersion = "1.0.0.0"

            Write-Verbose "Resource parameters will have version ${contentVersion}"

            $ResourceObject | Add-Member -MemberType NoteProperty -Name "contentVersion" -Value $contentVersion
        }
    }
    end
    {
        Write-Verbose "Finished Set-ABContentVersion"
    }
}