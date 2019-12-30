$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("\tests\unit"), [String]::Empty
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

    Context "tags Validation" {
        It "Has tagOpCo tag parameter" {
            $json.parameters.tagOpCo | should not be $null
        }
        It "Has tagEnvironment tag parameter" {
            $json.parameters.tagEnvironment | should not be $null
        }
        It "Has tagApplication tag parameter" {
            $json.parameters.tagApplication | should not be $null
        }
        It "Has tagUse tag parameter" {
            $json.parameters.tagUse | should not be $null
        }
        It "Has tagsAdditional tag parameter" {
            $json.parameters.tagsAdditional | should not be $null
        }

        It "tagOpCo tag parameter is of type string" {
            $json.parameters.tagOpCo.type | should be "string"
        }
        It "tagEnvironment tag parameter is of type string" {
            $json.parameters.tagEnvironment.type | should be "string"
        }
        It "tagApplication tag parameter is of type string" {
            $json.parameters.tagApplication.type | should be "string"
        }
        It "tagUse tag parameter is of type string" {
            $json.parameters.tagUse.type | should be "string"
        }
        It "tagsAdditional tag parameter is of type object" {
            $json.parameters.tagsAdditional.type | should be "object"
        }

        It "tagOpCo tag parameter is not mandatory" {
            $json.parameters.tagOpCo.PSObject.Properties.Name -contains "defaultValue" | should be $true 
        }
        It "tagEnvironment tag parameter is mandatory" { 
            $json.parameters.tagEnvironment.PSObject.Properties.Name -contains "defaultValue" | should be $false 
        }
        It "tagApplication tag parameter is mandatory" { 
            $json.parameters.tagApplication.PSObject.Properties.Name -contains "defaultValue" | should be $false 
        }
        It "tagUse tag parameter is mandatory" { 
            $json.parameters.tagUse.PSObject.Properties.Name -contains "defaultValue" | should be $false 
        }
        It "tagsAdditional tag parameter is not mandatory" {
            $json.parameters.tagsAdditional.PSObject.Properties.Name -contains "defaultValue" | should be $true 
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
