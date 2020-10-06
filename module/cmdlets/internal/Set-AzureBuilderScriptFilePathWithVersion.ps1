function Set-AzureBuilderScriptFilePathWithVersion
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
        $scriptInfo = Test-ScriptFileInfo -Path $Path

        $version = $scriptInfo.Version

        if($version -as [version])
        {
            $parentFolder = [System.IO.Path]::GetDirectoryName($Path)
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

            $versionedPath = ("{0}\{1}.{2}.ps1") -f $parentFolder, $fileName, $version

            return $versionedPath
        }
        else
        {
            Write-Error "${Path} does not have a valid version '${version}', make sure script info is attached to script by using New-ScriptFileInfo and specifiying version"
        }
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}