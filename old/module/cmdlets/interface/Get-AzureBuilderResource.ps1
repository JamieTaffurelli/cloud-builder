function Get-AzureBuilderResource
{
    <#
        .DESCRIPTION
        Gets an Azure resource by type and name or by name

        .EXAMPLE
        Get-AzureBuilderResource -Type 'Storage Account' -Name 'mystorage'
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('Storage Account')]
        [String]
        $Type
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        switch($Type)
        {
            "Storage Account"
            {
                $resources = Get-AzStorageAccount | Where-Object { ($PSItem -ne $null) -and ($PSItem.StorageAccountName -eq $Name) }
            }
            default
            {
                $resources = Get-AzResource | Where-Object { ($PSItem -ne $null) -and ($PSItem.Name -eq $Name) }
            }
        }

        if($resources)
        {
            return $resources
        }
        else 
        {
            Write-Error "${Type} '${Name}' not found, make sure it exists and you have the permissions to view it"    
        }
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}