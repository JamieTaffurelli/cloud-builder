[cmdletbinding()]
param
(
    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $RecoveryServicesVaultName,

    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $RecoveryServicesVaultResourceGroupName,

    [parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $vmName = $env:COMPUTERNAME,

    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $databaseName,

    [parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $backupPath = "C:\Temp",

    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $KeyVaultName,

    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $AwsAccessKeySecretName,

    [parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $AwsDefaultRegion = "us-east-1"
)

$ErrorActionPreference = "Stop"

try
{
    if(!(Test-Path -Path "C:\AWSSQLBackups" -PathType Container))
    {
        New-Item -Path "C:\AWSSQLBackups" -ItemType Directory
    }

    Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Authenticating to Azure using identity" -Path "C:\AWSSQLBackups\log.txt"
    Connect-AzAccount -Identity

    Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Setting AWS Credentials" -Path "C:\AWSSQLBackups\log.txt"
    $env:AWS_ACCESS_KEY_ID = $AwsAccessKeySecretName
    $env:AWS_SECRET_ACCESS_KEY = Get-AzKeyVaultSecret -VaultName $KeyVaultName -SecretName $AwsAccessKeySecretName -AsPlainText
    $env:AWS_DEFAULT_REGION = $AwsDefaultRegion

    Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Getting backup details..." -Path "C:\AWSSQLBackups\log.txt"
    $vaultId = (Get-AzRecoveryServicesVault -Name $RecoveryServicesVaultName -ResourceGroupName $RecoveryServicesVaultResourceGroupName).ID
    $targetContainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVMAppContainer" -FriendlyName $vmName -VaultId $vaultId
    $backupItem = Get-AzRecoveryServicesBackupItem -WorkloadType "MSSQL" -Container $targetContainer -VaultId $vaultId -Name $databaseName
    $recoveryChain = Get-AzRecoveryServicesBackupRecoveryLogChain -Item $backupItem -VaultId $vaultId
    $fileRestoreWithLogConfig = Get-AzRecoveryServicesBackupWorkloadRecoveryConfig -PointInTime $recoveryChain.EndTime -TargetContainer $targetContainer -RestoreAsFiles -FilePath $backupPath -VaultId $vaultId -Item $backupItem

    Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Starting restore..." -Path "C:\AWSSQLBackups\log.txt"
    $backupJob = Restore-AzRecoveryServicesBackupItem -WLRecoveryConfig $fileRestoreWithLogConfig -VaultId $vaultId

    do
    {
        Start-Sleep -Seconds 5
    }
    while((Get-AzRecoveryServicesBackupJob -VaultId $vaultId -JobId $backupJob.JobId).Status -eq "InProgress")

    $backupJob = Get-AzRecoveryServicesBackupJob -VaultId $vaultId -JobId $backupJob.JobId

    if((Get-AzRecoveryServicesBackupJob -VaultId $vaultId -JobId $backupJob.JobId).Status -eq "Completed")
    {
        Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Zipping backup..." -Path "C:\AWSSQLBackups\log.txt"
        $zipName = '{0}-{1}' -f $vmName, (Get-Date -Format "yyyyMMddHHmm")

        Get-ChildItem -Path $backupPath | Compress-Archive -DestinationPath "${backupPath}\${zipName}"

        Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Uploading backup to AWS..." -Path "C:\AWSSQLBackups\log.txt"
        & aws s3 cp "${backupPath}\${zipName}.zip" "s3://test123backups/" | Out-File -FilePath "C:\AWSSQLBackups\log.txt" -Append
        Add-Content -Value "`n$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Deleting local backup" -Path "C:\AWSSQLBackups\log.txt"
        Get-ChildItem -Path $backupPath | Remove-Item -Force

        Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Backup task executed successfully" -Path "C:\AWSSQLBackups\log.txt"
    }
    else
    {
        throw "Job id $($backupJob.JobId) failed with status $($backupJob.Status)"
    }
}
catch
{
    Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) ${PSITEM}" -Path "C:\AWSSQLBackups\log.txt"
    throw $PSITEM
}

