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
    $databaseName
)

$ErrorActionPreference = "Stop"

try
{
    if(!(Test-Path -Path "C:\AzureSQLRestores" -PathType Container))
    {
        New-Item -Path "C:\AzureSQLRestores" -ItemType Directory
    }

    Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Authenticating to Azure using identity" -Path "C:\AzureSQLRestores\log.txt"
    Connect-AzAccount -Identity

    Add-Content -Value "$('[{0:MM/dd/yy} {0:HH:mm:ss}]' -f (Get-Date)) Getting backup details..." -Path "C:\AzureSQLRestores\log.txt"
    $vaultId = (Get-AzRecoveryServicesVault -Name $RecoveryServicesVaultName -ResourceGroupName $RecoveryServicesVaultResourceGroupName).ID
    $backupContainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVMAppContainer" -FriendlyName $vmName -VaultId $vaultId
    $backupItem = Get-AzRecoveryServicesBackupItem -WorkloadType "MSSQL" -Container $targetContainer -VaultId $vaultId -Name $databaseName
    $recoveryChain = Get-AzRecoveryServicesBackupRecoveryLogChain -Item $backupItem -VaultId $vaultId
    $targetContainer = Get-AzRecoveryServicesBackupContainer -ContainerType "AzureVMAppContainer" -FriendlyName $env:COMPUTERNAME -VaultId $vaultId
    $targetItem = Get-AzRecoveryServicesBackupItem -WorkloadType "MSSQL" -Container $targetContainer -VaultId $vaultId -Name $databaseName
    $fileRestoreWithLogConfig = Get-AzRecoveryServicesBackupWorkloadRecoveryConfig -PointInTime $recoveryChain.EndTime -TargetContainer $targetContainer -Target-AlternateWorkloadRestore -VaultId $vaultId -Item $backupItem

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

