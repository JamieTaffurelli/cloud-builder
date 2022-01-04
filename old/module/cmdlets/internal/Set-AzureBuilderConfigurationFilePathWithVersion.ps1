function Set-AzureBuilderConfigurationFilePathWithVersion
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq ".ps1") } )]
        [String]
        $Path
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        $configurationName = ((Get-Content -Path $Path -First 1) -split " ") | Select-Object -Last 1

        if ($configurationName -match "(?<number>\d)")
        {
            $configurationVersion = $configurationName.Substring($configurationName.indexOf($Matches.number))

            if(($configurationVersion -notmatch '^\d+$') -or ($configurationVersion.Length -ne 3))
            {
                Write-Error "${configurationName} does not end with a 3 digit verion (without periods '.')"
            }
        }
        else 
        {
            Write-Error "${configurationName} does not end with a 3 digit verion (without periods '.')"
        }

        $parentFolder = [System.IO.Path]::GetDirectoryName($Path)
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

        $versionedPath = ("{0}\{1}{2}.ps1") -f $parentFolder, $fileName, $configurationVersion

        return $versionedPath
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}