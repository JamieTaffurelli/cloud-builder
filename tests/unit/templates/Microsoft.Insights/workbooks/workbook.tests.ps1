$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Workbook Parameter Validation" {

    Context "workbookName Validation" {

        It "Has workbookName parameter" {

            $json.parameters.workbookName | should not be $null
        }

        It "workbookName parameter is of type string" {

            $json.parameters.workbookName.type | should be "string"
        }

        It "workbookName parameter is mandatory" {

            ($json.parameters.workbookName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "location Validation" {

        It "Has location parameter" {

            $json.parameters.location | should not be $null
        }

        It "location parameter is of type string" {

            $json.parameters.location.type | should be "string"
        }

        It "location parameter default value is [resourceGroup().location]" {

            $json.parameters.location.defaultValue | should be "[resourceGroup().location]"
        }

        It "location parameter allowed values are northeurope, westeurope" {

            (Compare-Object -ReferenceObject $json.parameters.location.allowedValues -DifferenceObject @("northeurope", "westeurope")).Length | should be 0
        }
    }

    Context "kind Validation" {

        It "Has kind parameter" {

            $json.parameters.kind | should not be $null
        }

        It "kind parameter is of type string" {

            $json.parameters.kind.type | should be "string"
        }

        It "kind parameter default value is Shared" {

            $json.parameters.kind.defaultValue | should be "Shared"
        }

        It "kind parameter allowed values are Shared, User" {

            (Compare-Object -ReferenceObject $json.parameters.kind.allowedValues -DifferenceObject @("Shared", "User")).Length | should be 0
        }
    }

    Context "displayName Validation" {

        It "Has displayName parameter" {

            $json.parameters.displayName | should not be $null
        }

        It "displayName parameter is of type string" {

            $json.parameters.displayName.type | should be "string"
        }

        It "displayName parameter is mandatory" {

            ($json.parameters.displayName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "serializedData Validation" {

        It "Has serializedData parameter" {

            $json.parameters.serializedData | should not be $null
        }

        It "serializedData parameter is of type string" {

            $json.parameters.serializedData.type | should be "string"
        }

        It "serializedData parameter is mandatory" {

            ($json.parameters.serializedData.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "version Validation" {

        It "Has version parameter" {

            $json.parameters.version | should not be $null
        }

        It "version parameter is of type string" {

            $json.parameters.version.type | should be "string"
        }

        It "version parameter is mandatory" {

            ($json.parameters.version.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "category Validation" {

        It "Has category parameter" {

            $json.parameters.category | should not be $null
        }

        It "category parameter is of type string" {

            $json.parameters.category.type | should be "string"
        }

        It "category parameter default value is workbook" {

            $json.parameters.category.defaultValue | should be "workbook"
        }
    }

    Context "workbookTags Validation" {

        It "Has workbookTags parameter" {

            $json.parameters.workbookTags | should not be $null
        }

        It "workbookTags parameter is of type array" {

            $json.parameters.workbookTags.type | should be "array"
        }

        It "workbookTags parameter default value is an empty array" {

            $json.parameters.workbookTags.defaultValue.Count | should be 0
        }
    }

    Context "sourceId Validation" {

        It "Has sourceId parameter" {

            $json.parameters.sourceId | should not be $null
        }

        It "sourceId parameter is of type string" {

            $json.parameters.sourceId.type | should be "string"
        }

        It "sourceId parameter is mandatory" {

            ($json.parameters.sourceId.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "tags Validation" {

        It "Has tags parameter" {

            $json.parameters.tags | should not be $null
        }

        It "tags parameter is of type object" {

            $json.parameters.tags.type | should be "object"
        }

        It "tags parameter is mandatory" {

            ($json.parameters.tags.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }
}

Describe "Workbook Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/workbooks" {

            $json.resources.type | should be "Microsoft.Insights/workbooks"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2020-10-20" {

            $json.resources.apiVersion | should be "2020-10-20"
        }
    }
}

Describe "Workbook Output Validation" {

    Context "Workbook Reference Validation" {

        It "type value is object" {

            $json.outputs.workbook.type | should be "object"
        }

        It "Uses full reference for Workbook" {

            $json.outputs.workbook.value | should be "[reference(resourceId('Microsoft.Insights/workbooks', guid(parameters('workbookName'), resourceGroup().id)), '2020-10-20', 'Full')]"
        }
    }
}