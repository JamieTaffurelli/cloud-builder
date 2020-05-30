function Connect-AzureBuilderDevOpsAccount
{
    <#
        .DESCRIPTION
        Connect to Azure in an Azure DevOps pipelines task

        .EXAMPLE
        Connect-AzureBuilderDevOpsAccount -Name 'ServicePrincipalName'
    #>
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [object]
        $Name  
    )
    begin
    {
        "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        try
        {
            $accountName = Get-VstsInput -Name $Name
            $endpoint = Get-VstsEndpoint -Name $accountName -Require
            $id = $endpoint.Auth.Parameters.ServicePrincipalId
            $key = ConvertTo-SecureString $endpoint.Auth.Parameters.ServicePrincipalKey -AsPlainText -Force
            $cred = New-Object System.Management.Automation.PSCredential($id, $key)
            $tenant = $endpoint.Auth.Parameters.TenantId

            Connect-AzAccount -ServicePrincipal -Tenant $tenant -Credential $cred -EnvironmentName "AzureCloud" -ErrorAction Stop
            Set-AzContext -SubscriptionId $endpoint.Data.SubscriptionId
        }
        catch
        {
            Write-Error "An error occurred whilst attempting to connect to Azure using the Service Connection: $_"
        }    
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}