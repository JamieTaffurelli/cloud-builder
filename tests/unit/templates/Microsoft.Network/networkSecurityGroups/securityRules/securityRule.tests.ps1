$testPath = Join-Path -Path $PSScriptRoot -ChildPath $MyInvocation.MyCommand.Name -Resolve
$armTemplatePath = ($testPath -replace "tests.ps1", "json") -replace [regex]::Escape("tests\unit"), [String]::Empty
$json = (Get-Content -Path $armTemplatePath) | ConvertFrom-Json

Describe "Security Rule Parameter Validation" {

    Context "securityRuleName Validation" {

        It "Has securityRuleName parameter" {

            $json.parameters.securityRuleName | should not be $null
        }

        It "securityRuleName parameter is of type string" {

            $json.parameters.securityRuleName.type | should be "string"
        }

        It "securityRuleName parameter is mandatory" {

            ($json.parameters.securityRuleName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "securityRuleName parameter minimum is 1" {

            $json.parameters.securityRuleName.minLength | should be 1
        }

        It "securityRuleName parameter is maximum length is 80" {

            $json.parameters.securityRuleName.maxLength | should be 80
        }
    }

    Context "nsgName Validation" {

        It "Has nsgName parameter" {

            $json.parameters.nsgName | should not be $null
        }

        It "nsgName parameter is of type string" {

            $json.parameters.nsgName.type | should be "string"
        }

        It "nsgName parameter is mandatory" {

            ($json.parameters.nsgName.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "description Validation" {

        It "Has description parameter" {

            $json.parameters.description | should not be $null
        }

        It "description parameter is of type string" {

            $json.parameters.description.type | should be "string"
        }

        It "description parameter is mandatory" {

            ($json.parameters.description.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "protocol Validation" {

        It "Has protocol parameter" {

            $json.parameters.protocol | should not be $null
        }

        It "protocol parameter is of type string" {

            $json.parameters.protocol.type | should be "string"
        }

        It "protocol parameter default value is TCP" {

            $json.parameters.protocol.defaultValue | should be "TCP"
        }

        It "protocol parameter allowed values are TCP, UDP, *" {

            (Compare-Object -ReferenceObject $json.parameters.protocol.allowedValues -DifferenceObject @("TCP", "UDP", "*")).Length | should be 0
        }
    }

    Context "sourceAddressPrefixes Validation" {

        It "Has sourceAddressPrefixes parameter" {

            $json.parameters.sourceAddressPrefixes | should not be $null
        }

        It "sourceAddressPrefixes parameter is of type array" {

            $json.parameters.sourceAddressPrefixes.type | should be "array"
        }

        It "sourceAddressPrefixes parameter is mandatory" {

            ($json.parameters.sourceAddressPrefixes.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "destinationAddressPrefixes Validation" {

        It "Has destinationAddressPrefixes parameter" {

            $json.parameters.destinationAddressPrefixes | should not be $null
        }

        It "destinationAddressPrefixes parameter is of type array" {

            $json.parameters.destinationAddressPrefixes.type | should be "array"
        }

        It "destinationAddressPrefixes parameter is mandatory" {

            ($json.parameters.destinationAddressPrefixes.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "sourcePortRanges Validation" {

        It "Has sourcePortRanges parameter" {

            $json.parameters.sourcePortRanges | should not be $null
        }

        It "sourcePortRanges parameter is of type array" {

            $json.parameters.sourcePortRanges.type | should be "array"
        }

        It "sourcePortRanges parameter default value is *" {

            $json.parameters.sourcePortRanges.defaultValue | should be "*"
        }
    }

    Context "destinationPortRanges Validation" {

        It "Has destinationPortRanges parameter" {

            $json.parameters.destinationPortRanges | should not be $null
        }

        It "destinationPortRanges parameter is of type array" {

            $json.parameters.destinationPortRanges.type | should be "array"
        }

        It "destinationPortRanges parameter is mandatory" {

            ($json.parameters.destinationPortRanges.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }
    }

    Context "access Validation" {

        It "Has access parameter" {

            $json.parameters.access | should not be $null
        }

        It "access parameter is of type string" {

            $json.parameters.access.type | should be "string"
        }

        It "access parameter is mandatory" {

            ($json.parameters.access.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "access parameter allowed values are Allow, Deny" {

            (Compare-Object -ReferenceObject $json.parameters.access.allowedValues -DifferenceObject @("Allow", "Deny")).Length | should be 0
        }
    }

    Context "priority Validation" {

        It "Has priority parameter" {

            $json.parameters.priority | should not be $null
        }

        It "access priority is of type int" {

            $json.parameters.priority.type | should be "int"
        }

        It "priority parameter is mandatory" {

            ($json.parameters.priority.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "priority parameter minimum value is 100" {

            $json.parameters.priority.minValue | should be 100
        }

        It "priority parameter maximum value is 4096" {

            $json.parameters.priority.maxValue | should be 4096
        }
    }

    Context "direction Validation" {

        It "Has direction parameter" {

            $json.parameters.direction | should not be $null
        }

        It "direction parameter is of type string" {

            $json.parameters.direction.type | should be "string"
        }

        It "direction parameter is mandatory" {

            ($json.parameters.direction.PSObject.Properties.Name -contains "defaultValue") | should be $false
        }

        It "direction parameter allowed values are Inbound, Outbound" {

            (Compare-Object -ReferenceObject $json.parameters.direction.allowedValues -DifferenceObject @("Inbound", "Outbound")).Length | should be 0
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

Describe "Security Rule Function Validation" {

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $json.resources.apiVersion | should be "2018-11-01"
        }
    }
}
Describe "Security Rule Function Validation" {

    Context "securityRule Namespace Validation" {

        It "securityRule namespace exists" {

            ($json.functions.namespace -contains "securityRule") | should be $true
        }
        
        $securityRuleNamespace = $json.functions | Where-Object { $PSItem.namespace -eq "securityRule" }

        It "securityRule has member setStringOrArrayProperty" {

            ($securityRuleNamespace.members.PSObject.Properties.Name -contains "setStringOrArrayProperty") | should be $true
        }

        $setStringOrArrayPropertyMember = $securityRuleNamespace.members.setStringOrArrayProperty

        It "setStringOrArrayProperty member has three input parameters" {

            $setStringOrArrayPropertyMember.parameters.Count | should be 3
        }

        It "setStringOrArrayProperty member has stringPropertyName input parameter" {

            $setStringOrArrayPropertyMember.parameters | Where-Object { $PSItem.name -eq "stringPropertyName" } | should not be $null
        }

        It "stringPropertyName input parameter is of type string" {

            ($setStringOrArrayPropertyMember.parameters | Where-Object { $PSItem.name -eq "stringPropertyName" }).type | should be "string"
        }

        It "setStringOrArrayProperty member has arrayPropertyName input parameter" {

            $setStringOrArrayPropertyMember.parameters | Where-Object { $PSItem.name -eq "arrayPropertyName" } | should not be $null
        }

        It "arrayPropertyName input parameter is of type string" {

            ($setStringOrArrayPropertyMember.parameters | Where-Object { $PSItem.name -eq "arrayPropertyName" }).type | should be "string"
        }

        It "setStringOrArrayProperty member has propertyValue input parameter" {

            $setStringOrArrayPropertyMember.parameters | Where-Object { $PSItem.name -eq "propertyValue" } | should not be $null
        }

        It "propertyValue input parameter is of type array" {

            ($setStringOrArrayPropertyMember.parameters | Where-Object { $PSItem.name -eq "propertyValue" }).type | should be "array"
        }
        
        It "setStringOrArrayProperty member output is of type string" {

            $setStringOrArrayPropertyMember.output.type | should be "string" 
        }
    }
}

Describe "Security Rule Resource Validation" {

    Context "name Validation" {

        It "Uses child resource naming" {

            $json.resources.name | should be "[concat(parameters('nsgName'), '/', parameters('securityRuleName'))]"
        }
    }

    Context "apiVersion Validation" {

        It "apiVersion value is 2018-11-01" {

            $json.resources.apiVersion | should be "2018-11-01"
        }
    }
}