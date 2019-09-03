function Add-AzBuildKeyVaultManagedStorageAccount
{
    <#
        .DESCRIPTION
        Copies an item to blob storage with option to skip existing blobs

        .EXAMPLE
        Copy-AzBuildBlobItem -StorageAccountName 'mystorage' -ContainerName 'mycontainer' -Blob 'blob.txt' -File 'C:\myFile.txt' -SkipExisting
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StorageAccountName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $VaultName,

        [Parameter()]
        [ValidateSet('key1', 'key2')]
        [String]
        $ActiveKeyName = "key1",

        [Parameter()]
        [ValidateRange(0, 365)]
        [String]
        $RegenerationPeriodDays = 90,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $DisableAutoRegenerateKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $CreateRoleAssignment
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        $storageAccount = Get-AzStorageAccount | Where-Object { $PSItem.StorageAccountName -eq $StorageAccountName }

        if($storageAccount)
        {
            $storageAccountResourceId = $storageAccount.Id

            if($CreateRoleAssignment)
            {
                $servicePrincipalId = (Get-AzADServicePrincipal -ServicePrincipalName cfa8b339-82a2-471a-a3c9-0fc0be7a4093).Id
            }

            Add-AzKeyVaultManagedStorageAccount `
                -VaultName $VaultName `
                -AccountName $StorageAccountName `
                -AccountResourceId $storageAccountResourceId `
                -ActiveKeyName $ActiveKeyName `
                -RegenerationPeriod [System.Timespan]::FromDays($RegenerationPeriodDays) `
                -ErrorAction "Stop"

        }
        else 
        {
            Write-Error "Storage Account ${StorageAccountName} not found, please make sure it exists and you have permissions to view it"    
        }
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}