function Set-AzBuildTemplateFilePathWithVersion
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { ($PSItem | Test-Path -PathType "Leaf") -and ([System.IO.Path]::GetExtension($PSItem) -eq ".json") } )]
        [String]
        $Path
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        $json = Get-Content -Path $Path | ConvertFrom-Json

        $version = $json.ContentVersion

        if($version -as [version])
        {
            $parentFolder = [System.IO.Path]::GetDirectoryName($Path)
            $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

            $versionedPath = ("{0}\{1}.{2}.json") -f $parentFolder, $fileName, $version

            return $versionedPath
        }
        else
        {
            Write-Error "${Path} does not have a valid content version '${version}'"
        }
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}