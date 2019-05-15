function Get-AzBuildResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [String]
        $Name,

        [Parameter()]
        [ValidateSet('StorageAccount')]
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
            "StorageAccount"
            {
                $resources = Get-AzStorageAccount | Where-Object { $PSItem.StorageAccountName -eq $Name }
            }
            "Default"
            {
                $resources = Get-AzResource | Where-Object { $PSItem.Name -eq $Name}
            }
        }

        if($resources)
        {
            return $resources
        }
        else 
        {
            Write-Error "${Type} '${StorageAccountName}' not found, make sure it exists and you have the permissions to view it"    
        }
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}