Configuration DomainJoin100
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ComputerManagementDsc
    
    Node $AllNodes.Nodename
    {
        $JoinDomainCredential = Get-AutomationPSCredential -Name $Node.JoinDomainUser
        
        Computer JoinDomain
        {
            Name       = $Node.NodeName
            DomainName = $Node.DomainName
            Credential = $JoinDomainCredential
            JoinOU     = $Node.DomainOU
        }
    }
}