$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json
Describe "Application Insights Parameter Validation" {

    Context "appInsightsName Validation" {

        It "Has appInsightsName parameter" {

            $json.parameters.appInsightsName | should not be $null
        }

        It "appInsightsName parameter is of type string" {

            $json.parameters.appInsightsName.type | should be "string"
        }

        It "appInsightsName parameter is mandatory" {

            ($json.parameters.appInsightsName.PSObject.Properties.Name -contains "defaultValue") | should be $false
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

        It "kind parameter default value is web" {

            $json.parameters.kind.defaultValue | should be "web"
        }
    }

    Context "appType Validation" {

        It "Has appType parameter" {

            $json.parameters.appType | should not be $null
        }

        It "appType parameter is of type string" {

            $json.parameters.appType.type | should be "string"
        }

        It "appType parameter default value is web" {

            $json.parameters.appType.defaultValue | should be "web"
        }

        It "appType parameter allowed values are web and other" {

            (Compare-Object -ReferenceObject $json.parameters.appType.allowedValues -DifferenceObject @("web", "other")).Length | should be 0
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

Describe "Application Insights Resource Validation" {

    Context "type Validation" {

        It "type value is Microsoft.Insights/components" {

            $json.resources.type | should be "Microsoft.Insights/components"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2015-05-01" {

            $json.resources.apiVersion | should be "2015-05-01"
        }
    }
}

Describe "Application Insights Output Validation" {

    Context "Application Insights Reference Validation" {

        It "type value is object" {

            $json.outputs.appInsights.type | should be "object"
        }

        It "Uses full reference for Application Insights" {

            $json.outputs.appInsights.value | should be "[reference(resourceId('Microsoft.Insights/components', parameters('appInsightsName')), '2015-05-01', 'Full')]"
        }
    }
}