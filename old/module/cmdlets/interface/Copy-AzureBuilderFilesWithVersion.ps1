function Copy-AzureBuilderFilesWithVersion
{
    <#
        .DESCRIPTION
        Appends ARM template and DSC configuration files with content version value and copies to specified location

        .EXAMPLE
        Copy-AzureBuilderFilesWithVersion -SearchFolder "C:\templates" -OutputFolder "C:\versioned-templates"
    #>
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [ValidateScript( { $PSItem | Test-Path -PathType "Container" } )]
        [String]
        $SearchFolder = (Get-Location),

        [Parameter(Mandatory = $true)]
        [ValidateScript( { $PSItem | Test-Path -PathType "Container" -IsValid } )]
        [String]
        $OutputFolder,

        [Parameter()]
        [ValidateSet( 'ARM', 'DSC', 'Script')]
        [String]
        $FileType = "ARM"
    )
    begin
    {
        Write-Verbose "Starting $($MyInvocation.MyCommand.Name)"
    }
    process
    {
        $files = Get-ChildItem -Path $SearchFolder -Recurse -File

        if($files)
        {
            foreach($filePath in $files.FullName)
            {
                Write-Verbose "Setting versioned file path for ${filePath}"

                switch($FileType)
                {
                    "ARM"
                    {
                        $versionedFilePath = Set-AzureBuilderTemplateFilePathWithVersion -Path $filePath
                    }
                    "DSC"
                    {
                        $versionedFilePath = Set-AzureBuilderConfigurationFilePathWithVersion -Path $filePath
                    }
                    "Script"
                    {
                        $versionedFilePath = Set-AzureBuilderScriptFilePathWithVersion -Path $filePath
                    }
                }

                $outputPath = $versionedFilePath -replace [regex]::Escape($SearchFolder), $OutputFolder

                Write-Verbose "Setting ${filePath} to versioned path ${outputPath}"

                if(!(Test-Path $outputPath -PathType "Leaf"))
                {
                    Write-Verbose "${outputPath} not found, creating file"
                    New-Item -Path $outputPath -ItemType "File" -Force | Out-Null
                }

                Copy-Item -Path $filePath -Destination $outputPath -Force
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