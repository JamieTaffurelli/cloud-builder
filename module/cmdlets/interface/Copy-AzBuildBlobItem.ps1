function Copy-AzBuildBlobItem
{
    <#
        .DESCRIPTION
        

        .EXAMPLE
        
    #>
    [CmdletBinding(DefaultParameterSetName = 'DynamicAuth')]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StorageAccountName,

        [Parameter()]
        [ValidateSet('Default', 'Key', 'Anonymous')]
        [String]
        $AuthMethod = 'Default',

        [Parameter(Mandatory = $true, ParameterSetName = 'StaticKeyAuth')]
        [ValidateNotNullOrEmpty()]
        [String]
        $StorageAccountKey
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"

        if($PSCmdlet.ParameterSetName -eq "DynamicAuth")
        {
            $storageAccount = Get-AzStorageAccount | Where-Object { $_.StorageAccountName -eq $StorageAccountName }

            if(!($storageAccount))
            {
                Write-Error "Storage Account '${StorageAccountName}' not found, make sure it exists and you have the permissions to view it"
            }
        }
        

        if(($PSCmdlet.ParameterSetName -eq "StaticKeyAuth") -or ($AuthMethod -eq "Key"))
        {
            Write-Warning "Consider using default OAuth method of authentication for V2 Storage Accounts"

            if($AuthMethod -eq "Key")
            {
                $key = (Get-AzStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $StorageAccountName)[0]
            }
            
            $storageContext = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $key
        }
    }
    process
    {
        

        
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}