[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Modules
)

Install-PackageProvider -Name NuGet -Force -Scope CurrentUser

foreach($module in $Modules)
{
    Install-Module -Name $module -Force -Scope CurrentUser
}
