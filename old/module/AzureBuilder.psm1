$cmdletsPaths = (Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "cmdlets" -Resolve) -File -Recurse).FullName

foreach($cmdletPath in $cmdletsPaths)
{
    . $cmdletPath
}