function New-AzureBuilderStorageContext
{
    [CmdletBinding(DefaultParameterSetName = 'DynamicAuth')]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StorageAccountName,

        [Parameter(ParameterSetName = 'DynamicAuth')]
        [ValidateSet('OAuth', 'Key', 'Anonymous')]
        [String]
        $AuthMethod = 'OAuth',

        [Parameter(Mandatory = $true, ParameterSetName = 'StaticKeyAuth')]
        [ValidateNotNullOrEmpty()]
        [String]
        $StorageAccountKey,

        [Parameter(Mandatory = $true, ParameterSetName = 'StaticSasAuth')]
        [ValidateNotNullOrEmpty()]
        [String]
        $SasToken
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        $params = @{
            StorageAccountName = $StorageAccountName
            Protocol           = "https"
        }

        if((@("StaticKeyAuth", "StaticSasAuth") -contains $PSCmdlet.ParameterSetName) -or ($AuthMethod -eq "Key"))
        {
            Write-Warning "Consider using default OAuth method of authentication for Storage Account authentication"

            if(($PSCmdlet.ParameterSetName -eq "StaticKeyAuth") -or ($AuthMethod -eq "Key"))
            {
                if($AuthMethod -eq "Key")
                {
                    $storageAccount = Get-AzureBuilderResource -Name $StorageAccountName -Type "Storage Account"
                    $StorageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $StorageAccountName)[0]
                }

                $params.Add('StorageAccountKey', $StorageAccountKey)
            }
            else 
            {
                $params.Add('SasToken', $SasToken)
            }
        }
        else
        {
            if($AuthMethod -eq "OAuth")
            {
                $params.Add('UseConnectedAccount', $true)
            }
            else 
            {
                $params.Add('Anonymous', $true)
            }
        }

        return (New-AzStorageContext @params)
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
} 