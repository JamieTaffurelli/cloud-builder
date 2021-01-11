$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [Regex]::Escape(("tests{0}unit{1}" -f [IO.Path]::DirectorySeparatorChar, [IO.Path]::DirectorySeparatorChar)), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Connector Parameter Validation" {

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

    Context "connectorType Validation" {
        It "Has connectorType parameter" {
            $json.parameters.connectorType | should not be $null
        }
        It "connectorType parameter is of type string" {
            $json.parameters.connectorType.type | should be "string"
        }
        It "connectorType parameter is mandatory" {
            $json.parameters.connectorType.PSObject.Properties.Name -contains "defaultValue" | should be $false
        }
    }

    Context "connectorName Validation" {
        It "Has connectorName parameter" {
            $json.parameters.connectorName | should not be $null
        }
        It "connectorName parameter is of type string" {
            $json.parameters.connectorName.type | should be "string"
        }
        It "connectorName parameter is mandatory" {
            $json.parameters.connectorName.PSObject.Properties.Name -contains "defaultValue" | should be $false
        }
    }

    Context "connectorDisplayName Validation" {
        It "Has connectorDisplayName parameter" {
            $json.parameters.connectorDisplayName | should not be $null
        }
        It "connectorDisplayName parameter is of type string" {
            $json.parameters.connectorDisplayName.type | should be "string"
        }
        It "connectorDisplayName parameter is mandatory" {
            $json.parameters.connectorDisplayName.PSObject.Properties.Name -contains "defaultValue" | should be $false
        }
    }

    Context "parameterValues Validation" {
        It "Has parameterValues parameter" {
            $json.parameters.parameterValues | should not be $null
        }
        It "parameterValues parameter is of type secureobject" {
            $json.parameters.parameterValues.type | should be "secureobject"
        }
        It "parameterValues parameter is mandatory" {
            $json.parameters.parameterValues.PSObject.Properties.Name -contains "defaultValue" | should be $false
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

Describe "Connector Resource Validation" {

    Context "type Validation" {
        It "type value is Microsoft.Web/connections" {
            $json.resources.type | should be "Microsoft.Web/connections"
        }
    }

    Context "apiVersion Validation" {
        It "apiVersion value is 2016-06-01" {
            $json.resources.apiVersion | should be "2016-06-01"
        }
    }

}
Describe "Connector Output Validation" {

    Context "Connector Reference Validation" {

        It "type value is object" {
            $json.outputs.connector.type | should be "object"
        }
        It "Uses full reference for connector" {
            $json.outputs.connector.value | should be "[reference(resourceId('Microsoft.Web/connections', parameters('connectorName')), '2016-06-01', 'Full')]"
        }
    }
}
