function Copy-AzureBuilderBlobItem
{
    <#
        .DESCRIPTION
        Copies an item to blob storage with option to skip existing blobs

        .EXAMPLE
        Copy-AzureBuilderBlobItem -StorageAccountName 'mystorage' -ContainerName 'mycontainer' -Blob 'blob.txt' -File 'C:\myFile.txt' -SkipExisting
    #>
    [CmdletBinding(DefaultParameterSetName = 'DynamicAuth')]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StorageAccountName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ContainerName,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript( { $PSItem | Test-Path -PathType Leaf } )]
        [Alias('FullName')]
        [String]
        $File,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Blob,

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
        $SasToken,

        [Parameter(Mandatory = $true, ParameterSetName = 'StorageContext')]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Azure.Commands.Common.Authentication.Abstractions.IStorageContext]
        $StorageContext,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $SkipExisting
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"

        switch($PSCmdlet.ParameterSetName)
        {
            "DynamicAuth"
            {
                $context = New-AzureBuilderStorageContext -StorageAccountName $StorageAccountName -AuthMethod $AuthMethod
                break
            }
            "StaticKeyAuth"
            {
                $context = New-AzureBuilderStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
                break
            }
            "StaticSasAuth"
            {
                $context = New-AzureBuilderStorageContext -StorageAccountName $StorageAccountName -SasToken $SasToken
                break
            }
            "StorageContext"
            {
                $context = $StorageContext
                break
            }
            default
            {
                throw "Parameter set not recognised"
            }
        }
        
        Write-Verbose "Checking container ${ContainerName} exists in ${StorageAccountName}"
        $context | Get-AzStorageContainer -Name $ContainerName -ErrorAction Stop | Out-Null
    }
    process
    {
        $blobExists = Test-AzureBuilderBlobItem -StorageAccountName $StorageAccountName -ContainerName $ContainerName -Blob $Blob -StorageContext $Context

        if($blobExists -and $SkipExisting)
        {
            Write-Verbose "Blob ${Blob} exists, skipping"
        }
        else 
        {
            Write-Host "Uploading ${Blob}"
            Set-AzStorageBlobContent -File $File -Blob $Blob -Container $ContainerName -Context $Context -Force
        }
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}