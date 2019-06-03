[CmdletBinding()]
param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $modules
)

Install-PackageProvider -Name NuGet -Force -Scope CurrentUser

foreach($module in $modules)
{
    Install-Module -Name $module -Force -Scope CurrentUser
}
