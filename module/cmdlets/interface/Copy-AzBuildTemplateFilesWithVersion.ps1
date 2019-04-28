function Copy-AzBuildTemplateFilesWithVersion
{
    <#
        .DESCRIPTION
        Appends template files with content version value and copies to specified location

        .EXAMPLE
        Copy-AzBuildTemplateFilesWithVersion -SearchFolder "C:\templates" -OutputFolder "C:\versioned-templates"
    #>
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateScript( { $_ | Test-Path -PathType "Container" } )]
        [String]
        $SearchFolder = (Get-Location),

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $_ | Test-Path -PathType "Container" -IsValid } )]
        [String]
        $OutputFolder
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        $templateFilePaths = Get-ChildItem -Path $SearchFolder -Recurse -Filter "*.json"

        if($templateFilePaths)
        {
            foreach($templateFilePath in $templateFilePaths.FullName)
            {
                Write-Verbose "Setting versioned file path for ${templateFilePath}"
                $versionedTemplateFilePath = Set-AzBuildTemplateFilePathWithVersion -Path $templateFilePath

                $outputPath = $versionedTemplateFilePath -replace [regex]::Escape($SearchFolder), $OutputFolder

                Write-Verbose "Setting ${templateFilePath} to versioned path ${outputPath}"

                if(!(Test-Path $outputPath -PathType "Leaf"))
                {
                    Write-Verbose "${outputPath} not found, creating file"
                    New-Item -Path $outputPath -ItemType "File" -Force | Out-Null
                }

                Copy-Item -Path $templateFilePath -Destination $outputPath -Force
            }
        }
        else
        {
            Write-Warning "No templates found in ${SearchFolder}"
        }
    }
    end
    {
        Write-Verbose "Finished $($MyInvocation.MyCommand.Name)"
    }
}